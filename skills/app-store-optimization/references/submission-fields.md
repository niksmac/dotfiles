# Submission fields: everything App Store Connect and Play Console ask for (verified 2026-11-11)

Use this for a first submission, or when a review blocks on a declaration. Copy for the listing itself (name, subtitle, keywords, descriptions) is in `metadata-specs.md` and `keywords.md`; this file covers everything else.

Tags: **[C]** confirmed on the official page linked; **[U]** not confirmed, check in the live console. Base URLs: A = `https://developer.apple.com/help/app-store-connect/`, G = `https://support.google.com/googleplay/android-developer/answer/`.

The last column says how to get the answer from the code. Put the answers in the `submission` block of the metadata JSON (`aso-lint.py --template`), and the long answers (questionnaires, privacy tables) in `aso/submission.md` with evidence.

## Apple App Store Connect

### App Information (app level, App > General > App Information) [C: A reference/app-information/app-information]

| Field | Rule | Required | From the code |
|---|---|---|---|
| Name | 2–30 chars, localized, unique on the store | Yes | Listing copy |
| Subtitle | 30 chars, localized | No | Listing copy |
| Bundle ID | Must match Xcode; fixed after first build upload | Yes | `PRODUCT_BUNDLE_IDENTIFIER` |
| SKU | Letters, digits, `-` `.` `_`; can't start with `-` `.` `_`; fixed | Yes | Team choice, e.g. `<app>-ios` |
| Primary language | Default metadata locale | Yes | |
| Primary / secondary category | One each; subcategories only for Games and Stickers | Primary yes | Intent and competition (`keywords.md`) |
| Content rights | Does the app contain, show or access third-party content, and do you have the rights? | Yes | UGC, licensed media, AI output from third-party models |
| Age rating | Questionnaire, below | Yes | |
| Made for Kids | Only if the computed rating is 4+ or 9+; locks the age band after approval; Kids Category rules (1.3) apply | Optional | Any third-party analytics, ads or external links rule it out |
| License agreement | Standard Apple EULA or custom text | Optional | |
| Privacy Policy URL | Public URL | Yes (iOS, macOS) | Also linked inside the app (5.1.1(i)) |
| Privacy Choices URL | Public URL where users manage privacy choices | Optional | |
| EU DSA trader status | Trader or non-trader; traders' address, phone and email show on EU pages | Required for EU distribution | Company details |
| Korea GRAC, China ICP / permits, Vietnam game licence | Only when they apply | Conditional | Mainland China also requires a generative-AI licence for AI apps [U]: usually exclude China unless you hold one |
| Regulated medical device | Health / Medical apps in EU/EEA, UK, US | Conditional | |
| App Store Server Notifications URL | Shown when the app has IAP | Optional | Backend endpoint |

### Age rating questionnaire [C: A reference/app-information/age-ratings-values-and-definitions]

Answer None / Infrequent / Frequent (yes/no for gambling and loot boxes). Tiers: 4+, 9+, 13+, 16+, 18+ (Unrated can't be published).

- **In-app controls:** Parental Controls; Age Assurance.
- **Capabilities:** Unrestricted Web Access; User-Generated Content; Social Media; Social Media Disabled for Users Under 13; Messaging and Chat; Advertising.
- **Mature themes:** Profanity or Crude Humor; Horror/Fear; Alcohol, Tobacco or Drugs.
- **Medical or wellness:** Medical or Treatment Information; Health or Wellness Topics.
- **Sexuality or nudity:** Mature/Suggestive; Sexual Content or Nudity; Graphic Sexual Content.
- **Violence:** Cartoon/Fantasy; Realistic; Prolonged Graphic or Sadistic; Guns/Weapons.
- **Chance-based:** Gambling; Simulated Gambling; Contests; Loot Boxes.

Tier hints from the page:
- UGC, chat and ads alone keep 4+.
- Social Media sets 13+.
- Unrestricted web access sets 16+.
- Gambling or frequent sexual or realistic violent content sets 18+.

Dates:
- **2026-11-16:** new declarations **Shared Location** and **Dating and Relationships**. Every app must answer them by **2027-01-12**; Dating forces 18+.
- **September 2026:** the Social Media question became required for new submissions.

Whether there's an AI-capability question: [U].

Age assurance laws (Texas SB 2420 since 2026-06-04; Utah, Louisiana, Brazil, Australia, Singapore coming) are app implementation work (Declared Age Range API, PermissionKit), not an App Store Connect field [C: developer.apple.com/support/age-assurance/].

### Version page (App > iOS App > version) [C: A reference/app-information/platform-version-information]

| Field | Rule | Required | From the code |
|---|---|---|---|
| Promotional text | 170 chars, localized, not indexed | Optional | |
| Description | 4,000 chars, plain text, localized | Yes | |
| Keywords | 100 bytes, each >2 chars, no app/company names | Yes | |
| Support URL | With protocol; must lead to real contact info | Yes | Check the page has an email or form |
| Marketing URL | With protocol | Optional | |
| Version | | Yes | `CFBundleShortVersionString` / pubspec `version` |
| Copyright | "YYYY Owner"; © is added automatically | Yes | Legal entity |
| What's New | 4,000 chars; **not on the first version** | Updates | Real changes (2.3.12) |
| Screenshots | 1–10 per size; iPhone 6.3" (1206×2622 or 1179×2556) required; iPad 13" if the app runs on iPad | Yes | `TARGETED_DEVICE_FAMILY` contains `2` → iPad needed |
| App previews | 0–3 per size and locale, 15–30 s, ≤500 MB | Optional | |
| Build | Select an uploaded build | Yes | |
| Release | Manual, automatic, or automatic not before a date; phased release (7 days) for updates | | |
| Routing app coverage | .geojson | Routing apps only | |

### App Review Information (same page; private to Apple)

- **Contact:** name, email, phone. The phone must be in international format with a leading `+`.
- **Sign-in required:** username and password for a demo account that doesn't expire. Give it the paid tier and sample content, so the reviewer can test without waiting or paying. **The password goes in the console only, never in the repo.**
- **Notes:** up to 4,000 bytes. Cover:
  - where each main feature lives;
  - anything slow (server generation) and what to expect;
  - how purchases, reporting, blocking and account deletion work;
  - why any sensitive permission is needed;
  - how this app differs from any similar app by the same developer (4.3).
- **Attachment:** optional [U].

### App Privacy [C: developer.apple.com/app-store/app-privacy-details/]

For each data type collected (sent off the device and kept longer than needed to serve the request), answer:
- purposes: Third-Party Advertising, Developer's Advertising or Marketing, Analytics, Product Personalization, App Functionality, Other;
- whether it's linked to the user;
- whether it's used for tracking.

Data types:
- **Contact Info:** Name, Email, Phone, Address, Other.
- **Health & Fitness.**
- **Financial Info:** Payment, Credit, Other.
- **Location:** Precise, Coarse.
- **Sensitive Info.**
- **Contacts.**
- **User Content:** Emails/Texts, Photos or Videos, Audio Data, Gameplay Content, Customer Support, Other User Content.
- **Browsing History.**
- **Search History.**
- **Identifiers:** User ID, Device ID.
- **Purchases:** Purchase History.
- **Usage Data:** Product Interaction, Advertising Data, Other.
- **Diagnostics:** Crash, Performance, Other.
- **Surroundings:** Environment Scanning.
- **Body:** Hands, Head.
- **Other Data.**

How to derive it from the code:
- sign-up and profile fields;
- uploads (photos, audio);
- user-written content sent to the API;
- account IDs;
- purchase verification calls;
- every SDK in the dependency manifest (analytics, crash, ads, auth), using its own privacy documentation.
- Processors (cloud, TTS or voice vendors, model APIs) still count as collection.
- Tracking means linking with third-party data for ads or sharing with data brokers; it requires App Tracking Transparency.

Also ship `PrivacyInfo.xcprivacy` for the app target when it calls required-reason APIs (UserDefaults, file timestamps, disk space, boot time). Most plugins ship their own manifest, but the app's own use needs one.

### Pricing, accessibility, export compliance

- **Pricing and availability** [C: A reference/app-information/required-localizable-and-editable-properties]:
  - price;
  - countries;
  - pre-order (up to 180 days);
  - Business/Education distribution;
  - tax category.
- **Accessibility Nutrition Labels** [C: A manage-app-accessibility/overview-of-accessibility-nutrition-labels]:
  - Features: VoiceOver, Voice Control, Larger Text, Dark Interface, Differentiate Without Color Alone, Sufficient Contrast, Reduced Motion, Captions, Audio Descriptions.
  - Answered per device. Voluntary for now; Apple will make them required with notice.
  - Declare only what works across the common tasks.
- **Export compliance** [C: A manage-app-information/overview-of-export-compliance]: asked for each version unless `Info.plist` has `ITSAppUsesNonExemptEncryption` [U on that page; standard Xcode key].
  - Apps that use only HTTPS and OS crypto are exempt: set the key to `NO`.
  - Custom or non-standard crypto needs documentation. France has its own ANSSI rules.

### In-app purchases and auto-renewable subscriptions [C: A reference/in-app-purchases-and-subscriptions/…]

| Field | Rule |
|---|---|
| Reference name | 64 chars, internal |
| Product ID | ≤100 chars; letters, digits, `-` `.` `_`; permanent, never reusable |
| Display name (localized) | **2–30 chars** (IAP page; subscription page states none, so keep to 30) |
| Description (localized) | **45 chars** (IAP page; keep subscriptions to 45) |
| Review screenshot | One per product, at an app screenshot size; shows the purchase screen |
| Review notes | 4,000 chars |
| Promotional image | 1024×1024, only for promoted IAPs and win-back offers |
| Subscription group | Reference name (internal) + localized display name: no markup, emoji, diacritics or special characters |
| Duration | 1 week, 1, 2, 3, 6 months, 1 year; locked after submission |
| Level | Order within the group (1 = highest); sets upgrade/downgrade behaviour |
| Price | Base storefront, auto-equalized |
| Family Sharing, tax category | Optional |

- The first subscription and its group must be **submitted together with an app version**.
- **3.1.2 / Subscriptions page** [C: developer.apple.com/app-store/subscriptions/]:
  - The purchase screen shows the plan name, duration, what's included, and the full renewal price (clear and localized), plus restore.
  - **The app and the App Store metadata must link to the Terms of Use (EULA) and the Privacy Policy.** Put both links in the description, or use the EULA field plus the privacy URL.

## Google Play Console

### Store listing and store settings [C: G 9859152, G 9866151, G 9859673]

| Field | Rule | Required |
|---|---|---|
| App name | 30 chars, localized | Yes |
| Short description | 80 chars, localized | Yes [U] |
| Full description | 4,000 chars, localized | Yes [U] |
| App icon | 512×512, 32-bit PNG with alpha, ≤1 MB | Yes |
| Feature graphic | 1024×500, JPEG or 24-bit PNG, no alpha | Yes |
| Phone screenshots | 2–8; JPEG or 24-bit PNG, no alpha; 320–3840 px, long side ≤2× short | Yes |
| Tablet / Chromebook screenshots | 1080–7680 px, 16:9 or 9:16; 4+ for large-screen recommendations | Optional |
| Promo video | YouTube, public or unlisted, no ads, not age-restricted, embeddable | Optional |
| AI-generated assets | Per-asset self-declaration checkbox for AI-made listing assets (G 17262077) | When it applies |
| App or game, category | Store settings | Yes |
| Tags | Up to 5, from Google's list | Optional |
| Contact email | Public | Yes |
| Contact phone, website | Public | Optional |

### App content (Policy and programs > App content) [C: G 9859455 unless noted]

| Declaration | What to answer | From the code |
|---|---|---|
| Privacy policy | Public URL (not a PDF, no login); also in the app | Legal links config |
| App access | Restricted? Up to 5 sets of credentials and steps | Login screen → yes; same demo account as Apple |
| Ads | Any ads, including from SDKs | Ad SDKs in dependencies |
| Content rating | IARC questionnaire (category, then violence, sexuality, language, controlled substances, user interaction, sharing location, digital purchases …) → ESRB, PEGI, USK, ClassInd, GRAC, ACB, Google Play ratings [G 9859655; question names U] | UGC, purchases, chat, location |
| Target audience | Age bands 5 and under, 6–8, 9–12, 13–15, 16–17, 18+. Any band under 13 brings the **Families policy** (self-certified ad SDKs, neutral age screen, Teacher Approved option) [G 9867159] | Who operates the app; child-appealing art and copy count toward "appeals to children" |
| Data safety | Data collected and shared, purposes, required vs optional, encrypted in transit, deletion method. Categories: Location, Personal info, Financial info, Health and fitness, Messages, Photos and videos, Audio, Files and docs, Calendar, Contacts, App activity, Web browsing, App info and performance, Device or other IDs [G 10787469] | Same derivation as App Privacy; processors are not "sharing" |
| Account deletion | In-app path **and** a web URL where users can request deletion, entered in the Data safety form [G 13327111] | Delete-account flow; the web page must exist |
| Advertising ID | Uses `com.google.android.gms.permission.AD_ID`? [G 6048248] | Check the **merged** manifest after a release build: plugins can add it |
| Financial features | Required for every app, including "none" [G 13849271] | |
| Health apps | Required for every app, including "none" [G 14738291] | |
| News, Government apps, COVID-19 | Yes/no forms [U on details] | |
| Foreground service | For each `foregroundServiceType` on Android 14+: description, impact if deferred, use case, **demo video link** (mediaPlayback: show the user starting playback) [G 13392821] | `AndroidManifest.xml` `FOREGROUND_SERVICE_*`, `<service foregroundServiceType>` |
| Photo and video permissions | `READ_MEDIA_IMAGES` / `READ_MEDIA_VIDEO` only if the system Photo Picker can't serve a core feature; otherwise remove them [G 14115180] | Manifest; `image_picker` and similar use the picker |
| Other sensitive permissions | SMS/Call Log, All files access, Exact alarms, Accessibility, Location in background, Package visibility: each has its own form | Manifest |
| AI-generated content | Generative AI apps need in-app reporting/flagging of offensive output without leaving the app [G 14094294, G 13985936]; hosted AI content falls under UGC (G 9876937) | Is there a report action on the user's **own** generated content? |
| DSA trader status | Per account and per app; existing accounts declare by **2027-02-01**; shown publicly from 2027-03-01 [G 17594752] | Company details |

### Release [C: G 9859348, G 9859654]

- Release name: internal; defaults to the version name.
- Release notes: **500 chars per language** (`<en-US>…</en-US>` tags).
- Countries and regions: selectable.
- First release: no staged rollout, and **no managed publishing** (managed publishing works only for later updates).
- **New personal developer accounts** (created after 2023-11-13) must run a closed test with ≥12 opted-in testers for 14 consecutive days before applying for production [C: G 14151465]. Organization accounts: not stated.

### Subscriptions (Monetize with Play > Products > Subscriptions) [C: G 140504]

| Field | Rule |
|---|---|
| Product ID | ≤40 chars; starts with a digit or lowercase letter; lowercase, digits, `_`, `.`; permanent |
| Name | 55 chars, localized |
| Benefits | Up to 4, each ≤40 chars; no free-trial or price mentions |
| Description | Optional; no stated limit |
| Base plan ID | Starts with a digit or lowercase letter; lowercase, digits, `-` |
| Billing period | Weekly, 4 weeks, monthly, 2/3/4/6/8 months, yearly; prepaid plans too |
| Price | Tax-exclusive, per country |
| Offers | Single payment, recurring, or free trial (3 days to 3 years); up to 20 tags |

At least one active base plan is required before the subscription can be bought.

### Developer account [C: G 13628312, G 17594752]

- Developer name.
- Organization accounts also need: D-U-N-S (free, up to 30 days to obtain), phone, website, public developer email.
- Trader status (see above).

## Blocker scan (run on the code before filling the forms)

| Check | Where | Typical fix |
|---|---|---|
| Sensitive Android permissions a declaration won't approve | `AndroidManifest.xml`, merged manifest | Remove `READ_MEDIA_*` when the photo picker is used; drop `AD_ID` if nothing uses it |
| Foreground service types | Manifest | Record the demo video |
| Missing `ITSAppUsesNonExemptEncryption` | `Info.plist` | Add `NO` for HTTPS-only apps |
| Missing app privacy manifest | `ios/Runner/PrivacyInfo.xcprivacy` | Add one if the app calls required-reason APIs |
| Usage strings for every iOS permission | `Info.plist` `NS*UsageDescription` | Specific, honest purpose text |
| Login gate | Auth screens | Demo account with paid tier and sample content |
| Account deletion | Profile/settings | In-app flow plus a web request page |
| UGC moderation | Public content features | Report, block abusive users, filter, published contact (Apple 1.2) |
| AI output reporting | Generated-content screens | Report action on the user's own generated content too |
| Duplicate / sibling app | Same developer's existing listings | Retire or differentiate; explain in the review notes (Apple 4.3, Play repetitive content) |
| Subscription terms | Paywall + metadata | Name, period, price, restore, Terms and Privacy links |
