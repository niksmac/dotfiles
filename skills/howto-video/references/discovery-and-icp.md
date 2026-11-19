# Discovery and the ICP

The goal of discovery is a short list of **true claims, real screens and the audience's own words**.
A how-to video that shows a screen the product doesn't have, or a number the site contradicts, loses
trust and can break consumer-protection rules.

## Where to look (in this order)

| Source | What to take | How |
|---|---|---|
| Pages the user named | the promise, steps, numbers, FAQ answers, CTAs, page illustrations | `curl -sL URL \| pandoc -f html -t plain` (Linux) or `… \| textutil -stdin -format html -convert txt -stdout` (macOS). Strip nav and footer with `grep -v '^\s*$'` |
| Pricing, FAQ, help center, terms | plan names, which plan includes what, limits, eligibility | same; a JavaScript-rendered page won't fetch, so say so and ask for a screenshot |
| The web app's code | exact UI labels, form fields, states (empty, loading, success, toast text), colours, fonts, radius, shadows | grep the routes and components for the feature: `grep -rn -i "<label text>" app components --include='*.jsx'`; tokens from `tailwind.config.*`, `globals.css`, `theme.*` |
| The mobile app's code | the same, for in-app flows; which features are web-only | look for feature modules, paywall gates, hidden flags |
| Docs in the repo | brand sheet, product spec, store listing, claims list, "don't say" lists | `README`, `DESIGN.md`, `BRAND.md`, `docs/`, `copy/` |
| `public/` or the asset folders | page illustrations, logos, **animated logos**, OG images | list the folder that serves the pages you read; view a contact sheet with ffmpeg `tile` |
| Footage | screen recordings, launch films, app previews | `ffprobe` for size and length; grab frames to see what's on screen |
| Owned music | a launch score or brand sting | prefer it to generated music (free, on-brand) |

Build a contact sheet of candidate images to see them in one look:

```bash
ffmpeg -i a.webp -i b.webp … -filter_complex "[0]scale=360:360:force_original_aspect_ratio=decrease,pad=360:360:(ow-iw)/2:(oh-ih)/2:white[v0];…;[v0][v1]…xstack=inputs=N:layout=…" sheet.png
```

### Spot the gaps and contradictions

Write down where sources disagree: the site says "30 seconds" and the brand doc says "about a minute",
the site says 39 languages and the app ships 7, or a feature is on the pricing page but its toggle is
hidden in the app. Each one becomes either wording that needs no number ("one short passage") or a
question for the user. Also note **where** a feature lives (web only, app only), because that decides
which UI you rebuild.

## ICP-<slug>.md template

```markdown
# ICP: <product> · <video topic>

## Who it's for
- Primary: <role / situation>, e.g. "parenting creators with 10k+ followers"
- Secondary: <…>
- Not for: <who would be misled or isn't served>

## Their moment
What just happened that makes this video relevant (trigger), and what they're trying to get done (job).

## What they need to see to act
The 3–5 proofs, each tied to a real screen or claim: "one tick turns a playlist into a podcast
(NewPlaylist.jsx: 'Make this a Podcast')".

## Objections to answer honestly
"Does it pay per listen?" → "No: income comes from sponsors, subscriptions and listeners (article §…)".

## Their words
Phrases from the site, reviews, FAQs and comments that the audience uses (for headlines and captions).

## Where they'll watch → formats
YouTube (16:9, chapters, description links), Shorts, Reels and TikTok (9:16, sound off: captions on),
LinkedIn, website embed.

## The one action
The CTA and its URL (with UTM), and whether a QR on the end card makes sense (TV, desktop, shared screens).

## Claims we may use
| Claim | Source |
|---|---|

## Claims to avoid
Prices (unless the owner allows them), superlatives ("best"), features that are hidden or unreleased,
promises about earnings or results, competitor names, anything the brand doc bans.

## Contradictions and open questions
| Topic | Source A says | Source B says | Proposal |
|---|---|---|---|
```

Keep it to one page. Its job is to make the script obvious and to give the user something concrete to
correct before you plan.
