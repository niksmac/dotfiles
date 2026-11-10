# Store specs and policy (verified 2026-11-10)

Sources: Apple screenshot specifications (https://developer.apple.com/help/app-store-connect/reference/app-information/screenshot-specifications/) and app-preview specifications, product page, custom product pages and product page optimization help pages; Play Console help 9866151 (preview assets), 9898842 (metadata policy), 9867158 (custom store listings), 6227309 (listing experiments). Neither store dates its pages: re-check sizes in the upload UI on upload day, and re-verify this file if it is more than about 6 months old.

## Apple App Store

| Item | Requirement |
|---|---|
| iPhone sets | **Required: 6.3" Dynamic Island (medium), 1206 x 2622** (or 1179 x 2556): "At least one screenshot for iPhone with Dynamic Island (medium display)." App Store Connect rejects a 1320 x 2868 file in that slot. Optional: 6.9" Dynamic Island (large) 1320 x 2868 (1290 x 2796, 1260 x 2736 also accepted). Make both: the 6.3" frames import the 6.9" frames scaled 0.914226 (2622 / 2868). |
| iPad set | **Required when the app runs on iPad** (`TARGETED_DEVICE_FAMILY` includes 2). **2064 x 2752** (13") or 2048 x 2732. Never an iPhone frame in an iPad slot. |
| Mac set | Required for Mac apps (separate listing). **16:10**: 1280 x 800, 1440 x 900, 2560 x 1600 or **2880 x 1800** (verified 2026-11-09). 1 to 10, no alpha. Mac app preview: 1920 x 1080 landscape, 15 to 30 s, shown before screenshots. |
| Count / format | 1 to 10 per device size and locale. PNG or JPEG, **no alpha** ("Images can't include alpha channels or transparencies"). Exact pixel sizes only: a 2x export (2640 x 5736) is rejected. |
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

- Render four sizes: iPhone 1206 x 2622 (required) and 1320 x 2868, Play 1080 x 1920, iPad 2064 x 2752, plus the 1024 x 500 feature graphic. Export at 1x, then flatten alpha and check exact pixel sizes before upload (a 2x export or a PNG with an alpha channel is rejected by both stores).
- Run every export through `scripts/normalize-exports.sh` before upload (canvas-recipes.md, Exporting for upload): the canvas exporter defaults to 2x and keeps PNG alpha.
- Apple set: no Android imagery (the Play frames' camera hole is Play-only).
- Strictest store wins for copy: no best / #1 / top / new / sale / prices anywhere; "free" never on the feature graphic.
- Growth levers after launch, in order: localized captions (rewrite per market, not word for word), intent-matched custom pages (lead frame per search intent), one A/B test at a time (frame 1 angle first).
