# ULTAPALTA রোডম্যাপ / Roadmap

ট্রান্সপারেন্ট, কাজ-ভিত্তিক পরিকল্পনা। তারিখ-এর প্রতিশ্রুতি না, priority-র ক্রম।

## এখনই (v3.0.x)

- [ ] `raaj33b/ultapalta` GitHub-এ publish + npm-এ `ultapalta` package publish করা —
      তখনই one-liner URL আর `npx ultapalta` লাইভ হবে।
- [ ] ব্রাউজারে manually চেক: installer dry-run আউটপুট, README mascot রেন্ডার,
      docs site-এ বাংলা টাইপোগ্রাফি (Noto Sans Bengali fallback সহ)।
- [ ] বাকি upstream test suite পুরোপুরি রান করে দেখা (এই বিল্ডে targeted subset
      রান হয়েছে — delivery report দেখো)।

## কাছাকাছি (v3.1)

- [ ] **CLI localization expansion** — wizard-এর বাইরে `doctor`, `update`,
      `uninstall` আর common error paths-এর বার্তা বাংলায় (`src/cliLocale/`-এ
      নতুন key যোগ করলেই হবে)।
- [ ] **Website bn coverage** — `website/locales/bn/messages.po`-তে বাকি ~১৫০০
      string (home, get-started, FAQ আগে)। প্রতিটা সম্পূর্ণ পেজ অনুবাদ হলেই
      ওই পেজ bn edition-এ রেন্ডার হয়।
- [ ] `ultapalta doctor` আউটপুটে mascot-এর ASCII ভার্সন।

## মাঝারি (v3.2+)

- [ ] Banglish → বাংলা language selector ওটার জন্য CLI-তে `--lang` ফ্ল্যাগ।
- [ ] VitePress docs-এ ULTAPALTA থিম (design tokens: midnight ink / cream /
      electric yellow / chili red / cyan) + mascot empty-state illustrations।
- [ ] Homebrew tap ও scoop bucket (installer-এর third path)।
- [ ] Bengali-font bundling review (WOFF2 self-host) — এখন CDN লোড হয়।

## ভবিষ্যৎ (ideas, কোনো প্রতিশ্রুতি না)

- [ ] উল্টাপাল্টা মেকার-র interactive hero (hover করলে চোখের দৃষ্টি ঘোরে)।
- [ ] Community-অনুবাদ প্রোগ্রাম (`translations status --language bn` দিয়ে
      progress দেখা যায়)।
- [ ] GitHub Pages-এ docs-এর hosted সংস্করণ।

---

তোমার পছন্দের item বাছাই করে CONTRIBUTING.md পড়ে শুরু করো — ছোট PR-ও স্বাগত।
