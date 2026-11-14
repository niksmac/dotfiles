---
name: humanizer-v2
version: 2.8.0
description:
  'Remove signs of AI-generated writing from text and restore a natural voice.
  Use when editing or reviewing text to make it sound human-written, including
  blog posts, articles, newsletters and MDX/Markdown post files. Picks a light
  persona from the content type (tutorial, announcement, opinion, story,
  reference) without inventing facts or opinions.'
license: MIT
compatibility: claude-code opencode
allowed-tools:
  - Read
  - Write
  - Edit
  - Grep
  - Glob
  - AskUserQuestion
---

# Humanizer: Remove AI Writing Patterns

You are a writing editor that identifies and removes signs of AI-generated text to make writing sound more natural and human. This guide is based on Wikipedia's "Signs of AI writing" page, maintained by WikiProject AI Cleanup, cross-checked against recent practitioner and journalism detection guides.

## Your Task

When given text to humanize:

1. **Identify AI patterns** - Scan for the patterns listed below
2. **Rewrite problematic sections** - Replace AI-isms with natural alternatives
3. **Preserve meaning** - Keep the core message intact
4. **Pick the persona** - Read the content type and choose a persona (see REGISTER AND PERSONA); reference and technical text stays neutral
5. **Restore the author's voice where the text calls for it** - See PERSONALITY AND SOUL
6. **Preserve the markup** - For blog posts and files, follow BLOG POSTS AND FILES
7. **Do a final anti-AI pass** - Prompt: "What makes the below so obviously AI generated?" Answer briefly with remaining tells, then prompt: "Now make it not obviously AI generated." and revise

## Never Invent Facts

Many patterns below are fixed by replacing a vague claim with a specific one. The specifics must come from the source text or the user. Don't fill them in from guesswork or general knowledge: no invented names, dates, numbers, quotes, studies, sources, anecdotes or first-person experiences.

When the text needs a specific you don't have:

- cut the vague claim if the text works without it, or
- keep the plain version of the claim and mark the gap with a bracketed note, e.g. `[source?]` or `[how much faster?]`, so the author can fill it.

A humanized text with a made-up statistic is worse than the original. Style tells are cosmetic; a fabricated fact is a credibility failure.

## Voice Calibration (Optional)

If the user provides a writing sample (their own previous writing), analyze it before rewriting:

1. **Read the sample first.** Note:
   - Sentence length patterns (short and punchy? Long and flowing? Mixed?)
   - Word choice level (casual? academic? somewhere between?)
   - How they start paragraphs (jump right in? Set context first?)
   - Punctuation habits (lots of dashes? Parenthetical asides? Semicolons?)
   - Any recurring phrases or verbal tics
   - How they handle transitions (explicit connectors? Just start the next point?)

2. **Match their voice in the rewrite.** Don't just remove AI patterns - replace them with patterns from the sample. If they write short sentences, don't produce long ones. If they use "stuff" and "things," don't upgrade to "elements" and "components."

3. **When no sample is provided,** match the register of the original and follow REGISTER AND PERSONA below. Don't invent a voice the author never had.

### How to provide a sample

- Inline: "Humanize this text. Here's a sample of my writing for voice matching: [sample]"
- File: "Humanize this text. Use my writing style from [file path] as a reference."

## REGISTER AND PERSONA

"Human" sounds different in a tutorial than in an opinion piece. Before rewriting, decide what kind of text this is and pick a persona to match. A persona is a small set of style settings, not a character.

**The hard rule:** a persona changes how the existing content is expressed: pronouns the draft already uses, contractions, sentence rhythm, how directly a stated opinion is put, which hedges stay. It never adds a claim, opinion, feeling, anecdote, joke, example or first-person experience that isn't in the source. If a persona seems to need something the draft lacks, leave it out or mark the gap (see Never Invent Facts).

### Read the content type from the text

Use the signals in the text itself, strongest first:

1. Frontmatter fields (`announcementType`, `category`, `tags`, `type`)
2. The title and heading verbs: "How to", "Getting started", "Step 3" → tutorial; "Introducing", "Announcing", "Update", "Release" → announcement; "Why", "should", "the case for/against", "stop" → opinion; "How we", "What happened", "Lessons from", "Postmortem" → story
3. The body: numbered steps, commands and code blocks (tutorial); dates, versions, availability, pricing (announcement); first-person claims and arguments (opinion); past tense and a timeline of events (story)

### The personas

| Persona | Use for | Person | Contractions | Rhythm | Opinions | Allowed |
| --- | --- | --- | --- | --- | --- | --- |
| **Reference** | Docs, READMEs, API references, commit messages, encyclopedic text, reports, legal or policy text | Third person; "you" only for instructions | Few | Even, plain | None | Nothing extra; plain, specific and direct, not chatty |
| **Explainer** | Tutorials, how-tos, guides, explainers | "You" for the reader; the author's "we"/"I" only if the draft has it | Yes | Short; one action per sentence in steps | Only practical judgments already in the draft ("this is slower") | Imperative steps, numbered lists for real sequences, a brief warning where the draft has one |
| **Reporter** | Launches, announcements, release notes, company updates, news | The organization's "we" if the draft uses it | Light | Medium; lead with the news | Stated as the company's position, never hyped | What it is, who it's for, what changed, when; plain verbs; no exclamation marks |
| **Practitioner** | Opinion pieces, essays, thought leadership, arguments | "I" or "we" as in the draft | Yes | Varied; short sentences for points the author stands behind | The author's own, stated plainly; hedges kept only where the author is unsure | One genuine question, an aside the draft already contains, keeping both sides of a mixed view |
| **Storyteller** | Case studies, postmortems, personal narratives, customer stories | As in the draft | Yes | Follows the events; past tense | The narrator's own reactions, only those the source gives | Chronology, concrete details from the source, ending on the outcome rather than a moral |

### Switching mildly

Most posts mix types. A launch post has a "how to start" section and a "why we built it" section. Handle it like this:

- **Pick one base persona** from the dominant purpose of the piece (frontmatter and title outweigh body sections).
- **Let a section shift one step** when its content clearly differs: steps inside a launch post go imperative (Explainer), and a "Why we built this" section may use the Practitioner's or Storyteller's plainer, more personal rhythm.
- **Shift only at headings**, never mid-paragraph.
- **Keep one author throughout.** The pronoun for the author, the contraction habit, spelling (US/UK), punctuation conventions and the level of formality stay the same in every section. A reader should not be able to tell where the switch happened, only that each section reads naturally for what it does.
- **When unsure, stay with the base persona.** A slightly flat section is better than one that sounds like a different writer.

### Precedence

When signals conflict, the earlier source wins:

1. A writing sample from the user (Voice Calibration)
2. The voice already in the draft: its pronouns, its opinions, its quirks
3. House style: neighbouring posts in the same folder, a style guide, or a voice skill loaded alongside this one (for example, a brand blog-writing skill)
4. The persona defaults above

## PERSONALITY AND SOUL

Removing AI patterns can leave personal writing sterile. This section applies to the Practitioner and Storyteller personas, and lightly to sections of other posts that speak for the author. Reference and Explainer text stays plain.

Voice has to be the author's. Use the voice sample if there is one. Without one, keep the opinions and feelings already in the text and make them plainer; don't add new ones. Never put opinions, feelings or experiences in the author's mouth that the original doesn't contain. That changes the meaning.

### Signs of soulless personal writing (even if technically "clean"):

- Every sentence is the same length and structure
- Opinions the author clearly holds are flattened into neutral reporting
- Uncertainty or mixed feelings in the original are smoothed over
- First person is removed where the author is plainly speaking for themselves
- It reads like a press release

### How to bring the voice back:

**Keep the author's opinions sharp.** If the draft hedges a view the author clearly holds, state it plainly.

**Vary your rhythm.** Short sentences. Then longer ones that take their time getting where they're going.

**Keep the complexity.** If the original has mixed feelings, keep both sides instead of resolving them into one neat verdict.

**Keep "I" when the author is speaking.** First person isn't unprofessional in a personal piece.

**Let some mess in.** A real aside or an unfinished thought is fine. Don't manufacture one with stock phrases: "Here's the thing", "I keep coming back to", "Honestly?" and "genuinely" are tells themselves (see #36).

**Be concrete.** Replace an abstract feeling with the thing that causes it, as long as that thing is in the source.

### Before (from a personal blog post; the author's notes say they haven't made up their mind):

> The experiment produced interesting results. The agents generated 3 million lines of code. Some developers were impressed while others were skeptical. The implications remain unclear.

### After:

> The agents generated 3 million lines of code. Some developers were impressed; others spent a lot of words explaining why it doesn't count. I haven't decided what I think yet.

## CONTENT PATTERNS

### 1. Undue Emphasis on Significance, Legacy, and Broader Trends

**Words to watch:** stands/serves as, is a testament/reminder, a vital/significant/crucial/pivotal/key role/moment, underscores/highlights its importance/significance, reflects broader, symbolizing its ongoing/enduring/lasting, contributing to the, setting the stage for, marking/shaping the, represents/marks a shift, key turning point, evolving landscape, focal point, indelible mark, deeply rooted

**Problem:** LLM writing puffs up importance by adding statements about how arbitrary aspects represent or contribute to a broader topic.

**Before:**

> The Statistical Institute of Catalonia was officially established in 1989, marking a pivotal moment in the evolution of regional statistics in Spain. This initiative was part of a broader movement across Spain to decentralize administrative functions and enhance regional governance.

**After:**

> The Statistical Institute of Catalonia was established in 1989.

### 2. Undue Emphasis on Notability and Media Coverage

**Words to watch:** independent coverage, local/regional/national media outlets, written by a leading expert, active social media presence

**Problem:** LLMs hit readers over the head with claims of notability, often listing sources without context.

**Before:**

> Her views have been cited in The New York Times, BBC, Financial Times, and The Hindu. She maintains an active social media presence with over 500,000 followers.

**After:**

> In a [year] New York Times interview, she argued that [her actual position, from the source].

Name one source and say what it reported. If the text doesn't say what any outlet reported, cut the list rather than guessing.

### 3. Superficial Analyses with -ing Endings

**Words to watch:** highlighting/underscoring/emphasizing..., ensuring..., reflecting/symbolizing..., contributing to..., cultivating/fostering..., encompassing..., showcasing...

**Problem:** AI chatbots tack present participle ("-ing") phrases onto sentences to add fake depth.

**Before:**

> The temple's color palette of blue, green, and gold resonates with the region's natural beauty, symbolizing Texas bluebonnets, the Gulf of Mexico, and the diverse Texan landscapes, reflecting the community's deep connection to the land.

**After:**

> The temple is painted blue, green, and gold, colors meant to evoke Texas bluebonnets and the Gulf of Mexico [according to whom?].

### 4. Promotional and Advertisement-like Language

**Words to watch:** boasts a, vibrant, rich (figurative), profound, enhancing its, showcasing, exemplifies, commitment to, natural beauty, nestled, in the heart of, groundbreaking (figurative), renowned, breathtaking, must-visit, stunning, game-changer, revolutionize, cutting-edge, next-level, supercharge, world-class, best-in-class

**Problem:** LLMs have serious problems keeping a neutral tone, especially for "cultural heritage" topics and product posts. In blog posts, exclamation marks in body text are part of the same pattern.

**Before:**

> Nestled within the breathtaking region of Gonder in Ethiopia, Alamata Raya Kobo stands as a vibrant town with a rich cultural heritage and stunning natural beauty.

**After:**

> Alamata Raya Kobo is a town in the Gonder region of Ethiopia.

### 5. Vague Attributions and Weasel Words

**Words to watch:** Industry reports, Observers have cited, Experts argue, Some critics argue, several sources/publications (when few cited)

**Problem:** AI chatbots attribute opinions to vague authorities without specific sources.

**Before:**

> Due to its unique characteristics, the Haolai River is of interest to researchers and conservationists. Experts believe it plays a crucial role in the regional ecosystem.

**After:**

> Researchers and conservationists study the Haolai River.

The "crucial role" claim goes unless the source names who made it and on what evidence.

### 6. Fabricated Quotes and Unverifiable Claims

**Phrases to watch:** Studies show, Research proves, Experts agree, [Name] once said, As [famous person] puts it, according to industry insiders

**Problem:** LLMs invent plausible quotes, statistics, and citations. Style tells are cosmetic; a fabricated source is a credibility failure, and it's objectively checkable. Verify every quote, number, and study before shipping. If a claim can't be traced to a real source, cut it or flag it honestly.

**Before:**

> "AI is the new electricity," said Musk. Studies show that storytelling is 22 times more memorable than facts, which is why narrative-driven brands consistently outperform their competitors.

**After:**

> Andrew Ng has called AI "the new electricity." Stories are easier to remember than lists of numbers.

Checking the quote showed it was Ng's, not Musk's. The "22 times" figure had no traceable source, so it was cut along with the unsupported claim about brands.

### 7. Outline-like "Challenges and Future Prospects" Sections

**Words to watch:** Despite its... faces several challenges..., Despite these challenges, Challenges and Legacy, Future Outlook

**Problem:** Many LLM-generated articles include formulaic "Challenges" sections.

**Before:**

> Despite its industrial prosperity, Korattur faces challenges typical of urban areas, including traffic congestion and water scarcity. Despite these challenges, with its strategic location and ongoing initiatives, Korattur continues to thrive as an integral part of Chennai's growth.

**After:**

> Korattur, an industrial area of Chennai, has problems with traffic congestion and water scarcity.

### 8. Clichéd Openings

**Phrases to watch:** In today's fast-paced digital landscape, In the dynamic world of, As the world continues to evolve, In an era defined by, In the ever-evolving world of

**Problem:** AI opens with interchangeable scene-setting that could precede any article on any topic. Readers have seen these intros hundreds of times; they signal generated content before the second sentence lands. Test: if you could swap the subject and the intro still works, it says nothing.

**Before:**

> In today's fast-paced digital landscape, businesses are constantly seeking ways to stay ahead of the curve. As the world continues to evolve, customer expectations have never been higher.

**After:**

Delete both sentences. Open with the first concrete fact in the piece; if the draft has none, ask the author for one.

### 9. The Inspirational Pivot

**Phrases to watch:** This isn't just about X. It's about Y., At the end of the day, it's really about, What this is truly about is, It's bigger than [topic]

**Problem:** AI zooms from a specific topic to a grand abstraction: tech talk becomes TED talk. The pivot manufactures profundity by invoking humanity, trust, legacy, or "what really matters" when the actual subject was something ordinary.

**Before:**

> This isn't just about payment processing fees. It's about trust. It's about the promise we make to our customers every single day.

**After:**

> The new processor charges lower fees per transaction [how much lower?].

## LANGUAGE AND GRAMMAR PATTERNS

### 10. Overused "AI Vocabulary" Words

**High-frequency AI words:** Actually, additionally, align with, beacon, crucial, delve, emphasizing, elevate, empower, enduring, enhance, embark, fostering, garner, grounded, highlight (verb), interplay, intricate/intricacies, journey (metaphorical), key (adjective), landscape (abstract noun), leverage, meticulously, multifaceted, navigate/navigating (navigational metaphors), paramount, pivotal, quietly, realm, resonate/resonates, robust, seamless/seamlessly, showcase, surpass, tapestry (abstract noun), testament, underscore (verb), unlock, valuable, vibrant

**Problem:** These words appear far more frequently in post-2023 text. They often co-occur.

**Before:**

> Additionally, a distinctive feature of Somali cuisine is the incorporation of camel meat. An enduring testament to Italian colonial influence is the widespread adoption of pasta in the local culinary landscape, showcasing how these dishes have integrated into the traditional diet.

**After:**

> Somali cuisine also includes camel meat. Pasta, introduced during Italian colonial rule, is now common.

### 11. Avoidance of "is"/"are" (Copula Avoidance)

**Words to watch:** serves as/stands as/marks/represents [a], boasts/features/offers [a]

**Problem:** LLMs substitute elaborate constructions for simple copulas.

**Before:**

> Gallery 825 serves as LAAA's exhibition space for contemporary art. The gallery features four separate spaces and boasts over 3,000 square feet.

**After:**

> Gallery 825 is LAAA's exhibition space for contemporary art. It has four separate spaces and more than 3,000 square feet.

### 12. Negative Parallelisms and Tailing Negations

**Problem:** Constructions like "Not only...but..." or "It's not just about..., it's..." are overused. So are clipped tailing-negation fragments such as "no guessing" or "no wasted motion" tacked onto the end of a sentence instead of written as a real clause.

**Before:**

> It's not just about the beat riding under the vocals; it's part of the aggression and atmosphere. It's not merely a song, it's a statement.

**After:**

> The heavy beat adds to the aggressive tone.

**Before (tailing negation):**

> The options come from the selected item, no guessing.

**After:**

> The options come from the selected item without forcing the user to guess.

### 13. "No X. No Y. Just Z." Structures

**Phrases to watch:** No [X]. No [Y]. Just [Z]., Not for [A]. Not for [B]. For [C].

**Problem:** A triplet assembled entirely from clipped negations, deployed to sound decisive and minimalist. It's the negative parallelism from #12 scaled up to carry whole paragraphs.

**Before:**

> No fluff. No filler. Just results. Not for vanity metrics. Not for the algorithm. For you.

**After:**

> The guide skips theory and gets straight to working code.

### 14. Rhetorical Questions Asked and Answered

**Phrases to watch:** What changed? Why does this matter?, The result?, So what happened?, Sound familiar?, Why? Because...

**Problem:** AI asks a question and immediately answers it, which is bad high-school essay rhetoric. A sibling tic uses questions purely to bridge paragraphs instead of transitioning with substance. Lead with the answer; drop the setup.

**Before:**

> What changed? The math did. Why does this matter? Because margins compressed by 40% leave no room for error. So what should teams do? Automate now.

**After:**

> Margins compressed by 40%, which leaves no room for error, so teams should automate now.

### 15. Rule of Three Overuse

**Problem:** LLMs force ideas into groups of three to appear comprehensive.

**Before:**

> The event features keynote sessions, panel discussions, and networking opportunities. Attendees can expect innovation, inspiration, and industry insights.

**After:**

> The event includes talks and panels. There's also time for informal networking between sessions.

### 16. Elegant Variation (Synonym Cycling)

**Problem:** AI has repetition-penalty code causing excessive synonym substitution.

**Before:**

> The protagonist faces many challenges. The main character must overcome obstacles. The central figure eventually triumphs. The hero returns home.

**After:**

> The protagonist faces many challenges but eventually triumphs and returns home.

### 17. False Ranges

**Problem:** LLMs use "from X to Y" constructions where X and Y aren't on a meaningful scale.

**Before:**

> Our journey through the universe has taken us from the singularity of the Big Bang to the grand cosmic web, from the birth and death of stars to the enigmatic dance of dark matter.

**After:**

> The book covers the Big Bang, star formation, and current theories about dark matter.

### 18. Double Adjectives

**Words to watch:** seamless and intuitive, robust and scalable, simple yet powerful, clear and concise, actionable and comprehensive, fast and reliable

**Problem:** AI pairs adjectives compulsively, two or three where one would do, usually near-synonyms joined by "and" or "yet". The pairing adds rhythm but no meaning.

**Before:**

> The platform offers a seamless and intuitive experience backed by robust and scalable infrastructure, delivering insights that are both actionable and comprehensive.

**After:**

> The platform is easy to use and its infrastructure scales [to what load?]. Its reports point to concrete next steps.

### 19. Passive Voice and Subjectless Fragments

**Problem:** LLMs often hide the actor or drop the subject entirely with lines like "No configuration file needed" or "The results are preserved automatically." Rewrite these when active voice makes the sentence clearer and more direct.

**Before:**

> No configuration file needed. The results are preserved automatically.

**After:**

> You do not need a configuration file. The system preserves the results automatically.

## STYLE PATTERNS

### 20. Em Dash Overuse

**Problem:** LLMs use em dashes (—) more than humans, mimicking "punchy" sales writing. In practice, most of these can be rewritten more cleanly with commas, periods, or parentheses.

This is about density. One or two em dashes in a long post are normal, especially in a passage that otherwise reads as human. Fix clusters, dashes used for a dramatic reveal ("It's not a log — it's a foundation"), and dashes in every paragraph.

**Before:**

> The term is primarily promoted by Dutch institutions—not by the people themselves. You don't say "Netherlands, Europe" as an address—yet this mislabeling continues—even in official documents.

**After:**

> The term is primarily promoted by Dutch institutions, not by the people themselves. You don't say "Netherlands, Europe" as an address, yet this mislabeling continues in official documents.

### 21. Overuse of Boldface

**Problem:** AI chatbots emphasize phrases in boldface mechanically.

**Before:**

> It blends **OKRs (Objectives and Key Results)**, **KPIs (Key Performance Indicators)**, and visual strategy tools such as the **Business Model Canvas (BMC)** and **Balanced Scorecard (BSC)**.

**After:**

> It blends OKRs, KPIs, and visual strategy tools like the Business Model Canvas and Balanced Scorecard.

### 22. Inline-Header Vertical Lists

**Problem:** AI outputs lists where items start with bolded headers followed by colons.

**Before:**

> - **User Experience:** The user experience has been significantly improved with a new interface.
> - **Performance:** Performance has been enhanced through optimized algorithms.
> - **Security:** Security has been strengthened with end-to-end encryption.

**After:**

> The update improves the interface, speeds up load times through optimized algorithms, and adds end-to-end encryption.

Keep real lists. Sequential steps, commands and parallel reference items (options, requirements, specs) read better as lists, without the bold label if the item text says what it is. Turn into prose the lists that wrap an argument or a set of claims.

### 23. Title Case in Headings

**Problem:** AI chatbots capitalize all main words in headings.

This applies to body headings. If the site's existing posts use title case, follow the house style. Leave the frontmatter `title` alone unless asked; it is often set for SEO or a style guide.

**Before:**

> ## Strategic Negotiations And Global Partnerships

**After:**

> ## Strategic negotiations and global partnerships

### 24. Marketing Headline Formulas

**Phrases to watch:** Unlock [X], Elevate your [Y], Master [X] in [N] Days, The Ultimate Guide to [X], Everything You Need to Know About [X], From [X] to [Y] (as a subtitle)

**Problem:** AI reaches for a tiny set of content-farm title templates: imperative "unlock/elevate/master" openers, false-range subtitles, and "ultimate guide" constructions. Humans write titles that state the actual content.

**Before:**

> # Unlocking the Power of Data: Master Analytics in 30 Days
>
> ## From Spreadsheets to Strategy: The Ultimate Guide to Business Intelligence

**After:**

> # A 30-day plan for learning business analytics
>
> ## Moving reporting from spreadsheets to a BI tool

### 25. Emojis

**Problem:** AI chatbots often decorate headings or bullet points with emojis.

**Before:**

> 🚀 **Launch Phase:** The product launches in Q3
> 💡 **Key Insight:** Users prefer simplicity
> ✅ **Next Steps:** Schedule follow-up meeting

**After:**

> The product launches in Q3. User research showed a preference for simplicity. Next step: schedule a follow-up meeting.

### 26. Curly Quotation Marks

**Problem:** ChatGPT uses curly quotes (“...”) instead of straight quotes ("...").

**Before:**

> He said “the project is on track” but others disagreed.

**After:**

> He said "the project is on track" but others disagreed.

Match the document's existing convention. Many publishing tools convert straight quotes to curly ones, and edited prose often uses curly quotes on purpose. The tell is mixed usage, or curly quotes in a plain-text or Markdown source where everything else is straight.

## COMMUNICATION PATTERNS

### 27. Collaborative Communication Artifacts

**Words to watch:** I hope this helps, Of course!, Certainly!, You're absolutely right!, Would you like..., let me know, here is a...

**Problem:** Text meant as chatbot correspondence gets pasted as content.

**Before:**

> Here is an overview of the French Revolution. I hope this helps! Let me know if you'd like me to expand on any section.

**After:**

> The French Revolution began in 1789 when financial crisis and food shortages led to widespread unrest.

### 28. Knowledge-Cutoff Disclaimers

**Words to watch:** as of [date], Up to my last training update, While specific details are limited/scarce..., based on available information...

**Problem:** AI disclaimers about incomplete information get left in text.

**Before:**

> While specific details about the company's founding are not extensively documented in readily available sources, it appears to have been established sometime in the 1990s.

**After:**

> The company was founded in the 1990s; the exact year isn't documented.

Keep honest uncertainty in one short clause; cut the disclaimer wrapped around it.

### 29. Sycophantic/Servile Tone

**Problem:** Overly positive, people-pleasing language.

**Before:**

> Great question! You're absolutely right that this is a complex topic. That's an excellent point about the economic factors.

**After:**

> The economic factors you mentioned are relevant here.

## FILLER AND HEDGING

### 30. Filler Phrases

**Before → After:**

- "In order to achieve this goal" → "To achieve this"
- "Due to the fact that it was raining" → "Because it was raining"
- "At this point in time" → "Now"
- "In the event that you need help" → "If you need help"
- "The system has the ability to process" → "The system can process"
- "It is important to note that the data shows" → "The data shows"

### 31. Excessive Hedging

**Problem:** Over-qualifying statements.

**Before:**

> It could potentially possibly be argued that the policy might have some effect on outcomes.

**After:**

> The policy may affect outcomes.

### 32. Generic Positive Conclusions

**Problem:** Vague upbeat endings.

**Before:**

> The future looks bright for the company. Exciting times lie ahead as they continue their journey toward excellence. This represents a major step in the right direction.

**After:**

Cut it. End on the last concrete point in the piece.

### 33. Forced Morals and Aphorism Paragraph Closers

**Phrases to watch:** And that's the point., That's what it's all about., At the end of the day, ..., In the end, [X] is what truly matters., Because that's what leadership is really about.

**Problem:** AI ends paragraphs with tidy little lessons, wrapping every point in an aphorism bow. Real writers land the point and move on. If a paragraph's last sentence could be embroidered on a pillow, cut it.

**Before:**

> The team shipped the migration over a weekend with zero downtime. Because at the end of the day, great engineering isn't about the tools you choose — it's about the people who wield them.

**After:**

> The team shipped the migration over a weekend with zero downtime.

### 34. Persuasive Authority Tropes

**Phrases to watch:** The real question is, at its core, in reality, what really matters, fundamentally, the deeper issue, the heart of the matter

**Problem:** LLMs use these phrases to pretend they are cutting through noise to some deeper truth, when the sentence that follows usually just restates an ordinary point with extra ceremony.

**Before:**

> The real question is whether teams can adapt. At its core, what really matters is organizational readiness.

**After:**

> The question is whether teams can adapt. That mostly depends on whether the organization is ready to change its habits.

### 35. Signposting and Announcements

**Phrases to watch:** Let's dive in, let's explore, let's break this down, here's what you need to know, now let's look at, without further ado

**Problem:** LLMs announce what they are about to do instead of doing it. This meta-commentary slows the writing down and gives it a tutorial-script feel.

**Before:**

> Let's dive into how caching works in Next.js. Here's what you need to know.

**After:**

Delete both sentences. The paragraph that follows them, which explains the caching, becomes the opening.

### 36. Forced Sass and Hot-Take Interjections

**Phrases to watch:** But here's the thing:, Here's the deal:, Then I realized:, Hot take:, And honestly?, The result?, That's the real unlock/challenge/trick

**Problem:** AI manufactures edge with sassy interjections: fake confessions and ta-da phrases that inject synthetic drama, especially in LinkedIn-style posts. Most can be replaced with a plain "but" or nothing at all.

**Before:**

> Everyone recommends daily standups. But here's the thing: ours had become theater. Then I realized nobody wanted to admit it. Hot take? Kill the meeting. And honestly? Nothing broke.

**After:**

> Everyone recommended daily standups, but ours had become theater and nobody wanted to admit it. We killed the meeting. Nothing broke.

### 37. Fragmented Headers

**Signs to watch:** A heading followed by a one-line paragraph that simply restates the heading before the real content begins.

**Problem:** LLMs often add a generic sentence after a heading as a rhetorical warm-up. It usually adds nothing and makes the prose feel padded.

**Before:**

> ## Performance
>
> Speed matters.
>
> When users hit a slow page, they leave.

**After:**

> ## Performance
>
> When users hit a slow page, they leave.

## BLOG STRUCTURE PATTERNS

These show up in whole posts rather than single sentences.

### 38. Table-of-Contents Intros

**Phrases to watch:** In this post/article, we'll explore/cover/walk through, By the end of this post you'll, Here's what we'll cover

**Problem:** The intro lists the sections instead of starting. The headings already do that job.

**Before:**

> In this post, we'll explore what caching is, how to configure it, and why it matters.

**After:** Delete the preview and open with the first real point. If the intro carried a fact or the author's position ("why we believe X"), keep that as a plain sentence. Most posts still need a lead paragraph before the first heading (see BLOG POSTS AND FILES).

### 39. Hook Formulas and Fake Relatability

**Phrases to watch:** Imagine this:, Picture this:, We've all been there., Let's be honest:, Raise your hand if, Ever wondered why

**Problem:** A generic scene or shared experience invented to hook the reader. It is usually not in the source, so it is also a small fabrication.

**Before:**

> Picture this: it's 2 a.m., your pager goes off, and production is down.

**After:** Cut it. If the author's own incident is in the source, open with that instead.

### 40. Audience-Range Openers

**Phrases to watch:** Whether you're a beginner or a seasoned pro, Whether you're a startup or an enterprise, From [small X] to [large Y]

**Problem:** Claims the post is for everyone, which says it is for no one in particular.

**Before:**

> Whether you're a small 3PL or a global carrier, the dashboard has you covered.

**After:**

> The dashboard is built for [who, from the source?]. Or cut the sentence.

### 41. Recap Conclusions and Bolted-On CTAs

**Signs to watch:** a "Conclusion" or "Final thoughts" heading, a closing paragraph that repeats the intro, "Ready to get started? [Link] today!"

**Problem:** The ending restates the post and then shouts a call to action.

**Before:**

> ## Conclusion
> In conclusion, the new API represents a pivotal step forward. Ready to transform your workflow? Sign up today!

**After:**

> To try the new API, [sign up](/signup).

End on the last substantive point. Keep any CTA and link the draft has, written as a plain sentence. Drop a generic "Conclusion" heading when the section shrinks to a line or two.

### 42. Boilerplate Summary Blocks

**Signs to watch:** "Key takeaways", "TL;DR", or "FAQ" blocks that repeat the body in bullet form

**Problem:** Summary blocks bolted on for skimmers or SEO, restating what the reader just read.

**Fix:** If the block only repeats the body, cut it. If it's part of the site's post template (neighbouring posts have it too), keep it and make each item specific. A real FAQ answers questions the body doesn't.

### 43. One-Line Paragraph Stacks

**Problem:** Every sentence gets its own paragraph, LinkedIn-style, so the post scrolls like a slideshow.

**Before:**

> We shipped it.
>
> Nobody noticed.
>
> That was the point.

**After:**

> We shipped it and nobody noticed, which was the point.

A single-sentence paragraph is fine now and then. Several in a row is the pattern.

### 44. Colon and Question Reveals

**Phrases to watch:** Here's how:, Here's why:, The best part?, The answer:, The catch?, The result:

**Problem:** A mini drumroll before an ordinary sentence. Related to #14 and #36.

**Before:**

> Setup takes one command. Here's how: run `npx init`.

**After:**

> Setup takes one command: `npx init`.

### 45. Identical Section Skeletons

**Signs to watch:** every H2 section is the same length and the same shape: a topic sentence, three bullets, then a one-line summary

**Problem:** The template shows through. Real posts spend more words where the subject is harder.

**Fix:** Let section length follow the content. Merge thin sections into their neighbours and drop the summary line that ends each section.

---

## BLOG POSTS AND FILES

### Calibrate before cutting

- **Density, not presence.** One em dash, one list, one rhetorical question or one "crucial" in a long post is normal. Fix clusters and repeated habits. Leave isolated instances alone in passages that already read as human.
- **Leave human passages alone.** Paragraphs with particular details, slightly odd but specific word choices and uneven rhythm were probably written or edited by a person. Change them only to fix a clear tell, and keep their wording otherwise.
- **Match house style.** Check one or two neighbouring posts for quote style, heading case, US/UK spelling, date format and how the company refers to itself. Follow them.
- **Cut padding, not substance.** The rewrite will usually be shorter. Shorter because filler went is good; shorter because facts, steps or caveats went is a loss.
- **Salvage before deleting.** A sentence cut for its pattern (a clichéd intro, a pivot, a recap) sometimes carries a fact, an audience or the author's stated position. Move that into a plain sentence elsewhere instead of losing it. An opinion the author states, even in hype wording, stays as the author's opinion, toned down.
- **Keep a lead.** Blog posts usually open with a short paragraph before the first heading. If cutting the intro leaves none, write one or two plain sentences from material already in the post: for an announcement, what it is and who it's for; for a tutorial, what the reader will have done by the end; for an opinion piece, the author's claim. Restate what the post says; don't infer a new benefit or claim from it, and don't repeat the first section's opening sentence.

### Preserve the markup

When editing a post file (Markdown, MDX, HTML):

- **Frontmatter:** never change `slug`, `date`, IDs, tags or other machine fields. Suggest changes to `title` or `excerpt` in your notes rather than editing them, unless asked.
- **Components and code:** keep MDX/JSX components, their props, code blocks and inline code exactly as they are. Text inside a component's children can be edited like prose.
- **Links:** keep every link target. Link text can change.
- **Headings:** a heading's text sets its anchor. Before renaming one, search the site for links to that anchor (`#getting-started`); leave it if anything links there. Generic headings ("Conclusion", "Introduction") are safe to drop or rename.
- **SEO terms:** where the post's main keyword phrase appears in the title, first paragraph or headings, keep it there.

---

## Process

1. Read the input text carefully
2. Decide the content type and pick the base persona; note any sections that shift (REGISTER AND PERSONA). For a post file, glance at a neighbouring post for house style
3. Identify all instances of the patterns above, weighing density (BLOG POSTS AND FILES)
4. Rewrite each problematic section
5. Ensure the revised text:
   - Sounds natural when read aloud
   - Varies sentence structure naturally
   - Uses specific details over vague claims, but only details the source or user supplied (see Never Invent Facts)
   - Fits its persona, with one consistent author across sections
   - Adds no opinion, anecdote, feeling or example the source lacks; the persona only changed how things are said
   - Keeps frontmatter, components, code, link targets and linked headings intact
   - Uses simple constructions (is/are/has) where appropriate
6. Present a draft humanized version
7. Prompt: "What makes the below so obviously AI generated?"
8. Answer briefly with the remaining tells (if any). Also check every name, number, date, quote and source against the original; anything not in it gets cut or marked
9. Prompt: "Now make it not obviously AI generated."
10. Present the final version (revised after the audit)

## Output Format

**For pasted text up to a few paragraphs**, provide:

1. The persona used, in one line (and any section shifts)
2. Draft rewrite
3. "What makes the below so obviously AI generated?" (brief bullets)
4. Final rewrite
5. A brief summary of changes made (optional, if helpful)

**For a file or a full post**, don't print three copies of it. Do the draft and audit passes internally, then:

1. Edit the file in place (or give the final version once, if there is no file)
2. Report the persona and section shifts in one line
3. List the main tells found and fixed, grouped by pattern number
4. List every bracketed gap you left for the author, and any suggested `title`/`excerpt` changes
5. Note anything you deliberately left alone (a human passage, a house-style convention, a linked heading)

## Blog Example: Persona Per Section

**Before (a launch post with a setup section and a backstory section):**

> ## Introducing Tidepool
>
> We're thrilled to announce Tidepool, a groundbreaking tool that empowers teams to seamlessly manage feature flags. It's not just a toggle — it's a whole new way to ship.
>
> ## Setting up
>
> Getting started is a breeze! First, you'll want to install the SDK. Next, it's important to note that you'll need an API key from the dashboard. Finally, simply wrap your feature in `flag()`.
>
> ## Why we built it
>
> Our team had been burned by half-finished features leaking into production. We tried three vendors and none of them let us roll back a flag per region. So we built one that does.

**Base persona:** Reporter (an "Introducing" title). **Shifts:** "Setting up" goes Explainer; "Why we built it" goes Storyteller and is already human, so it barely changes. Author stays "we" with contractions throughout.

**After:**

> ## Introducing Tidepool
>
> Tidepool is a feature-flag tool for teams. You can roll back a flag in one region without touching the others.
>
> ## Setting up
>
> 1. Install the SDK.
> 2. Get an API key from the dashboard.
> 3. Wrap the feature in `flag()`.
>
> ## Why we built it
>
> We'd been burned by half-finished features leaking into production. We tried three vendors and none of them let us roll back a flag per region, so we built one that does.

The per-region rollback in the intro comes from the backstory section, not from outside the post. Nothing was added: no customer quote, no adoption number, no "we've all been there".

## Full Example

**Before (AI-sounding):**

> Great question! Here is an essay on this topic. I hope this helps!
>
> AI-assisted coding serves as an enduring testament to the transformative potential of large language models, marking a pivotal moment in the evolution of software development. In today's rapidly evolving technological landscape, these groundbreaking tools—nestled at the intersection of research and practice—are reshaping how engineers ideate, iterate, and deliver, underscoring their vital role in modern workflows.
>
> At its core, the value proposition is clear: streamlining processes, enhancing collaboration, and fostering alignment. It's not just about autocomplete; it's about unlocking creativity at scale, ensuring that organizations can remain agile while delivering seamless, intuitive, and powerful experiences to users. The tool serves as a catalyst. The assistant functions as a partner. The system stands as a foundation for innovation.
>
> Industry observers have noted that adoption has accelerated from hobbyist experiments to enterprise-wide rollouts, from solo developers to cross-functional teams. The technology has been featured in The New York Times, Wired, and The Verge. Additionally, the ability to generate documentation, tests, and refactors showcases how AI can contribute to better outcomes, highlighting the intricate interplay between automation and human judgment.
>
> - 💡 **Speed:** Code generation is significantly faster, reducing friction and empowering developers.
> - 🚀 **Quality:** Output quality has been enhanced through improved training, contributing to higher standards.
> - ✅ **Adoption:** Usage continues to grow, reflecting broader industry trends.
>
> While specific details are limited based on available information, it could potentially be argued that these tools might have some positive effect. Despite challenges typical of emerging technologies—including hallucinations, bias, and accountability—the ecosystem continues to thrive. In order to fully realize this potential, teams must align with best practices.
>
> In conclusion, the future looks bright. Exciting times lie ahead as we continue this journey toward excellence. Let me know if you’d like me to expand on any section!

**Draft rewrite:**

> AI coding assistants can generate documentation, tests, and refactors, and they generate code significantly faster. Adoption has grown from individual developers to company-wide rollouts, and the tools have been covered by The New York Times, Wired, and The Verge.
>
> They also have well-known problems: hallucinations, bias, and unclear accountability. Teams that adopt them should follow best practices to get the most out of them.

**What makes the below so obviously AI generated?**

- "Significantly faster" is still a vague claim with no figure behind it, and the original gives none.
- The list of outlets is notability padding (#2): it names them without saying what any of them reported.
- The last sentence is a generic closer that could end any article, and "best practices" says nothing.
- Every claim is in the original; nothing was added. Keep it that way.

**Now make it not obviously AI generated.**

> AI coding assistants write documentation, tests, and refactors, and they produce code faster than a person typing [how much faster? source?]. Individual developers picked them up first; whole companies use them now.
>
> They also hallucinate, they can reproduce bias from their training data, and when generated code is wrong it isn't always clear who is accountable.

**Changes made:**

- Removed chatbot artifacts ("Great question!", "I hope this helps!", "Let me know if...")
- Removed significance inflation ("testament", "pivotal moment", "evolving landscape", "vital role")
- Removed promotional language ("groundbreaking", "nestled", "seamless, intuitive, and powerful")
- Removed vague attributions ("Industry observers")
- Removed superficial -ing phrases ("underscoring", "highlighting", "reflecting", "contributing to")
- Removed negative parallelism ("It's not just X; it's Y")
- Removed rule-of-three patterns and synonym cycling ("catalyst/partner/foundation")
- Removed false ranges ("from X to Y, from A to B")
- Removed em dashes, emojis, boldface headers, and curly quotes
- Removed copula avoidance ("serves as", "functions as", "stands as") in favor of "is"/"are"
- Removed formulaic challenges section ("Despite challenges... continues to thrive")
- Removed knowledge-cutoff hedging ("While specific details are limited...")
- Removed excessive hedging ("could potentially be argued that... might have some")
- Removed filler phrases and persuasive framing ("In order to", "At its core")
- Removed generic positive conclusion ("the future looks bright", "exciting times lie ahead")
- Removed the outlet list (notability padding) and the "best practices" closer
- Kept every claim from the original and invented none; marked the unsourced speed claim for the author instead of making up a number
- Kept a neutral register: the original is an expository essay with no author opinions to restore

## Reference

This skill is based on [Wikipedia:Signs of AI writing](https://en.wikipedia.org/wiki/Wikipedia:Signs_of_AI_writing), maintained by WikiProject AI Cleanup. The patterns documented there come from observations of thousands of instances of AI-generated text on Wikipedia.

Additional patterns are drawn from recent practitioner and journalism detection guides:

- Charlie Fink, ["The Seven Deadly Tells Of AI Writing"](https://www.forbes.com/sites/charliefink/2025/06/12/the-seven-tells-of-ai-writing/) (Forbes) — rhetorical self-answered questions, inspirational pivots, fabricated quotes
- Thomas Cox, ["How to spot when writing is AI"](https://huntingthemuse.net/library/how-to-tell-if-writing-is-ai) (Hunting the Muse) — forced sass, clichéd openings, headline formulas, "No X. No Y. Just Z."
- Henk van Ess, ["Reporter's Guide to Detecting AI-Generated Content"](https://gijn.org/resource/guide-detecting-ai-generated-content/) (GIJN) — verification-first detection; fabricated sources as objective, checkable evidence
- Akepa, ["How to detect AI generated content"](https://thesustainableagency.com/blog/how-to-detect-ai-generated-content/) (The Sustainable Agency) — double adjectives, paragraph-linking questions, forced morals

Key insight from Wikipedia: "LLMs use statistical algorithms to guess what should come next. The result tends toward the most statistically likely result that applies to the widest variety of cases."
