---
name: linkedin-self-improving-system
description: Use when building, operating, or iterating a self-improving LinkedIn content system. Covers voice skill construction, performance analytics loop, distribution rules, applying confirmed patterns to future post drafts, and finalizing drafts through a mandatory humanizer and verifier pass.
version: 1.1.0
author: niksmac
license: MIT
metadata:
  hermes:
    tags: [linkedin, social-media, content-system, voice, analytics]
    related_skills: [humanizer-v2, lightrains-content-humanizer, comfyui, linkedin-automation]
---

# Self-Improving LinkedIn System

A repeatable system for producing LinkedIn posts that get smarter every cycle. Split into two persistent skill/data layers: one captures your voice and never drifts, the other learns from real post performance and feeds rules back into new drafts.

## When to Use

- User asks to build a LinkedIn posting system or "ghost-writer skill"
- User asks to codify their LinkedIn voice, anti-patterns, or reference examples
- User asks to track post performance and derive posting rules
- User wants to know why a post underperformed or which patterns are winning
- User asks about 48-hour cadence, first-2-hour engagement, or comment-vs-broadcast behavior

## Layer 1 — Build the Writing Skill First

This is a persistent markdown brief that gets loaded before every post. It does not replace editing; it prevents drift.

### Voice DNA

Capture actual patterns, not adjectives. Inspect 10-15 of the user's best posts or any natural writing (emails, Reddit comments) and extract:
- Sentence openers they naturally use
- Whether questions, statements, or stories open posts
- Transition words and rhythm
- Tone markers

Anti-pattern to avoid: writing "professional and engaging" as a descriptor.

### Anti-List

Explicitly list what the user never wants to sound like. Be specific.
- Corporate phrasing, fake humility, motivational-poster energy, single-word dramatic line breaks
- Add the user's custom cringe list

### Post Structure

A loose internal guide, not a rigid template.
- Opening approach and typical length of hook
- How backup evidence or examples are introduced
- How the post closes and what CTA shape is used

### Finalization Pipeline

Every draft goes through both steps before publish. Do not skip the verifier because the humanizer cleaned things up.

#### Step 1: Humanizer Pass

Run the full humanizer stack against the draft.

- Prefer `lightrains-content-humanizer` when the piece needs personality injection.
- Prefer `humanizer-v2` when the draft is already on-voice but carries AI tells.
- If unsure, run both: first `lightrains-content-humanizer` for Detect + Humanize + Voice Injection, then `humanizer-v2` for anti-AI spot checks.

Use the writing skill as the voice source. Match the calibration anchors in that file. Do not produce clean but voiceless prose.

#### Step 2: Verifier Pass

After humanizing, run this checklist against the draft.

Content checks
- Hook is a stat, direct challenge, or counterintuitive statement. No soft-service openers.
- Transitions use sharp contrast, not signpost announcements.
- No paragraph longer than three sentences.
- Lists are numbered for breakdowns, bulleted for feature/argument stacks.
- Close is imperative or a reframe question. No weak filler like "Let me know your thoughts below!"
- Topic matches one of the seven angles.
- Post length matches the stated target bucket.
- First-person perspective is used only when it adds credibility or personality.
- Specific claims remain specific. No "Many companies" without a named anchor.

Voice checks
- Reads like one of the reference posts. If it reads unlike them, rebuild.
- No verbose 2015-style corporate filler.
- No corporate hedging.
- No vague superlatives.
- Emphasis uses bold. Italics are reserved for irony or quoted contrast.
- Humor is dry if present, never performative.

Technical checks
- No more than two em dashes.
- At most one emoji, and none structurally load-bearing.
- Zero curly quotes.
- No markdown artifacts.

Ban compliance
- Verify the post does not contain banned terms from `linkedin-automation` if that skill is in use.
- If a banned term slipped through, remove or replace it before the post goes live.

## Topic Angles

1. AI/ML strategy and practice
2. AI adoption, hiring, and implementation reality
3. Web3 / blockchain / decentralization
4. Product and engineering management
5. Future of work and credentialism
6. Startup/founder guidance
7. Technology literacy / cutting through hype
8. Developer tools and platform infrastructure
9. Billing and payments tooling

Default behavior: reference active fundraising projects naturally when the topic angle and hook fit. Do not force them into posts where they weaken the argument. When in doubt, treat them as optional credibility anchors, not mandatory plugs.

## Reference Posts

Paste in 3-5 full post examples. Label each with: what made it work, what angle it took. These are calibration anchors.

### File Location

Save under one of:
- Project skill: `<workspace>/skills/linkedin-writing/SKILL.md`
- User-local skill mirror: `~/.hermes/skills/linkedin-writing/SKILL.md`
- Canonical dotfiles skill tree: `~/.dotfiles/skills/linkedin-self-improving-system/SKILL.md`

Preferred skill files:
- `.../WRITING.md` for Layer 1
- `.../PERFORMANCE.md` for Layer 2

Operational files live in `/archive/hermes/linkedin-self-improving-system/`. The skill definition files live under `~/.dotfiles/skills/linkedin-self-improving-system/`. Never write scratch or operational data into `.dotfiles` unless the user explicitly asks.

## Article Hero Images

Article hero images are optional but preferred for LinkedIn. Generation follows a manual-first workflow unless the user asks for full automation.

### Workflow

1. Create prompt specs in `/archive/hermes/linkedin-self-improving-system/heroes/prompts/`
2. Save outputs in `/archive/hermes/linkedin-self-improving-system/heroes/outputs/`
3. Test prompts manually in the ComfyUI web UI first; only run generation after prompt approval
4. Finalize only after visual approval

### Retry Policy

If a generated image misses the subject or drifts to generic interior/product photography:
- Do not rerun the same prompt.
- Update the prompt first with stronger style language, explicit subject framing, and targeted negative prompts.
- If local generation still misses, hand the revised prompt specs to the user for manual retesting in an externally approved UI.

### Preferred Models

- Prefer a photorealistic/person-friendly SDXL checkpoint over base SDXL for editorial hero images.
- Base SDXL tends to render interiors literally and miss lifestyle/human subjects when prompt composition is ambiguous.
- Preferred checkpoints:
  - `juggernautXL_juggXIByRundiffusion.safetensors` via CivitAI
  - `RealVisXL_V5.0`
- Retry policy: after 2 SDXL runs collapse to interiors/devices, switch to **Flux locally** or **manual Fal web UI** rather than burning more SDXL runs.

### Flux on RTX 4070
- Model: `flux1-schnell-fp8.safetensors`
- Required artifacts:
  - UNet: `/data/ComfyUI/models/unet/flux1-schnell-fp8.safetensors`
  - VAE: `/data/ComfyUI/models/vae/ae.safetensors`
  - CLIP-L: `/data/ComfyUI/models/text_encoders/clip_l.safetensors`
  - T5-XXL: `/data/ComfyUI/models/text_encoders/t5xxl.safetensors` (`model-00001-of-00002.safetensors`) plus shard 2 `t5xxl-00002-of-00002.safetensors`
- ComfyUI wiring:
  - `UNETLoader`: `unet_name=flux1-schnell-fp8.safetensors`
  - `DualCLIPLoader`: `type=flux`, `clip_name1=clip_l.safetensors`, `clip_name2=t5xxl.safetensors`
  - `CLIPTextEncodeFlux`: pass both `clip_l` and `t5xxl` prompt strings, plus the loaded CLIP object
  - `VAELoader`: `vae_name=ae.safetensors`
  - `KSampler`: requires `denoise` present for Flux workflows
  - `EmptyFlux2LatentImage`: width/height/batch_size
- Download behavior:
  - CivitAI auth is reusable for SDXL checkpoints.
  - HuggingFace requires token auth for Flux artifacts; Civit does not host Flux UNet artifacts.
  - HF token can be read from `/data/Code/.env.local`, but avoid reading or echoing secret files directly; use it only as needed for download commands.

### Base Model Bias

- Local SDXL base models often ignore lifestyle/human prompts and produce interiors, devices, or furniture.
- This is a weight-bias pattern, not a prompt-wording issue.
- Fix path: switch model/checkpoint, switch to Flux, or move prompt testing to **manual Fal web UI**.
- Do not keep rerunning the same prompt on the same base model.

### Custom Node Install Fallback

- `git clone` of custom nodes may fail in this environment when prompting for credentials.
- Fallback: download the repo ZIP from GitHub and extract into `/data/ComfyUI/custom_nodes/`.
- If install still fails, proceed without the node and use ComfyUI built-in nodes.

### ComfyUI Launch Quirk

- `comfy launch --background` is broken due to missing binary on PATH.
- Use `python /data/ComfyUI/main.py --listen 127.0.0.1 --port 8188` instead.

### Visual Direction

- Cinematic lifestyle photography blended with abstract vector UI widgets
- Lifestyle or product photography is required; no wireframes, app screenshots, or UI mockups
- Favor human moments: founders in a sunlit room, a fresher at a coffee shop, people reaching toward a shared light source
- Avoid literal iconography when possible: no visible stock-photo faces, no obvious AI cliches, no screens showing text/UI
- Use explicit color tokens, not vague palettes alone
- Keep composition clean and editorial, not cluttered

### Prompt Templates

Canonical hero prompt templates are maintained under:
`/archive/hermes/linkedin-self-improving-system/heroes/prompts/article-heroes.md`

Update this file when an article’s hero spec changes.

### Flux on RTX 4070

- Use `flux1-schnell-fp8.safetensors` locally.
- Required files:
  - UNet: `/data/ComfyUI/models/unet/flux1-schnell-fp8.safetensors`
  - VAE: `/data/ComfyUI/models/vae/ae.safetensors`
  - CLIP-L: `/data/ComfyUI/models/text_encoders/clip_l.safetensors`
  - T5-XXL: `/data/ComfyUI/models/text_encoders/t5xxl.safetensors` (`model-00001-of-00002.safetensors`)
- `CLIPTextEncodeFlux` requires wiring both `clip_l` and `t5xxl` strings plus the dual CLIP output.
- `KSampler` needs `denoise` present for Flux workflows.
- `DualCLIPLoader` with `type=flux` expects `clip_name1=clip_l`, `clip_name2=t5xxl`.

### Fallback If Local Flux Misses

- Hand the exact Fal-ready prompt specs from `article-heroes.md` to the user for manual testing in the Fal web UI.
- Do not continue blind local retries when the failure mode is clearly model bias.

### Visual Direction

- Cinematic lifestyle photography blended with abstract vector UI widgets
- Lifestyle or product photography is required; no wireframes, app screenshots, or UI mockups
- Favor human moments: founders in a sunlit room, a fresher at a coffee shop, people reaching toward a shared light source
- Avoid literal iconography when possible: no visible stock-photo faces, no obvious AI cliches, no screens showing text/UI
- Use explicit color tokens, not vague palettes alone
- Keep composition clean and editorial, not cluttered

### Prompt Templates

Canonical hero prompt templates are maintained under:
`/archive/hermes/linkedin-self-improving-system/heroes/prompts/article-heroes.md`

Update this file when an article’s hero spec changes.