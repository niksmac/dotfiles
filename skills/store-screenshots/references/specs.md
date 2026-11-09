# Store specs and policy (verified 2026-11-08)

Sources: Apple screenshot and app-preview specifications, product page, custom product pages and product page optimization help pages; Play Console help 9866151 (preview assets), 9898842 (metadata policy), 9867158 (custom store listings), 6227309 (listing experiments). Neither store dates its pages: re-check sizes in the upload UI on upload day, and re-verify this file if it is more than about 6 months old.

## Apple App Store

| Item | Requirement |
|---|---|
| iPhone set | One large set: **1320 x 2868** portrait (6.9"; 1290 x 2796 and 1260 x 2736 also accepted). Smaller iPhones scale down from it. |
| iPad set | **Required when the app runs on iPad** (`TARGETED_DEVICE_FAMILY` includes 2). **2064 x 2752** (13") or 2048 x 2732. Never an iPhone frame in an iPad slot. |
| Count / format | 1 to 10 per device size and locale. PNG or JPEG, **no alpha**. |
| Search result | First 1 to 3 screenshots show in search when there is no app preview. Portrait shows three side by side. |
| App preview | Up to 3, 15 to 30 s, iPhone 886 x 1920, iPad 1200 x 1600. Autoplays muted and takes the first search slot. |
| Review 2.3.3 | More than half the screenshots must show the app in use. Login and splash screens don't count. |
| Review 2.3.10 | No other platforms' names or imagery: no Android status bars or camera holes, no Windows or Linux. |
| Caption OCR | ASO vendors report Apple reads caption text as a weak ranking signal since mid-2025 (unconfirmed by Apple). A bonus, never a reason for worse copy. |
| Custom product pages | Up to 70, each with keywords, its own URL, optional deep link (iOS 18+). |
| PPO (A/B) | Up to 3 treatments vs original, up to 90 days, live apps only. |
| Upcoming | iPhone Duo screenshots (1398 x 2034 outer, 2007 x 2853 inner) required from April 2027 for apps built with the iOS 27.1 SDK. |

## Google Play

| Item | Requirement |
|---|---|
| Phone screenshots | 2 to 8. JPEG or 24-bit PNG, no alpha. Sides 320 to 3840 px, **long side at most 2x the short side**, so the iPhone 1320 x 2868 render (2.17:1) is rejected. Use **1080 x 1920**. |
| Featuring | At least 4 screenshots at min 1080 px. |
| Tablets | Optional; if used, at least 4, 9:16 or 16:9, 1080 to 7680 px. |
| Feature graphic | **Required**, **1024 x 500**, no alpha. Keep logo, name and tagline away from the edges (cropped on some surfaces). No pure white, black or dark-gray fill, no device frames, no store badges, **no "Free"**. |
| Promo video | Optional YouTube URL, ads off; first 30 s autoplay; show the real app within 10 s. |
| Text in images | Taglines under **20% of the image**. Alt text up to 140 characters per screenshot. |
| Banned in screenshots | "Best", "#1", "Top", "New", "Discount", "Sale", "Million downloads", rankings, awards, testimonials, prices, promos; CTAs "Download now", "Install now", "Try now". |
| Custom store listings | Up to 50: country, search keywords, ads traffic, pre-registration, lapsed users. |
| Listing experiments | Up to 2 variants vs current; published apps only; stops after 6 months. |

## Design consequences

- Render three sizes: iPhone 1320 x 2868, Play 1080 x 1920, iPad 2064 x 2752, plus the 1024 x 500 feature graphic. Export at 1x, JPEG.
- Apple set: no Android imagery (the Play frames' camera hole is Play-only).
- Strictest store wins for copy: no best / #1 / top / new / sale / prices anywhere; "free" never on the feature graphic.
- Growth levers after launch, in order: localized captions (rewrite per market, not word for word), intent-matched custom pages (lead frame per search intent), one A/B test at a time (frame 1 angle first).
