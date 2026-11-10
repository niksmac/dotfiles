# Keyword research and placement

Confidence tags: **[official]** Apple/Google docs, **[consensus]** every major ASO vendor agrees, **[vendor]** one vendor's data or tests, **[unverified]** repeated claim with no data.

## 1. Research process (both stores)

0. **Pick the store and the country first.** The same term has different popularity and competition on the App Store and Google Play, and per storefront. Store data (Apple Ads popularity, Play Console search terms) is the source of truth; every tool's volume number is an estimate [consensus: Appfigures, MobiLoud].
1. **Seed list (30–50 terms).** Pull from:
   - what the app does, in the user's words, not the team's (mine reviews, support tickets, Reddit, competitor reviews);
   - store autocomplete on a clean device, per storefront;
   - competitors' titles, subtitles, short descriptions and the terms they rank for (ASO tool);
   - Apple Ads search-term reports and Google Ads search terms: real queries with real conversion data, the best source there is [consensus];
   - Play Console → Store performance → search terms; App Store Connect → Analytics → Sources (search vs browse);
   - **search suggestions** under the store search bar: they are what people actually type.
2. **Score each term** on four axes:
   - **Relevance** (0–3): would a person typing this be happy to find the app? Relevance gates everything; an irrelevant top-ranked term gives impressions without installs, and low conversion on a term drags its rank down.
   - **Volume**: Apple Search Popularity (5–100, logarithmic, from Apple Ads; ~half of all terms sit below 25 and almost everything above 80 is a brand) [vendor] or the tool's own estimate.
   - **Difficulty**: how strong the apps ranking top 10 are (ratings count, brand power, downloads).
   - **Intent / conversion potential**: specific, task-shaped phrases ("budget planner couples") convert better than heads ("finance") [consensus].
3. **Cluster by intent**, not by word. Since Apple's June 2025 search change, results for broad terms mix intents and semantic matching is stronger [vendor: AppTweak, hypothesis]. One cluster = one user need = one CPP / custom store listing / screenshot story.
4. **Pick 5–10 core terms** to own (title / subtitle / short description) and a long tail for the keyword field and long description. Two-word phrases are usually the sweet spot between volume and difficulty [vendor]; Google reported long-tail (3+ words) drives most installing searches [vendor: AppsFlyer citing Google].
5. **Check seasonality** (Google Trends, tool history): fitness peaks Jan and May–Jun, shopping Oct–Dec, tax/finance around filing deadlines. Ship seasonal metadata 2–3 weeks before the peak in each market [vendor].
6. **Record a baseline** (rank, impressions, conversion per term) before any change, then track ranks daily with a tool (AppTweak, Appfigures, MobileAction, Asodesk, App Radar…).
7. **Optional: test copy with search ads before shipping metadata.** Run Google Ads (mobile) or Apple Ads ad groups per keyword theme for ~2 weeks and compare CTR / tap-through and conversion; promote the winning phrasing into title, subtitle or short description [vendor: Asodesk]. Apple Ads Search Match and search-term reports also surface terms you hadn't found.

New app with no ratings: avoid head terms you can't rank for; take long-tail terms where the top 10 are weak, win them, then move up.

## 2. Apple App Store placement

Indexed for search [official]: **app name (30), subtitle (30), keyword field (100 bytes), primary category**. Vendors report in-app purchase display names, in-app event text and the developer name also match searches [unverified]: name IAPs and events in plain search language anyway. Since July 2025, keywords assigned to a **custom product page** decide which page shows for that search; they don't add new keywords.

**Not indexed: the description and promotional text.** Write them for people. Old guides claiming Apple indexes the description are wrong [consensus].

**Screenshot caption text: contested.** Some vendors claim OCR indexing since June 2025; Apple has not confirmed it, and a controlled test of 64 phrases found no strong evidence. Write captions in search language because it helps conversion; never trade clarity for a keyword.

Weight: name > subtitle > keyword field [consensus, no official numbers].

### Plan for word combinations

Apple builds phrases from any words in name + subtitle + keyword field of one locale. Choose words so their intersections form many real queries: `Learn Spanish: Lessons & Words` + keyword field `french,german,italian,language,vocabulary,beginner` covers "spanish lessons", "french lessons", "learn german", "language lessons" and more. List the target phrases, then check each is fully covered by the words in one locale.

### Keyword field rules [consensus; Apple: "separate with commas"]

- 100 bytes, not characters: Cyrillic, CJK, Arabic etc. use 2–3 bytes per character. Count bytes.
- Commas, **no spaces** (`budget,planner,couples`). Spaces waste bytes.
- **Single words**, not phrases: Apple combines words across name + subtitle + keyword field within one locale. `meet,new,people` covers "meet new people".
- **Never repeat** a word that is in the name or subtitle, or already in the field. No extra credit for repetition.
- Each keyword must be more than 2 characters, per App Store Connect help [official]; short tokens like "tv" belong in the name or subtitle.
- Singular **or** plural, not both, in English (Apple matches both). Other locales often don't match plural forms: use the form with more traffic ("palabras" over "palabra"), or both if both have volume.
- Skip stop words ("the", "and", "for", "with", "a", "de", "la"…): Apple handles them; they waste bytes.
- Diacritics: check traffic of each form. People often type without accents ("meditation" vs "méditation"); some forms are auto-corrected by the store, others are not.
- Don't add: "app", "free", "iphone", the category name, your own app/developer name: already covered.
- Hyphens, `@`, `*`, `&` act as separators and cost bytes.
- **No competitor names, trademarks, celebrity names or irrelevant popular terms** (App Review Guideline 2.3.7). Apps are rejected and can be removed.
- Fill all 100 bytes. Unused bytes are wasted ranking surface.
- Changing the keyword field needs a new app version submission (only promotional text changes without one).

### Name and subtitle

- Name: brand + the single most valuable term ("Calm: Sleep & Meditation"). Keep the brand first and readable; Apple rejects names stuffed with keywords, trademarks or other apps' names, prices or other platforms (2.3.7, 2.3.10); reviewers also reject "free", "#1", "best" [unverified as written rules].
- Subtitle: a benefit phrase containing 2–3 indexed words not already in the name. It also shows under the name in search, so it is conversion copy too.
- Don't duplicate words between name and subtitle.

### Cross-localization (US and other storefronts index extra locales)

Each storefront indexes its primary locale plus some secondary locales [vendor: AppTweak, based on 2022 tests, updated Nov 2025; re-verify with a test keyword before relying on it]. Filling a secondary locale with extra **English** keywords widens coverage in that storefront.

| Storefront | Primary | Also indexed |
|---|---|---|
| United States | English (US) | Spanish (Mexico), Russian, Chinese (Simplified), Arabic, French, Portuguese (Brazil), Chinese (Traditional), Vietnamese, Korean |
| United Kingdom | English (UK) | English (Australia) |
| Australia, New Zealand | English (Australia) | English (UK) |
| Canada | English (Canada) | French (Canada) |
| Japan | Japanese | English (US) |
| Germany, Austria | German | English (UK) |
| Switzerland | German | English (UK), French, Italian |
| France, Italy, Netherlands, Poland, Korea, Brazil (most others) | local | English (UK) |
| Mexico and most of Latin America | Spanish (Mexico) | English (UK) |
| Saudi Arabia, UAE (Arabic markets) | Arabic | English (UK) |

Rules:
- Words combine only **within one locale**, not across locales. Put phrase-forming words in the same locale.
- The name/subtitle of a secondary locale is shown to users of that language. In the US, a Spanish (Mexico) name must still make sense to Spanish speakers: keep it a real Spanish name/subtitle and use the English overflow only in that locale's keyword field.
- Apple tolerates this but doesn't endorse it. Keep it relevant; irrelevant terms are still a 2.3.7 violation.

## 3. Google Play placement

Indexed [consensus; Google only says repeated or irrelevant keywords in these fields violate policy]: **title (30), short description (80), full description (4,000)**, developer name, plus behavioural signals. No keyword field. Google applies NLP to natural text, so related terms and synonyms count; repetition beyond natural use does not.

- **Title**: brand + top term, as on iOS. Play's metadata policy bans emoji, ALL CAPS (unless brand), repeated special characters, ranking/performance claims ("#1", "top", "best", "popular"), price/promo text ("free", "% off") and program terms ("Editor's Choice", "new") in the title, icon and developer name.
- **Short description**: Play's best-practice page says don't repeat it verbatim in the full description.
- **Short description**: primary term + benefit, readable as a sentence. It is shown on the listing and in some search layouts.
- **Full description**:
  - first 1–3 lines matter most to people (shown before "more") and are weighted most [consensus];
  - mention each core term where it naturally belongs, usually a handful of times across 4,000 characters, plus synonyms and related terms; don't aim for a target density (older "5 times" rules are obsolete). No keyword lists, no blocks of repeated terms (policy: keyword stuffing, unattributed testimonials and lists of other apps or search terms are violations);
  - structure: hook, 3–6 feature/benefit sections with short headings, social proof that is attributed and verifiable (awards with source), FAQ-style lines that answer real queries (Ask Play and AI summaries read the description), support contact;
  - no HTML beyond Play's supported tags; no user testimonials unless attributed.
- **Ask Play / Guided Search (2025–26)** draw on the long description, key features and reviews [vendor inference]. Describe concrete use cases ("track shared expenses with your partner") rather than adjectives.
- **Off-store signals**: Google Play reportedly gives weight to web mentions/backlinks to the Play listing; Apple does not [vendor].

## 4. Localization

- **Localize, don't translate.** Run keyword research per market: the local search term often isn't the translation ("free calls" in Germany is "kostenlos telefonieren", not "freie Anrufe").
- Prioritise by revenue potential × search volume × competition. Tiers [vendor]:
  1. Full: metadata + local keyword research + localized screenshots (+ video) for top markets.
  2. Selective: metadata with local keyword research, default screenshots.
  3. Translation only for the long tail.
- Pilot one or two markets, expand when organic installs rise.
- Play auto-translates listings for missing languages; machine translation is better than nothing but loses keyword intent. Write your own for priority markets.
- Native-speaker review for every title/subtitle: a wrong word in a title is visible to every user.
- Localize text inside the icon (if any) and the screenshots too: local-language captions often lift conversion more than metadata alone (anecdote: Portuguese text on a kids' game icon doubled installs in Brazil) [vendor anecdote].

## 4a. Brand vs generic in the title

- Established brand with brand search: keep the brand in the title (it's the strongest field and protects brand suggestions); a short brand plus one generic term.
- Unknown brand: give most of the 30 characters to the generic term, the brand short. Putting the brand on the icon/screenshot frees title characters, but test it: dropping the brand from the title can lose brand suggestions and let competitors appear on your brand query [vendor: Asodesk].
- Protect your brand query with Apple Ads / Google Ads brand campaigns if competitors bid on it.

## 5. Iteration cadence

- One change set per release; change 1–2 keyword elements at a time so you can attribute the effect.
- iOS: new keywords usually start ranking within days of the version going live; judge rank after **2–4 weeks**, stable after 4–8 [vendor]. Claims of a guaranteed "72-hour update boost" are unsourced.
- Play: metadata changes go live after review, ranking settles over **2–6 weeks** [vendor].
- Review every 4–8 weeks: drop terms where you rank below ~20 with no movement and that are irrelevant or uncontested; promote terms from the keyword field to the subtitle when they convert.
- React off-cycle to: competitor moves, a seasonal peak, a conversion drop, or high-converting Apple Ads/Google Ads terms not yet in metadata.
