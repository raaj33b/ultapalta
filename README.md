<div align="center">

**English (upstream)** · [简体中文](docs/readme/README_zh.md) · [繁體中文](docs/readme/README_zh-TW.md) · [日本語](docs/readme/README_ja.md) · [한국어](docs/readme/README_ko.md) · [Türkçe](docs/readme/README_tr.md) · [Русский](docs/readme/README_ru.md) · [Tiếng Việt](docs/readme/README_vi.md) · [ไทย](docs/readme/README_th.md) · [Deutsch](docs/readme/README_de.md) · [Español](docs/readme/README_es.md) · [Français](docs/readme/README_fr.md) · [Українська](docs/readme/README_uk.md) · [Polski](docs/readme/README_pl.md) · [Português (Brasil)](docs/readme/README_pt-BR.md) · [العربية](docs/readme/README_ar.md) · [فارسی](docs/readme/README_fa.md) · [Bahasa Indonesia](docs/readme/README_id.md) · [Italiano](docs/readme/README_it.md) · [Ελληνικά](docs/readme/README_el.md) · [മലയാളം](docs/readme/README_ml.md) · [বাংলা](docs/readme/README_bn.md)

# উল্টাপাল্টা

### ULTAPALTA

**কাজের জিনিস, আজব স্টাইলে।**

<img src="assets/mascot/ultapalta-maker-static.svg" width="230" alt="উল্টাপাল্টা মেকার — ULTAPALTA-র মাসকট: কৌতূহলী ছোট্ট ডিজিটাল ট্রিকস্টার" />

[![MIT license](https://img.shields.io/badge/license-MIT-f4c430?style=flat-square)](LICENSE)
[![CI](https://github.com/raaj33b/ultapalta/actions/workflows/ci.yml/badge.svg)](https://github.com/raaj33b/ultapalta/actions/workflows/ci.yml)
[![Node.js requirements](https://img.shields.io/badge/Node.js-22.19%2B%20%7C%2024.11%2B%20%7C%2026%2B-339933?style=flat-square&logo=nodedotjs&logoColor=white)](#requirements)

**Reverse engineer anything — এখন বাংলায়।** One CLI + one MCP server for your terminal ও coding agent।

</div>

> [!NOTE]
> উল্টাপাল্টা হলো [**REA: Reverse Engineer Anything**](https://github.com/morluto/rea)-র একটা **Bangla-first fork**। মূল প্রকল্প MIT-licensed, তাই স্বীকৃতিসহ (attribution) এই রূপান্তর সম্পূর্ণ বৈধ — কিন্তু এটা upstream-এর replace না, একটা নিজস্ব flavor। Upstream-এর অফিসিয়াল সোর্স: [morluto/rea](https://github.com/morluto/rea) · [rea.tools](https://rea.tools/) · [rea-agents npm](https://www.npmjs.com/package/rea-agents)। বিস্তারিত: [NOTICE.md](NOTICE.md)।

---

## ⚡ এক লাইনে ইনস্টল — main attraction

যে কেউ টার্মিনালে এক লাইন চালিয়ে পুরো জিনিসটা নামাতে, ডিপ্লয় করতে আর চালু করতে পারবে — ধাপে ধাপে, serially, installer-এর ভেতরেই সব:

**Windows (PowerShell):**

```powershell
irm https://raw.githubusercontent.com/raaj33b/ultapalta/main/install.ps1 | iex
```

**macOS / Linux / Termux:**

```bash
curl -fsSL https://raw.githubusercontent.com/raaj33b/ultapalta/main/install.sh | bash
```

**npm (classic):**

```bash
npx ultapalta setup
```

Installer নিজেই serially করে, প্রতিটা ধাপ বাংলায় দেখিয়ে:

1. **ধাপ ১/৫** — এনভায়রনমেন্ট চেক (OS, curl/PowerShell)
2. **ধাপ ২/৫** — Node.js চেক (22.19+/24.11+/26+; Windows-এ winget অফার, Termux-এ `pkg` গাইড)
3. **ধাপ ৩/৫** — ভার্সন ঠিক করা + ইনস্টল প্ল্যান
4. **ধাপ ৪/৫** — npm global ইনস্টল (npm-এ প্যাকেজ না পেলে GitHub source থেকে fallback)
5. **ধাপ ৫/৫** — `ultapalta setup` উইজার্ড → agent রেজিস্ট্রেশন → **"✓ হয়ে গেছে!"**

> [!IMPORTANT]
> `raw.githubusercontent.com` লিংকগুলো তখনই কাজ করবে যখন এই রিপো `raaj33b/ultapalta` হিসেবে GitHub-এ পুশ হবে। তার আগে লোকাল কপি থেকে: `./install.ps1` বা `bash install.sh` (দুটোতেই `--dry-run`/`-DryRun` আছে)।

---

## এটা দিয়ে কী হয়?

কোনো app-এ এমন একটা feature দেখলে যেটা তোমার নিজের প্রজেক্টেও চাই — উল্টাপাল্টা দিয়ে তোমার coding agent **সোর্স কোড ছাড়াই** সেই app পরীক্ষা করে বলে দিতে পারে feature-টা কীভাবে কাজ করে, evidence-সহ। সব analysis লোকালেই চলে; ফলাফলের সাথে সীমাবদ্ধতাও স্পষ্ট থাকে।

- **Terminal থেকে** — `ultapalta analyze-javascript-application "D:/apps/example" --json`
- **Coding agent থেকে** — MCP server হিসেবে (Claude Code, Codex, Cursor, Gemini CLI, Grok, OpenCode…)
- **CLI-এর খোলামেলা বার্তা বাংলায়** — wizard, progress, আর success/error মেসেজ। ইংরেজি চাইলে `ULTAPALTA_LANG=en`

## Quick start

Node.js 22.19+/24.11+/26+ লাগবে (npm সহ)। তারপর:

```bash
npx ultapalta setup
```

Agent বাছাই করো, প্ল্যানটা রিভিউ করো, approve দাও — উল্টাপাল্টা নিজের MCP registration আর workflow skill বসিয়ে দেবে, আগের কনফিগের ব্যাকআপসহ। Setup-এর পর agent-কে বলো:

```text
Understand how search works in the Notes app, show me the evidence, and build a
similar feature for my project.
```

Terminal-only হলে:

```bash
npx -y ultapalta@latest analyze-javascript-application /absolute/path/to/app --json
```

> npm-এ `ultapalta` প্যাকেজটা publish হওয়ার আগে এই কমান্ডগুলো source থেকেই চালাও —
> repo root-এ `npm install && npm run compile`, তারপর `node scripts/rea.mjs setup`।
> উপরের one-liner installer-গুলো এটাই automatically করে।

## কী কী analyze করা যায়?

| টার্গেট | কী পাওয়া যায় | দরকারি টুল |
| --- | --- | --- |
| JavaScript / Electron app (বা ASAR) | modules, imports, Electron boundaries + evidence | শুধু Node.js |
| Native binary (PE/ELF/Mach-O) | functions, strings, decompiled code | Hopper / Ghidra / IDA (ঐচ্ছিক, setup-এ গাইড) |
| Website / browser | runtime behavior, network captures, modules | Playwright browser |
| Android (APK, device, resources) | manifest, resources, runtime | apktool, JADX, adb |
| .NET / Flutter / WASM / EVM / firmware / SQLite / PCAP… | প্রতি টার্গেটের নিজস্ব analysis | দেখো [docs/](docs/) |

পুরো list আর workflow: [docs/mcp-contracts.md](docs/mcp-contracts.md) ও upstream [README](docs/UPSTREAM_README.md)।

## Architecture (এক নজরে)

- `src/` — TypeScript engine: domain logic, analysis services, CLI, MCP server। Upstream REA-র সম্পূর্ণ ইঞ্জিন, অক্ষুণ্ণ।
- `src/cliLocale/` — ULTAPALTA-র Bengali/English CLI message layer (bn default, en fallback)।
- `src/identity.ts` — প্রোডাক্ট identity-র single source (`ultapalta` binary + `rea`/`rea-agents` compat alias)।
- `install.ps1` / `install.sh` — step-by-step one-liner installer (Windows / macOS/Linux/Termux)।
- `assets/mascot/` — উল্টাপাল্টা মেকার mascot + emblem (original artwork, CC0)।
- `website/` — upstream-এর static সাইট + **নতুন `bn` locale** (বাংলা edition)।
- `docs/` — VitePress ডকুমেন্টেশন + ২২টা ভাষার README edition।

বিস্তারিত সিদ্ধান্ত: [ARCHITECTURE_DECISIONS.md](ARCHITECTURE_DECISIONS.md)।

## Configuration

`.env.example`-এ সব supported environment variable-এর ব্যাখ্যা আছে (মূল প্রজেক্টের `REA_*` variable-গুলো নাম অপরিবর্তিত — compatibility-র জন্য)। গুরুত্বপূর্ণ কয়েকটা:

| Variable | কাজ |
| --- | --- |
| `ULTAPALTA_LANG` | CLI ভাষা — `bn` (default) / `en` |
| `REA_LOG_LEVEL` | Logging level (`silent`, `info`, `debug`…) |
| `REA_ANALYSIS_PROVIDER` | Native analysis-এর provider override |
| `REA_MCP_INPUT_SCHEMA_PROFILE` | MCP schema detail (`compact` default / `full`) |

আসল `.env` কখনো commit কোরো না।

## Development

```bash
git clone https://github.com/raaj33b/ultapalta.git
cd ultapalta
npm install
npm run compile          # TypeScript build → dist/
npm run check:fast       # typecheck + lint
npm run test:run         # vitest suite
npm run docs:dev         # VitePress docs locally
```

> Low-memory মেশিনে typecheck করতে: `GOMAXPROCS=2 npm run typecheck` — native TS
> compiler ডিফল্ট প্যারালেলিজমে OOM করতে পারে (আমরা নিজের বিল্ডে ধরেছি)।

Testing-এর পুরো গল্প: [CONTRIBUTING.md](CONTRIBUTING.md)।

## Security আর দায়িত্বশীল ব্যবহার

- শুধু সেই software/system analyze করো যার **অনুমতি তোমার আছে** (নিজের app, authorized engagement, CTF, interoperability research)।
- এই প্রকল্প credential theft, malware, DRM bypass বা unauthorized access-এর জন্য না। বিস্তারিত: [DISCLAIMER.md](DISCLAIMER.md) ও [SECURITY.md](SECURITY.md)।
- Vulnerability report: GitHub Security Advisories — জায়গামতো, public issue-তে না।

## Contributing

সব ধরনের contribution স্বাগত — কোড, অনুবাদ (বিশেষ করে `website/locales/bn/messages.po`-তে বাকি ১৫০০+ string!), ডকুমেন্টেশন, টেস্ট। শুরু: [CONTRIBUTING.md](CONTRIBUTING.md) + [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md)।

## Attribution আর License

- **Upstream engine:** [morluto/rea](https://github.com/morluto/rea) © morluto ও contributors — [MIT](LICENSE)। মূল copyright notice অক্ষুণ্ণ।
- **ULTAPALTA-র নতুন কাজ** (branding, bn locale, mascot, installer, docs): Copyright (c) 2026 ULTAPALTA contributors — MIT।
- **Mascot artwork:** [CC0 1.0](assets/mascot/README.md)। Third-party notices: [THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md), lineage: [NOTICE.md](NOTICE.md)।

---

<div align="center">

**ভালো লাগলে একটা ⭐ রেখে যাও** — [github.com/raaj33b/ultapalta](https://github.com/raaj33b/ultapalta)।
এটা ছাড়া কোনো তারকা-গণনা, badge বা endorsement এই প্রজেক্ট দাবি করে না।

**ঝামেলা কম, জোস বেশি।** 🎸

<sub>উল্টাপাল্টা riff — drop-D-তে হালকা ঘাঁটাঘাঁটি:<br/>
<code>e|---------------------------------------------------|<br/>B|---------------------------------------------------|<br/>G|---------------------------------------------------|<br/>D|-------7-----7----7 ~ 10------7------7-------------|<br/>A|----5-----5-----8----------7-----5-----------------|<br/>E|---------------------------------------------------|</code></sub>

</div>
