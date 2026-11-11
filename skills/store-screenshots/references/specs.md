# Store specs and policy (verified 2026-11-11)

Sources: Apple screenshot specifications (https://developer.apple.com/help/app-store-connect/reference/app-information/screenshot-specifications/), app preview specifications (…/app-preview-specifications), creative assets specifications (…/creative-assets-specifications), Manage your App Store assets (…/manage-app-information/manage-your-app-store-assets), asset best practices (https://developer.apple.com/app-store/asset-best-practices/) and the news post "Showcase your apps with new assets on the App Store" (https://developer.apple.com/news/?id=ljpl7kyn, 2026-10-05); product page, custom product pages and product page optimization help pages; Play Console help 9866151 (preview assets), 9898842 (metadata policy), 9867158 (custom store listings), 6227309 (listing experiments). Neither store dates its pages: re-check sizes in the upload UI on upload day, and re-verify this file if it is more than about 6 months old.

## Apple App Store

| Item | Requirement |
|---|---|
| iPhone sets | **Required: 6.3" Dynamic Island (medium), 1206 x 2622** (or 1179 x 2556): "At least one screenshot for iPhone with Dynamic Island (medium display)." App Store Connect rejects a 1320 x 2868 file in that slot. Optional: 6.9" Dynamic Island (large) 1320 x 2868 (1290 x 2796, 1260 x 2736 also accepted). Make both: the 6.3" frames import the 6.9" frames scaled 0.914226 (2622 / 2868). |
| iPad set | **Required when the app runs on iPad** (`TARGETED_DEVICE_FAMILY` includes 2). **2064 x 2752** (13") or 2048 x 2732. Never an iPhone frame in an iPad slot. |
| Mac set | Required for Mac apps (separate listing). **16:10**: 1280 x 800, 1440 x 900, 2560 x 1600 or **2880 x 1800** (verified 2026-11-09). 1 to 10, no alpha. Mac app preview: 1920 x 1080 landscape, 15 to 30 s, shown before screenshots. |
| Count / format | 1 to 10 per device size and locale. PNG or JPEG, **no alpha** ("Images can't include alpha channels or transparencies"). Exact pixel sizes only: a 2x export (2640 x 5736) is rejected. |
| Search result | iOS/iPadOS 27+: a **search results creative asset** (below) shows when set; "If you choose to not use a search result creative asset, your In-App Events, app previews, and screenshots will appear." Up to 3 app previews may appear, else up to 3 screenshots ("depending on orientation"; portrait shows three side by side). Older iOS: previews, then screenshots 1 to 3. |
| App preview | Optional, up to 3 per device size and language; full spec in **App previews** below. Always shown before screenshots, even if reordered; a preview whose aspect ratio differs from the screenshots moves to "A Closer Look". |
| Review 2.3.3 | More than half the screenshots **for each device type** (and each localization) must show the app in use; see the checklist below. |
| Review 2.3.10 | No other platforms' names or imagery: no Android status bars or camera holes, no Windows or Linux. |
| Caption OCR | ASO vendors report Apple reads caption text as a weak ranking signal since mid-2025 (unconfirmed by Apple). A bonus, never a reason for worse copy. |
| Custom product pages | Up to 70, each with keywords, its own URL, optional deep link (iOS 18+). |
| PPO (A/B) | Up to 3 treatments vs original, up to 90 days, live apps only. |
| Upcoming | iPhone Duo screenshots (1398 x 2034 outer, 2007 x 2853 inner) required from April 2027 for apps built with the iOS 27.1 SDK; submitting them adds a "made for iPhone Duo" badge. |

## Apple 2.3.3 checklist (https://developer.apple.com/help/app-review/guideline-reference/2-3-3-screenshots, read 2026-11-11)

Guideline: "Screenshots should show the app in use, and not merely the title art, login page, or splash screen. They may also include text and image overlays (for example, to demonstrate input mechanisms, such as an animated touch point or Apple Pencil) and show extended functionality on device, such as Touch Bar."

- **Majority rule:** "App Review takes the set of screenshots submitted for each supported device into account, and will approve only those submissions where more than half of screenshots show the app in use." 3 per device needs 2 in use, 4 needs 3, 7 needs 4. The rest "can exhibit the app's main benefits and features using marketing materials". Each localization's set is assessed the same way. One screenshot per device is enough if it shows the app in use.
- **Do:** show main features and functionality in the majority for each device type; update screenshots with each new version to match the current UI; show different configurations such as Dark Mode; splash screens or marketing text are fine while the majority still shows the app in use; use overlays to demonstrate input mechanisms; show extended functionality on device; show the app on another Apple platform when that is part of the experience (Merrin's iPhone + Mac sync frame).
- **Don't:** only generic login pages or splash screens; screenshots that misrepresent the app's actual interface or include misleading marketing; overlays or marketing visuals that crowd out the app or obscure the primary functionality; only the hardware, or an overlay with no app interface behind it.
- **Apple's examples:** approved set = the app's dashboard, an hourly forecast with one small promotional badge over a corner, and one feature-summary frame. Rejected set = the app only as a small mockup behind large promotional text, a sign-in screen, a splash screen.
- An image of the app may span several screenshots (panoramas are allowed). Third-party platform references (status bars) fall under 2.3.10.
- **How this skill counts "in use":** a real, current app screen is the dominant element of the frame (device or full-bleed), headline above it, overlays beside it. Lifted cards alone are counted as marketing: Apple doesn't say they count, and the review is per frame and per device.

## Apple creative assets (iOS and iPadOS 27 and later; optional)

New placements on top of previews and screenshots: the **product page header** and the **search results** asset (also In-App Event cards). "Creative assets are optional"; they are submitted with a version or from Asset Library (reviewed against the latest version) and, once a version is live, can be swapped without a new version. Roles: Account Holder, Admin, App Manager or Marketing. Not shown on iOS 26 and earlier, Mac, TV or Vision Pro.

| Placement | Image | Video |
|---|---|---|
| Product page header | **21:9, 3840 x 1646**, .jpeg/.jpg/.png; or **16:9, 5244 x 2950, .png only** | 21:9, 3840 x 1646, 30 or 60 fps, 5 to 30 s, .mov/.m4v/.mp4 |
| Search results | **3:2, min 1920 x 1280, max 3840 x 2560**, .jpeg/.jpg/.png; or **16:9, 5244 x 2950, .png only** | 3:2, min 1920 x 1280, max 3840 x 2560, 30 or 60 fps, 5 to 30 s, .mov/.m4v/.mp4 |
| In-App Event card / details | 16:9 1920 x 1080 to 3840 x 2160 / 9:16 1080 x 1920 to 2160 x 3840, max 500 MB | same sizes, 30 or 60 fps, 15 to 30 s |

- No alpha ("Images can't include alpha channels or transparencies"). Codec, colour space and video file size are not stated: use H.264 or HEVC, sRGB / Rec. 709.
- **Universal asset:** the 16:9 5244 x 2950 PNG listed under both placements; "If you upload a universal creative asset, you can use it for both your product page header and search results placement" ("Use header asset in search results", universal assets only). Video has no universal size.
- Playback: "Videos are muted by default in search results and can't currently be unmuted. On your product page, videos are also muted by default, but people can unmute them. Videos loop continuously in both placements." Design silent-first and loop-clean. A poster frame is set per video and applies everywhere it is used.
- Safe area: Apple's templates (Figma, Photoshop, Pixelmator, Sketch on the best-practices page) define it; the pages only say to keep the focal point and text in the centre "to prevent any unwanted clipping". For the universal asset, the part both crops keep is the centre **4425 x 2247** (inferred: 21:9 keeps full width, 3:2 keeps full height). The App Store Connect Preview tool shows iPhone and iPad, orientations, languages and Dark Mode: check there before submitting.
- Content rules (best practices): must relate to the app's functionality; short phrase that enhances the visual, localized for every app language; **no pricing, discounts, website URLs or copyright symbols; no logos or references to other platforms or marketplaces; no Apple-designated recognitions (Editors' Choice, App of the Day, Apple Design Award); no unverifiable claims**; 4+ age rating content. Device frames and people: no rule stated.
- PPO can test alternative header visuals.

## Apple app previews (verified 2026-11-11)

| Item | Requirement |
|---|---|
| Count | Optional; up to 3 per device size and language (iOS, macOS, tvOS, visionOS). Not for iMessage apps. |
| Length / size | 15 to 30 s; max 500 MB. Poster frame chosen in App Store Connect (default at 5 s). Processing up to 24 h. |
| iPhone | **886 x 1920** portrait or 1920 x 886 landscape for every Dynamic Island, Face ID and iPhone Duo class; 1080 x 1920 for Home-button large and 4"; 750 x 1334 for Home-button medium. Larger classes fall back to scaled Face ID (large) previews and back. |
| iPad | **1200 x 1600** portrait or 1600 x 1200 (13", 11", and 12.9" which also takes 900 x 1200). |
| Mac / Apple TV / Vision Pro | 1920 x 1080 landscape only / landscape only / 3840 x 2160. |
| Video (H.264) | .mov/.m4v/.mp4, progressive, up to High Profile Level 4.0, **max 30 fps**, target 10 to 12 Mbps. ProRes 422 HQ .mov also accepted (~220 Mbps VBR). |
| Audio | Stereo, AAC 256 kbps (PCM allowed with ProRes), 44.1 or 48 kHz; all tracks enabled; 1 track 2-channel or 2 tracks 1-channel. |
| Orientation | iOS portrait or landscape (rotates on play); Mac, TV, Vision Pro landscape only. Match the screenshots' orientation or the preview goes to "A Closer Look". |
| Localization | A missing localized preview falls back to the next best available language. |

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

- Search on iOS 27+: decide per listing whether a search creative asset (3:2, or the universal 16:9) or the preview and screenshots carry the first impression. Without one, screenshots 1 to 3 (or previews) are still the search billboard, and they always are on older iOS.
- Render four sizes: iPhone 1206 x 2622 (required) and 1320 x 2868, Play 1080 x 1920, iPad 2064 x 2752, plus the 1024 x 500 feature graphic. Export at 1x, then flatten alpha and check exact pixel sizes before upload (a 2x export or a PNG with an alpha channel is rejected by both stores).
- Run every export through `scripts/normalize-exports.sh` before upload (canvas-recipes.md, Exporting for upload): the canvas exporter defaults to 2x and keeps PNG alpha.
- Apple set: no Android imagery (the Play frames' camera hole is Play-only).
- Strictest store wins for copy: no best / #1 / top / new / sale / prices anywhere; "free" never on the feature graphic.
- Growth levers after launch, in order: localized captions (rewrite per market, not word for word), intent-matched custom pages (lead frame per search intent), one A/B test at a time (frame 1 angle first).
