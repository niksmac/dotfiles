# Slop pattern catalog

Every pattern has a stable ID that audit reports cite (`T1`, `W3`) and that
`scripts/slop_scan.py` prints. Each entry gives:

- **Signal**: how strongly the pattern points to slop on its own.
  - **hard**: one clear sighting is a finding. A careful writer almost never does this on purpose.
  - **strong**: a finding on one sighting, after you check the context and the guards.
  - **weak**: report it only in a cluster (two or more other tells in the same paragraph) or above the density threshold given. Alone, it is normal writing.
- **Watch**: phrases and shapes to look for. These are examples of the shape, not a complete list.
- **Fix**: what to do with the span.
- **Don't flag**: the false positives.

The families follow the slop taxonomy of Shaib et al. (2025): information
problems (I) matter most to readers, then leftovers (R), then style: inflation
(S), staging (T), words (W), rhythm and structure (Y) and formatting (F).
In that study, expert annotators agreed more on *which spans* were bad than
on any single word list, and density, relevance and tone predicted their
judgments best. Read for those first. Word lists come last.

---

## I. Information: what the text says

These are the costliest problems. A scanner can't find most of them; you find
them by reading. Check every piece for I1 to I4 even when the style looks clean.

### I1 Invented or unsourced specifics · hard

**Watch:** precise numbers with no source ("3x more", "22 times more memorable", "40% of teams"); quotes attributed to famous people; named studies, surveys or reports; "[Name] once said"; dates, versions or prices that the surrounding material doesn't support.

**Why:** LLMs produce plausible specifics. Style tells are cosmetic, but a fabricated fact is a credibility failure, and one a reader can check.

**Fix:** if the user supplied the source, cite it plainly. Otherwise cut the specific and keep the plain claim, or mark it: `[source?]`, `[how much faster?]`. Never swap one unsourced number for another. Where you can verify (a quote's real author, a study's existence), say what you checked.

> **Before:** "AI is the new electricity," said Musk. Studies show that storytelling is 22 times more memorable than facts.
>
> **After:** Andrew Ng has called AI "the new electricity." Stories are easier to remember than lists of numbers [source?].

Checking the quote showed it was Ng's, not Musk's. The "22 times" figure had no traceable source.

**Don't flag:** numbers from the author's own data, a linked source or the surrounding text.

### I2 Vague attribution and borrowed authority · strong

**Watch:** Studies show, Research suggests, Experts agree/argue/believe, Industry reports, Observers have noted, Analysts predict, widely regarded as, many believe, according to insiders, several publications (when few are cited); lists of outlets a subject was "featured in"; "active social media presence", "over N followers".

**Why:** the claim borrows authority it hasn't earned. The reader can't check it.

**Fix:** name the source and what it said, or drop the attribution and own the claim, or cut it. Name one outlet and what it reported rather than listing five.

> **Before:** Experts believe the Haolai River plays a crucial role in the regional ecosystem.
>
> **After:** Researchers and conservationists study the Haolai River. [Who says it's crucial, and on what evidence?]

> **Before:** Her views have been cited in The New York Times, BBC, Financial Times, and The Hindu.
>
> **After:** In a [year] New York Times interview, she argued that [her position, from the source].

**Don't flag:** a missing citation alone, in informal writing that makes no research claim.

### I3 Low density: generic, portable sentences · strong

**Watch:** sentences that could move unchanged into another company's post, another product's page or another topic's essay. "Communication is key to success." "Teams need the right tools to thrive." "Quality matters." Paragraphs that use many words to say one thing.

**Why:** this is the strongest predictor of human slop judgments in the research: verbose text with little information. The reader pays attention and gets nothing.

**Test (portability):** could this sentence appear unchanged on a competitor's site, or in an article about a different subject? If yes, it carries no information.

**Fix:** cut it, or replace it with the specific fact it gestures at, if the source has one. Don't invent one; mark the gap.

> **Before:** In order to succeed in today's market, businesses need solutions that deliver real value to their customers.
>
> **After:** (cut; the next paragraph, which names the actual problem, becomes the opening)

### I4 Off the point: relevance drift · strong

**Watch:** an answer to a different question than the one asked; paragraphs about the topic's general importance instead of the reader's task; a "how do I improve my marathon time?" piece that explains the benefits of exercise; a post where you can't state the core point in one sentence.

**Why:** relevance was one of the top predictors of slop labels in the research, and no automatic metric catches it.

**Fix:** name the reader's actual question or the piece's actual point, then cut or move what doesn't serve it. If you can't find a point, report that as the main finding; no line edit fixes it.

### I5 Overclaim and false certainty · strong

**Watch:** universally beneficial, everyone knows, without a doubt, the only way, guaranteed, never been easier, always/never/all/none where the evidence covers some; outcomes stated as fact with no basis ("Faster releases, fewer incidents, and happier teams").

**Why:** confident claims with no support read as sales copy and mislead.

**Fix:** scope the claim to what the source supports ("in our tests", "for most small teams") or mark it `[measured how?]`.

**Don't flag:** absolutes that define requirements: "never commit secrets", "all inputs must be validated". Keep "must", "never" and "all" exactly where they set a rule.

### I6 Flattened stance · strong

**Watch:** an opinion piece with no opinion; "there are pros and cons" with no verdict where the author clearly has one; both-sides mush; hedging every claim so nothing could be disagreed with; an author's view rewritten as neutral reporting; detachment where engagement is expected (a personal travel post written like an encyclopedia).

**Why:** the research codes this as bias in the other direction: text too "objective" when a point of view is called for. A reader can't disagree with anything, so they have nothing to take away.

**Fix:** if the source states a view, put it plainly as the author's. If the author's notes show they haven't decided, keep the uncertainty in one honest sentence. Never supply an opinion the source doesn't hold; mark `[your view?]` instead.

### I7 Re-explaining what the reader knows · strong

**Watch:** a reply that restates the problem, walks through the diagnosis and justifies the plan before reaching the decision; an email that recaps the thread; a PR description that re-describes the ticket.

**Fix:** lead with the decision or answer. Keep only the reasoning that would change the reader's agreement.

### I8 Coherence breaks · strong

**Watch:** sentences that don't follow from each other; a paragraph that drifts between unrelated points; a conclusion that contradicts the body; a list item that doesn't belong to its list; the same claim stated two incompatible ways.

**Fix:** reorder, add the missing link the source supports, or cut the stray sentence. Resolve contradictions from the source; if the source doesn't settle it, flag it for the author.

---

## R. Residue: leftovers from the chat and the draft

### R1 Chatbot residue · hard

**Watch:** I hope this helps, Of course!, Certainly!, Absolutely!, Great question!, You're absolutely right, Would you like me to..., Want me to...?, Should I continue?, let me know if, happy to help, Here is a revised version, as an AI.

**Fix:** delete. Keep the content around it.

> **Before:** Here is an overview of the French Revolution. I hope this helps! Let me know if you'd like me to expand on any section.
>
> **After:** The French Revolution began in 1789 when financial crisis and food shortages led to widespread unrest.

**Don't flag:** salutations and sign-offs in real letters, emails or comments ("Let me know if Thursday works").

### R2 Knowledge-limit disclaimers and guesses · hard

**Watch:** as of my last training update, while specific details are limited, based on available information, not widely documented, in the provided sources, maintains a low profile, it is believed that, likely grew up/studied/began.

**Fix:** keep honest uncertainty in one short clause; cut the disclaimer around it. Cut speculative "likely" biography.

> **Before:** While specific details about the company's founding are not extensively documented in readily available sources, it appears to have been established sometime in the 1990s.
>
> **After:** The company was founded in the 1990s; the exact year isn't documented.

### R3 Placeholders and reasoning leaks · hard

**Watch:** `[Company Name]`, `[Insert statistic]`, `[YOUR PRODUCT]`, lorem ipsum, "Let me think step by step", "Here's my thought process", a visible outline or draft note.

**Fix:** fill from the source or ask the author. Never fill a placeholder with an invented value.

**Don't flag:** gap markers this skill adds on purpose (`[source?]`), or brackets that are links, footnotes or code.

### R4 Writing about the document · strong

**Watch:** "The table below compares...", "This section is organized by owner", "was added to replace", "compiled from the provided sources", "anything unconfirmed is flagged rather than guessed".

**Fix:** delete the description and let the table, section or note speak. Keep a caption only if the reader needs it to read the table.

---

## S. Inflation: making things sound bigger

### S1 Significance and legacy puffery · strong

**Watch:** stands/serves as, is a testament/reminder, a vital/significant/crucial/pivotal/key role/moment, underscores/highlights its importance, reflects broader, symbolizing its enduring/lasting, setting the stage for, marking/shaping the, represents/marks a shift, key turning point, evolving landscape, focal point, indelible mark, deeply rooted, rich tapestry, speaks volumes, paves the way, game changer, this changes everything, raises the bar, at the forefront of, cornerstone of, sheds light on, paradigm shift, new era.

**Fix:** keep the fact, drop the significance.

> **Before:** The Statistical Institute of Catalonia was officially established in 1989, marking a pivotal moment in the evolution of regional statistics in Spain.
>
> **After:** The Statistical Institute of Catalonia was established in 1989.

### S2 Notability name-dropping · strong

Covered with I2 when it's attribution. Flag separately when the text lists coverage, awards or follower counts to prove importance ("featured in Forbes, TechCrunch and Wired").

**Fix:** say what one source reported, or cut the list.

### S3 Shallow -ing tails · strong

**Watch:** a sentence that ends in `, highlighting / underscoring / emphasizing / ensuring / reflecting / symbolizing / contributing to / cultivating / fostering / encompassing / showcasing / empowering / paving the way ...`.

**Why:** the participle tacks on fake analysis. It claims a consequence without showing it.

**Fix:** cut the tail, or turn it into its own sentence with a concrete consequence from the source.

> **Before:** The temple's colors of blue, green, and gold resonate with the region's natural beauty, symbolizing Texas bluebonnets and the Gulf of Mexico, reflecting the community's deep connection to the land.
>
> **After:** The temple is painted blue, green, and gold, colors meant to evoke Texas bluebonnets and the Gulf of Mexico [according to whom?].

### S4 Promotional and hype language · strong

**Watch:** boasts a, vibrant, rich (figurative), profound, nestled, in the heart of, groundbreaking, renowned, breathtaking, must-visit, stunning, game-changing, revolutionize, cutting-edge, next-level, supercharge, world-class, best-in-class, state-of-the-art, seamless, unparalleled, transformative, hidden gem, bustling, picturesque.

**Fix:** state what the thing is or does in plain words.

> **Before:** Nestled within the breathtaking region of Gonder in Ethiopia, Alamata Raya Kobo stands as a vibrant town with a rich cultural heritage and stunning natural beauty.
>
> **After:** Alamata Raya Kobo is a town in the Gonder region of Ethiopia.

**Don't flag:** marketing copy where the brand voice is deliberately enthusiastic and the claim is true and specific. Flag only the hollow superlatives.

### S5 Challenges-and-outlook formula · strong

**Watch:** "Despite its... faces several challenges...", "Despite these challenges, ... continues to thrive", headings like "Challenges and Legacy", "Future Outlook", "Future Prospects".

**Fix:** state the problems plainly, without the redemptive turn.

> **Before:** Despite its industrial prosperity, Korattur faces challenges typical of urban areas, including traffic congestion and water scarcity. Despite these challenges, Korattur continues to thrive as an integral part of Chennai's growth.
>
> **After:** Korattur, an industrial area of Chennai, has problems with traffic congestion and water scarcity.

### S6 Artificial enthusiasm and false warmth · strong

**Watch:** We're thrilled/excited/delighted to announce, exciting developments, incredible opportunity, fascinating case study; warm corporate closers ("We can't wait to see what you build!"); warmth that appears with no basis in the content.

**Fix:** lead with the news. Keep a feeling only if the author states one and it adds something.

> **Before:** We're thrilled to announce Tidepool, a groundbreaking tool that empowers teams to seamlessly manage feature flags.
>
> **After:** Tidepool is a feature-flag tool for teams.

---

## T. Staging: performing a point instead of making it

### T1 Not X but Y · strong (hard when used as a dash reveal)

**Watch:** not just/only/merely X, but Y; It's not X, it's Y; X isn't Y — it's Z; This does not mean X. It means Y.; Not because X. Because Y.; The question isn't X. It's Y.; clipped tails like "..., no guessing".

**Why:** it argues against a claim nobody made in order to make Y sound like a revelation.

**Fix:** state Y directly. Then check whether Y still holds on its own; often it doesn't, and the sentence goes.

> **Before:** It's not just about the beat riding under the vocals; it's part of the aggression and atmosphere.
>
> **After:** The heavy beat adds to the aggressive tone.

> **Before (tailing negation):** The options come from the selected item, no guessing.
>
> **After:** The options come from the selected item, so the user doesn't have to guess.

**Don't flag:** real corrections and disambiguation: "Use pnpm, not npm." "The painting is real, not a forgery." "This is a warning, not an error."

### T2 Negative listing: "No X. No Y. Just Z." · hard

**Watch:** No fluff. No filler. Just results. / Not for vanity metrics. Not for the algorithm. For you. / Not a tool. Not a platform. A partner.

**Fix:** one plain sentence saying what it is.

> **Before:** No fluff. No filler. Just results.
>
> **After:** The guide skips theory and goes straight to working code.

### T3 Arguing with no one · strong

**Watch:** I'm not saying..., Don't get me wrong, To be clear, This is not to say, Some might say... but, You might think..., One might be tempted to, A tempting approach would be, It would be easy to just... Several pre-emptive rebuttals in a row is a stronger sign.

**Fix:** cut the imagined objection and make the point. Keep a rebuttal only when a real, named position exists.

### T4 Rhetorical question asked and answered · strong

**Watch:** What changed? The math did. / Why does this matter? Because... / So what should teams do? / Sound familiar? / questions used only to bridge paragraphs.

**Fix:** lead with the answer; drop the setup.

> **Before:** What changed? The math did. Why does this matter? Because margins compressed by 40% leave no room for error.
>
> **After:** Margins compressed by 40%, which leaves no room for error.

**Don't flag:** one genuine question the author wants the reader to consider, or a FAQ.

### T5 Colon and question reveals · strong

**Watch:** Here's how:, Here's why:, The best part?, The catch?, The result:, The answer:, The kicker:, Plot twist:, Think about it:, The bottom line:

**Fix:** write the sentence plainly. Colons are for lists, labels and quotations.

> **Before:** Setup takes one command. Here's how: run `npx init`.
>
> **After:** Setup takes one command: `npx init`.

### T6 Signposting and throat-clearing · strong

**Watch:** Let's dive in, let's explore, let's break this down, here's what you need to know, now let's look at, without further ado, Here's the thing, Here's the deal, The truth is, The uncomfortable truth is, Let me be clear, I'll be honest, Let's be honest, Real talk, Look, The thing is, heads up, quick note.

**Fix:** delete the run-up. The sentence after it is the point.

> **Before:** Let's dive into how caching works in Next.js. Here's what you need to know.
>
> **After:** (delete both; the explanation that follows becomes the opening)

**Don't flag:** "honestly" or "look" inside a casual sentence where it carries tone.

### T7 Faux-insight setups · strong

**Watch:** This is the part most people skip, What most people get wrong, Here's what nobody tells you, The part everyone misses, Most people don't realize.

**Fix:** cut the setup and state the insight. If the "insight" is ordinary once stated plainly, the sentence may go too.

### T8 Forced sass and emphasis crutches · strong

**Watch:** Hot take:, And honestly?, Then I realized:, Let that sink in., Read that again., Full stop., Make no mistake, This cannot be overstated., The stakes are real., every. single. day., ALL CAPS for emphasis.

**Fix:** delete. Most can become a plain "but" or nothing.

> **Before:** Everyone recommends daily standups. But here's the thing: ours had become theater. Hot take? Kill the meeting. And honestly? Nothing broke.
>
> **After:** Everyone recommended daily standups, but ours had become theater. We killed the meeting. Nothing broke.

### T9 Deep-sounding sayings · strong

**Watch:** the real question is, at its core, in reality, what really matters, fundamentally, the deeper issue, the heart of the matter; "X is the Y of Z"; "X is not a tool but a mirror"; "the currency/language/architecture of trust".

**Fix:** say the ordinary point plainly. If nothing is left, cut it.

> **Before:** The real question is whether teams can adapt. At its core, what really matters is organizational readiness.
>
> **After:** The question is whether teams can adapt, which depends on whether the organization will change its habits.

### T10 Inspirational pivot · strong

**Watch:** This isn't just about X. It's about Y.; At the end of the day, it's really about...; It's bigger than [topic]; a zoom from an ordinary subject to trust, humanity, legacy or "what really matters".

**Fix:** stay on the subject.

> **Before:** This isn't just about payment processing fees. It's about trust.
>
> **After:** The new processor charges lower fees per transaction [how much lower?].

### T11 Kickers: aphorism paragraph closers · strong

**Watch:** And that's the point., That's what it's all about., At the end of the day, ..., In the end, X is what truly matters., Because that's what leadership is really about. Any closing line that could be embroidered on a pillow.

**Fix:** delete the kicker. **Don't rewrite it into a better aphorism.** End on the last concrete sentence.

> **Before:** The team shipped the migration over a weekend with zero downtime. Because at the end of the day, great engineering isn't about tools, it's about people.
>
> **After:** The team shipped the migration over a weekend with zero downtime.

### T12 Interpretive metadiscourse · strong

**Watch:** This distinction matters., That last part matters more than it sounds., The key point is, As you can see, It's worth noting that, It's important to note that, It should be noted, Needless to say, It goes without saying, In other words (when nothing needed restating).

**Fix:** delete the label. If the point is important, the reader will see it; if they won't, show why instead of saying so.

### T13 Hook formulas and fake relatability · strong

**Watch:** Picture this:, Imagine this:, We've all been there., Raise your hand if, Ever wondered why, What if I told you.

**Why:** a generic scene invented to hook the reader. It usually isn't in the source, so it's also a small fabrication.

**Fix:** cut. If the author's own incident is in the source, open with that.

> **Before:** Picture this: it's 2 a.m., your pager goes off, and production is down.
>
> **After:** (cut, or open with the author's real incident if the source has one)

### T14 Audience-range openers · strong

**Watch:** Whether you're a beginner or a seasoned pro, Whether you're a startup or an enterprise, From small teams to global brands.

**Fix:** name who it's for, from the source, or cut the sentence. `[who is this for?]`

### T15 Clichéd openings · hard

**Watch:** In today's fast-paced digital landscape, In the dynamic world of, As the world continues to evolve, In an era defined by, In today's world, It's no secret that, Now more than ever. Any opening that would work in front of any article.

**Test:** swap the subject. If the intro still works, it says nothing.

**Fix:** delete. Open with the first concrete fact; if there is none, ask the author for one.

### T16 False ranges · strong

**Watch:** "from X to Y" where X and Y aren't on a scale: from the Big Bang to the cosmic web, from hobbyists to enterprises, from the birth of stars to the dance of dark matter. Doubled ranges are a stronger sign.

**Fix:** list the actual items, or name the actual span.

> **Before:** Our journey has taken us from the singularity of the Big Bang to the grand cosmic web, from the birth and death of stars to the enigmatic dance of dark matter.
>
> **After:** The book covers the Big Bang, star formation, and current theories about dark matter.

### T17 Slogan cadence and anthropomorphized tools · weak

**Watch:** runs of two-beat imperative lines ("Ship faster. Sleep better."); tools that want, decide, hunt or defend themselves ("The suite defends itself."). Flag at three or more slogan lines in one piece.

**Fix:** say what the tool does, with a person as the subject where there is one.

---

## W. Words

### W1 AI vocabulary · strong list / weak list

**Strong list (flag wherever it appears, unless literal):** delve, tapestry, testament, multifaceted, meticulous(ly), intricate/intricacies, interplay, underscore (verb), garner, paramount, pivotal, realm, beacon, embark, elevate, empower, bolster, burgeoning, ever-evolving, showcase, foster, resonate with, synergy, deep dive.

**Weak list (flag in clusters, or more than about 5 per 1,000 words):** crucial, vital, landscape (abstract), leverage, robust (figurative), seamless, navigate (figurative), journey (figurative), enhance, streamline, facilitate, harness, comprehensive, holistic, dynamic, innovative, nuanced, myriad, plethora, moreover, furthermore, additionally, ecosystem, quietly, vibrant, valuable, enduring, profound, unlock, align with, actionable, scalable, key (adjective).

**Why:** these words rose sharply in text after 2023 and cluster together. The list ages: re-check it against current output every few months.

**Fix:** use the plain word, or the specific thing the word stands in for ("robust" becomes the load it handles). Don't swap one tell for another ("delve into" becomes "look at", not "dig into" or "unpack").

> **Before:** Additionally, a distinctive feature of Somali cuisine is the incorporation of camel meat. An enduring testament to Italian colonial influence is the widespread adoption of pasta in the local culinary landscape.
>
> **After:** Somali cuisine also includes camel meat. Pasta, introduced during Italian colonial rule, is now common.

**Don't flag:** literal and technical uses: robust statistics, a landscape painting, navigate a website, a gated CI step, an ecosystem in biology, a key in a map or lock, "unlock" a phone.

### W2 Business jargon and stock idioms · weak

**Watch:** move the needle, low-hanging fruit, circle back, touch base, stay ahead of the curve, secret sauce, recipe for disaster, ship with confidence, peace of mind, best practices, take it to the next level, drive growth/value, unlock value/potential, thought leadership, value proposition, end-to-end solution.

**Fix:** say the concrete thing. "Best practices" means: which practices?

### W3 Copula avoidance · strong

**Watch:** serves as, stands as, functions as, operates as, acts as, marks, represents [a], boasts, features, offers, maintains [a].

**Fix:** use is, are, has.

> **Before:** Gallery 825 serves as LAAA's exhibition space for contemporary art. The gallery features four separate spaces and boasts over 3,000 square feet.
>
> **After:** Gallery 825 is LAAA's exhibition space for contemporary art. It has four rooms and more than 3,000 square feet.

**Don't flag:** literal roles ("she serves as treasurer"), "features" as a noun.

### W4 Empty intensifiers · weak

**Watch:** truly, deeply, fundamentally, inherently, incredibly, literally, essentially, genuinely, undeniably, remarkably, really, very, simply, just.

**Fix:** delete, unless the word carries emphasis, contrast, uncertainty or spoken rhythm the author wants.

### W5 Filler phrases · weak

- "In order to achieve this goal" → "To achieve this"
- "Due to the fact that it was raining" → "Because it was raining"
- "At this point in time" → "Now"
- "In the event that you need help" → "If you need help"
- "The system has the ability to process" → "The system can process"
- "When it comes to pricing, ..." → "Pricing ..."
- "In terms of performance" → name the measure
- "A wide range of" → the actual range, or cut

### W6 Stacked and opening hedges · weak (opening hedges strong)

**Watch (stacked):** could potentially, might possibly, may arguably, it could be argued that, in some cases it may, to some extent, generally speaking, for the most part, in many cases.

**Watch (opening, strong):** It should be noted that..., It's worth mentioning that..., Of course, ..., Naturally, ...

**Fix:** one hedge where the author is really unsure, stated specifically ("we haven't tested this above 10k users"); none where the claim should just be a claim.

> **Before:** It could potentially possibly be argued that the policy might have some effect on outcomes.
>
> **After:** The policy may affect outcomes.

**Don't flag:** single ordinary hedges ("perhaps", "tends to", "I think", "maybe") that express real uncertainty. Safety and legal guards are content: "may cause drowsiness", "does not establish causation".

### W7 Vague connection · weak

**Watch:** associated with, in association with, connected to, linked to, tied to (when the relationship is known).

**Fix:** name the relationship: founded, funded, caused, owns, reports to.

**Don't flag:** literal links (files linked to a path, a URL linked to a page).

### W8 Register mismatch · strong

**Watch:** words at the wrong level for the piece: aforementioned, henceforth, whereby, therein, pertaining to, utilize, in lieu of in a casual post; academic jargon in a gardening article ("phenolic compounds", "pathogenic microorganism colonization"); stiff phrasing that is grammatical but nobody says ("the earthen area that formerly held the puddle").

**Fix:** the word the reader would use. "Utilize" → "use". "The aforementioned beverage" → "the coffee".

**Don't flag:** terms of art in technical, legal or scientific text written for specialists.

### W9 Synonym cycling (elegant variation) · strong

**Watch:** the same referent renamed in consecutive sentences: the protagonist / the main character / the central figure / the hero; the tool / the platform / the solution / the system.

**Fix:** pick the clear word and repeat it, or use a pronoun.

> **Before:** The protagonist faces many challenges. The main character must overcome obstacles. The central figure eventually triumphs.
>
> **After:** The protagonist faces many challenges but eventually triumphs.

### W10 Double adjectives · weak

**Watch:** seamless and intuitive, robust and scalable, simple yet powerful, clear and concise, fast and reliable, actionable and comprehensive.

**Fix:** keep the one that's true and specific, or replace both with the fact.

> **Before:** The platform offers a seamless and intuitive experience backed by robust and scalable infrastructure.
>
> **After:** The platform is easy to use and its infrastructure scales [to what load?].

### W11 Hyphenated pairs after the noun · weak

**Watch:** "the data is high-quality", "the approach is long-term", "it's well-documented" stacked through a passage.

**Fix:** hyphen before the noun ("a well-known author"), none after ("the author is well known"). Dictionary compounds ("third-party") keep theirs.

---

## Y. Rhythm and structure

### Y1 Rule of three · weak

**Watch:** ideas forced into threes: three adjectives, three benefits, three short sentences, three facts plus a lesson. Flag the padded ones: abstract nouns ("innovation, inspiration, and insight"), or a third item weaker than the first two. A real list of three things is normal.

**Fix:** keep the items that carry weight; two is fine.

> **Before:** The event features keynote sessions, panel discussions, and networking opportunities. Attendees can expect innovation, inspiration, and industry insights.
>
> **After:** The event includes talks and panels, with time for informal networking between sessions.

### Y2 Uniform sentence length and shape · weak

**Watch:** ten or more sentences in a row of nearly the same length and structure (subject, verb, object, clause). The scanner flags a standard deviation under about 5 words.

**Fix:** vary by meaning: a short sentence for a point the author stands behind, a longer one where an idea needs room. Don't manufacture "punchy" fragments to fake variety.

### Y3 Repeated sentence openings · strong (three in a row)

**Watch:** She noted... She added... She filed...; It is... It has... It offers...

**Fix:** merge sentences or change the subject. Keep deliberate anaphora ("We shall fight on the beaches, we shall fight...").

### Y4 Staccato: one-line paragraph stacks and dramatic fragments · strong

**Watch:** three or more one-sentence paragraphs in a row (LinkedIn style); runs of fragments ("X. And Y. And Z."); "[Noun]. That's it. That's the [thing]."

**Fix:** join them into a paragraph that reads naturally.

> **Before:** We shipped it.
>
> Nobody noticed.
>
> That was the point.
>
> **After:** We shipped it and nobody noticed, which was the point.

**Don't flag:** a single one-line paragraph now and then; social copy where the platform convention calls for short lines (flag only the run).

### Y5 Template skeletons · strong

**Watch:** every H2 section the same length and shape (topic sentence, three bullets, one-line summary); every paragraph running statement, explanation, example, bridge; symmetric sections of about 300 words each; each section ending with a summary sentence.

**Fix:** let length follow difficulty. Merge thin sections, drop the closing summary line of each section, cut bullets that wrap an argument.

### Y6 Heading restated · strong

**Watch:** a heading followed by a one-line paragraph that restates it before the real content.

> **Before:** ## Performance
>
> Speed matters.
>
> When users hit a slow page, they leave.
>
> **After:** ## Performance
>
> When users hit a slow page, they leave.

### Y7 Table-of-contents intros · strong

**Watch:** In this post, we'll explore..., By the end of this article you'll..., Here's what we'll cover.

**Fix:** delete the preview and open with the first real point. Salvage any fact or position the intro carried.

### Y8 Recap endings and bolted-on CTAs · strong

**Watch:** a "Conclusion" or "Final thoughts" heading over a paragraph that repeats the intro; In conclusion, In summary, Ultimately, Overall; the future looks bright, exciting times ahead, a step in the right direction; "Ready to transform your workflow? Sign up today!"

**Fix:** end on the last substantive point. Keep a CTA and link the draft has, as one plain sentence. Drop a generic "Conclusion" heading when the section shrinks to a line or two.

> **Before:** ## Conclusion
> In conclusion, the new API represents a pivotal step forward. Ready to transform your workflow? Sign up today!
>
> **After:** To try the new API, [sign up](/signup).

### Y9 Boilerplate summary blocks · strong

**Watch:** "Key takeaways", "TL;DR" or "FAQ" blocks that repeat the body.

**Fix:** cut if it only repeats. If it's the site's template (neighbouring posts have it), keep it and make each item specific. A real FAQ answers questions the body doesn't.

### Y10 Passive voice and subjectless fragments · weak

**Watch:** "No configuration file needed." "The results are preserved automatically." "Mistakes were made."

**Fix:** name the actor when it makes the sentence clearer.

> **Before:** No configuration file needed. The results are preserved automatically.
>
> **After:** You don't need a configuration file. The system saves the results automatically.

**Don't flag:** passive voice where the actor is unknown or irrelevant, as in scientific methods and reference text.

### Y11 Connective paragraph openers · weak

**Watch:** paragraph after paragraph opening with Additionally, Moreover, Furthermore, Ultimately, Importantly, Notably, Overall.

**Fix:** delete the connective; the order of paragraphs already says "next". Keep "However" where the contrast is real.

---

## F. Formatting

### F1 Em dash density · weak (strong as a reveal)

**Watch:** dashes (—, spaced –, " -- ") in most paragraphs; two or more in one paragraph; the "not X — it's Y" reveal dash.

**Thresholds:** a few in a long piece is normal. Flag more than about 3 per 1,000 words, two or more in a paragraph, or any reveal dash. In short copy (under 150 words), flag any that a comma or period would do.

**Fix:** commas, periods, colons or parentheses. Leave dashes inside code, paths, URLs and ranges.

> **Before:** The term is promoted by Dutch institutions—not by the people themselves. You don't say "Netherlands, Europe" as an address—yet this mislabeling continues—even in official documents.
>
> **After:** The term is promoted by Dutch institutions, not by the people themselves. You don't say "Netherlands, Europe" as an address, yet the mislabeling continues in official documents.

**Don't flag:** dashes in the author's writing sample; a house style that uses them.

### F2 Decorative boldface · weak

**Watch:** bold on phrases mid-sentence with no reason; bold on every key term.

**Fix:** remove. Keep bold for a real warning or a UI label the reader must find.

> **Before:** It blends **OKRs (Objectives and Key Results)**, **KPIs (Key Performance Indicators)**, and the **Business Model Canvas (BMC)**.
>
> **After:** It blends OKRs, KPIs, and the Business Model Canvas.

### F3 Bold-label lists · weak (strong when items restate labels)

**Watch:** every list item starts with a bold label and colon, and the sentence after it restates the label.

> **Before:**
> - **User Experience:** The user experience has been significantly improved with a new interface.
> - **Performance:** Performance has been enhanced through optimized algorithms.
>
> **After:** The update improves the interface and speeds up load times through optimized algorithms.

**Don't flag:** reference lists where the label is a term being defined (options, keys, config fields, glossary entries).

### F4 Title case headings · weak

**Fix:** sentence case in body headings, unless the site's other posts use title case. Leave the frontmatter `title` alone unless asked.

### F5 Headline formulas and furniture headings · strong

**Watch:** Unlock/Unlocking the power of X, Elevate your Y, Master X in N days, The Ultimate Guide to X, Everything You Need to Know About X, From X to Y (as a subtitle); and furniture headings that describe the slot rather than the content: Introduction, Overview, Key Takeaways, Conclusion, Final Thoughts.

**Test:** could this heading sit unchanged on a competitor's page? Then it isn't finished.

**Fix:** a heading that states the actual content or payoff.

> **Before:** # Unlocking the Power of Data: Master Analytics in 30 Days
>
> **After:** # A 30-day plan for learning business analytics

### F6 Emojis in headings and lists · strong

**Fix:** remove from headings, bullets and labels. Keep emoji the platform expects (some social copy, chat messages) if the author uses them.

### F7 Curly quotes · weak

**Watch:** curly quotes mixed with straight ones, or curly quotes in a plain-text or Markdown source where everything else is straight.

**Fix:** match the document's convention. Many publishing tools convert straight quotes to curly ones on purpose.

### F8 Exclamation marks in body text · weak

**Fix:** remove from body text of announcements, docs and posts. Keep them in quotations and genuinely excited personal writing.

### F9 Over-structuring · weak

**Watch:** bullets wrapping an argument that should be prose; headers over two-sentence sections; horizontal rules between every section; a top-level heading that repeats the title.

**Fix:** prose for arguments, lists for real sequences and parallel reference items, headings only where a reader would navigate.

---

## Page-level checks

These come from reading the piece as a whole, not line by line. Each one
that applies counts as one finding in the verdict.

1. **Point:** can you state the core point in one sentence? (I4)
2. **Opening:** does the first paragraph say something only this author could say, or could it sit on any site? (T15, I3)
3. **Numbers:** does every statistic have a source and date? (I1)
4. **Stance:** is there anything a reader could disagree with? (I6)
5. **Headings:** do they carry content, or describe furniture? (F5)
6. **Shape:** do sections vary in length with their difficulty? (Y5)
7. **Ending:** does it end on substance, or a recap, kicker or CTA shout? (Y8, T11)
8. **Residue:** any placeholders, chatbot lines or "as an AI"? (R1, R3)
9. **Person and date:** in a personal or company post, is there anything first-hand and specific (a customer, a date, a number the author owns)? Don't add one; note its absence as a gap.
10. **Reason to exist:** does the piece say anything the obvious top search results don't? Report this as an editorial note, not a line edit.
