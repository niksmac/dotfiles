# Measurement, paid + organic, launch, AI-era discovery

Confidence tags as in `keywords.md`.

## 1. The funnel and its KPIs

ASO has two jobs: **discovery** (being found) and **conversion** (being chosen). Most teams overweight discovery and underweight conversion [Appfigures]. Measure the whole path:

| Stage | iOS (App Store Connect → Analytics) | Google Play (Console → Grow → Store performance / Statistics) |
|---|---|---|
| Impressions | Impressions, unique impressions by source (Search, Browse, App Referrer, Web Referrer) | Store listing visitors by traffic source (Search, Explore, external) |
| Page views | Product page views | Store listing visitors |
| Conversion | Conversion rate (first-time downloads ÷ unique impressions; also per page view) | Store listing acquisition rate (acquisitions ÷ visitors) |
| Installs | First-time downloads, redownloads | Store listing acquisitions, first-time installers |
| Keyword | Search terms (top terms, limited) + Apple Ads search-term reports | Search terms report (top terms by visitors/acquisitions) |
| Quality | Retention, crashes, Day-N, proceeds per download, download-to-paid (2025) | Retained installers, uninstall rate, Android vitals, ratings |

Per keyword, track **rank, estimated impressions, tap-through and conversion** (third-party tool + Apple Ads data).

Rules:
- Compare the same source and the same week span before/after a change (weekday mix matters). Separate organic search from browse and from paid.
- Redownloads outnumber first-time downloads on iOS (~2:1 in Apple's 2024 data) [official/Phiture]: retention and re-engagement count.
- Attribute paid separately: Apple Ads via AdAttributionKit/SKAN or Apple Ads attribution API; Google Ads via Firebase/GA4 or an MMP (AppsFlyer, Adjust, Branch, Singular). An MMP is how you see ASO's effect on blended CAC.

## 2. Benchmarks (use your own category data first)

- Average conversion US 2025: App Store ~8.6% (impression → install ~3.8%), Google Play ~16% (visitor → install) [vendor: AppTweak, May 2026]. Category spread is huge (Food & Drink, Auto very high; strategy games and trivia low).
- Vendors define CVR differently (with or without redownloads, per impression or per page view): never compare numbers across vendors. Benchmark against App Store Connect's peer-group benchmarks and your own history.
- Branded searches convert 60–80%, generic 10–20% [vendor].
- Day-1 retention 25–35%, Day-7 10–15% are rough industry figures [vendor estimate], not store thresholds.
- Android vitals bad-behaviour thresholds [official]: user-perceived crash rate **1.09%**, ANR **0.47%** overall; **8%** on any single phone model; watch crash 4%, ANR 5%; excessive partial wake locks 5%, battery 1%. Over threshold → lower visibility and possibly a warning on the listing; assessed on the last 28 days. Memory and DEX-optimisation metrics join from 2027.

## 3. Timelines

| Change | When to judge |
|---|---|
| iOS keywords (name, subtitle, keyword field) | 2–4 weeks; stable 4–8 weeks |
| Play title / descriptions | 2–6 weeks |
| Visual change without a test | 2–4 weeks of conversion data, same traffic mix |
| PPO / Play experiment | at least 7 days; until the pre-set confidence or the 90-day PPO limit |
| Rating recovery after a fix | weeks to months; reset (iOS) only with a prompt plan |

## 4. ASO + paid acquisition

- **Search ads are keyword research with conversion data.** Run Apple Ads discovery (Search Match + broad) to find terms, then exact-match ad groups to measure tap-through and conversion per term. Terms with strong TTR and conversion earn a place in name/subtitle; others go to the keyword field [vendor].
- **CPP per ad group** (Apple) and **custom store listing per Google Ads campaign** (Play) lift paid conversion; reuse the winner organically (keyword-linked CPP / keyword custom listing).
- **Paid installs lift organic rank** through download velocity for the terms you rank on (practitioner consensus, no official confirmation). Launch bursts work best when the metadata targets the same terms.
- **Cannibalisation:** bidding on terms where you already rank top-3 organically mostly buys installs you'd get free. Check organic installs for the term before vs during the campaign; keep brand defence only if competitors bid on your brand.
- Since March 2026 Apple shows **more ad slots in search** (UK and Japan first): organic results sit lower, so organic tap-through on contested terms falls. Factor ad presence into keyword choice.
- Apple Ads also runs on the Today tab and "You Might Also Like" on product pages.

## 5. Launch and update playbook

Pre-launch:
- Keyword research and metadata per priority locale; screenshots and (optional) video; privacy labels / Data safety ready (both are on the page and a reason for rejection when wrong).
- Play **pre-registration** (with a pre-registration custom listing and rewards allowed only per Play policy) and iOS **pre-order** (up to 180 days) to bank day-1 velocity.
- Landing page on the web with the store badges, structured product info and the same promise; it's what AI assistants and Google read.
- Plan the review prompt and the support channel before launch.

Launch week:
- Concentrate traffic (email, social, PR, paid) into a short window: velocity is a strong ranking signal.
- Nominate for featuring: Apple's featuring nomination form in App Store Connect (new apps, big updates, in-app events), Google Play's featuring is editorial via the Console (no form for most apps; good vitals, ratings and a large-screen-ready, policy-clean app are prerequisites). Featuring can't be bought.

Ongoing:
- **In-app events** (Apple: up to 10 published and 15 approved; each up to 31 days, promotable 14 days before start; searchable; card art 16:9 and details 9:16 with no text or logos; not for price-only promos) and **Promotional content** (Play: Offer, Time-limited event or Major update, up to 4 weeks; submit up to 60 days ahead, ≥14 days ahead to be considered for featuring; review up to ~4 days) for every real moment: seasons, challenges, new content, sales.
- Ship updates regularly with meaningful What's New text; refresh screenshots when the UI or story changes, not on a whim.
- Seasonal metadata and screenshots 2–3 weeks before each market's peak.

## 6. AI and web discovery (2025–26)

- Apple **App Store tags** (iOS 26, en-US first): AI-generated from your metadata, editor-reviewed, shown in search and collections. You can't add tags, only deselect wrong ones in App Store Connect. Make metadata describe what the app does, plainly, so the right tags are generated.
- Apple **AI review summaries** and Google Play **"Users are saying"**: generated from reviews; you can report issues but not edit them. More reviews describing concrete use cases help.
- Google Play **Ask Play** (Gemini on listing pages, comparisons since Oct 2026) and **Guided Search**: draw on the long description, features and reviews. Write the description as clear, specific answers ("Works offline", "Supports shared budgets with a partner", "Exports to CSV").
- **Chat assistants** (ChatGPT, Gemini, Claude) shortlist apps before the store; in a US ChatGPT sample, ~48% of citations were store listings (App Store 37.6%, Play 9.5%) and 27% open web [vendor: AppTweak, May 2026]. Store rank doesn't feed them directly. Help them by:
  - stating specific use cases and the audience in the listing;
  - a crawlable web page per app with the same facts, store links, pricing, FAQs, comparisons;
  - consistent naming everywhere; presence in reviews, comparison articles, Reddit and community answers.
- Accessibility Nutrition Labels (Apple) are on the product page; users can search for accessibility features. Fill them truthfully after an audit.
