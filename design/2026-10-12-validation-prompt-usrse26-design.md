# External validation request: poster design, layout, and production approach

You are an experienced designer of academic and conference posters, with some knowledge of research-software and library communities. You have no prior context, so everything you need is below. Be specific and blunt. I will verify every claim against the files before changing anything, so tell me which claims you are sure of and which are guesses. Do not end with general encouragement.

## What this is

- **Poster:** "Is the DataSquad Model For You?" for US-RSE '26 (US Research Software Engineer Association), San Jose. Poster reception Monday Oct 19, 2026. Camera-ready PDF due Wednesday Oct 21 and also uploaded to Zenodo. Today is Monday Oct 12, so there is **one week**.
- **Size:** 44 x 44 inches maximum, square. Printed large format. Unknown mounting surface and no confirmed power.
- **Presenters:** Paula Lackie and Oliver Hall (Carleton College DataSquad), Tim Dennis and Leigh Phan (UCLA Library Data Science Center DataSquad). Tim is the one building this; the others will edit wording.
- **What a DataSquad is:** a team of paid undergraduate analysts who help researchers work with data, started at Carleton and run at UCLA. A network, DataSquad International (datasquad.info), helps other institutions adopt it. Core claim: developing skilled students is itself a primary service. Students are the tool and also a product of the service, and trained students carry good practice into labs and offices across campus.
- **Audience and goal:** research software engineers, research computing and library staff, and supervisors of student workers. We want them to stop, compare obstacles and solutions, and visit the starter kit at datasquad.info/join (QR code on the poster).
- **Tim's design brief, in his words:** he is interested in "non-AI design, however we accomplish that." He does not want a poster that reads as AI-generated or templated.

## Already decided, do not relitigate

- Brand colors from the project website: navy #1D3557, steel blue #457B9D, orange #F9AE1A, canvas #F8F9FA. Font: Atkinson Hyperlegible (low-vision legibility). Accessibility is a priority.
- The title "Is the DataSquad Model For You?" stays.
- The logo is the existing DataSquad International mark: a gray hexagon containing an S-shaped ribbon and a faint globe. Only a 215 x 234 px raster exists so far; a vector may come later.
- Both schools get equal presence (two presenters each, two examples each).

## How it is built now (the approach in question)

- Quarto + Typst. One file, `poster.qmd`, holds all words. Section headings are `# Heading`. A separate `typst-template.typ` controls layout and colors. `data/outcomes.csv` holds chart counts. The PDF is rendered with `quarto render poster.qmd`.
- Why: coauthors "only tweak words and understand Git", so they edit plain text and open pull requests. Claude Code (an AI coding assistant) helps maintain it. The weakness I worry about: a code-generated layout tends to look like a web page printed big.
- Alternative I am considering: hand-design the layout in InDesign, Figma, Affinity Publisher, Illustrator, or Canva, keep the text in a plain document, and have Tim paste revised wording into the design file. Costs: coauthors cannot rebuild it, changes need Tim, and Git diffs are meaningless.

## Current layout, as rendered

- Square page, light gray-white background.
- Hero band across the top: full-width navy rounded rectangle. Small orange letter-spaced uppercase eyebrow, very large white bold title, light blue-gray subtitle, white bold author line, orange affiliation line. Logo on a white rounded tile at right. Thin orange rule below.
- Under it, three equal-width flowing text columns. Text flows top to bottom, then into the next column.
- Each main section heading is a white rectangle strip with a 10 pt steel-blue top border, thin gray outline, and navy bold text. Sub-headings are plain navy bold text. Body is 44 pt, left aligned, dark slate. Bullets are small orange squares. Bold is navy.
- One pale orange callout box holds the central idea.
- The only graphic is a single horizontal stacked bar with four segments (navy, steel, orange, light blue) and counts, then a legend.
- A QR code and one line of text sit at the end of the third column.
- Navy footer bar.
- No photographs, no student faces, no hand-made elements. In the last render, roughly a third of column three was empty.

## Poster text as it prints now

```markdown
<!--
EDITING GUIDE (for coauthors)
- Change words anywhere below. "# Heading" makes a navy section bar, "## Heading" a sub-heading.
- Student outcome numbers live in data/outcomes.csv (category,count). The chart redraws itself.
- Do not edit typst-template.typ unless you want to change the layout.
- Build:  quarto render poster.qmd   (writes poster.pdf)
- Open a PR for changes; Tim or Paula merges.
-->

# The gap

Campuses need more data and software support than they have staff to give, and students have few ways to get real experience doing it. The work is hard to see from the outside, so students from underrepresented backgrounds are the least likely to find it.

Students who want that experience can close the gap. They add support capacity, more kinds of people thrive in research software and data work, and the problem-solving is fun.

::: {.block fill="rgb(255, 244, 221)" inset="28pt" radius="10pt"}
Training students is part of the service. A student is the tool and also a **product** of the service. Those who move on to labs and offices take good practice with them.
:::

# What a DataSquad is

A team of paid undergraduate analysts who help researchers work with data. The network defines what a DataSquad is and how squads coordinate. Each institution runs the day-to-day its own way.

## What squads do

- Data wrangling and transformation
- Data management and the data lifecycle
- Visualization and storytelling
- Reproducibility and open science
- Statistical and analytical support
- Emerging methods, such as geospatial and 3D data

## What squads do not do

- Change the substance of a researcher's data or research questions
- Tutor or help with homework
- Break confidentiality. Consultations stay in confidence.

# Who is on a squad

- Student **data analysts** do the hands-on work with researchers.
- Student **technical writers** document projects and write guides.
- A student **project manager** triages requests and keeps work moving.
- Library or department **program staff** supervise, fund, and sustain the squad.

## The tradeoff

Student turnover and learning time make the service slower than a professional team's. More students can take on more varied projects, but they need more oversight.

# What squads have built

- Two UCLA students designed **wbcheck**, a Carpentries lesson checker, in 2023. Extended in 2026 with AI assistance, it now has tests, a license, release notes, and a citation file crediting the original authors.
- In the **helicopter flight data** project, a UCLA researcher took our base functions and adapted them to her own questions.
- Carleton's **Google Analytics with Python** write-up gives steps anyone can repeat.

<!-- TODO Paula: confirm the Carleton Google Analytics example and a public link.
     TODO Paula: confirm we can offer sample job descriptions (start-one section promises them).
     TODO Tim: UC OSPO education site (ucospo.net/education) is a candidate third example once details are checked. -->

# Where students go

::: {.block fill="white" inset="28pt" radius="10pt"}
```{=typst}
#outcomes-bar("data/outcomes.csv")
```

19 UCLA DataSquad alumni we have tracked, by current job category. Carleton alumni to be added.
:::

<!-- TODO: add Carleton alumni counts to data/outcomes.csv, or split into two charts. -->

# Start one

Borrow the shared pieces and choose the local ones yourself. The starter kit on the site covers roles, a confidentiality agreement, onboarding, and request tracking. Ask us for sample job descriptions.

```{=typst}
#grid(columns: (1fr, auto), column-gutter: 30pt, align: horizon,
  [Join the network and find the starter kit at #link("https://datasquad.info/join")[datasquad.info/join]],
  image("assets/qr-datasquad-info.svg", width: 5in),
)
```
```

## Pending changes already agreed in principle

1. **Example parity.** Replace the current "What squads have built" with two Carleton and two UCLA examples:
   - Carleton: an election-news transcript scraper (Python, Selenium) started in 2021 by one student and improved or used by nine students in total through 2024, for a political science research project. Message: one tool outlasted several student cohorts, which answers the "student turnover slows us down" objection.
   - Carleton: a language-placement dashboard where the project was longer than any student's time at the college, so the squad sketched the database and chose the visualization (heatmaps) for the development team instead of building it. Message: scoping and advising.
   - UCLA: `wbcheck`, a Carpentries lesson checker. Two students started it in 2023; in 2026 it was rebuilt with AI assistance and now has 48 documented rules and a citation file crediting the original authors.
   - UCLA: the UC OSPO education site. A 55-lesson catalog, and two students built the search and the site on it, with a student project manager.
2. **Alumni chart.** The chart now shows 19 UCLA alumni by current job category (11 data/analytics/consulting, 4 software/IT, 2 research/graduate school, 2 nonprofit/public sector). Plan: two bars, one per school, same categories and same "current job" definition, each labeled with its own n. Carleton data was requested from Paula and may not arrive. Rule: if it has not arrived by about Oct 16, cut the chart or label it "UCLA only" (I lean toward cutting).
3. **Open decisions:** whether to name students on a printed poster (needs their consent); whether to add a student quote or photo; whether to add a diagram of the model.

## Questions

### A. Approach
1. Given one week, a single builder, and coauthors who edit text in Git, is the plain-text Typst pipeline the right call, or would you hand-design in a layout tool? Give a clear recommendation and the one condition that would flip it. If there is a hybrid (for example, design the poster as a Typst or SVG layout but export the hand-drawn diagram and photo frames from a design tool), describe it concretely.
2. What are the top three risks in this pipeline for a large-format print (fonts, image resolution at 44 inches, PDF/X or color profile, bleed, print shop expectations, Zenodo upload size), and how do I verify each before Oct 21?

### B. Layout
3. Is "three equal flowing text columns" the right skeleton for this content? Propose two or three alternative skeletons for a 44 x 44 square (for example: a central diagram with satellite panels; an asymmetric 2/3 + 1/3 split with one dominant visual; a left-to-right story that follows a student through the program; a grid of unequal panels). For each: sketch it in words with approximate proportions, what goes where, and how well it survives a text-only editing workflow.
4. What would a central diagram show to carry the "students are the tool and also a product" idea in about five seconds? Describe the shapes, labels (6 words or fewer each), and flow. Can it be built in Typst or SVG in under a day?
5. Does the central idea currently get enough visual weight? Where does it sit and how big should it be relative to the title?
6. Reading order and distance: at 4 to 6 feet, what does a viewer read first, second, third now, and what should they read? Give minimum point sizes for title, section heads, body, chart labels, and QR code size and quiet zone.
7. How should two institutions be given equal presence visually without a split-screen cliché (two logos, two colors, a shared center)? Note the network has one logo and each school has its own brand colors (UCLA blue and gold, Carleton blue and maize), which Tim would use only as thin local accents.

### C. "Not AI-looking" design
8. Rank the specific tells in the current design that read as generated or templated, and for each give the smallest change that removes it.
9. Name 6 to 8 buildable, hand-made-feeling moves with cost in hours, ordered by impact per hour. Consider: scale contrast in type, a real hand-drawn or photographed element, annotated screenshots of the actual tools (wbcheck output, the UC OSPO site, the scraper's folder tree), an honest timeline across both schools, one large student quote, deliberately uneven whitespace, rule lines and marginalia used in academic posters, a single strong accent used with discipline.
10. How should we get student voices and photos in one week (consent, who asks, what format, image resolution for 44 inches)? Suggest the lightest viable approach.

### D. Plan
11. Give a day-by-day plan, Oct 12 through Oct 21, of what to build and decide in priority order, assuming Tim has about two hours per day. Mark the point of no return for sending to print.
12. What would a skeptical poster-session reviewer flag first at 4 to 6 feet?

### E. Output format
Answer in this order: (1) a three-sentence verdict on the approach; (2) numbered answers; (3) the ten-line plan for the week; (4) a confidence score 0 to 100 on your verdict and the single unknown that would change it most.
