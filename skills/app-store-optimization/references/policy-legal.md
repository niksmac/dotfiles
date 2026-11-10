# Policy and legal restrictions (verified 2026-11-10)

What gets a listing rejected, an app removed, or a company fined. Rule numbers are Apple App Review Guidelines (https://developer.apple.com/app-store/review/guidelines/) and Google Play Developer Program Policy pages. Tags: **[C]** read on the official page, **[S]** official page via a search summary, **[U]** widely reported, not confirmed on an official page. Re-verify this file if it is more than ~6 months old: both stores change rules several times a year.

Apply the **strictest store wins** rule for anything shared across stores (screenshots, copy, video).

## 1. Apple App Store

### Metadata accuracy
- **2.3 / 2.3.1** [C] Metadata (name, description, screenshots, previews, privacy info) must reflect the app's core experience and be kept current. Hidden, dormant or undocumented features, misleading marketing, false price claims, or promoting services the app doesn't offer → rejection, removal, possibly account termination.
- **2.3.3** [C] Screenshots show the app in use, not just title art, login or splash screens. Text and image overlays are allowed.
- **2.3.4** [C] App previews use only video screen captures of the app itself. Narration and overlays allowed.
- **2.3.12** [C] What's New must describe significant changes; generic text only for bug fixes, security and performance updates.

### Name, subtitle, keywords (2.3.7) [C]
- Unique name, max 30 characters.
- No trademarked terms, popular app names, pricing information or other irrelevant phrases in any metadata to game search.
- Names, subtitles, screenshots and previews must not include prices, terms or descriptions not specific to that metadata type. Subtitles must not reference other apps or make unverifiable product claims.
- Apple may change inappropriate keywords at any time.
- In practice reviewers also reject "free", "#1", "best", emoji and ALL CAPS in names/subtitles and in in-app event text (Apple's in-app event guidance says avoid "best" and "#1", no prices, no ALL CAPS) [U for names; C for events].

### Audience and platforms
- **2.3.8** [C] Metadata, icons (including IAP icons) must suit a 4+ audience even if the app is rated higher. "For Kids" / "For Children" are reserved for the Kids Category. Name and all icon variants should look consistent.
- **2.3.10** [C] No names, icons or imagery of other mobile platforms or alternative marketplaces (Android, Google Play, Android status bars) unless there's approved interactive functionality.
- **1.3 Kids Category** [C] No links out, purchases or distractions without a parental gate; no third-party analytics or ads; no personal data to third parties.

### Apple trademarks and marketing (https://developer.apple.com/app-store/marketing/guidelines/) [C]
- OK: "<App> for iPhone", "works with Apple Watch". Not OK: "iPhone <App>", Apple product names for devices you don't support, "Apple Vision Pro" in the app name (fine in the description).
- Say "App Store", never "Apple App Store", "iPhone App Store" or "iTunes App Store". Don't translate Apple trademarks.
- Official "Download on the App Store" badge artwork only, unmodified; don't imply Apple endorsement or partnership.
- Device frames: Apple-provided product images only; show real UI.

### Ratings and reviews
- **5.6.1** [C] Use the provided API (`SKStoreReviewController` / `RequestReviewAction`) to ask for reviews; custom review prompts are disallowed. Replies to reviews must address the user's comment, with no personal information, spam or marketing.
- The system shows the prompt at most 3 times per user per 365 days [U from this fetch; long-documented in StoreKit docs]. A "Write a review" link (`https://apps.apple.com/app/id<ID>?action=write-review`) is fine from a settings screen.
- **5.6.3 Discovery fraud** [C] Manipulating charts, search, reviews or referrals (incentivised installs or reviews, bot/fake downloads, review farms, paying for rankings) → removal and account termination.
- **5.6** Developer code of conduct: dishonest or fraudulent behaviour can end the developer account.

### Privacy and disclosures
- **App Privacy "nutrition labels"** [C] required for every new app and update; must cover third-party SDK data; answers can be updated without a build; must be accurate.
- **Privacy policy URL** required in App Store Connect and inside the app (5.1.1(i)) [C].
- **App Tracking Transparency**: tracking across others' apps/sites needs the ATT prompt; don't incentivise or pre-prompt in a misleading way (5.1.1, 5.1.2) [U on this fetch].
- **Privacy manifests** (`PrivacyInfo.xcprivacy`, required-reason APIs) required for uploads since 1 May 2024 [C].
- **Age ratings** [C]: tiers 4+, 9+, 13+, 16+, 18+ (since July 2025; all apps had to answer the new questionnaire by 31 Jan 2026). Questions cover in-app controls, capabilities (chatbots/AI, user-generated content, web access), medical/wellness and violent themes. Regional overrides (Australia, Korea; social-media questions added July 2026).
- **Medical devices** [C]: since 26 Mar 2026, Health & Fitness and Medical apps in the EU/EEA, UK and US must declare whether they are regulated medical devices.
- **Accessibility Nutrition Labels** [S]: voluntary for now (Apple says mandatory later), shown on iOS 26+. App Review can require fixing misleading claims. Only declare features that work across the common tasks.
- **EU DSA trader status** [C]: required; apps without it were removed from EU storefronts from 17 Feb 2025. Traders' address, phone and email are shown on the EU product page.

### Testing and custom pages
- PPO treatments, custom product pages, in-app events and promotional text all go through App Review [C]. PPO: one test at a time, up to 3 treatments, 90 days, alternate icons must be in the binary, a running test can't be edited. CPPs: up to 70, keyword assignment unique per page.

## 2. Google Play

### Metadata policy (https://support.google.com/googleplay/android-developer/answer/9898842) [C]
Title, icon and developer name must not contain:
- emoji, emoticons, repeated special characters;
- ALL CAPS unless it's the brand;
- store-performance or ranking claims ("#1", "Top", "Best", "Popular", "App of the year", "Best of Play 20XX", award icons);
- price or promo text ("Free", "10% off", "$50 cash back", "free for a limited time");
- Google Play program references ("Editor's Choice", "New");
- misleading symbols (fake notification badges, download arrows when the app isn't about downloads).

Descriptions must not contain:
- repetitive or unrelated keywords, keyword blocks or lists of terms;
- special characters or ALL CAPS used to attract attention;
- deceptive claims ("best game ever");
- unattributed or anonymous user testimonials;
- excessive length or repetition.

Everywhere in the listing:
- No celebrity names, likenesses or third-party brands/logos without permission (also covered by the Impersonation and Intellectual Property policies).
- No profanity, sexual content, graphic violence or drug use in assets.
- Graphics, screenshots and video must represent the actual app.
- The policy applies to every translation.

Graphic-asset guidance [C, Play Console help 9866151]:
- Feature graphic and screenshots: avoid "Best", "#1", "Top", "New", "Free", "Discount", "Sale", "Million downloads"; no store badges; no device frames on the feature graphic.
- No calls to action ("Download now", "Install now", "Play now", "Try now") in the short description, screenshots or video (guidance, not a separate policy).
- Icon: no text or graphics that promote deals or incentivise installs.
- Text under ~20% of each image.

### Impersonation and IP [C via policy centre structure, details U]
- No names, icons, screenshots or descriptions that imitate another app or company, or imply endorsement (including "official" or a brand's logo) without authorisation.
- No competitor names in metadata to capture their searches. Trademark owners can file complaints that lead to removal.

### Ratings, reviews and installs (https://support.google.com/googleplay/android-developer/answer/9898684) [C]
- No incentives of any kind for ratings, reviews or installs.
- No fake, paid or automated ratings, reviews or installs; no manipulating placement.
- No forcing users to rate, no deceptive rating pop-ups.
- **In-App Review API** (https://developer.android.com/guide/playcore/in-app-review) [C]: don't ask any question before or while showing the card ("Do you like the app?" = review gating); don't alter, overlay or remove the card; don't trigger it from a call-to-action button (send people to the Play listing instead); the quota is undisclosed and the card may not appear.

### Data safety, families, age
- **Data safety** section [C] required for every app on any non-internal track, including apps that collect nothing; covers SDKs; privacy policy link required; inaccuracies → update rejection or removal.
- **Families policy** [C]: declare the target audience truthfully; child-appealing imagery or words in the listing affect Google's assessment; apps targeting children use only Families self-certified ad SDKs, no personalised ads.
- **Age ratings** via the IARC questionnaire in Play Console; misrepresenting content → removal [U on this fetch].

### EU DSA trader status [C] (https://support.google.com/googleplay/android-developer/answer/17594752)
- Every active developer account must declare trader / non-trader by **1 Feb 2027**; from **1 Mar 2027** trader contact details (address, phone, D-U-N-S) show on the listing in the EEA, and the trader name replaces Google in "Offered by" in EEA and UK. Misdeclaring → suspension.

### Promotional content (LiveOps) [C]
- Types: Offer, Time-limited event, Major update. Max 4 weeks (major update 28 days). Submit up to 60 days ahead; review up to ~4 days; featuring needs submission ≥14 days ahead; can't edit after submission.
- Images: no text, logos, slogans or app names; no store badges; no rankings/awards; no "tap/press" requests. Percentage discounts belong in the tagline/description.
- Quarterly featuring quota per app (broad audience: games 4, apps 6; specific audience 2 each).

### Custom store listings and experiments [C]
- Custom store listings (up to 50) and experiment variants must follow the same Metadata policy. Ad-linked custom listings are reviewed. Store listing experiments: up to 2 variants vs current; one default-graphics experiment or up to 5 localized experiments at once; auto-stop after 6 months.

### App quality that hits visibility (Android vitals) [C]
- Overall user-perceived crash rate > 1.09% or ANR rate > 0.47% (last 28 days), or > 8% on a single device model, can reduce visibility and add a warning to the listing.

## 3. Consumer and advertising law (applies off-store too)

### United States: FTC
- **Consumer Reviews and Testimonials Rule** (16 CFR 465, effective 21 Oct 2024) [C]: bans fake or AI-generated reviews and testimonials, buying positive or negative reviews, insider reviews without disclosure, company-controlled "independent" review sites, suppressing reviews by threats or intimidation, and selling or buying fake social-media indicators (followers, views). Incentives conditioned on the review being positive are banned. Civil penalties apply per violation (US$53,088 per violation in 2025 [S]).
- **FTC Act §5 and Endorsement Guides (16 CFR 255)**: claims in listings and ads must be truthful and substantiated ("#1", "clinically proven", "saves 3 hours a week" need evidence); influencer/affiliate ties must be disclosed; review gating ("only send happy users to the store") can be deceptive.
- **Free / subscription claims**: "Free" must be free; free trials that auto-renew need clear terms and easy cancellation (ROSCA; state auto-renewal laws like California's). The store's own subscription UI handles some of this, but the listing copy must not contradict it.
- **COPPA**: apps directed at children under 13 (or with actual knowledge) need verifiable parental consent before collecting personal data; the 2025 COPPA Rule update tightened third-party sharing and data retention.

### European Union
- **Unfair Commercial Practices Directive as amended by the Omnibus Directive (EU) 2019/2161** (applies since 28 May 2022) [S]: banned outright: claiming reviews come from real users without reasonable checks; submitting or commissioning fake reviews or endorsements; misrepresenting reviews or ratings (including selective display). Traders must say whether and how they verify reviews. Price-reduction claims must reference the lowest price of the last 30 days.
- **Digital Services Act**: trader traceability (store trader status above); no dark patterns in interfaces.
- **GDPR / ePrivacy**: consent for tracking, accurate privacy disclosures (the privacy label is a public statement).
- **Accessibility Act (EAA)**, applicable since 28 June 2025: consumer apps in scope (e-commerce, banking, transport, e-books, communications) must be accessible; don't claim accessibility you don't deliver.
- **Comparative advertising** (Directive 2006/114): comparisons with competitors allowed only if objective, verifiable, not misleading and not denigrating; no riding on a competitor's trademark reputation. Using a competitor's brand in your listing is a trademark risk everywhere.

### United Kingdom
- **Digital Markets, Competition and Consumers Act 2024** (consumer provisions in force 6 Apr 2025) [S]: fake reviews, commissioning them, concealed incentivised reviews, and publishing reviews in a misleading way (e.g. suppressing negatives) are automatically unfair. CMA can fine up to 10% of global turnover (or £300,000 if higher). CMA guidance: CMA208.
- **CAP Code (ASA)**: ads, including app store screenshots used in ads and social, must not mislead; claims need evidence.

### Elsewhere
- India (Consumer Protection (E-Commerce) Rules and the 2022 BIS online-review standard), Australia (ACL; ACCC fake-review actions), Korea, Japan (Stealth Marketing regulation since Oct 2023: undisclosed promotions are misleading). The same practical rule covers them all: no fake, bought or gated reviews; claims must be true and provable; disclose paid endorsements.

### Intellectual property
- Don't use competitors' or other brands' trademarks, celebrity names or likenesses, sports leagues, film/TV/game titles or characters in titles, keywords, icons or screenshots without a licence. Keyword-field trademarks are invisible to users but still violate Apple 2.3.7 and can trigger trademark complaints.
- Use licensed fonts, photos and music in screenshots and videos. Stock photos of recognisable people need a model release for commercial use.
- "Works with <Brand>" is allowed only when true and when the brand's guidelines permit it; keep the other brand's mark secondary.

## 4. Quick reject-risk checklist (run before every submission)

- [ ] No competitor, celebrity or third-party brand names in any field, including the iOS keyword field.
- [ ] No "free", "best", "#1", "top", "new", "sale", prices, discounts, rankings, awards or download counts in title, subtitle, icon, developer name, feature graphic or screenshots.
- [ ] No emoji, ALL CAPS (unless brand), repeated symbols in titles.
- [ ] No other platforms' names or UI (Android on iOS, iPhone frames on Play).
- [ ] More than half the iOS screenshots show the real app; Play assets show the real app; previews are screen captures.
- [ ] Every claim is true for every user, or qualified ("after a one-time download"). Paid features are marked.
- [ ] Testimonials and awards attributed with a source (Play bans unattributed ones in descriptions; keep them out of Play screenshots).
- [ ] Review prompts use only the system APIs, no pre-question, no incentive, no button trigger.
- [ ] Privacy label / Data safety match what the app and its SDKs actually do.
- [ ] Age rating answers current; kids wording only in the Kids/Families programme.
- [ ] Trader status set for the EU.
- [ ] What's New describes the real change.
