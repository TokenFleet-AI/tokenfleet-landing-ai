<p align="center">
  <img src="public/xy-logo-transparent.png" alt="TokenFleet" width="160" />
</p>

<h1 align="center">TokenFleet Landing</h1>

<p align="center">
  Public Astro site for TokenFleet, a unified AI model API gateway for engineering teams and enterprise buyers.
</p>

<p align="center">
  <a href="README.zh-CN.md">简体中文</a> · English
</p>

<p align="center">
  <strong>Astro 6</strong> · <strong>React 19 Islands</strong> · <strong>Static Model Catalog</strong> · <strong>OpenAI-Compatible API Narrative</strong>
</p>

> [!NOTE]
> This repository contains the static marketing site and model catalog pages. It does not contain the TokenFleet API service or console application.
> This repository is the **overseas deployment site** (default branch `main`): English is the default locale and the catalog is sourced from `tokenfleet.ai`. It lives in its own deployment repo (`TokenFleet-AI/tokenfleet-landing-ai`), separate from the cn-site code repo, and is not merged back by default.

## Overview

TokenFleet Landing presents an English-first product narrative for **TokenFleet**: one API key, OpenAI-compatible integration, unified billing, invoices, and a searchable model catalog across LLM, image, and video models — with parallel Chinese, Japanese, and Korean locales.

| Area                | Details                                                                        |
| ------------------- | ------------------------------------------------------------------------------ |
| Framework           | Astro 6 static site                                                            |
| Interactive islands | React 19, OGL WebGL hero, animated logo loop                                   |
| Languages           | English (default at `/`), Chinese at `/zh`, Japanese at `/ja`, Korean at `/ko` |
| Main routes         | `/`, `/models`, `/zh`, `/zh/models`, `/ja`, `/ja/models`, `/ko`, `/ko/models`  |
| Legacy redirects    | `/en` → `/`, `/en/models` → `/models` (back-compat for old English links)      |
| Catalog source      | Root `pricing-api.json` snapshot mirroring `https://tokenfleet.ai/api/pricing` |
| Current catalog     | 36 models across 6 active vendors; endpoints: OpenAI / Anthropic / Gemini      |
| Quality gates       | ESLint, Prettier, `astro check`, GitHub Actions CI                             |
| Build output        | Static files in `dist/`                                                        |

## Contents

- [Highlights](#highlights)
- [Tech Stack](#tech-stack)
- [Getting Started](#getting-started)
- [Available Scripts](#available-scripts)
- [Routes](#routes)
- [Project Structure](#project-structure)
- [Key Files](#key-files)
- [Updating the Model Catalog](#updating-the-model-catalog)
- [Deployment Notes](#deployment-notes)
- [Continuous Integration](#continuous-integration)

## Highlights

- **English-first landing page** for CTOs, engineers, enterprise finance, and procurement readers, with parallel **Chinese (`/zh`)**, **Japanese (`/ja`)**, and **Korean (`/ko`)** locales driven by a single dictionary in `src/i18n.ts`.
- **Animated WebGL hero backdrop** built with OGL, with reduced-motion, visibility pause, and no-WebGL fallback handling.
- **Local AI brand logo strip** with a horizontally looping vendor showcase.
- **OpenAI SDK compatibility narrative** with copyable `curl`, Python, and Node examples.
- **Static model catalog** at `/models`, currently built from `pricing-api.json` with **36 models** across **6 vendors** (all active), and OpenAI / Anthropic / Gemini endpoint metadata.
- **Catalog interactions** for vendor filters, model-type filters, search, name sorting, URL-synced state, and copyable model IDs.
- **Enterprise positioning** around unified billing, VAT invoices, VPC/private deployment, SLA conversations, and GPU rental coming soon.
- **Accessibility-minded UI** with a skip link, keyboard-friendly code tabs, visible focus states, responsive layouts, and reduced-motion handling.

## Tech Stack

| Layer            | Technology                                                                                           |
| ---------------- | ---------------------------------------------------------------------------------------------------- |
| Site framework   | [Astro](https://astro.build/) 6                                                                      |
| Islands          | React 19 through `@astrojs/react`                                                                    |
| Motion / WebGL   | [OGL](https://github.com/oframe/ogl)                                                                 |
| Styling          | Plain CSS, design tokens, button primitives, Tailwind CSS 4 Vite plugin                              |
| Typography       | Inter (latin) + Noto Sans SC (CJK) + Geist Mono — loaded via Google Fonts in `src/styles/global.css` |
| Language         | TypeScript 6 with Astro components and a shared `src/i18n.ts` dictionary                             |
| Quality          | ESLint (astro, react, react-hooks), Prettier (`prettier-plugin-astro`), `@astrojs/check`             |
| Browser behavior | Vanilla JavaScript for navigation, reveal animations, code tabs, and model explorer interactions     |
| Assets           | Static assets under `public/`                                                                        |

## Getting Started

### Requirements

- Node.js 22.12 or newer (matches `engines.node` in `package.json` and the CI workflow)
- npm

### Install

```sh
npm install
```

### Development

```sh
npm run dev
```

Astro will print the local development URL, usually `http://localhost:4321`.

### Production Build

```sh
npm run build
```

### Preview Build

```sh
npm run preview
```

## Available Scripts

| Command                | Description                                             |
| ---------------------- | ------------------------------------------------------- |
| `npm run dev`          | Start the Astro development server.                     |
| `npm run build`        | Build the static site into `dist/`.                     |
| `npm run preview`      | Preview the production build locally with host binding. |
| `npm run check`        | Run `astro check` for type and content diagnostics.     |
| `npm run lint`         | Run ESLint across Astro, TS, JS, and JSX sources.       |
| `npm run format:check` | Verify formatting with Prettier (no writes).            |
| `npm run astro`        | Run Astro CLI commands directly.                        |

## Routes

| Route        | Purpose                                                                             |
| ------------ | ----------------------------------------------------------------------------------- |
| `/`          | English landing page (default locale) with hero, featured models, and sections.     |
| `/models`    | English searchable static catalog for all models in the pricing snapshot.           |
| `/zh`        | Chinese landing page sharing the same sections, driven by `locale = 'zh'`.          |
| `/zh/models` | Chinese static catalog mirroring `/models`.                                         |
| `/ja`        | Japanese landing page, `locale = 'ja'`.                                             |
| `/ja/models` | Japanese static catalog.                                                            |
| `/ko`        | Korean landing page, `locale = 'ko'`.                                               |
| `/ko/models` | Korean static catalog.                                                              |
| `/en`        | Redirects to `/` (back-compat for old English-first links; see `astro.config.mjs`). |
| `/en/models` | Redirects to `/models`.                                                             |

## Project Structure

```text
docs/                  Product, design, and maintenance notes
public/                Static images, favicons, OG assets, brand marks
public/ai-brand-logo/  Local LobeHub vendor SVG snapshots
public/images/         Marketing imagery used across sections
src/assets/            Bundled assets (e.g. QR codes) imported by components
src/components/        Page sections and reusable Astro components
src/components/react/  Hydrated React islands for the hero backdrop and logo loop
src/data/              pricing.ts (catalog + price math) and model-limits.ts (TPM/RPM)
src/i18n.ts            Locale type, path helper, and the en / zh / ja / ko dictionary
src/layouts/           Shared HTML shell and metadata
src/pages/             Astro routes for the English site (`/`, `/models`)
src/pages/zh/          Astro routes for the Chinese site (`/zh`, `/zh/models`)
src/pages/ja/          Astro routes for the Japanese site (`/ja`, `/ja/models`)
src/pages/ko/          Astro routes for the Korean site (`/ko`, `/ko/models`)
src/styles/            Global styles, design tokens, and button styles
```

## Key Files

| File                                              | Purpose                                                                                                               |
| ------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------- |
| `src/pages/index.astro`                           | Composes the English landing page (`locale = 'en'`, default).                                                         |
| `src/pages/zh/index.astro`                        | Composes the Chinese landing page (`locale = 'zh'`); `ja` / `ko` pages mirror it. All pages share section components. |
| `src/pages/models.astro`                          | Renders the English model catalog page.                                                                               |
| `src/pages/zh/models.astro`                       | Renders the Chinese model catalog page; `ja/models.astro` / `ko/models.astro` mirror it.                              |
| `src/i18n.ts`                                     | Defines locales, `localePath`, and the full `en` / `zh` / `ja` / `ko` UI dictionary consumed by every component.      |
| `src/components/HeroBackdrop.astro`               | Hosts the static fallback and hydrated WebGL terminal backdrop.                                                       |
| `src/components/react/FaultyTerminalIsland.jsx`   | Wraps the OGL terminal effect with WebGL, reduced-motion, and visibility guards.                                      |
| `src/components/BrandStrip.astro`                 | Renders the animated AI vendor logo strip with `BrandLogoLoop.jsx`.                                                   |
| `src/data/pricing.ts`                             | Imports `pricing-api.json`, maps vendors, formats prices, detects modality, and exposes the static catalog.           |
| `src/data/model-limits.ts`                        | Manually curated TPM / RPM rate limits per model (consumed by `ModelRow.astro`).                                      |
| `src/components/ModelsPage.astro`                 | Shared Chinese / English model catalog page shell (hero + explorer).                                                  |
| `src/components/ModelsExplorer.astro`             | Crawlable catalog list toolbar plus vanilla JS vendor / type filters, search, name sorting, and URL state.            |
| `src/components/ModelRow.astro`                   | One model row in the catalog list (name, ID, type, TPM, RPM).                                                         |
| `src/components/FeaturedModels.astro`             | Homepage featured-models gallery driven by a hardcoded `featuredModelIds` list.                                       |
| `src/components/SalesQrLightbox.astro`            | Shared sales QR modal reused by footer and enterprise CTAs.                                                           |
| `src/layouts/Base.astro`                          | Defines metadata, favicons, canonical links, global CSS imports, skip link, and reveal behavior.                      |
| `docs/model-catalog-maintenance.md`               | Maintainer guide for the model catalog: the six maintenance points and standard operating procedures.                 |
| `PRODUCT.md`, `DESIGN.md`, `docs/design-brief.md` | Document product and design decisions behind the page.                                                                |

## Updating the Model Catalog

The model catalog is generated at build time from the root `pricing-api.json` snapshot, which mirrors `https://tokenfleet.ai/api/pricing`. Pricing is read-only from that snapshot — never hand-edit prices in code.

For the full maintainer workflow (adding, retiring, renaming, re-limiting, and re-pricing models), see **[docs/model-catalog-maintenance.md](docs/model-catalog-maintenance.md)**. It covers the six maintenance points (`pricing-api.json`, `pricing.ts` overrides, `model-limits.ts` TPM/RPM, four-language `featured.blurbs` in `i18n.ts`, `FeaturedModels.astro` featured ids, and `public/ai-brand-logo/` icons) and the common pitfalls.

Quick summary:

1. Refresh `pricing-api.json` from the API.
2. Check that `src/data/pricing.ts` still maps any new vendors, model types, endpoint types, and icon slugs correctly.
3. Populate TPM / RPM in `src/data/model-limits.ts` if known; leave `—` placeholders otherwise (never fabricate).
4. Run `npm run build` to verify the static catalog across `/models`, `/zh/models`, `/ja/models`, `/ko/models`.

## Deployment Notes

The site is configured in `astro.config.mjs` with:

- `site: 'https://tokenfleet.ai'`
- `trailingSlash: 'never'`
- compressed HTML output
- build assets emitted under `_assets`

The production build output is written to `dist/` and can be deployed to any static hosting platform.

## Continuous Integration

`.github/workflows/ci.yml` runs on every push and pull request targeting `main` and gates merges with the same checks you should run locally:

1. `actionlint` against the workflow files
2. `npm ci` on Node.js 22
3. `npm run format:check` (Prettier)
4. `npm run lint` (ESLint)
5. `npm run build` (Astro build)
6. `npm run check` (Astro type and content diagnostics)

> [!TIP]
> Run `npm run format:check && npm run lint && npm run build && npm run check` before pushing to mirror CI locally.
