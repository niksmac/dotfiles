---
name: lp-intent-mapper
description: Clarify and structure a landing-page or homepage request into a precise, confirmed brief covering goal, audience, offer, traffic sources, and objections. Use when the user's request is vague, missing key details, or when the page's purpose and audience aren't clearly defined.
metadata:
  author: github.com/niksmac
compatibility: Designed for OpenCode
---

# lp-intent-mapper

Turn a vague request like “make a landing page for my app” into a concrete brief other skills can trust.

## Collect

Ask one question at a time until you can fill:

- **Primary goal** – single most important outcome (email_signups, demo_bookings, purchase, etc.)
- **Page role** – campaign_landing, product_landing, or homepage_like
- **Target audience** – who they are + main pains
- **Main offer** – what users get when they convert
- **Traffic sources** – ads, email, organic, social, etc.
- **Message match notes** – promises/keywords from ads or SEO you must echo
- **Success metric** – how they will judge success (e.g., “15% signup rate”)
- **Key objections** – top 2–3 hesitations or anxieties

If `page_role = homepage_like`, also collect:

- **Homepage tagline** – short “who / what / for whom”
- **Top visitor tasks** – 3–5 key actions (e.g., view pricing, read docs, log in)

## Output

Summarise as:

```md
## Landing Page Brief

- **Primary goal:** …
- **Page role:** …
- **Target audience:** …
- **Main offer:** …
- **Traffic sources:** …
- **Message match notes:** …
- **Success metric:** …
- **Key objections:** …
- **Homepage tagline (if homepage_like):** …
- **Top visitor tasks (if homepage_like):** …
```

Then ask:

> “Does this brief accurately capture what you want this page to do?  
>  Please correct anything that’s off or missing.”

Only hand control back after the user confirms or corrects the brief.
