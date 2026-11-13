# Conversion: creatives, testing, ratings and reviews

Rankings bring impressions; the product page turns them into installs, and conversion feeds back into ranking for the terms that brought the visitor. Fix conversion before buying traffic.

Confidence tags as in `keywords.md`. For exact pixel sizes, counts and upload rules, use `../store-screenshots/references/specs.md` (and the `store-screenshots` skill to design the frames).

## 1. What people see, in order

| Surface | iOS | Google Play |
|---|---|---|
| Search result | icon, name, subtitle, rating, first **3 portrait screenshots** or the app preview (autoplays muted) | icon, title, rating, downloads; for some queries screenshots/video, feature graphic |
| Product page above the fold | name, subtitle, rating/age/rank badges, first screenshots or preview | feature graphic or video, icon, title, rating, downloads, first screenshots |
| Below | promo text (170), description, What's New, ratings & reviews, AI review summary, privacy and accessibility labels, events | short description, "About this app", Data safety, ratings & reviews, AI "Users are saying", events/promotional content |

Most visitors decide without scrolling, so the icon, the first 2–3 screenshots, the subtitle (iOS) / short description (Play) and the rating do most of the work [consensus].

## 2. Icon

- One simple, recognisable shape; no words (illegible at 60 px), no screenshots in the icon.
- Distinct from the top 10 competitors on your main search terms: put your icon in a mock search results row to judge it.
- iOS 26: supply a layered icon made with **Icon Composer** so it renders correctly in Liquid Glass default, dark, clear and tinted modes; flat untouched icons get the glass treatment automatically, realistic 3D renders tend to look worse [official guidance via WWDC 2025].
- Play: 512 × 512 32-bit PNG; Google applies the mask and shadow; no badges ("free", "#1", "new"), no ranking claims (metadata policy).
- Icons give the biggest single test swings (5–10% in vendor tests) [vendor]; test 2–4 times a year.

## 3. Screenshots

- **Benefit first.** Caption = what changes for the user ("Split bills in seconds"), UI = proof. 2–6 words, large type, legible on a phone in the search row.
- **Frames 1–3 are the billboard**: the core promise, the #1 differentiator, the #2 differentiator. Many people never swipe further.
- One clear message per frame; consistent visual system; tell a sequence.
- Match the top search intent: if most traffic comes from "budget planner", frame 1 says budget planner. Use CPPs/custom listings for other intents.
- **Honest UI**: Apple 2.3.3 requires screenshots to show the app in use (more than half the frames), not just title art, login or splash screens; Play requires that graphics represent the actual app. Lifted, enlarged real UI cards are fine; fake features are not.
- Social proof only if real and attributable (an award with its source and year). Apple: no fake ratings; Play: no testimonials, ratings, rankings, "#1", "best", downloads counts, prices or promos in screenshots, and no CTAs ("Download now", "Play now").
- Localize captions per market, and the UI in them where you can (5–15% conversion gains reported) [vendor].
- Games: landscape gameplay often works; non-games: portrait [consensus]. Test, don't assume.
- Captions in natural search language cost nothing and might help indexing (contested); never make copy worse for it.

## 4. Video (iOS app preview, Play promo video)

- iOS: up to 3 previews per locale and device, 15–30 s, captured from the app (no hands holding devices, no footage that isn't the app). The first preview autoplays muted in search and takes slot 1 of the 3 visible, so it replaces a screenshot. Hook in the first 3–5 s; design for muted viewing (captions).
- Play: one public/unlisted YouTube URL, monetisation off, not age-restricted, embeddable; only the first 30 s autoplay; show the app within 10 s and keep ≥80% of the video on the real experience; no CTAs; landscape or portrait without black bars (early 2026 tests: portrait slightly better watch time and conversion [vendor]).
- Video doesn't always win: Apple's own PPO example (Simply Piano) shows screenshots beating video by 3%. Test it; skip video rather than ship a poor one.

## 5. Text that converts

- iOS subtitle (30): the benefit, with keywords. Promotional text (170): time-sensitive news, changes **without** a new build, not indexed.
- Play short description (80): benefit + top term, a sentence a person would say.
- Description opening lines: who it's for, the outcome, the proof. Then features as benefits, then trust (privacy stance, support contact, awards).
- What's New: real release notes. A wall of "bug fixes" is a missed chance to show momentum.
- No claims you can't back. "Works offline" needs to be true in every flow, or qualified.

## 6. A/B testing

### Apple Product Page Optimization (PPO)
- Up to **3 treatments vs original**: icon (alternate icons must ship in the binary), screenshots, previews. Text can't be tested. A running test can't be edited.
- Runs up to **90 days**; Apple reports Bayesian confidence (90% threshold) and warns if it won't reach it. Treatments need App Review.
- Only **organic** App Store traffic in supported surfaces. Only one test at a time.
- Low traffic (a few hundred page views a day) rarely reaches significance: test bold differences, fewer treatments.

### Apple Custom Product Pages (CPP)
- Up to **70** per app, each with its own screenshots, previews, promotional text and URL; optional deep link (iOS 18+). Reviewed like any metadata.
- Use them for: Apple Ads ad groups (one CPP per keyword theme), campaigns/social/email (link the CPP URL), and since July 2025 **organic search**: assign keywords from your keyword set to a CPP, and that page shows for those searches. A keyword maps to one CPP. It doesn't add keywords.
- Reported lift 5.9% average, up to 8.6% [vendor].

### Google Play Store Listing Experiments
- One default-graphics experiment (icon, feature graphic, screenshots, video) or up to 5 localized experiments (which can also test short and full description) at a time. Up to **2 variants** vs current; auto-stop after 6 months; one variable per test.
- Run at least **7 days** to cover weekday/weekend cycles even if significance shows earlier; Google lets you pick the metric (retained first-time installers, recommended), confidence level and minimum detectable effect.
- Don't run overlapping tests on the same listing; avoid holidays and big campaigns that change traffic mix.
- Apply the winner, then re-measure: test lift often shrinks after rollout (novelty, regression to the mean).

### Google Play custom store listings
- Up to **50**: by country, by search keyword (2025: show a listing for chosen search terms; Play suggests keywords), pre-registration, lapsed/churned users, Google Ads campaigns (unique URL). Not auto-translated.
- Group several related keywords per keyword listing; one term alone gives little traffic.

### Method
- Hypothesis first ("Leading with 'shared budgets' will lift conversion from 'budget app for couples' traffic"), one variable, a pre-set metric and stop rule.
- Aim for a few hundred conversions per variant before trusting a result.
- Log every test and result in the app's ASO log so learnings carry over (see SKILL.md).
- iOS and Play audiences behave differently: test on each store.

## 7. Ratings and reviews

### Why
- Rating shows in every search row; under ~4.0 stars conversion drops sharply (size disputed: 10–50% across vendors) [consensus on direction]; most featured apps are ≥ 4.0, typically 4.2–4.6 [vendor].
- Volume and recency matter for ranking more than the decimal [vendor].
- Review text now feeds AI summaries on both stores and Ask Play: reviews describing concrete use cases help.

### How to ask (allowed)
- iOS: `SKStoreReviewController.requestReview(in:)` / SwiftUI `requestReview`. The system shows it at most **3 times per 365 days** per user and may not show it at all; never call it from a button ("Rate us" buttons must deep-link to the App Store write-review page instead: `https://apps.apple.com/app/id<ID>?action=write-review`).
- Android: Play **In-App Review API**. Quota-limited by Google, may not show; don't call it from a button or ask a question first that decides whether to show it.
- Ask after a success moment (task completed, streak, saved money), never on first launch, during onboarding, after an error or crash, or mid-task.

### Prohibited (both stores + consumer law, see `policy-legal.md`)
- **Incentives** of any kind for ratings or reviews (coins, unlocks, discounts, contest entries). Older articles that recommend incentives are wrong today.
- **Review gating**: asking "Do you like the app?" and sending only happy users to the store. Prohibited on Play (and by Apple's ban on custom review prompts), and treated as review suppression by the FTC.
- Custom review pop-ups that imitate or replace the system prompt (Apple 5.6.1).
- Fake, bought or employee reviews, review swaps, review farms; reviewing competitors.
- "Rate us 5 stars" wording, or pre-selecting stars.

### Replies
- Reply on both stores (App Store Connect, Play Console or API). Prioritise recent 1–2 star reviews that report bugs or confusion; say what was fixed and in which version. Users often update their rating.
- Short, human, specific; no copy-paste wall; never argue, never ask for personal data in public, don't offer compensation in exchange for changing a review.
- Feed monthly review themes to product: the cheapest roadmap research there is.

### iOS rating reset
- When releasing a new version you can reset the summary rating per territory. Irreversible. Use only after a version that fixes the cause of a poor rating, together with a review-prompt plan from day one.
