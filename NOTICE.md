# NOTICE

This file documents lineage, ownership, and licensing distinctions for
**ULTAPALTA (উল্টাপাল্টা)**.

## 1. What ULTAPALTA is

ULTAPALTA is a Bangla-first rebrand and extension of
[REA: Reverse Engineer Anything](https://github.com/morluto/rea), a reverse
engineering CLI and MCP server originally published at
`github.com/morluto/rea` and `npm` as `rea-agents`, distributed under the MIT
License (see [LICENSE](LICENSE), copyright (c) 2026 morluto).

MIT's only substantive condition is preservation of the original copyright
and permission notice. ULTAPALTA therefore:

- keeps the upstream `LICENSE` file and its copyright notice untouched;
- keeps upstream code, tests, tooling, documentation and third-party notices
  ([THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md)) substantially intact,
  with changes limited to product identity, localization, installers,
  documentation and assets described below;
- does not claim sole authorship of inherited code;
- does not remove or alter any third-party attribution.

## 2. Files authored or substantially modified for ULTAPALTA

Copyright (c) 2026 ULTAPALTA contributors (MIT, consistent with the inherited
license):

- `src/cliLocale/` — Bengali/English CLI message catalogs and resolver.
- `src/cli/interactiveSetup.ts` — localized setup wizard.
- `src/identity.ts`, `src/generatedPackageMetadata.ts`, `package.json`,
  `package-lock.json` — product identity (name `ultapalta`, version 3.0.0,
  `ultapalta` executable; `rea`/`rea-agents` kept as compatibility aliases).
- `install.ps1` — original PowerShell one-line installer.
- `install.sh` — adapted from the upstream installer (morluto/rea, MIT) with
  Bengali step messaging, npm-latest resolution and Termux support; the
  upstream truncation-guard structure is intentionally preserved.
- `assets/mascot/*` — original mascot artwork (see below).
- `website/locales/bn/` — original Bengali translation catalog.
- `scripts/build-bn-locale.py`, `scripts/website_i18n.py` (Bengali font
  loading addition only).
- `README.md`, `docs/readme/README_bn.md`, `NOTICE.md`,
  `ARCHITECTURE_DECISIONS.md`, `ROADMAP.md`, `CODE_OF_CONDUCT.md`,
  `.env.example`, and the ULTAPALTA 3.0.0 entry in `CHANGELOG.md`.
- `tests/boundary/cli/cliSetup.test.ts` — updated to the Bengali-default
  wizard strings plus an English-locale regression test.

The original upstream README is preserved at
[docs/UPSTREAM_README.md](docs/UPSTREAM_README.md) for reference.

## 3. Artwork and brand assets

The উল্টাপাল্টা মেকার (ULTAPALTA Maker) mascot, the উল্টা-spiral emblem and
the ULTAPALTA visual language are original artwork created for this project.
They are dedicated to the public domain under
[CC0 1.0](https://creativecommons.org/publicdomain/zero/1.0/). They are not
derived from any existing game, film, or brand character.

## 4. Trademarks

"REA" and "Reverse Engineer Anything" are project names of the upstream
repository. ULTAPALTA uses them only for honest attribution and
interoperability references. "ULTAPALTA / উল্টাপাল্টা" is the name of this
fork's product. No affiliation with or endorsement by upstream authors is
claimed.

## 5. No warranty

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, AS DETAILED IN THE FULL MIT LICENSE TEXT. Use this toolkit only on
software and systems you are authorized to analyze (see
[DISCLAIMER.md](DISCLAIMER.md) and [SECURITY.md](SECURITY.md)).
