# External validation request: conference poster content and design

You are reviewing a printed academic conference poster before it goes to print. You have no prior context, so everything you need is below. Please be specific and blunt. I will check each of your claims against the files before changing anything, so say which claims you are sure of and which are guesses.

## What this is

- **Poster:** "Is the DataSquad Model For You?" for US-RSE '26 (US Research Software Engineer Association conference, San Jose, poster reception Monday Oct 19, 2026). Printed at most 44 x 44 inches, square. A PDF also goes to Zenodo and the conference proceedings.
- **Presenters:** Paula Lackie and Oliver Hall (Carleton College DataSquad), Tim Dennis and Leigh Phan (UCLA Library Data Science Center DataSquad).
- **Audience:** research software engineers, research computing and library staff, and supervisors of student workers who might start a student-staffed data and software support team on their own campus.
- **The model:** a DataSquad is a team of paid undergraduate analysts who help researchers work with data. It started at Carleton College and runs at UCLA. A network called DataSquad International (datasquad.info) supports other institutions adopting it. Paula's core claim, which the poster is built around: the mindset shift from using student labor as a means to deliver a service to treating the development of skilled students as itself a primary service. Students are the tool and also a product of the service. Trained students carry good practice into labs and offices across campus.
- **Goal for the poster:** attract supervisors of student workers to compare obstacles and solutions, and send them to the starter kit on the website.

## Already decided, please do not relitigate

- Format is one 44 x 44 inch page, built with Quarto + Typst, text editable in plain files by coauthors.
- Brand colors and font come from the project website and stay: navy #1D3557, steel blue #457B9D, orange #F9AE1A, canvas #F8F9FA. Font is Atkinson Hyperlegible (chosen for low-vision legibility). Accessibility is a priority.
- The title stays as is.
- The logo is the existing DataSquad International mark (a gray hexagon with a globe).

## The poster text exactly as it prints (Quarto markdown)

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

Data behind the chart (data/outcomes.csv, aggregates only): Data / analytics / consulting 11; Software / engineering / IT 4; Research / graduate school 2; Nonprofit / public sector 2. Total 19. These are UCLA DataSquad alumni whose current job category Tim checked on LinkedIn. It is not every UCLA alumnus. Carleton alumni data has not arrived yet.

Header text (above the columns): eyebrow "US-RSE '26 poster, DataSquad International"; title; subtitle "Student-staffed data and research software support that trains the people who deliver it"; the four presenter names; affiliations "Carleton College DataSquad | UCLA Library Data Science Center DataSquad". Footer: "US-RSE '26, San Jose, Poster reception, Monday Oct 19" and "datasquad.info". A QR code points to datasquad.info/join.

## Current visual design (what you would see in the attached PNG, if I attached it)

- Square page, canvas-gray background (#F8F9FA).
- Full-width navy rounded hero band at top: small orange letter-spaced uppercase eyebrow, very large white bold title, light-gray-blue subtitle, white bold author line, orange affiliation line. The logo sits at the right on a white rounded tile. A thin orange rule runs under the band.
- Below it, three equal flowing text columns (text flows top to bottom, then to the next column).
- Each level-1 section heading is a white card strip with a 10 pt steel-blue top border and a thin light-gray outline, with navy bold heading text. Sub-headings are navy bold text.
- Body text 44 pt Atkinson Hyperlegible, left aligned, dark slate. Bullets use small orange squares. Bold text is navy.
- One callout box with a pale orange fill holds the central idea.
- The chart is a single horizontal stacked bar (navy, steel, orange, light blue) with big white or navy counts and a legend below it, in a white rounded box.
- Navy footer bar with white and orange text.
- There are no photographs, no diagrams other than the stacked bar, and no student faces. Roughly one third of the page is whitespace at the bottom of column three.

## Questions

### A. Content

1. **30-second test.** From the title, subtitle, section headings, and the callout alone, what would a passerby think the poster claims? Does that match the central claim above? Rewrite the three most important lines if not.
2. **Audience fit.** Would a research software engineer or a supervisor of student workers find this credible and useful? What question would they ask first that the poster does not answer (for example cost, student pay, how much supervisor time, what happens with confidentiality, how quality is controlled)?
3. **Overclaims and gaps.** Flag any statement that overreaches the evidence. In particular: the chart is n=19 UCLA alumni by current job category, not a cohort outcome study; the wbcheck example says it was extended in 2026 with AI assistance (the conference has an AI-use policy and asks for disclosure); the "helicopter flight data" example is the one known case of a client reusing our code. What evidence would a skeptic want that we could plausibly add in under a week?
4. **Missing pieces.** Paula's planning notes also wanted: a flowchart or Sankey of student demographics to career outcomes, sustainability (which varies a lot by institution), and example project sites. Which of those, if any, would most improve the poster, and which would just add clutter?
5. **Structure.** Is the order of sections right (gap, central idea, what a DataSquad is, who is on a squad, what squads have built, where students go, start one)? Propose a better order if not.
6. **Abstract.** Here is the suggested abstract (about 230 words) for the proceedings. Is it adequate as a standalone description? What would you cut or sharpen?

```
> A DataSquad is a team of paid undergraduates who provide data and research software support and learn the work by doing it. The model began at Carleton College and now runs at UCLA, and a network, DataSquad International, supports other institutions that want to adopt it. It answers two problems at once. Campuses have limited capacity for data and software support, and students, especially those from underrepresented backgrounds, have few ways to gain practical experience in research software engineering (RSE) and data work, partly because the work is so little known.
>
> The idea that matters most is a change in mindset: developing skilled students is itself a primary service, not only a means of delivering one. Students who move on to labs and offices carry good practice with them. This poster describes the shared model (roles, services, and the limits we keep), what two programs have built, and where student alumni go. The tradeoffs are real: student turnover and learning time slow delivery, and more students means more varied projects and more oversight.
>
> We hope to meet supervisors of student workers who want to compare obstacles and solutions. We will share job descriptions, confidentiality agreements, and project management frameworks that help others start a DataSquad in their own setting, without a dedicated budget or full-time oversight.
```

### B. Style and design: Tim wants this NOT to look AI-generated or templated

Tim's words: he is interested in non-AI design, however we accomplish that. Treat that as the main design brief.

7. **AI and template tells.** List specific visual tells in the design above that make it read as generic AI-generated or SaaS-dashboard output (for example: uniform rounded cards, identical heading treatments, evenly weighted three columns, safe corporate navy and orange, a single stacked bar as the only graphic, tidy symmetry, no imperfection). Rank by how much each hurts.
8. **Concrete non-AI moves.** Give 6 to 10 specific, buildable changes, ordered by impact per hour of effort, assuming one week and a Typst/Quarto pipeline that coauthors edit as text. For each, say what changes visually and what it costs. Think about: strong typographic hierarchy and scale contrast, asymmetric or non-column layout, a real hand-drawn or diagrammatic explanation of the model (students in, service out, trained students out to campus), annotated examples, photographs of actual students at work, a timeline, pull quotes from students, using the whitespace deliberately, academic poster conventions that people in this community recognize.
9. **What to keep.** Which parts of the current design are already working and should not be touched?
10. **Poster-at-a-distance.** At 44 inches square, viewed from 4 to 6 feet, which elements are too small or too weak? Give minimum point sizes you would use for title, section heads, body, captions, and the chart labels.
11. **Accessibility.** Any contrast, color-only encoding, or type problems for low-vision or color-blind viewers? The chart colors are navy, steel, orange, and light blue with a text legend.

### C. Output format

Please answer in this order: (1) three-sentence overall verdict; (2) numbered answers to the questions above; (3) a prioritized list of the top 5 changes you would make this week; (4) a confidence score from 0 to 100 for your overall verdict and the one thing that would most change it.
