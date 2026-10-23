# ARCHITECTURE_DECISIONS

ULTAPALTA 3.0.0 — কেন কী সিদ্ধান্ত নেওয়া হলো, সংক্ষেপে। This file records the
load-bearing decisions made while transforming the upstream REA repository
into ULTAPALTA, so future maintainers know what was deliberate.

## A1. Fork in place; do not rewrite the engine

**Decision:** PRESERVE the entire upstream engine (`src/`, `bridge/`,
`native/`, `tests/`, `scripts/`, CI) and rebrand only the identity surfaces.

**Why:** The upstream repo is a mature, heavily-tested system (5,400+ files,
vitest suites, conformance fixtures, generated catalogs). Replacing its
architecture for visual reasons would destroy working functionality — exactly
what the brief forbids. MIT permits rebranding with attribution.

## A2. Central identity: `src/identity.ts`

**Decision:** Change `PRODUCT_IDENTITY` (displayName `ULTAPALTA`, cliBinary
`ultapalta`, mcpServerKey `ultapalta`, configFileName `ultapalta.json`)
instead of scattering renames.

**Why:** Upstream already centralizes identity so persistent client
registrations cannot drift from packaging. Renaming here cascades safely.

**Compatibility kept:** `bin` in `package.json` still exposes `rea` and
`rea-agents` aliases, and the distributed skill keeps its upstream name
`reverse-engineer-anything`, so existing agent guidance keeps resolving.

## A3. Environment variables stay `REA_*`

**Decision:** Do not rename `REA_*` environment variables.

**Why:** They are documented, tested, wired through CI and deep in the engine.
Renaming would break provider configuration for no user-visible gain. The
new `ULTAPALTA_LANG` variable is additive. Documented in `.env.example`.

## A4. CLI localization scope

**Decision:** New `src/cliLocale/` layer (bn default, en fallback,
`ULTAPALTA_LANG=en` opt-out) applied to the **interactive setup wizard** —
the primary human-facing surface — plus banner-ready strings. Command names,
flags, paths, schemas and machine-readable output stay untranslated.

**Why (honesty):** The CLI has thousands of `.describe()` strings across 60+
command modules; translating everything mechanically would reduce precision
where technical instructions must stay unambiguous. The wizard is where a
person reads prose. Coverage is documented here rather than overstated.

## A5. Installer-first distribution (the "main attraction")

**Decision:** `install.ps1` (Windows, `irm | iex` style) and a reworked
`install.sh` (macOS/Linux/Termux, `curl | bash`) that run five serial
Bengali-labeled steps: environment → Node gate → plan → install → setup.

**Why:** The brief asks for a Chris-Titus-winutil-style one-liner anyone can
run. Upstream's `install.sh` already had a strong truncation-guard design; it
was adapted (not replaced), gaining npm-latest default resolution and a
GitHub source-install fallback. The PowerShell installer is new.

**Limitation documented:** The one-liner URLs resolve only after the repo is
pushed to `raaj33b/ultapalta`; until then the scripts run locally.

## A6. Website: add a real `bn` locale; do not reskin the production site

**Decision:** Add Bengali as a first-class locale —
`website/locales/bn/messages.po` (1728-entry catalog, 200 strings translated:
full navigation, plus complete `contributors`, `blog`, and `guides` pages),
registered in `languages.json`, with Noto Sans Bengali loaded for `bn` pages.
Leave `templates/` and the shared header/footer branding as upstream.

**Why:** The website is a production system with strict drift checks
(`website.py check` verifies template-synced regions, README editions, and
catalog consistency). Reskinning it would break its publisher. The i18n
design natively supports partial catalogs with labeled English fallback per
page — so a partial bn catalog is architecturally correct, and contributors
can extend it (see ROADMAP).

## A7. README strategy

**Decision:** Main `README.md` is the Banglish ULTAPALTA edition; the
original English README is preserved at `docs/UPSTREAM_README.md`; a
`docs/readme/README_bn.md` edition keeps the language-edition inventory
consistent (this exact match is enforced by `website_i18n.languages()`).

## A8. Mascot: layered SVG, not WebGL

**Decision:** Original 3D-inspired layered SVG artwork (gradients, rim
light, specular highlights, CSS keyframe idle/blink animation with
`prefers-reduced-motion` support) plus pose variants — over a Three.js/WebGL
scene.

**Why:** No heavyweight dependency, editable source of truth, works in
README/docs/CLI contexts, degrades everywhere. The brief allows exactly this
trade-off when 3D is unjustified.

## A9. Version 3.0.0

**Decision:** Fork version resets to `3.0.0` (per product direction) while
`CHANGELOG.md` retains full upstream history. The generated
`src/generatedPackageMetadata.ts` was kept in sync by hand; re-run
`npm run metadata:generate` after future `package.json` changes.

## A10. CI

**Decision:** Keep upstream workflows (they build/lint/test from source, so
they remain meaningful for the fork). They were not executed in this
environment (no GitHub runner); see the delivery report for what was
actually validated locally.
