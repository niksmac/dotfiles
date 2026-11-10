# Sources, confidence and myths

Research done 2026-11-10. When a source here and an official page disagree, the official page wins. Re-verify volatile items (limits, AI features, ad slots, policy dates) if this file is more than ~6 months old.

## Official (highest confidence)

- Apple App Review Guidelines: https://developer.apple.com/app-store/review/guidelines/ (2.3.x metadata, 5.6.1 reviews, 5.6.3 discovery fraud, 1.3 kids)
- Apple App Store search: https://developer.apple.com/app-store/search/ (indexed: title, subtitle, keywords, primary category; promo text not indexed; tags)
- Apple product page: https://developer.apple.com/app-store/product-page/
- App Store Connect platform version info (field limits): https://developer.apple.com/help/app-store-connect/reference/app-information/platform-version-information
- Screenshot and app-preview specifications: https://developer.apple.com/help/app-store-connect/reference/app-information/screenshot-specifications
- Custom product pages: https://developer.apple.com/app-store/custom-product-pages/ · PPO: https://developer.apple.com/app-store/product-page-optimization/
- In-app events: https://developer.apple.com/app-store/in-app-events/
- App tags: https://developer.apple.com/help/app-store-connect/manage-app-information/manage-app-tags/
- Ratings and reviews: https://developer.apple.com/app-store/ratings-and-reviews/ · StoreKit `RequestReviewAction`
- App privacy details: https://developer.apple.com/app-store/app-privacy-details/ · Age ratings news: https://developer.apple.com/news/?id=ks775ehf · Upcoming requirements: https://developer.apple.com/news/upcoming-requirements/
- Apple marketing and trademark guidelines: https://developer.apple.com/app-store/marketing/guidelines/
- App Store Connect release notes: https://developer.apple.com/help/app-store-connect/release-notes/
- Google Play Metadata policy: https://support.google.com/googleplay/android-developer/answer/9898842
- Play store listing: https://support.google.com/googleplay/android-developer/answer/9859152 · Preview assets: answer/9866151 · Best practices: answer/13393723
- Play ratings, reviews and installs policy: https://support.google.com/googleplay/android-developer/answer/9898684
- Play In-App Review API: https://developer.android.com/guide/playcore/in-app-review
- Play custom store listings: answer/9867158 · Store listing experiments: answer/12053285 · Promotional content: answer/12932541
- Data safety: answer/10787469 · Families: answer/9893335 · DSA trader status: answer/17594752
- Android vitals: https://developer.android.com/topic/performance/vitals
- FTC Consumer Reviews and Testimonials Rule: https://www.ftc.gov/business-guidance/resources/consumer-reviews-testimonials-rule-questions-answers
- EU Omnibus Directive 2019/2161: https://eur-lex.europa.eu/legal-content/en/ALL/?uri=CELEX%3A32019L2161
- UK DMCC Act unfair practices guidance: https://www.gov.uk/government/publications/what-businesses-need-to-know-about-unfair-commercial-practices

## Practitioner guides (the brief's sources)

| Source | Date | Read | Notes |
|---|---|---|---|
| AppRadar, "What is ASO" https://appradar.com/academy/what-is-app-store-optimization-aso | updated 2026-04-29 | full | Broadest guide; SplitMetrics vendor numbers (4.0-star drop, 400–500 conversions per variant, cadence, localization tiers, ROI model). |
| Semrush, "App Store Optimization" https://www.semrush.com/blog/app-store-optimization/ | 2025-03-21 | full | Solid basics; CPP limit (35) outdated; lists visuals as Play ranking factors (unproven). |
| AppsFlyer, "How to ASO like a pro" https://www.appsflyer.com/blog/measurement-analytics/aso/ | older | search summary only (fetch blocked) | Long-tail data from Google; backlinks for Play; **recommends rating incentives: now prohibited**. |
| Adjust, "ASO 101" https://www.adjust.com/resources/guides/app-store-optimization/ | older | search summary only (fetch blocked) | Region-specific keyword research, one variable per test, MMP for measurement; 23% icon uplift is vendor data. |
| Asodesk, "14 ASO tips" https://asodesk.com/blog/15-app-store-optimization-tips/ | 2021, updated 2023 | full | Phrase combinations, stop words, diacritics, locale plurals, Google Ads copy tests, brand-on-icon. App-size thresholds and "72-hour update boost" are dated/unsourced. Asodesk sells "incentivized installs": don't use them (Apple 5.6.3, Play installs policy). |
| Appfigures, "ASO: The Complete Guide for 2026" https://appfigures.com/resources/guides/app-store-optimization | 2026-11-04 | full (hub page) | Discovery vs conversion framing, per-store-and-country research, daily rank tracking. |
| MobiLoud, "ASO: 2026 Guide & Checklist" https://www.mobiloud.com/blog/app-store-optimization/ | 2026 | search summary only (403) | Store data over tool estimates; no target keyword density; full-funnel measurement; CPPs only for real intent differences. |

## Latest research (2025–26)

- Phiture, ASO trends 2026: https://phiture.com/blog/aso-trends-in-2026/ · iOS 26 updates: https://phiture.com/blog/app-store-ios-26-updates-aso/ · keyword CPPs: https://phiture.com/blog/keyword-based-custom-product-pages-cpps-arrive-in-app-store-connect/
- AppTweak: cross-localization (updated 2025-11) https://www.apptweak.com/en/aso-blog/how-to-benefit-from-cross-localization-on-the-app-store · keyword field https://www.apptweak.com/en/aso-blog/how-to-optimize-your-ios-keyword-field · AI and relevance (2026-02) https://www.apptweak.com/en/aso-blog/ai-reshaping-app-store-relevance · Play ranking factors (2025-06) https://www.apptweak.com/en/aso-blog/google-play-ranking-factors · CVR benchmarks (2026-05) https://www.apptweak.com/en/aso-blog/average-app-conversion-rate-per-category · Apple Ads slots https://www.apptweak.com/en/aso-blog/apple-ads-search-results-are-expanding · Google I/O 2026 https://www.apptweak.com/en/aso-blog/google-i-o-2026-aso-updates · Ask Play (2026-10) https://www.apptweak.com/en/aso-blog/how-to-get-recommended-by-ask-play-google-play · LLM discovery (2026-08) https://www.apptweak.com/en/aso-blog/ai-app-discovery-llm-search
- TechCrunch on App Store tags (2025-06): https://techcrunch.com/2025/06/14/the-app-stores-new-ai-generated-tags-are-live-in-the-beta
- Heise on extra Apple Ads slots (2026): https://heise.de/-11119517

## Myths and outdated advice (don't repeat them)

| Claim | Status |
|---|---|
| Apple indexes the description | False. Apple lists title, subtitle, keywords, category. |
| Promotional text helps iOS ranking | False (Apple says so). |
| Apple indexes screenshot captions (OCR) since June 2025 | Contested: vendor claims, a 64-phrase test found no strong evidence, Apple silent. Write good captions anyway. |
| Offer rewards for ratings | Prohibited by both stores; FTC/EU/UK law on top. |
| "Enjoying the app?" pre-prompt, then store | Review gating: banned by Play API rules, Apple 5.6.1, risky under FTC/CMA. |
| Repeat keywords in the iOS keyword field / title for weight | No benefit; wastes bytes. |
| Mention the keyword N times in the Play description | No target density; write naturally. Stuffing violates the Metadata policy. |
| Use competitor names in the keyword field: it's hidden | Violates 2.3.7; trademark complaints; removal. |
| CPP limit 35 / Play experiments 3 variants | Outdated: CPPs 70 (Oct 2025); Play experiments 2 variants. |
| Updating gives a guaranteed 72-hour search boost | Unsourced. |
| Star rating alone is a ranking factor | Unproven; volume, recency and conversion effects are better supported. |
| Incentivized-install services boost ranking safely | Discovery fraud (Apple 5.6.3), Play installs policy: removal risk. |
