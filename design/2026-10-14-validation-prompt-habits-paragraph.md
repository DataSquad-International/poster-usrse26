# Validation prompt: the "Research software habits" paragraph (poster rewrite)

Paste everything below the line into ChatGPT or Gemini. No attachment needed.

---

You are an editor and a research software engineering (RSE) practitioner reviewing one paragraph of a conference poster. You have no other context, so everything you need is below. Please answer the numbered questions at the end.

## The project and the audience

DataSquad is a program where paid undergraduates provide data and research software support for researchers on their campus and learn the work by doing it. It runs at Carleton College and at the UCLA Library Data Science Center, and a network, DataSquad International, supports institutions that want to adopt the model. The poster is for the US-RSE 2026 conference (research software engineers and the people who manage them), shown at a poster reception, printed at 44 x 44 inches. Body text is 42 pt. The goals are to show supervisors of student workers that the model is adoptable and to start conversations with people who supervise students.

The paragraph sits at the bottom of the middle column, under two short project examples (an election-news transcript scraper that nine students built and extended over several years, and a police-helicopter flight-data project in which two students refactored a lab's R code with staff and the code went through code review). It is the poster's only statement about software practice, so RSE readers will read it closely.

## The paragraph, before and after

Before:
> **Research software habits, when the project needs them.** Run instructions, a dependency list, one test, and a citation file. We do not treat them as a checklist. We plan to track whether researchers keep them. Two student-built projects have citation files and DOIs that credit their developers: wbcheck (doi:10.5281/zenodo.23329531) and the UC OSPO Education site (doi:10.5281/zenodo.23330022).

After (what I want you to evaluate):
> **Research software habits, when a project needs them.** Some projects get run instructions, a dependency list, one test, and a citation file. We do not use them as a checklist. We plan to track whether researchers keep using them. Two student-built projects, wbcheck (doi:10.5281/zenodo.23329531) and the UC OSPO Education site (doi:10.5281/zenodo.23330022), have citation files and DOIs that credit their developers.

What changed: the list sentence had no verb and now has one ("Some projects get..."); "keep them" became "keep using them"; the two DOIs moved into the sentence that names the projects. About 56 words became 60. The DOIs are printed as links on the poster.

## Facts behind the paragraph (so you can judge what it may claim)

- wbcheck is a Carpentries lesson checker. Students started it in 2023; staff expanded it in 2026 with AI assistance. It has 48 documented rules, tests, a BSD-3 license, and a citation file with a Zenodo DOI that lists student authors first.
- The UC OSPO Education site is a catalog of 55 open source lessons that students built. It has a citation file and a Zenodo DOI. Open question: our own notes disagree on whether its citation file credits the students (one note says it omits both students, another says the release lists 10 authors and a CREDITS file). We are checking.
- The four items (run instructions, a dependency list, one test, a citation file) are the practices the poster names. The programs do not require them of every project; they apply them when a project needs them.
- "We plan to track whether researchers keep using them" is the original poster wording, kept in the rewrite. Our own reading, which may be wrong or unclear: the researchers who receive the work, and whether they keep using the practices. No tracking has happened yet. Please tell us if the sentence is ambiguous.

## Already decided: please do not relitigate

- No em dashes anywhere.
- Both DOIs stay, as links.
- The poster is full. The paragraph must stay at about 60 words or fewer.
- Students are never described as tools or helpers.
- We will not claim more than the facts above support.

## Questions

1. Clarity for an RSE reader in 10 seconds: what does a skimmer take away from this paragraph? Is the heading ("Research software habits, when a project needs them") clear, or does "habits" read as vague or twee to this audience? Suggest a better heading if so.
2. Is the four-item list the right minimum? Name what an RSE reviewer would expect that is missing (for example a license, a README, a pinned environment, version control, contribution notes), and what, if anything, to cut. Keep the total length in mind.
3. "Some projects get..." versus the heading "when a project needs them": do these say the same thing, or does the pair read as contradictory or vague about who decides?
4. "We do not use them as a checklist." Is this useful, or does it sound defensive or evasive? Offer a positive rewording that keeps the meaning (the practices are applied by need, not required for every project).
5. "We plan to track whether researchers keep using them." Who is "researchers" here, and who tracks? Is a printed promise to track wise when no tracking has happened? Suggest safer wording that is still honest.
6. "Citation files and DOIs that credit their developers": how should we word the credit claim so it is accurate even if one project's citation file credits only some contributors? Is "student-built" safe for wbcheck, given that staff expanded it in 2026?
7. Give two alternative rewrites of the whole paragraph, each 60 words or fewer, with different emphases (one practice-first, one outcomes-first). Keep both DOIs.
8. Anything here that would draw skepticism from an RSE audience, or that reads as AI-written?

For each recommendation give a confidence score (low, medium, high) and the concrete replacement wording, not general advice. If something I stated conflicts with common RSE practice, say which you trust.
