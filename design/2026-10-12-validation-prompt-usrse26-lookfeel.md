# External validation request: look and feel of a rebuilt conference poster, and the fixes planned next

You are an experienced poster and information designer. You have no prior context, so everything you need is below. Be specific and blunt. I will verify each claim against the files before changing anything, so say which claims you are sure of and which are guesses. If you recommend a change, say what it costs in hours and what could go wrong with it.

## Context

- **Poster:** "Is the DataSquad Model For You?" for US-RSE '26 (US Research Software Engineer Association, San Jose). Poster reception Monday Oct 19, 2026, the first day of the conference. Printed up to 44 x 44 inches, square, then uploaded as a PDF to Zenodo. Today is Oct 12, so there is about one week, and the print happens in San Jose near the venue.
- **What a DataSquad is:** a team of paid undergraduate analysts who help researchers work with data, started at Carleton College and run at UCLA. A network (datasquad.info) supports other institutions adopting it. Presenters: Paula Lackie and Oliver Hall (Carleton), Tim Dennis and Leigh Phan (UCLA).
- **Audience:** research software engineers, research computing and library staff, and supervisors of student workers who might start a squad.
- **Tim's design brief, in his words:** he wants "non-AI design, however we accomplish that." He does not want something that reads as AI-generated or templated.
- **How it is built:** Quarto + Typst, text in a plain Markdown file so coauthors (who only tweak wording, in Git) can edit it. A small script turns `:::` blocks into layout areas. All graphics are vector. No photographs.

## Already decided, do not relitigate

- Brand colors from datasquad.info: navy #1D3557, steel blue #457B9D, orange #F9AE1A, canvas #F8F9FA, slate text #2D2D2D. Atkinson Hyperlegible font. Title stays. The logo is the DataSquad hexagon-S mark, vector, white on navy.
- The structure is a three-panel layout under a central band, because the presenters agreed it earlier: (1) paid learning and useful service, (2) practices as projects need them, (3) what we know and what adopting takes.
- The central line is Paula's own wording and stays.
- Both schools get equal presence (two Carleton and two UCLA examples). School names are tagged with thin accent rules in each school's official blue.
- No names or employers of alumni on the poster. The chart shows counts only.

## Changes since the last review

An earlier reviewer said the first version looked like a web page printed large. I adopted these changes: removed the boxed heading strips, the eyebrow, the subtitle, the orange rule and the logo tile; replaced three equal flowing columns with independently placed areas; added a central diagram; moved the central claim up and made it large; swapped orange bullets for navy squares; dropped body text sizes to fit; placed the QR code inside the third panel.

## Current design, as rendered (attached PNG, if I attached it)

Page: 44 x 44 in, canvas background, margins 1.25 in left and right, 1 in top, 1.7 in bottom (footer sits in the bottom margin).

1. **Header:** full-width navy rounded rectangle. Title in white bold 150 pt, left aligned. Authors below in white bold 46 pt, affiliations in light blue-gray 38 pt. Hexagon mark white at right, 3.8 in tall. About 4 in of empty navy sits between the title and the authors.
2. **Central band (two areas, 1 : 2):** left, Paula's line in navy bold 78 pt, then a six-line paragraph at 42 pt. Right, the diagram: small outlined box "Staff supervision" above a solid navy box "Paid student project work"; an outlined "Research requests" box with an arrow into it; two arrows out to an outlined "Useful research support" box and an orange-filled "Skilled students" box; a small arrow down to the caption "Good practice travels to labs and offices across campus". Labels are 46 to 60 pt bold. Arrows are drawn shapes, 7 pt strokes.
3. **Three panels (columns about 1.15 : 1.2 : 1):** each titled in navy bold 58 pt with one steel-blue rule underneath; no boxes. Sub-headings are navy bold 46 pt. Bullets are small navy squares. Body is 42 pt slate, left aligned, ragged right. Panel 2 has four examples, each with a thin colored left rule and a small letter-spaced school tag (CARLETON in dark navy-blue, UCLA in bright blue). Panel 3 has a single horizontal stacked bar (navy, steel, orange, light blue segments with white or navy counts, 1.7 in tall) and a text legend, then a short list, then "Start one" with a 3-inch QR code on a white square.
4. **Footer:** navy bar with white text left (conference and reception date) and orange text right (datasquad.info).

Whitespace: column 1 ends about 4 in above the footer, column 2 about 1 in above, column 3 is full. Sub-headings sit close to the text below them.

## Poster text as it prints (Quarto Markdown; `:::` lines are layout markers)

```markdown
::: {.cells columns="1fr 2fr" gutter="70pt"}

::: {.cell}
::: {.lede}
Students are not just the tool. They are a beneficial product of the service.
:::

Campuses need more data and software support than they have staff to give, and students have few ways to gain real experience. The work is little known, especially to students from underrepresented backgrounds. Students who want that experience can close the gap, and perhaps widen who thrives in this work.
:::

::: {.cell}
```{=typst}
#model-diagram()
```
:::

:::

::: {.cells columns="1.15fr 1.2fr 1fr" gutter="70pt"}

::: {.cell}
# Paid learning, useful service

Students are paid employees, supervised by library or department staff. They help researchers with data from wrangling to reproducibility.

## Who is on a squad

- Student **data analysts** do the hands-on work.
- A student **project manager** triages requests.
- Student **technical writers** document projects.
- **Staff** supervise, fund, and sustain the squad.

## Limits we keep

Squads help with a researcher's data. They do not change the research questions, tutor, or break confidentiality.

## What it costs in pace

Student availability, the academic calendar, onboarding, review, and graduation handoffs all slow the work. More students take on more varied projects but need more oversight. Handbooks, templates, and staff carry continuity.
:::

::: {.cell}
# Practices as projects need them

Examples sit on a spectrum. Not every client needs a public repository.

::: {.carleton}
**Election-news scraper.** Nine students started, extended, or used it from 2021 to 2024 to collect broadcast transcripts for a political science project. The tool outlasted the students who began it.
:::

::: {.ucla}
**wbcheck.** Two students began this Carpentries lesson checker in 2023. Staff rebuilt it in 2026 with AI assistance. It has 48 documented rules, tests, a BSD-3 license, and a citation file crediting the original authors.
:::

::: {.carleton}
**Language placement dashboard.** The project ran longer than any student would stay, so the squad sketched the database and chose heatmaps for the development team to build.
:::

::: {.ucla}
**UC OSPO education site.** Two students built the lesson pages and search for a catalog of 55 open source lessons.
:::

Where a project calls for it, students add run instructions, a dependency list, one test, or a citation file. We plan to track whether clients keep them.
:::

::: {.cell}
# What we know

```{=typst}
#outcomes-bar("data/outcomes.csv")
```

19 UCLA former student employees we located, by current job category (public profiles, 2026). Descriptive, not a placement rate. Carleton tracing is in progress.

## What adopting takes

- Paid student positions and a wage budget
- A supervisor with time to review
- Onboarding, and somewhere to keep documentation
- A plan for turnover

# Start one

::: {.cells columns="1fr 3.4in" gutter="36pt"}

::: {.cell}
The starter kit at **datasquad.info/join** covers roles, a confidentiality agreement, onboarding, and request tracking. Ask us for sample job descriptions.
:::

::: {.cell}
::: {.block fill="white" inset="16pt" radius="6pt"}
![](assets/qr-datasquad-info.svg){width=3in}
:::
:::

:::
:::

:::
```

## Fixes I plan next, in this order

1. Shrink the dead space in the header between the title and the authors.
2. Add consistent space above and below sub-headings.
3. Rebalance the three columns so they end at similar heights (move or trim content, not shrink type).
4. Enlarge the QR code to about 4 inches.
5. Polish the diagram labels and sizes.
6. Add one student quote and one real image if consent and files arrive; otherwise leave the space alone.
7. Zoom-check every section at full size for overflow and print-resolution problems.

## Questions

### A. Look and feel
1. **Verdict.** Does this still read as templated or AI-generated? Rank the specific features that still do, and say what, if anything, now reads as deliberate. Be concrete (name the element).
2. **Hierarchy.** At 4 to 6 feet, what is read first, second, and third? Is the central line plus diagram strong enough against the navy header, or does the header still dominate? Suggest specific size or weight changes with numbers.
3. **Type system.** I use one family in regular and bold only, five or six sizes, navy for headings and bold keywords, slate for body. Is that too uniform, or appropriately disciplined? What one typographic move would add the most character without breaking the brand?
4. **Color.** Is the orange used well (diagram highlight, chart segment, footer URL)? Is the navy-heavy header too heavy? The school-tag colors (Carleton #003069 and UCLA #2774AE) are very close to navy and steel: do they work as local accents or just add noise?
5. **Diagram.** Does it explain the idea in about five seconds? What would you change in shape, label wording, spacing, arrows, or emphasis? Should the "skilled students" output be visually larger than "useful research support", equal, or smaller, given the central claim?
6. **Chart.** Is a single stacked bar of 19 people the right device, or would a simple table, a row of icons, or no chart be better for this audience? Consider that Carleton data may not arrive and the bar would then show UCLA only.
7. **Whitespace and density.** Is the current density right for a conference poster in a crowded room? Where is it too dense or too sparse? Should the empty space at the bottom of column one be used, or left?
8. **Hand-made feeling.** Name 3 small, cheap, specific touches (not decoration) that would make this feel authored by people, buildable in Typst or SVG in under an hour each.

### B. My planned fixes
9. Is my order right? What would you add, drop, or reorder? What is the single highest-impact change that is not on my list?
10. For each of my seven planned fixes, give a concrete target value (for example, header height, space above sub-headings in points, QR size) and one thing that could go wrong.

### C. Print and distance
11. Minimum sizes you would accept for body, sub-headings, panel titles, diagram labels, chart counts, and QR code for a poster read from 4 to 6 feet. Which of mine fall below that?
12. Any contrast or color-vision problems in the palette as used (orange on canvas is about 1.8:1 and navy on orange is about 6.5:1; the chart uses navy, steel, orange, and light blue with a text legend)?

### D. Output format
Answer in this order: (1) a three-sentence verdict; (2) numbered answers; (3) a ranked list of the top five changes to make before the poster is sent to print; (4) a confidence score from 0 to 100 on your verdict and the one thing you could not judge without seeing the attached PNG.
