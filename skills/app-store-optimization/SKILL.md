---
name: app-store-optimization
description: App Store Optimization (ASO) for the Apple App Store and Google Play. Audits listings, researches and places keywords (iOS name, subtitle, keyword field, cross-localization; Play title, short and full description), writes policy-safe metadata per locale, plans screenshots, icon and video for conversion, ratings and review strategy, A/B tests (PPO, custom product pages, Play experiments, custom store listings), in-app events and promotional content, localization, measurement and paid/organic interplay, and checks every field against Apple and Google policy and consumer law (fake reviews, incentives, trademarks, misleading claims). Also prepares full submission metadata: every field App Store Connect and Play Console ask for (app information, age rating, App Privacy / Data safety, export compliance, App Review info and demo account, content rating, target audience, permission declarations, account deletion, subscriptions and in-app purchase text), derived from the code. Use when asked for ASO, app store keywords, an app title or subtitle, store listing copy, store submission metadata or a first submission, a listing audit, why downloads or rankings dropped, a store rejection over metadata, review prompts, or app launch visibility.
---

# App Store Optimization

ASO has two jobs: **discovery** (rank for the searches your users make) and **conversion** (turn the impression into an install). Conversion feeds back into rank, and a weak app can't be fixed by its listing: crashes, poor retention and bad reviews cap everything below.

Read as needed:
- `references/metadata-specs.md`: every field, limit and what each store indexes.
- `references/keywords.md`: research process, iOS keyword field rules, cross-localization table, Play description writing, localization, cadence.
- `references/conversion.md`: icon, screenshots, video, copy, PPO / CPP / Play experiments / custom listings, ratings and reviews.
- `references/measurement.md`: KPIs, benchmarks, timelines, paid + organic, launch playbook, AI-assistant discovery.
- `references/policy-legal.md`: Apple and Google rules, consumer law (FTC, EU, UK), trademarks, the pre-submission checklist.
- `references/submission-fields.md`: every field App Store Connect and Play Console ask for (new app and update), with limits, where each lives, and how to answer it from the code.
- `references/sources.md`: sources with dates and confidence, and the myths not to repeat.
- `scripts/aso-lint.py`: lints `aso/listing.md` directly (limits, keyword hygiene, banned terms, other platforms, competitors, IAP/subscription text, URLs, TODOs); `--write` refreshes the character counts after edits. Also reads a metadata JSON (plus its `submission` block's required fields and secrets). `--template` prints an example JSON.
- `scripts/aso-render.py`: one-time converter from a JSON draft (or the template) to `aso/listing.md`.
- Screenshots and feature graphic design and pixel specs: the `store-screenshots` skill (`../store-screenshots/references/specs.md`).

## 0. Ground rules

- **Truth first.** Every claim in the listing must be true for every user today, or qualified. Check claims against the code, pricing and the live product before writing them. Mark paid features.
- **Store facts change.** `policy-legal.md` and `metadata-specs.md` carry a verified date. If older than ~6 months, or when a limit matters for a submission, re-check the official page (links in `sources.md`) and update the file.
- **Label confidence.** Separate official rules from practitioner consensus and vendor claims when advising. Never state a contested claim (e.g. screenshot-caption indexing) as fact.
- **Never** propose: competitor or celebrity names in any field, rating incentives, review gating, fake or bought reviews or installs, misleading screenshots, keyword stuffing. These get apps removed and companies fined.

## 1. Gather ground truth

0. **Confirm which app you are looking at.** Read the bundle ID and package name from the code (`PRODUCT_BUNDLE_IDENTIFIER` in `ios/*.xcodeproj/project.pbxproj` or the Xcode target; `applicationId` in `android/app/build.gradle*`). A Play listing matches only if its `?id=` equals `applicationId`. An App Store listing matches only if its bundle ID matches; `https://itunes.apple.com/lookup?id=<appId>` returns `bundleId`, and `?bundleId=<id>` returns nothing if the app isn't live. Also check the developer and that the listed version is plausible next to the repo version. Store IDs in docs and specs can point at an older or sibling app from the same company: don't trust them unverified. If nothing matches, this is a **first submission**: skip the audit and say so.
1. Product: what it does, for whom, the 3 strongest differentiators, pricing model, which features are paid, markets and languages it supports. Prefer the live website's positioning over old repo copy.
2. Current listing per store and locale (name/title, subtitle, keywords if available, short/full description, screenshots, rating, reviews count). Ask the user for the iOS keyword field; it isn't public.
3. Data the user can share: App Store Connect analytics (impressions, page views, conversion by source, search terms), Play Console store performance and search terms, Apple Ads / Google Ads search-term reports, an ASO tool export. No data → say the plan is built on estimates.
4. Top 5–10 competitors per main search term, and what they rank for.

## 2. Audit (only when a listing for this exact app exists)

Score each item **good / fix / missing** and give the fix:
- Discovery: title and subtitle use the best terms; iOS keyword field full and clean (run the linter); Play short description leads with the main term; full description natural and specific; locales and cross-localization used; category choice.
- Conversion: icon stands out in the search row; frames 1–3 say the core promise; screenshots match top search intents; video earns its slot; rating ≥ 4.0 with recent reviews; replies to negative reviews.
- Health: Android vitals under thresholds; crash and retention issues behind bad reviews; update cadence.
- Compliance: run the checklist at the end of `policy-legal.md`.
- Opportunity: CPPs / custom store listings, in-app events / promotional content, untapped markets, seasonal moments.
Lead the report with the 3–5 changes with the largest expected impact.

## 3. Keyword research → placement

Follow `references/keywords.md`. Output a keyword table per store and market: term, relevance (0–3), popularity/volume, difficulty, intent cluster, current rank, target field. Then place:
- **iOS**: name (brand + top term) → subtitle (benefit + 2–3 new terms) → keyword field (100 bytes, single words, commas, no spaces, no repeats, no words from name/subtitle) → secondary locales that the storefront indexes → CPP keyword assignment per intent cluster.
- **Play**: title (brand + top term) → short description (main term + benefit, a real sentence) → full description (natural, specific use cases, synonyms; first lines strongest) → keyword-targeted custom store listings for distinct intents.

## 4. Write the metadata

- Write per store and per locale. Localize from local keyword research; native-speaker review for titles.
- **The deliverable is `aso/listing.md`, a Markdown file people read, paste from and edit.** Each field is a bold title (the console field name, count/limit) over a ```` ```text ```` block, grouped under `## App Store` / `## Google Play` and `### <locale> · <language>`. The competitor and trademark list sits in `## Lint settings` at the end. Nobody should have to open JSON to find or change store copy.
- Start it with `aso-render.py` from a JSON draft (convenient when a script builds the locales) or from `aso-lint.py --template`. From then on, edit the Markdown only, and don't keep the JSON in the repo, where it would drift.
- Lint it: `python3 scripts/aso-lint.py --write aso/listing.md`. This refreshes the counts and checks limits and policy. Fix every ERROR; justify any WARN you keep.
- When the team has edited `listing.md`, edit it in place; never regenerate it and wipe their changes.
- Give 2–3 options for name/title and subtitle/short description, with the trade-off (brand vs generic, which terms each covers).
- iOS promotional text: time-sensitive news (no build needed). What's New: the real change. A first version has no What's New; don't write "now you can…" copy for an app nobody has seen.

## 4a. Submission metadata (new app or a review-blocking gap)

Follow `references/submission-fields.md`. Put the text fields with limits (IAP and subscription names, descriptions and benefits, App Review notes, URLs) in `listing.md`, so they're linted and pasteable. Write every other console answer in `aso/submission.md` as readable tables, grouped the way each console groups them. Answer from the code, not from memory:
- **Permissions and usage strings**: `AndroidManifest.xml` `uses-permission` and `foregroundServiceType`; `Info.plist` `NS*UsageDescription`. Each sensitive Android permission maps to a Play declaration (photo/video, foreground service, …) or should be removed.
- **SDKs and data**: dependency manifest (`pubspec.yaml`, `package.json`, Podfile, Gradle) for analytics, ads, crash, auth and payment SDKs. Then the API calls that send user data (sign-up fields, uploads, recordings, purchases). This gives App Privacy and Data safety. Processors acting for you still count as collection.
- **Export compliance**: HTTPS / OS crypto only → exempt; set `ITSAppUsesNonExemptEncryption` = `NO` in `Info.plist` so builds stop asking.
- **Privacy manifest**: `PrivacyInfo.xcprivacy` for the app target when it calls required-reason APIs.
- **Login**: login-gated apps need a demo account for App Review and Play App access. Never write the password into the repo; it goes into the console only.
- **Account deletion**: in-app deletion is required by Apple (5.1.1(v)) when accounts can be created; Play also needs a web URL where people can request deletion.
- **User-generated content and AI output**: Apple 1.2 asks for filtering, reporting, blocking abusive users and published contact info. Play's UGC and AI-Generated Content policies ask for in-app reporting, including of AI output the user generated themselves.
- **Duplicate apps**: if the same developer already has a similar app live, flag Apple 4.3 (spam) and Play's repetitive-content policy. Plan to retire or clearly differentiate the old app and explain it in the review notes.
- **Subscriptions**: Apple 3.1.2 needs the plan name, length, price and links to Terms of Use (EULA) and Privacy Policy in the app and in the metadata.
- Mark every answer you couldn't derive as `TODO` with the person who must supply it (phone, address, D-U-N-S, demo account).

## 5. Creatives and conversion

Follow `references/conversion.md`. For each screenshot frame: headline (benefit), proof visual (real UI), the search intent it serves. Frames 1–3 carry the pitch. Design and export with the `store-screenshots` skill.

## 6. Ratings and reviews

Plan the system prompt moments (after a success, never at first launch or after an error), the "write a review" link for a settings screen, the reply process (recent 1–2 star first, say what was fixed), and the review-theme feedback loop to product. No incentives, no pre-question, no custom prompt.

## 7. Test, launch, iterate

- Test plan: one hypothesis and one variable per test, metric and stop rule set in advance; PPO (iOS, organic), Play experiments (≥ 7 days), CPPs and custom store listings for paid and intent traffic. Log each test.
- Launch: concentrate traffic for velocity, pre-order / pre-registration, featuring nomination (Apple), in-app events and Play promotional content for real moments.
- Measure with `references/measurement.md`: same source and same weekday span before and after; judge keyword changes after 2–4 weeks, not days.
- Revisit every 4–8 weeks, or when a competitor, a season or a conversion drop calls for it.

## 8. Deliverables

Save into the app's repo (ask where; default `aso/`), not into this skill:
- `aso/listing.md`: **required.** Every text field the stores ask for, per store and locale, ready to paste, with counts. Linted clean. The single source of store copy.
- `aso/keywords.md` (or `.csv`): the keyword table and cluster map.
- `aso/plan.md`: audit findings, the prioritised changes, screenshot frame plan, CPP / custom listing plan, test plan, localization order, review plan, KPIs and baseline numbers.
- `aso/log.md`: dated entries: what changed, why, and the measured result. Learnings carry over between cycles.
- `aso/submission.md` (first submission or a gap): every console answer from §4a, with the code evidence for each, and the blockers to fix before submitting.

Building a first draft as JSON from a small script (shared paragraphs, UK spelling swaps) keeps locales in sync; convert it with `aso-render.py`, then delete the JSON and the script.

## Pitfalls seen in past runs

- Auditing the wrong listing: a sibling or older app from the same company, found through an ID in a spec. Run step 1.0 first.
- `ai`, `tv` and other 2-letter terms can't go in the iOS keyword field (more than 2 characters required): put them in the name or subtitle.
- Apple reserves "For Kids" / "For Children" for the Kids Category (2.3.8). A website headline like "… for Kids" can't be copied into iOS metadata; use "for parents", "your child", "children aged 2 to 13".
- Art-style and voice-vendor brand names hide in product copy (e.g. "Pixar 3D", a TTS vendor). Add them to `competitors` so the linter catches them.
- Plan quotas the backend can change (stories per month) go stale in a description; describe tiers by what they unlock unless someone keeps the numbers in sync.
- Play listing pages often render empty for a plain fetch. Use the Console text, a store-data site, or ask the user.
- Play rejects `READ_MEDIA_IMAGES` / `READ_MEDIA_VIDEO` for apps that only pick an occasional photo: use the system photo picker and drop the permission.

## 9. Dos and don'ts at a glance

| | Apple App Store | Google Play |
|---|---|---|
| **Do** | Brand + top term in the 30-char name; new terms in the subtitle; fill the 100-byte keyword field with single words, commas, no spaces | Brand + top term in the 30-char title; main term + benefit in the 80-char short description |
| **Do** | Use secondary locales the storefront indexes (US: es-MX, fr, zh-Hans, …); keep each locale's name readable for its speakers | Write the 4,000-char description for people: concrete use cases, synonyms, scannable sections; Ask Play and AI summaries read it |
| **Do** | Make frames 1–3 the pitch; >50% of screenshots show the real app; previews are screen captures | Feature graphic with no text claims; screenshots of the real app; video shows the app within 10 s |
| **Do** | CPPs per intent (up to 70), keyword-linked for organic search; PPO for the default page | Custom store listings (up to 50) by keyword, country, ads, lapsed users; experiments ≥ 7 days |
| **Do** | `requestReview` after a success moment; reply to reviews; reset rating only after a real fix | In-App Review API after a success moment; reply to reviews; keep vitals under 1.09% crash / 0.47% ANR |
| **Do** | Privacy labels, age rating, accessibility labels and EU trader status accurate | Data safety, target audience, IARC rating and trader status accurate |
| **Don't** | Repeat words across name/subtitle/keywords; add "app", "free", plurals of English words, stop words | Repeat or list keywords; use emoji, ALL CAPS or repeated symbols in the title |
| **Don't** | Put competitor, celebrity or trademarked names anywhere, including the hidden keyword field (2.3.7) | Use others' brands, celebrity names or imply endorsement (Metadata, Impersonation, IP policies) |
| **Don't** | Mention Android or other platforms (2.3.10); "iPhone <App>" naming; "Apple App Store" | Put "#1", "best", "top", "new", "free", prices, "% off", awards or "Editor's Choice" in title, icon, developer name or graphics |
| **Don't** | Make unverifiable claims or prices in name/subtitle; generic What's New for feature releases | Use unattributed testimonials; CTAs like "Download now" in assets; misleading screenshots |
| **Don't** | Build custom review pop-ups, gate reviews, or reward ratings (5.6.1, 5.6.3) | Ask "Do you like the app?" before the review card, reward ratings, or trigger the card from a button |
| **Don't** | Buy installs, reviews or chart placement: discovery fraud (5.6.3) | Inflate installs or ratings by any means: removal and account termination |
| **Law** | FTC Reviews Rule (US), EU Omnibus/UCPD, UK DMCC Act: no fake, bought, insider-undisclosed or suppressed reviews; claims must be substantiated; trademarks and comparative-advertising rules apply | Same |
