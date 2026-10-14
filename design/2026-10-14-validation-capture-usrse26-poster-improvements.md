# Validation capture: US-RSE '26 poster improvements (round 2)

Prompt: `2026-10-14-validation-prompt-usrse26-poster-improvements.md`. Reviewer: an external chat model (response pasted 2026-10-14, poster.pdf attached). Adjudicated against our files; Tim signed off on all ADOPT items the same day.

## Verified against our files

- Type sizes match the reviewer's reading: 42 pt body, 58 pt section headings, 78 pt headline (title 130 pt was our change).
- The watermark was baked into the SVG at fill-opacity 0.07 (no template setting).
- wbcheck: first commit by a student on 2023-09-01; git history shows 101 commits by Tim and about 37 by students; `CITATION.cff` lists student authors first. "Students began it, staff filled in the code" holds.
- Language placement dashboard: the Carleton write-up supports "longer than any one student would stay". The dashboard post covers planning only and does not say it was built.
- Election-news scraper: no source for "nine students" in our website repo. The ITS blog post (3 June 2024) supports it: 7 developers in 2022 plus 2 students from Sept 2023 to Feb 2024, over 500,000 transcripts. "From 2021" on the old poster came from a class year.
- Both DOIs resolve (302); Zenodo metadata was not read, so student credit there is still unverified.
- Helicopter: the website entry says "over 800%" and names other students; the UCLA DSC Sway says about 318 to about 2 minutes (Sway's "156% faster" is wrong, it is about 159 times). Not reconciled.

## Adjudication and where it landed

| # | Claim | Verdict | Outcome |
|---|---|---|---|
| 1 | Give "Start a DataSquad" an orange-headed box | ADOPT | PR #6 (QR moved beside the text to stay on one page) |
| 2 | "Learn to be RSEs" overclaims | ADOPT (softer) | PR #5, headline now "build RSE skills" |
| 3 | New title wording | DEFER | coauthors' choice; check the program's printed title |
| 4 | Helicopter replaces a UCLA example, not Carleton | ADOPT | PR #11 (replaced UC OSPO, then wbcheck and the dashboard were cut for two examples with visuals) |
| 5 | Prototype one visual first | ADOPT | PR #11 (to-scale and tile graphics drawn in Typst, no third-party images except one CC BY photo) |
| 6 | Keep school labels, inline | ADOPT | PR #5 |
| 7 | Skip role icons, compact lines | DEFER, then built as pills | PR #10 (Leigh's bubble idea) |
| 8 | Intro paragraph is the weakest block | DEFER | Paula's abstract sentence; open |
| 9 | Cut the middle-column intro paragraph | ADOPT | PR #5 |
| 10 | CTA says what the scan gives | ADOPT | PR #5 |
| 11 | "Good practice spreads" reads as observed | ADOPT | PR #5 reworded as a goal; box removed in PR #9 |
| 12 | Add a concrete mentoring or handoff practice | DEFER | PR #9 added "Staff teach, review, and mentor"; verbs still need confirming at both schools |
| 13 | Halve watermark opacity | ADOPT | PR #5 (0.035) |
| 14 | Print an actual-size crop, remove DRAFT before camera-ready | ADOPT | task due 2026-10-21 |
| 15 | wbcheck: state the student and staff split | ADOPT | PR #5; paragraph later cut, credit moved to the habits paragraph |
| 16 | Dashboard line is an absolute claim | REJECT | the source supports it; example cut for space in PR #11 |
| 17 | Scraper: nine students, "outlasted" | DEFER | now sourced from the ITS blog; Paula to approve |
| 18 | Do not use 800% or LA Times for the helicopter | ADOPT | not used; 318 to 2 min used instead, unconfirmed |
| 19 | OSPO credit and "55 lessons" need checking | DEFER | open |

## Open before camera-ready (Wed 2026-10-21)

- Helicopter: confirm the figure, who refactored and reviewed, and the lab's OK with Lawrence, Maddie, and the staff involved; reconcile with the website entry.
- Scraper figures and the Carleton pick: Paula.
- Staff band verbs true at both schools; OSPO DOI credit and lesson count.
- Print proof: QR is 2.2 in; check the photo credit size; set `poster-draft: false`.
