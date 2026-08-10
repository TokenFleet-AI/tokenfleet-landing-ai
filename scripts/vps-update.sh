#!/usr/bin/env bash
#
# vps-update.sh — 在 VPS 上自动拉取并原子部署 tokenfleet-landing-ai 的最新 Release 产物。
#
# 背景：本仓库每次 push main 都会由 release-dist.yml 构建 dist/ 并发布为 GitHub
# Release 附件 —— 匿名可下载的 tokenfleet-landing-ai-dist.zip 及其 .sha256 校验文件，
# 产物契约见 docs/release-distribution.md。本脚本消费该契约：轮询 releases/latest，
# 有新版本才下载 → SHA256 校验 → 解压到新目录 → 符号链接原子切换，全程无需凭证。
#
# 目录布局（$TF_BASE，默认 /opt/tokenfleet-ai）：
#   releases/<tag>/   各版本站点根。zip 无顶层目录，解开即是站点根
#   current           符号链接 → 当前部署版本；web 服务器 root 指向此处
#   .staging/         下载与校验临时区；失败时残留便于排查
#   .deployed-tag     已部署版本标记，内容为 Release tag
#
# 依赖：curl / unzip / sha256sum（coreutils 自带，多数发行版默认已装）。
#
# 调用方式（cron 30 分钟一次即可，模型目录每日 22:00 UTC 才同步一次）：
#   */30 * * * * /usr/local/bin/vps-update.sh >> /var/log/tokenfleet-ai-update.log 2>&1
# 首次运行建议手动执行：无 .deployed-tag 时会执行一次完整部署。
# 回滚：ln -sfn "$TF_BASE/releases/<旧tag>" "$TF_BASE/current"
#
# 环境变量（均可选，默认值可直接用）：
#   TF_REPO    GitHub 仓库，默认 TokenFleet-AI/tokenfleet-landing-ai
#   TF_BASE    部署根目录，默认 /opt/tokenfleet-ai
set -euo pipefail

repo="${TF_REPO:-TokenFleet-AI/tokenfleet-landing-ai}"
base="${TF_BASE:-/opt/tokenfleet-ai}"

releases="$base/releases"
current="$base/current"
staging="$base/.staging"
marker="$base/.deployed-tag"

mkdir -p "$releases" "$staging"

# ──── 查询最新 Release tag ────
# 匿名 API，无 token：60 次/小时限额对半小时轮询绰绰有余（每天 48 次）。
# -fsSL：-f 让 4xx/5xx 直接失败退出，-S 保留错误输出，-L 跟随 GitHub 的 302 重定向。
latest="$(curl -fsSL "https://api.github.com/repos/$repo/releases/latest" \
  | sed -n 's/.*"tag_name": *"\([^"]*\)".*/\1/p')"

# tag 会直接拼进文件系统路径（releases/<tag>），只接受安全字符集：仓库改名或
# 被 fork 后 API 返回异常 tag 时在这里退出，而不是把 rm -rf 引向意料之外的路径。
# 空串（解析失败）也在此拦截。
case "$latest" in
  *[!A-Za-z0-9._-]* | '')
    echo "vps-update: 无法从 releases/latest 解析出合法 tag（网络或仓库路径有误）" >&2
    exit 1
    ;;
esac

# 与已部署版本比对：无新版本静默退出，cron 日志不刷屏。
if [ -f "$marker" ] && [ "$(cat "$marker")" = "$latest" ]; then
  exit 0
fi

# ──── 下载 + 校验 ────
# 两个文件都进临时区，且必须保留原始文件名：.sha256 文件内容是
# "<hash>  tokenfleet-landing-ai-dist.zip"，sha256sum -c 按其中记录的文件名查找。
# curl 失败（-f）即整脚本退出，不会把半截包留着部署。
curl -fsSL -o "$staging/tokenfleet-landing-ai-dist.zip" \
  "https://github.com/$repo/releases/latest/download/tokenfleet-landing-ai-dist.zip"
curl -fsSL -o "$staging/tokenfleet-landing-ai-dist.zip.sha256" \
  "https://github.com/$repo/releases/latest/download/tokenfleet-landing-ai-dist.zip.sha256"

# 校验须在临时区内执行（-c 按相对路径查找）。
# 校验失败 → 输出 FAILED 且退出码非 0 → 走这里显式退出，站点保持旧版本。
( cd "$staging" && sha256sum -c tokenfleet-landing-ai-dist.zip.sha256 ) >/dev/null || {
  echo "vps-update: SHA256 校验失败，拒绝部署（可检查 $staging 中残留文件）" >&2
  exit 1
}

# ──── 解压到新版本目录 ────
# zip 无顶层目录，解开即站点根；rm -rf 保证同一 tag 重复执行时幂等。
target="$releases/$latest"
rm -rf "$target"
mkdir -p "$target"
unzip -q "$staging/tokenfleet-landing-ai-dist.zip" -d "$target"

# ──── 原子切换 ────
# 先建 current.new 再整体 mv 覆盖：任何时刻 current 都指向一个完整版本目录，
# 不会出现新旧文件混叠的半成品状态。mv -T 把目标当普通文件/链接处理。
ln -sfn "$target" "$current.new"
mv -Tf "$current.new" "$current"
echo "$latest" > "$marker"

# ──── 清理 ────
# 临时区整目录重建，而不是 rm "$staging"/*：空目录时后者会退化成无参数 rm 报错。
rm -rf "$staging"
mkdir -p "$staging"

# 仅保留最近 3 个版本（按 mtime 而非字典序排序：tag 形如 dist-YYYYMMDD-<run>，
# run 号不补零，字典序会错排，如 -9 会排在 -12 之后）。保留的旧版本即回滚快照。
shopt -s nullglob
versions=("$releases"/*/)
if (( ${#versions[@]} > 3 )); then
  mapfile -t stale < <(ls -1dt "${versions[@]}" | tail -n +4)
  for dir in "${stale[@]}"; do
    rm -rf "$dir"
  done
fi

echo "[$(date '+%F %T %Z')] 已部署 $latest（站点根：$target）"
