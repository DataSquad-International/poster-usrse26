# Validation prompt: US-RSE '26 poster improvements (second round)

Paste everything below the line into ChatGPT or Gemini and attach `poster.pdf` (current render of `main`, 44 x 44 in, one page).

---

You are reviewing a conference poster. I attached the current PDF. You have no other context, so this prompt explains the project, the audience, what is already decided, and what I want challenged. Please read the PDF first, then answer the numbered questions at the end.

## The project and the audience

DataSquad is a program where paid undergraduates provide data and research software support for researchers on their campus and learn the work by doing it. It began at Carleton College and now also runs at UCLA (Library Data Science Center). A network, DataSquad International, supports other institutions that want to adopt it.

The poster is for the US-RSE 2026 conference (research software engineers: people who write and maintain software for research). It is shown at a poster reception, 44 x 44 inch square, one page, printed. Authors: Paula Lackie and Oliver Hall (Carleton), Tim Dennis and Leigh Phan (UCLA). Poster goals: show supervisors of student workers that the model is adoptable, and recruit people to compare obstacles and solutions. A QR code leads to datasquad.info/join.

## Current poster text (in reading order)

Title: "Developing RSE skills at the novice level". Subtitle: "Student RSE model for research support, experiential learning, and technical workforce development".

Top left: headline "Paid students contribute to research and learn to be RSEs while they do it." Then: "Campuses need more data and software help than staff can provide. Courses leave gaps, and so does the code researchers write. DataSquads are the glue. Many students never hear of this work, especially those from underrepresented groups."

Top right: a left-to-right flow diagram. "Research requests" and "Staff supervision and mentoring" feed "Paid student project work", which produces "Useful research support" and "Skilled students". An arrow from "Skilled students" leads to "Good practice spreads across campus".

Column 1, "A paid job that teaches": students are paid employees supervised by library or department staff. "Who is on a squad": student data analysts and developers, a student project manager who triages requests, student technical writers, and staff who supervise, mentor, fund, and sustain the squad. "Limits we keep": we help with a researcher's data and code, and we do not change their research questions, tutor their students, or share what we learn in confidence. "What slows us down": student availability, the academic calendar, onboarding, review, graduation handoffs; more students means more varied projects and more oversight; handbooks, templates, and staff are what stay when students graduate.

Column 2, "What the work looks like": four school-tagged examples (thin colored left border: Carleton or UCLA).
- Election-news scraper (Carleton): nine students started, extended, or used it from 2021 to 2024 to collect broadcast transcripts for a political science project; it outlasted the students who began it.
- wbcheck (UCLA): students began this Carpentries lesson checker in 2023; in 2026 staff filled in the code with AI assistance; 48 documented rules, tests, BSD-3 license, citation file crediting its student authors, with a DOI.
- Language placement dashboard (Carleton): the project ran longer than any student would stay, so the squad sketched the database and chose heatmaps for the development team to build.
- UC OSPO Education site (UCLA): students built lesson pages and search for a catalog of 55 open source lessons; citation file and DOI crediting its developers.
Then a paragraph: "Research software habits, when the project needs them. Run instructions, a dependency list, one test, a citation file. We don't treat them as a checklist, and we plan to track whether clients keep them."

Column 3: "Where students go next": 19 UCLA former student employees by current job category from public profiles (Data / analytics / consulting 11; Software / engineering / IT 4; Research / graduate school 2; Nonprofit / public sector 2), shown as a plain count list with the note "Descriptive, not a placement rate." "What adopting takes": paid student positions and a wage budget; supervisors and mentors with time to review work and coach students; onboarding and a home for documentation; a plan for turnover. "Start a DataSquad": the starter kit covers roles, confidentiality, onboarding, request tracking; students learn software sharing from an open lesson; "Supervise students? Tell us your hardest obstacle." QR code and datasquad.info/join.

Design: navy and orange palette, Atkinson Hyperlegible font (chosen for low-vision legibility), a faint full-page watermark, a "DRAFT" tag in the footer (removed for final print).

## Already decided: please do not relitigate

- Students are never described as "tools" or "helpers"; that framing is what we are moving away from. The headline above is the agreed direction, though I will take wording improvements.
- The outcomes panel stays a plain count list, not a chart or Sankey diagram. It is UCLA only, because the Carleton alumni data is not complete. The "Descriptive, not a placement rate" note stays.
- The watermark was requested by a coauthor; opacity can change, removal is not on the table.
- Claims about credit must be verifiable. We can say students are credited only where a citation file or DOI shows it (wbcheck, UC OSPO Education site).
- No em dashes anywhere in the text.
- The poster must stay one page and pass a build check (exactly one 44 x 44 in page).

## Ideas on the table (please evaluate, not just agree)

1. Cut text and use images in the examples: one small visual per example (chart, screenshot, map) instead of a paragraph.
2. Drop the Carleton/UCLA tags on each example to save space (the tags currently cost a line each; the school colors double as an identifier).
3. Replace the bullet list under "Who is on a squad" with role icons or bubbles.
4. Swap in a UCLA example about police helicopter surveillance research: twelve monthly flight-data files of about a million rows each, with nested records, were flattened with R functions into one analyzable dataset for an undergraduate researcher. A later round of code work, pulling data from an API, improved efficiency by over 800 percent. It was covered by the LA Times. One claim is not confirmed and would not go on the poster unless verified: that the code was improved with RSE help so it kept working after the students left. The project would replace the Carleton language placement dashboard, the least visual example.
5. Student quote and photo: only with written consent, so probably absent.

## Questions

1. First impression at 6 feet and at 3 feet: what does a passerby learn in 10 seconds? What do they miss? Where does the eye go first and is that the right place?
2. Is the headline and title pairing clear to an RSE audience? Is "learn to be RSEs" an overclaim for students who are mostly data analysts and developers? Suggest alternatives if so.
3. Rank the five ideas above by value for effort. For each, say what could go wrong.
4. Which single block is weakest and what would you do with that space? Which text could be cut entirely?
5. The poster says "Supervise students? Tell us your hardest obstacle." Is the call to action strong enough for supervisors and RSE managers? What would make someone scan the QR code?
6. What does an RSE-conference audience specifically care about that the poster under-serves (career paths, credit and citation, sustainability of software after students leave, mentoring practice, evaluation)? Is anything here likely to draw skepticism?
7. Accessibility and print: contrast, type sizes, the faint watermark behind text, color-only distinctions (school tags are color-coded). Anything to fix?
8. The example paragraphs mix several claims. Which claims need a number, a source, or a softer verb to survive a skeptical reader?

For each recommendation, give a confidence score (low, medium, high) and the concrete change, such as a replacement sentence, a layout move, or an element to add or delete. Do not just say "improve clarity". If something in the PDF contradicts this prompt, tell me which to trust.
