# PLAN-<slug>.md template (gate 1)

Present the plan as a file **and** as a short chat summary, then stop. The user approves, edits or
answers the open decisions, and their answers go into "Owner decisions" so they survive later sessions.

```markdown
# <Video title>: plan (v1, <date>)

Sources: <URLs, repo paths>. Audience: <one line from the ICP>.

## Owner decisions
(empty until the user answers; then one bullet per rule, with the date, e.g.
"Percentages on screen are fine, never dollar amounts (2026-11-19)")

## The message
One sentence. Then the 2–4 beats the video must land.

## Deliverables
| File | Size | Length |
|---|---|---|
| deliver/<slug>/<slug>-16x9.mp4 | 1920×1080, 30 fps | ~N s |
| deliver/<slug>/<slug>-9x16.mp4 | 1080×1920, 30 fps | ~N s |
| deliver/<slug>/thumbnail.jpg + youtube.md | 1280×720 | — |

## Storyboard
| # | Scene | Len | Visual (source) | Voice line | On-screen headline | SFX |
|---|---|---|---|---|---|---|
| 1 | Hook | 4–5 s | frame 0 must read alone (it's the thumbnail) | … | "… **chip phrase.**" | pop |
| … | | | rebuilt UI from `components/X.jsx`; screenshot `shots/y.png`; footage `z.mp4` 2–6 s | | | click, key, toggle |
| N | End card | 6 s | animated logo → lockup, URL, CTA, QR → <url> | "…" | — | slam, chime |

## Audio
- Voice: <ElevenLabs voice name/id>, model <id>; N lines, ~C characters ≈ C credits.
- Music: <owned score | free library | generated bed (~1,100 credits for 40 s)>; final hit on the end card.
- UI sounds: <project library | media-use bundled>.

## Costs
| Item | Credits / time |
|---|---|
| TTS (dry run) | ~C |
| Music | 0 / ~1,100 |
| Render | ~1–3 min per size |

## Truth checks
What is left out and why (prices, unstated numbers, hidden features, contradictions).

## Open decisions (for the owner)
1. Numbers on screen (percentages, prices, limits)?
2. Rebuild these screens from code, or will you screen-record them?
3. CTA and QR target URL?
4. Scope: one master or both sizes, extra cut-downs?
```

## Writing the storyboard

- **Hook (frame 0):** the headline is on screen at frame 0, along with the main visual. It's the
  thumbnail on most platforms and the first thing a sound-off viewer reads. Promise the outcome, in the
  audience's words.
- **One idea per scene**, 3–6.5 s. One headline per scene with one highlighted phrase.
- **Show, then tell:** every claim has a visual proof on screen at the moment it's said (time it to the
  word: word timings come from the TTS).
- **Answer one objection out loud** (it builds trust): what the product doesn't do, or what it needs
  (plan, follower count, platform).
- **Section cards** ("1 · …", "2 · …") when there are two or more paths.
- **End card:** a single action. A QR code is worth it for 16:9 (TV, desktop, shared screens) and still
  useful in 9:16. Hold it for at least 6 s.
- **Length:** 45–70 s for an explainer, 15–30 s for a cut-down. Voice lines run 2.5–6 s each, about
  12–15 characters per second.

## The chat summary

Five to eight lines: the message, formats and length, the scene list (one line each), the cost, and
the open decisions as a numbered list. End by asking for approval or changes.
