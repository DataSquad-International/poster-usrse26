# Validation prompt: poster layout and what to do with alumni outcome data

Paste this into an external model together with the rendered poster PDF (poster.pdf, one page, 44 x 44 in) and mock-outcomes-shape.csv (synthetic). Aggregates only: no names, emails, or employers appear here by design.

---

You are reviewing a conference poster and advising on a data visualization. You have zero prior context, so everything you need is below. I will also attach the poster as a PDF.

## What this is

Poster "Is the DataSquad Model For You?" for US-RSE '26 (the US Research Software Engineer Association conference, San Jose). Poster reception is Monday Oct 19, 2026; camera-ready Wed Oct 21. Maximum size 44 x 44 in; we use exactly that (square). The audience is research software engineers, research computing staff, and librarians who might start a student team on their own campus. Presenters are from Carleton College and UCLA, which run sibling programs called DataSquads: paid undergraduates who work on researchers' data and software projects, supervised and mentored by staff.

The poster is built as plain text (Quarto + Typst), so coauthors can edit words in Git. Style: navy #1D3557, steel #457B9D, orange #F9AE1A, Atkinson Hyperlegible font, no raster images, vector only. Carleton and UCLA must get equal visual presence.

## Program context

DataSquad International is a small network of campus programs (Carleton College, UCLA, and GESIS in Cologne; this poster covers the first two). Carleton's squad has run for many years (alumni class years go back to 2005); UCLA's alumni are more recent. Student roles are data analyst or developer, project manager (triages requests), and technical writer. Students are paid employees, supervised and mentored by library or department staff. The tables below are every former student employee we could find, not a sample, so counts are small and the groups are a census of who we located, not of everyone who ever worked on a squad. The public site is datasquad.info.

## Tools and constraints

- Build chain: Quarto 1.9 renders a plain-text file to Typst, which compiles the PDF. No Word, no PowerPoint, no web page.
- The current outcomes list is a small Typst function that reads a two-column CSV (category, count) and draws text and rules with native shapes. The poster must stay vector with no raster images; fonts are embedded (Atkinson Hyperlegible only).
- A new chart can be (a) drawn natively in Typst with rectangles, lines and text (counts are small, so this is realistic), (b) a hand-built or script-generated SVG that Typst embeds as vector, or (c) a Typst package such as a plotting library. Python (standard library or common plotting packages) is available to generate an SVG ahead of time, but nothing runs at print time. Please say which route each proposal needs and how much layout work it is. Do not propose JavaScript, interactive, or raster output.
- Everything must be editable by coauthors who are not Typst experts: data in a CSV, words in the .qmd file.

## Recent work (so you know what already changed)

- Header: title, a one-sentence subtitle defining a DataSquad, authors, and the DataSquad International mark (white on navy). The same mark is a faint full-page watermark.
- A central band: one line ("Students are not just the tool. They are a beneficial product of the service.") plus a three-sentence intro on why squads exist ("glue" between courses and the software researchers write), next to a flow diagram: Research requests -> Paid student project work (with staff supervision and mentoring above) -> Useful research support and Skilled students.
- A three-column band: (1) A paid job that teaches (who is on a squad, limits we keep, what slows us down); (2) What the work looks like (four short project examples, two per school, two with citable DOIs); (3) Where students go next (a small list of counts, see below), What adopting takes, Start one (QR code plus datasquad.info/join).
- The DRAFT mark was moved from a page watermark to the footer. Two software projects were released with DOIs crediting their student authors.

## Current text of the outcomes panel (verbatim)

"Where students go next. We located 19 UCLA former student employees. By current job category (public profiles, 2026):" followed by a plain list of counts, then "Descriptive, not a placement rate."

The list is a text table with large numerals: Data / analytics / consulting 11; Software / engineering / IT 4; Research / graduate school 2; Nonprofit / public sector 2.

## Decided, do not relitigate

- Counts and categories only on the poster. No alumni names, employers, or photos.
- The current five-category list (superseded by question set D if you recommend a change) is the baseline for both schools: Data / analytics / consulting; Software / engineering / IT; Research / graduate school; Nonprofit / public sector; Still a student. Category means current position at the check date. Someone can carry a second category.
- Poster stays a single 44 x 44 in page and works printed in grayscale.
- It says "Descriptive, not a placement rate." We will not claim causal effect of the program.
- Wording, authorship, and the project examples are being handled separately.

## The outcome data we have

Both programs track alumni in one table. Target shape, one row per person:

FirstName, LastName, Email, GraduationYear, LinkedIn, JobClassification, Major (plus Program, Group, CurrentPosition, Organization, AlsoClassification for charting). In the real table JobClassification is the old five-category label; the mock file adds the proposed SOC-based fields.

What is filled today:

| Field | UCLA (20 rows) | Carleton (120 rows) |
|---|---|---|
| Group | 19 alumni, 1 current student | 114 alumni, 6 current students |
| GraduationYear | 12 of 20 | 120 of 120 (class years 2005 to 2026; the source stores two-digit years, read as 20xx, and 2005 and 2009 are unconfirmed) |
| LinkedIn link | 0 of 20 in the table (checked by hand) | 117 of 120 |
| Email | 0 of 20 | 119 of 120 |
| JobClassification | 20 of 20 | 0 of 120 (not yet looked up) |
| Major | 0 | 0 (not in either source; some Carleton bios mention it) |
| Second category | 2 of 20 | 0 |

UCLA class years known so far: 2024: 5, 2025: 4, 2026: 3 (one still a student), 8 unknown. Overall UCLA: 11 / 4 / 2 / 2 across the four categories above, 1 still a student.

Carleton alumni by class year: 2005: 1, 2009: 3, 2010: 4, 2011: 1, 2012: 2, 2013: 2, 2014: 2, 2015: 4, 2016: 5, 2017: 3, 2018: 7, 2019: 4, 2020: 9, 2021: 5, 2022: 7, 2023: 14, 2024: 7, 2025: 19, 2026: 15. Carleton outcomes would be filled by hand from public LinkedIn profiles (about 117 lookups) and may not be done by the Oct 14 freeze.

Not in the data: the role a person held on the squad, years or hours on the squad, which projects they worked on, salary, or any survey of self-reported benefit. Class-year coverage is thin for UCLA and category coverage is empty for Carleton, so any chart must degrade gracefully if Carleton stays blank.

Paula (Carleton) suggested a Sankey diagram.

### Mock data (attached: mock-outcomes-shape.csv)

The attached CSV is synthetic, generated with the Python Faker library: 140 invented people with realistic names, emails, LinkedIn-style links, employers and majors. It is the table as it would look after the proposed taxonomy in section D is applied and Carleton is fully looked up. Columns: FirstName, LastName, Email, GraduationYear, LinkedIn, Major, Program, Group (alumni or current student), Level1Group (one of six), AlsoGroup (secondary, often blank), SOCCode and SOCTitle (O*NET-SOC, from memory and unverified), CurrentPosition, RoleDescription (one invented line), Organization, LegacyCategory (the old five-category label, for comparison).

What matches the real data: UCLA has 19 alumni plus 1 current student, with its real class-year spread (5 in 2024, 4 in 2025, 2 in 2026, 8 unknown) and 4 software roles. Carleton has the real class-year counts per year (2005 to 2026) plus 6 current students. What is invented: all Carleton job groups (about 15 percent left blank to mimic lookups not yet done), titles, SOC codes, descriptions, employers, majors. UCLA's real split is 11 data/analytics/consulting, 4 software, 2 research/graduate school, 2 nonprofit/public sector; the mock spreads the 11 across groups 1 and 3 and puts graduate-school roles in group 6. Use the file to prototype or sanity-check chart and taxonomy ideas, not to draw conclusions about real alumni.

## What I want from you

### A. Layout of the poster (see the attached PDF)

1. Reading order: does the eye go title -> diagram -> three columns -> Start one on a 44 in square? Where does it get lost? Give me the one change that most improves the first 10 seconds at 6 feet.
2. Text scale: body is 42 pt, panel titles 58 pt, lede 78 pt, title 150 pt. At a conference, readers stand 3 to 6 feet away. Is the body too small, too big, or fine? Cite your reasoning.
3. Density and whitespace: which panel is overfull, and what should be cut first? The page is a hard single page.
4. Equal Carleton/UCLA presence: is it actually equal in the PDF? A thin colored left rule and a small school label tag each project example. Is that enough, or does the header need to show both schools more prominently?
5. The outcomes panel is currently a text list of four counts. Should that panel stay a list, become a chart, or move? Where should the chart live and how much room should it get?
6. The watermark mark is faint behind everything. Does it hurt legibility anywhere?

### B. Outcome visualization

Given the data above (UCLA complete on category, Carleton possibly blank), propose what we can show. Paula thinks a Sankey. I am not sure it is right.

7. Is a Sankey a good idea here? What would the left, middle, and right nodes be, given the fields we have? Would it be readable at 20 UCLA people and 120 Carleton people, and with Carleton blank? State the specific failure mode.
8. Give me 3 to 5 alternatives, ranked, that work in grayscale, are vector, and are honest at these sample sizes. Examples to consider (reject or replace freely): a dot or unit chart where each person is one mark grouped by category; a cohort-by-category strip; a stacked bar by graduation year; a small multiple per school; a slope or alluvial chart from class year to first category; a simple labeled count list with an icon grid.
9. For each, say what it needs from the table (which columns, how many rows, what missingness is tolerable), what the headline sentence under it would be, and the one way it could mislead.
10. What would you do if Carleton stays blank by Oct 14? Is a UCLA-only chart with a plain statement acceptable at a conference whose theme is both schools, or is a different framing better?
11. What should be computed or collected next (Major, years on the squad, squad role) that would make a visual actually say something about the model rather than just where people ended up? Tell me which of those is realistic in a week from public sources versus needing a short survey.
12. How should small groups be handled (some categories have 2 people)? Suppression rule, wording, or merging categories?
13. Privacy: we hold names, emails, and LinkedIn links locally and publish only counts. Does anything in your proposed visual, such as one dot per person with a class year, risk re-identifying people in groups this small?

### D. Job classification taxonomy

Today's five categories are home-made (see Decided). We are considering replacing them with a two-level scheme built on O*NET-SOC (the US occupation classification): Level 1 is about six broad groups for the poster, Level 2 is the specific SOC / O*NET code kept with the data so coding is auditable and regroupable.

Proposed Level 1 groups (SOC mapping is from memory, unverified; please check it):
1. Data science and analytics (SOC 15-2xxx: Data Scientists, Statisticians, Operations Research Analysts)
2. Software and engineering (SOC 15-12xx: Software Developers, Systems Analysts, Administrators; other engineering)
3. Actuarial, finance and consulting (Actuaries, Management Analysts, Financial Analysts)
4. Research and academia (research assistants, scientists, postsecondary teaching)
5. Public sector, nonprofit and information work (librarians, GIS, program and operations staff)
6. Further study (graduate school), kept separate from occupations because school is not an employer

A person can carry one primary group and one "also" group.

Hard case to test the scheme (de-identified): a "Development Operations Supervisor" at a housing nonprofit. The role builds the fundraising team's processes and does fundraising analysis; the previous role managed the donor database, built mailing lists and produced giving reports for the board. I would put this under Fundraisers (O*NET 13-1131.00, from memory) in group 5, with an "also" of group 1 for the data work. A job-title keyword match would miss the data content.

14. Are the six groups the right breadth for 20 to 120 alumni, and is group 3 or group 1 more useful to split or merge? Name what you would change.
15. Check the SOC / O*NET codes and titles named above against what you know. Which are wrong or outdated?
16. Is "primary plus one also" the right rule? What is the cleanest, most reproducible way to decide primary when a role mixes data and non-data work?
17. How would you build a matcher (title keywords, employer type, description keywords, with human review) that two coders would apply the same way? Give an agreement check we could run on 20 people.
18. What breaks when we compare Carleton and UCLA alumni who graduated 15 years apart (job titles change over time)?

### C. Output format

For each numbered question give a one-line answer first, then reasoning. End with: your top 3 changes in order, a confidence score (0 to 100) for each, and what evidence would change your mind. Correct me concretely; do not give general praise.
