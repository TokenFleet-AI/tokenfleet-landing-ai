<p align="center">
  <img src="public/xy-logo-transparent.png" alt="TokenFleet" width="160" />
</p>

<h1 align="center">TokenFleet Landing</h1>

<p align="center">
  TokenFleet 的公开 Astro 官网：面向工程团队与企业采购的一站式 AI 模型 API 网关落地页。
</p>

<p align="center">
  简体中文 · <a href="README.md">English</a>
</p>

<p align="center">
  <strong>Astro 6</strong> · <strong>React 19 Islands</strong> · <strong>静态模型目录</strong> · <strong>OpenAI 兼容接入叙事</strong>
</p>

> [!NOTE]
> 这个仓库包含静态官网与模型目录页面，不包含 TokenFleet API 服务端或控制台应用。
> 本仓库是**海外站部署仓库**（默认分支 `main`）：默认语言为英文，目录数据取自 `tokenfleet.ai`，位于独立部署仓库 `TokenFleet-AI/tokenfleet-landing-ai`，与国内站代码仓库分流维护，默认不并回。

## 项目概览

TokenFleet Landing 是 **TokenFleet** 的公开站点。本分支以英文为主，面向工程团队与企业采购读者，传达“一把 API key、OpenAI 兼容接入、统一计费、统一开票，并覆盖 LLM、图像、视频模型目录”的产品定位，并提供中文、日文、韩文三个平行语言版本。

| 项目         | 说明                                                                          |
| ------------ | ----------------------------------------------------------------------------- |
| 框架         | Astro 6 静态站点                                                              |
| 交互 islands | React 19、OGL WebGL 首屏、动画 logo 循环                                      |
| 多语言       | 英文（默认 `/`）、中文 `/zh`、日文 `/ja`、韩文 `/ko`                          |
| 主要路由     | `/`、`/models`、`/zh`、`/zh/models`、`/ja`、`/ja/models`、`/ko`、`/ko/models` |
| 兼容重定向   | `/en` → `/`、`/en/models` → `/models`（兼容旧英文链接）                       |
| 目录数据源   | 根目录 `pricing-api.json` 快照，镜像 `https://tokenfleet.ai/api/pricing`      |
| 当前目录     | 36 个模型、6 家厂商（全部已挂模型）；endpoint：OpenAI / Anthropic / Gemini    |
| 质量门禁     | ESLint、Prettier、`astro check`、GitHub Actions                               |
| 构建产物     | 输出到 `dist/` 的静态文件                                                     |

## 目录

- [亮点](#亮点)
- [技术栈](#技术栈)
- [快速开始](#快速开始)
- [可用脚本](#可用脚本)
- [页面路由](#页面路由)
- [项目结构](#项目结构)
- [关键文件](#关键文件)
- [更新模型目录](#更新模型目录)
- [部署说明](#部署说明)
- [持续集成](#持续集成)

## 亮点

- **英文优先的产品叙事**，同时服务 CTO、工程师、企业财务与采购决策；并提供平行的**中文（`/zh`）**、**日文（`/ja`）**、**韩文（`/ko`）** 版本，由 `src/i18n.ts` 中的统一字典驱动。
- **WebGL 动效首屏背景** 基于 OGL 实现，并包含 reduced-motion、离屏暂停与无 WebGL fallback 处理。
- **本地 AI 品牌 logo 横向循环展示**，用于呈现已接入的主流模型厂商。
- **OpenAI SDK 兼容性展示**，首屏提供可复制的 `curl`、Python、Node 示例。
- **静态模型目录** 位于 `/models`，当前由 `pricing-api.json` 构建，覆盖 **36 个模型**、**6 家厂商**（全部已挂模型），并包含 OpenAI / Anthropic / Gemini endpoint 元数据。
- **目录交互完整**，支持厂商筛选、模型类型筛选、搜索、按名称排序、URL 状态同步与 model id 复制。
- **企业能力表达**，覆盖统一计费、增值税发票、VPC/私有部署、SLA 沟通与 GPU 算力出租 Coming Soon。
- **关注可访问性**，包含 skip link、键盘可用的代码 tab、可见焦点态、响应式布局与 reduced-motion 处理。

## 技术栈

| 层级         | 技术                                                                                                 |
| ------------ | ---------------------------------------------------------------------------------------------------- |
| 站点框架     | [Astro](https://astro.build/) 6                                                                      |
| Islands      | 通过 `@astrojs/react` 使用 React 19                                                                  |
| 动效 / WebGL | [OGL](https://github.com/oframe/ogl)                                                                 |
| 样式         | Plain CSS、设计 token、按钮原语、Tailwind CSS 4 Vite plugin                                          |
| 字体         | Inter（latin） + Noto Sans SC（CJK） + Geist Mono，在 `src/styles/global.css` 通过 Google Fonts 加载 |
| 语言         | TypeScript 6 的 Astro 组件，配合共享的 `src/i18n.ts` 字典                                            |
| 质量         | ESLint（astro、react、react-hooks）、Prettier（`prettier-plugin-astro`）、`@astrojs/check`           |
| 浏览器行为   | Vanilla JavaScript，用于导航、reveal 动画、代码 tab 与模型目录交互                                   |
| 静态资源     | 放在 `public/`                                                                                       |

## 快速开始

### 环境要求

- Node.js 22.12 或更高版本（与 `package.json` 的 `engines.node` 和 CI 一致）
- npm

### 安装依赖

```sh
npm install
```

### 本地开发

```sh
npm run dev
```

Astro 会在终端输出本地开发地址，通常是 `http://localhost:4321`。

### 生产构建

```sh
npm run build
```

### 本地预览构建产物

```sh
npm run preview
```

## 可用脚本

| 命令                   | 说明                                     |
| ---------------------- | ---------------------------------------- |
| `npm run dev`          | 启动 Astro 开发服务器。                  |
| `npm run build`        | 构建静态站点到 `dist/`。                 |
| `npm run preview`      | 以 host 绑定方式本地预览生产构建。       |
| `npm run check`        | 运行 `astro check`，做类型与内容诊断。   |
| `npm run lint`         | 对 Astro、TS、JS、JSX 源码运行 ESLint。  |
| `npm run format:check` | 使用 Prettier 校验格式（只读，不写回）。 |
| `npm run astro`        | 直接运行 Astro CLI 命令。                |

## 页面路由

| 路由         | 用途                                                           |
| ------------ | -------------------------------------------------------------- |
| `/`          | 英文落地页（默认语言），包含首屏、精选模型与各区块。           |
| `/models`    | 基于价格快照构建的英文全量模型静态目录。                       |
| `/zh`        | 中文落地页，与英文页共用所有 section 组件（`locale = 'zh'`）。 |
| `/zh/models` | 对应 `/models` 的中文版静态目录。                              |
| `/ja`        | 日文落地页（`locale = 'ja'`）。                                |
| `/ja/models` | 日文版静态目录。                                               |
| `/ko`        | 韩文落地页（`locale = 'ko'`）。                                |
| `/ko/models` | 韩文版静态目录。                                               |
| `/en`        | 重定向到 `/`（兼容旧的英文优先链接，见 `astro.config.mjs`）。  |
| `/en/models` | 重定向到 `/models`。                                           |

## 项目结构

```text
docs/                  产品、设计与维护文档
public/                静态图片、favicon、Open Graph 资源与品牌标识
public/ai-brand-logo/  LobeHub AI 厂商 SVG 本地快照
public/images/         各 section 使用的营销插图
src/assets/            被组件 import 的资源（如二维码）
src/components/        页面区块与可复用 Astro 组件
src/components/react/  Hydrated React islands，用于首屏背景与 logo 循环
src/data/              pricing.ts（目录与价格计算）与 model-limits.ts（TPM/RPM 限速）
src/i18n.ts            语言类型、`localePath` 工具与 en/zh/ja/ko 四语言统一字典
src/layouts/           共享 HTML 外壳与元信息
src/pages/             英文站点 Astro 路由（`/`、`/models`）
src/pages/zh/          中文站点 Astro 路由（`/zh`、`/zh/models`）
src/pages/ja/          日文站点 Astro 路由（`/ja`、`/ja/models`）
src/pages/ko/          韩文站点 Astro 路由（`/ko`、`/ko/models`）
src/styles/            全局样式、设计 token、按钮样式
```

## 关键文件

| 文件                                              | 作用                                                                             |
| ------------------------------------------------- | -------------------------------------------------------------------------------- |
| `src/pages/index.astro`                           | 组合英文落地页（`locale = 'en'`，默认）。                                        |
| `src/pages/zh/index.astro`                        | 组合中文落地页（`locale = 'zh'`）；`ja` / `ko` 页面同构，共用全部 section 组件。 |
| `src/pages/models.astro`                          | 渲染英文模型目录页。                                                             |
| `src/pages/zh/models.astro`                       | 渲染中文模型目录页；`ja/models.astro`、`ko/models.astro` 同构。                  |
| `src/i18n.ts`                                     | 定义 locale、`localePath` 与 en/zh/ja/ko 四语言 UI 字典，供所有组件消费。        |
| `src/components/HeroBackdrop.astro`               | 承载静态 fallback 与 hydrated WebGL 终端背景。                                   |
| `src/components/react/FaultyTerminalIsland.jsx`   | 为 OGL 终端动效补充 WebGL、reduced-motion 与可见性保护。                         |
| `src/components/BrandStrip.astro`                 | 与 `BrandLogoLoop.jsx` 一起渲染 AI 厂商 logo 横向循环展示。                      |
| `src/data/pricing.ts`                             | 导入 `pricing-api.json`，处理厂商映射、价格格式化、模型形态识别与静态目录导出。  |
| `src/data/model-limits.ts`                        | 手工维护的模型 TPM / RPM 限速（被 `ModelRow.astro` 消费）。                      |
| `src/components/ModelsPage.astro`                 | 中英文共用的模型目录页外壳（hero + explorer）。                                  |
| `src/components/ModelsExplorer.astro`             | 实现厂商/类型筛选、搜索、按名称排序、URL 状态同步的目录列表。                    |
| `src/components/ModelRow.astro`                   | 目录列表中的一行模型（名称、ID、类型、TPM、RPM）。                               |
| `src/components/FeaturedModels.astro`             | 首页精选模型卡片，由硬编码的 `featuredModelIds` 列表驱动。                       |
| `src/components/SalesQrLightbox.astro`            | 共享的销售二维码弹层，被 Footer 与 Enterprise 区块的 CTA 复用。                  |
| `src/layouts/Base.astro`                          | 定义 metadata、favicon、canonical、全局样式、skip link 与 reveal 行为。          |
| `docs/model-catalog-maintenance.md`               | 模型目录维护者指南：六个维护点与标准操作流程。                                   |
| `PRODUCT.md`、`DESIGN.md`、`docs/design-brief.md` | 记录页面背后的产品与设计决策。                                                   |

## 更新模型目录

模型目录在构建时读取仓库根目录的 `pricing-api.json` 快照；该文件镜像 `https://tokenfleet.ai/api/pricing`。价格为只读，不要在代码里手改价格。

完整的维护者流程（新增 / 下线 / 改名 / 调限速 / 调价）见 **[docs/model-catalog-maintenance.md](docs/model-catalog-maintenance.md)**。它覆盖六个维护点（`pricing-api.json`、`pricing.ts` 覆盖表、`model-limits.ts` 的 TPM/RPM、`i18n.ts` 四语言 `featured.blurbs`、`FeaturedModels.astro` 的精选 id、`public/ai-brand-logo/` 图标）与常见坑。

简要步骤：

1. 从 API 刷新 `pricing-api.json`。
2. 检查 `src/data/pricing.ts` 是否仍正确处理新增厂商、模型类型、endpoint 类型与 icon slug。
3. 拿到官方限速后在 `src/data/model-limits.ts` 填 TPM / RPM；拿不到就留空显示 `—`（绝不臆造）。
4. 运行 `npm run build` 验证 `/models`、`/zh/models`、`/ja/models`、`/ko/models` 的静态目录。

## 部署说明

站点在 `astro.config.mjs` 中配置了：

- `site: 'https://tokenfleet.ai'`
- `trailingSlash: 'never'`
- 压缩 HTML 输出
- 构建资源输出到 `_assets`

生产构建产物会写入 `dist/`，可以部署到任意静态托管平台。

### 通过 GitHub Release 分发生产产物

每次 push 到 `main` 都会把构建好的 `dist/` 产物发布为 **GitHub Release** 附件
（`.github/workflows/release-dist.yml`）。由于本仓库为 **PUBLIC**，附件**无需登录**即可匿名下载，
适合直接交付给运维。固定附件名提供稳定 URL：

```bash
curl -fL -O https://github.com/TokenFleet-AI/tokenfleet-landing-ai/releases/latest/download/tokenfleet-landing-ai-dist.zip
curl -fL -O https://github.com/TokenFleet-AI/tokenfleet-landing-ai/releases/latest/download/tokenfleet-landing-ai-dist.zip.sha256
sha256sum -c tokenfleet-landing-ai-dist.zip.sha256
unzip -d /path/to/site-root tokenfleet-landing-ai-dist.zip
```

压缩包解开后**直接是站点根**，**不含** `dist/` 顶层目录。每个 Release 正文记录 commit SHA、
构建时间（UTC / CST）与模型数量，用于版本追溯；仅保留最近 10 个 Release。
面向运维的说明见 [`docs/release-distribution.md`](docs/release-distribution.md)；
VPS 自动更新脚本见 [`scripts/vps-update.sh`](scripts/vps-update.sh)。

### GitHub Pages 部署

本仓库的静态站点通过 `.github/workflows/deploy-pages.yml` 部署到 GitHub Pages，
每次 push 到 `main`（或手动 `workflow_dispatch`）触发。它使用 `actions/configure-pages`
报告的 origin / base path 构建 `github-pages` 形态（`base` 子路径 + `file` 格式），
自动适配 Pages 项目站点。

## 持续集成

`.github/workflows/ci.yml` 会在每一次推送到 `main` 或目标为 `main` 的 PR 上运行，与本地需要执行的检查保持一致：

1. `actionlint` 检查工作流文件
2. 在 Node.js 22 下执行 `npm ci`
3. `npm run format:check`（Prettier）
4. `npm run lint`（ESLint）
5. `npm run build`（Astro 构建）
6. `npm run check`（Astro 类型与内容诊断）

> [!TIP]
> 推送前在本地依次跑 `npm run format:check && npm run lint && npm run build && npm run check` 可以提前复现 CI 行为。
