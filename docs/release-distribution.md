# 生产站产物分发（GitHub Release）

> 本文面向**运维**：海外站 `https://tokenfleet.ai` 的 `dist/` 构建产物已自动发布到
> GitHub Release，凭固定 URL 即可匿名下载、校验、解压部署，不再需要维护者本地构建后手动交付。

## 背景

- 每次 push 到 `main`，`.github/workflows/release-dist.yml` 会自动：
  构建 `dist/` → 打包为 `tokenfleet-landing-ai-dist.zip` → 生成 SHA256 校验文件 →
  发布为 GitHub Release → 清理旧 Release（仅保留最近 10 个）。
- 仓库为 **PUBLIC**，因此 Release 附件**无需登录 GitHub** 即可 `curl`/`wget` 下载
  （Actions artifact 需要登录与仓库权限，不适用于交付，故未采用）。
- 附件文件名固定，配合 GitHub 原生的 `releases/latest` 机制，下载 URL 永远指向最新产物。
- 产物为**默认根部署形态**（`site=https://tokenfleet.ai`、无 base、directory 格式），
  与生产站一致，可直接部署到任意静态托管 / VPS。

## 下载（匿名）

```bash
curl -fL -O https://github.com/TokenFleet-AI/tokenfleet-landing-ai/releases/latest/download/tokenfleet-landing-ai-dist.zip
curl -fL -O https://github.com/TokenFleet-AI/tokenfleet-landing-ai/releases/latest/download/tokenfleet-landing-ai-dist.zip.sha256
```

- 两个文件都应下载：`.zip` 是产物包，`.sha256` 用于完整性校验。
- Release 正文（GitHub 网页或 API 可见）中记录了对应的 commit SHA、构建时间（UTC / CST）、
  模型数量、文件数与包大小，用于线上异常时追溯版本。

## 校验完整性

```bash
sha256sum -c tokenfleet-landing-ai-dist.zip.sha256
```

输出 `tokenfleet-landing-ai-dist.zip: OK` 即校验通过；校验失败说明下载不完整或被篡改，
**不要继续部署**。

## 解压部署

压缩包解开后**直接是站点根**（含 `index.html`、`models/`、`_assets/` …），**不含**
`dist/` 顶层目录，因此解压到目标目录即可，无需再移动一层：

```bash
unzip -d /path/to/site-root tokenfleet-landing-ai-dist.zip
```

> 若目标目录已存在旧版本，建议先备份或清空再解压，避免新旧文件混叠。

## 版本追溯

每个 Release 都能对应到确切源码与构建时刻：

- **commit SHA**：Release 标题与正文给出，可回查对应源码。
- **构建时间**：UTC 与 CST 双时区记录在 Release 正文。
- **模型数量**：正文记录本次构建时的模型快照数量。

## 常见问题

| 现象           | 说明                                                                                         |
| -------------- | -------------------------------------------------------------------------------------------- |
| `curl` 报 404  | 可能仓库改名/迁移；确认 URL 中的仓库路径正确。                                               |
| 校验不通过     | 下载不完整或被篡改，重新下载或联系维护者。                                                   |
| 需要更早版本   | 仅保留最近 10 个 Release，更早的会被自动清理；如需回滚到更早版本，联系维护者从源码重新构建。 |
| 部署后页面异常 | 先核对 Release 正文的 commit SHA 与构建时间，确认部署的是预期版本。                          |
