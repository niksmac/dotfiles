# Metadata fields, limits and indexing (verified 2026-11-10)

Tags as in `policy-legal.md`: **[C]** official page read, **[S]** official via search summary, **[U]** unconfirmed. Image and video sizes for screenshots, previews and the feature graphic live in `../store-screenshots/references/specs.md`; don't duplicate them here.

## Apple App Store

| Field | Limit | Search | Notes |
|---|---|---|---|
| App name | 30 chars [C] | **Indexed, strongest** [C] | Needs a new version to change (except on first submission). |
| Subtitle | 30 chars [C] | **Indexed** [C] | Shown under the name in search. |
| Keywords | 100 **bytes** [C], comma-separated | **Indexed** [C] | Not public. Multi-byte scripts fit fewer characters. New version needed. |
| Primary / secondary category | — | **Indexed** [C] | Pick primary by intent and competition, not just fit. |
| Promotional text | 170 chars [C] | **Not indexed** [C] | Editable any time without a build. |
| Description | 4,000 chars, plain text [C] | Not indexed [consensus] | Conversion and AI summaries/tags. |
| What's New | 4,000 chars [C] | No | Must describe significant changes (2.3.12). |
| In-app purchase display name / description | 35 / 55 chars [C] | Indexed per vendors [U] | Up to 20 promoted IAPs show on the page. |
| In-app event name / short / long description | 30 / 50 / 120 chars [C] | Events are searchable [C]; ranking effect [U] | Up to 10 published, 15 approved; each up to 31 days, promotable 14 days before start. |
| Developer name | — | Matches developer searches [U] | From the account / legal entity. |
| App Store tags (iOS 26) | Apple-generated | Shown in search and browse [C]; ranking effect not stated | US English first; deselect wrong tags in App Store Connect. |
| Screenshots | 1–10 per device size and locale [C] | Captions: contested [U] | First 3 portrait frames show in search. |
| App previews | up to 3, 15–30 s [C] | No | Autoplay muted; screen captures only (2.3.4). |
| Custom product pages | up to 70 [C] | Keyword-assigned CPPs show for those searches [C] | Own URL, optional deep link (iOS 18+). |
| Support URL, privacy policy URL | required [C] | No | Marketing URL optional. |

Official search statement [C] (https://developer.apple.com/app-store/search/): results use text relevance (title, subtitle, keywords, primary category) and user behaviour (downloads, ratings and reviews, and more).

## Google Play

| Field | Limit | Search | Notes |
|---|---|---|---|
| App title | 30 chars [C] | **Indexed, strongest** [consensus] | Localized title per language allowed. |
| Short description | 80 chars [C] | **Indexed** [consensus] | Shown on the listing; don't repeat it in the full description (Play best practices) [C]. |
| Full description | 4,000 chars [C] | **Indexed** [consensus] | Natural language; NLP; Ask Play reads it. |
| Developer name | ~50 chars [U] | Matches developer searches [U] | Same metadata policy as title. |
| Release notes | 500 chars [U] | No | Per release, per language. |
| Screenshot alt text | 140 chars per image | Accessibility | |
| Promotional content | tagline 80, description 500 [S]; spotlight tagline 48 | Shown in Apps/Games home, search, listing [C] | See policy-legal.md for rules and timing. |
| Custom store listings | up to 50 [C] | Keyword-targeted listings show for chosen searches [C] | Country, keywords, pre-registration, lapsed users, Google Ads. |
| Store listing experiments | 2 variants vs current [C] | — | Default (graphics) or up to 5 localized (graphics + descriptions) at once; 6-month auto-stop. |
| Contact | support email required [C] | No | |

Play has no keyword field, no subtitle and no promotional text. Characters count the same in full- and half-width scripts [C].

## Behavioural signals both stores use (no official weights)

- Install volume and **velocity** (recent installs vs peers).
- **Conversion** of search impressions to installs for each term.
- **Engagement and retention** (uninstalls soon after install hurt; Play states it uses quality signals).
- **Ratings** (average, volume, recency) and review content.
- **Technical quality**: Android vitals on Play [C]; crashes on iOS [U].
- Update recency [vendor].
- Play: web mentions/backlinks to the listing [vendor]; Apple: none.
