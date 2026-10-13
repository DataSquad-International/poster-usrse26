# Validation prompt: US-RSE '26 poster, copy, and the credit-and-release process (2026-10-12)

You are an outside reviewer with no prior context. Please critique what is described below and give concrete, ranked corrections with a confidence score for each. Do not reply with general praise or "thoughts".

## 1. The project and audience

A conference poster, "Is the DataSquad Model For You?", for US-RSE '26 (the US Research Software Engineer association conference, San Jose, poster reception Monday Oct 19 2026, camera-ready Wed Oct 21, maximum 44 x 44 inches, PDF also deposited on Zenodo). Presenters: Paula Lackie and Oliver Hall (Carleton College DataSquad), Tim Dennis and Leigh Phan (UCLA Library Data Science Center DataSquad). A DataSquad is a team of paid undergraduates who do data and research-software support work and learn by doing it. The audience is research software engineers, library and IT staff, and supervisors of student workers, deciding whether to start a squad.

The poster is plain text (Quarto + Typst) so coauthors can edit words in Git. Style follows the program website: navy, steel blue, orange, Atkinson Hyperlegible, no raster images. It is a single page of 3168 x 3168 pt.

## 2. Already decided: do not relitigate

- Triptych of three panels under a central model diagram.
- Alumni outcomes shown as counts only. No alumni names, employers, or personal data on the poster or in the repository.
- Carleton and UCLA get equal presence.
- The central line "Students are not just the tool. They are a beneficial product of the service." is Paula's own sentence from her abstract. I am asking whether to propose an alternative to her, not to overrule her.
- Staff role is shown as a pair, "supervision and mentoring".
- Code license BSD-3-Clause, content CC-BY-4.0, font SIL OFL.

## 3. Current poster text (verbatim, from poster.qmd)

Title: Is the DataSquad Model For You?
Subtitle:
  A DataSquad is a team of paid undergraduates who learn data and software work by doing it,\
  and show researchers how to do theirs better.

Authors line: Paula Lackie, Oliver Hall, Tim Dennis, Leigh Phan
Affiliations line: Carleton College DataSquad | UCLA Library Data Science Center DataSquad

Body (markdown; ::: lines place blocks; the model diagram, drawn as shapes, reads: Research requests -> Paid student project work -> Useful research support and Skilled students; "Staff supervision and mentoring" feeds the work box; caption "Good practice travels to labs and offices across campus"):

::: {.cells columns="1fr 2fr" gutter="70pt"}

::: {.cell}
::: {.lede}
Students are not just the tool. They are a beneficial product of the service.
:::

Campuses need more data and software help than staff can give. Students want real experience, and many don't know this work exists, especially students from underrepresented backgrounds. A squad does both jobs at once.
:::

::: {.cell}
```{=typst}
#model-diagram()
```
:::

:::

::: {.cells columns="1fr 1.3fr 1fr" gutter="70pt"}

::: {.cell}
# A paid job that teaches

Students are paid employees, supervised by library or department staff. They help researchers with data from wrangling to reproducibility.

## Who is on a squad

- Student **data analysts** do the hands-on work.
- A student **project manager** triages requests.
- Student **technical writers** document projects.
- **Staff** supervise and mentor, fund, and sustain the squad.

## Limits we keep

We help with a researcher's data and code. We don't change their research questions, tutor their students, or share what we learn in confidence.

## What slows us down

Student availability, the academic calendar, onboarding, review, and graduation handoffs all slow the work. More students take on more varied projects but need more oversight. Handbooks, templates, and staff are what stay when students graduate.
:::

::: {.cell}
# What the work looks like

Some projects end as public code, others as a dashboard or a sketch. Not every client needs a public repository.

::: {.carleton}
**Election-news scraper.** Nine students started, extended, or used it from 2021 to 2024 to collect broadcast transcripts for a political science project. **The tool outlasted the students who began it.**
:::

::: {.ucla}
**wbcheck.** Students began this Carpentries lesson checker in 2023, and it evolved as we learned what collaborative lesson development takes. In 2026 staff filled in the code with AI assistance. It has 48 documented rules, tests, a BSD-3 license, and a citation file crediting its student authors ([doi:10.5281/zenodo.23329531](https://doi.org/10.5281/zenodo.23329531)).
:::

::: {.carleton}
**Language placement dashboard.** The project ran longer than any student would stay, so the squad sketched the database and chose heatmaps for the development team to build.
:::

::: {.ucla}
**UC OSPO education site.** Students built the lesson pages and search for a catalog of 55 open source lessons. It has a citation file and a DOI ([doi:10.5281/zenodo.23330022](https://doi.org/10.5281/zenodo.23330022)) crediting its developers.
:::

```{=typst}
#v(30pt)
```

**Research software habits, when the project needs them.** Run instructions, a dependency list, one test, a citation file. We don't treat them as a checklist, and we plan to track whether clients keep them.
:::

::: {.cell}
# Where students go next

We located 19 UCLA former student employees. By current job category (public profiles, 2026):

```{=typst}
#outcomes-list("data/outcomes.csv")
```

Descriptive, not a placement rate.

# What adopting takes

- Paid student positions and a wage budget
- A supervisor with time to review and mentor
- Onboarding, and somewhere to keep documentation
- A plan for turnover

# Start one

The starter kit covers roles, a confidentiality agreement, onboarding, and request tracking. Ask us for sample job descriptions. Supervise students? Tell us your hardest obstacle.

::: {.cells columns="3.6in 1fr" gutter="36pt"}

::: {.cell}
::: {.block fill="white" inset="0pt" radius="4pt"}
![](assets/qr-datasquad-info.svg){width=3.6in}
:::
:::

::: {.cell}
::: {.url}
[datasquad.info/join](https://datasquad.info/join)
:::
:::

:::
:::

Alumni counts file (data/outcomes.csv): Data / analytics / consulting 11, Software / engineering / IT 4, Research / graduate school 2, Nonprofit / public sector 2 (UCLA only, public profiles, 2026). Carleton counts are not available yet, and a line saying so was removed.

## 4. What we did this session (process)

1. Published two software releases with DOIs so the poster can cite them.
   - wbcheck (Carpentries lesson checker), v0.3.1, concept DOI 10.5281/zenodo.23329531. Source history: first commit 2023-09-01 by a student; about 36 commits by that student, 1 by a second student, 90 by Tim Dennis (2026 implementation, AI-assisted). No commits at all from the other people credited.
   - UC OSPO education site, v0.1.0, concept DOI 10.5281/zenodo.23330022.
2. Authorship decisions stamped into the DOI records (permanent, via CITATION.cff read by Zenodo):
   - wbcheck CITATION.cff authors (8): Lawrence Lee (UCLA DataSquad, ORCID); Eric Huang (UCLA DataSquad); Tim Dennis (UCLA Library Data Science Center, ORCID); Zhiyuan Yao (UCLA Library); Loretta Hu (UCLA Library); Hyerin Lee (UCLA Library); Emily Gong (UCLA Library); Madeline Kim (UCLA Library)
   - Education site CITATION.cff authors (10): Shawn Wang (UCLA Library Data Science Center); Gianna Kim (UCLA Library Data Science Center); Garv Sharma (no affiliation listed); Gauri Rathi (no affiliation listed); Ved Patel (no affiliation listed); Reid Otsuji (UCSD Library, ORCID); Laura Langdon (UC OSPO); Lauren Reyes (UCSD); Karla Padilla (UC San Diego Open Source Program Office); Tim Dennis (UCLA Library, ORCID)
   Rationale given by the project lead: wbcheck "evolved over time as we discovered what collaborative lesson development entailed," so the 2023 program team was listed as authors, not only the people who committed code. Students were listed first on the education site because they built most of it. The lead stated that consent to publish is a condition of the students' employment, so no separate consent was collected. Some affiliations and one name spelling were inferred from commit history and photo filenames and are unverified.
3. Added a CREDITS.md with CRediT (Contributor Roles Taxonomy) roles to each repo, because CFF has no role field. Roles are inferred from commit history and program titles and are labelled draft.

wbcheck CREDITS.md:
# Credits

Contributor roles use the [CRediT taxonomy](https://credit.niso.org/) (Contributor Roles Taxonomy, ANSI/NISO Z39.104-2022). Authors for citation are in [CITATION.cff](CITATION.cff). CFF has no role field, so roles live here.

wbcheck began in 2023 and evolved as the UCLA-IMLS Lessons for Librarians in Open Science program learned what collaborative lesson development involves.

| Person | Role in the project | CRediT roles |
|---|---|---|
| Lawrence Lee | UCLA DataSquad student, 2023 onward | Conceptualization, Methodology, Software |
| Eric Huang | UCLA DataSquad student | Conceptualization, Methodology |
| Tim Dennis | Program Director, UCLA Library | Project administration, Supervision, Software (2026 implementation, AI-assisted) |
| Zhiyuan Yao | Program Coordinator | Project administration |
| Loretta Hu | Lesson Infrastructure Developer | Software (program infrastructure), Writing - original draft (documentation) |
| Hyerin Lee | UCLA-IMLS program team | Software (program website) |
| Emily Gong | UCLA-IMLS program team | Software (program website) |
| Madeline Kim | UCLA-IMLS program team | Writing - original draft (lesson content) |

Draft: roles are inferred from commit history and program records. Each person should confirm their own roles before a release is cited.


Education site CREDITS.md:
# Credits

Contributor roles use the [CRediT taxonomy](https://credit.niso.org/) (ANSI/NISO Z39.104-2022). Authors for citation are in [CITATION.cff](CITATION.cff). CFF has no role field, so roles live here.

| Person | CRediT roles |
|---|---|
| Shawn Wang | Software |
| Gianna Kim | Software |
| Garv Sharma | Software |
| Gauri Rathi | Software |
| Ved Patel | Software |
| Reid Otsuji | to confirm |
| Laura Langdon | to confirm |
| Lauren Reyes | to confirm |
| Karla Padilla | to confirm |
| Tim Dennis | Software, Supervision, Project administration |

Draft: roles are inferred from commit history. Each person should confirm their own before the release is cited. Author order in CITATION.cff lists the student developers first, then the UC OSPO and UC library contributors.


5. Fixed a GitHub branch-protection problem: a required status check was path-filtered and never ran on docs-only pull requests, so they showed as blocked. Removed the path filter instead of loosening protection.
6. Added a vector trace of the program logo (the only source was a 215 px PNG) as the header mark and a faint full-page watermark, and moved the DRAFT marker to a footer tag.
7. Reworded panel headings: "A paid job that teaches", "What the work looks like", "Where students go next", and rewrote several sentences to be less abstract.

## 5. Specific challenges (answer each, with a confidence 0 to 100)

A. Poster copy and design
1. Does the text read as written by a person, or does it still show template or AI patterns? Quote the three weakest sentences and rewrite them.
2. Does a person walking past understand in ten seconds what a DataSquad is and why it matters? Is the subtitle the right place for the definition? Rewrite it if not.
3. The subtitle says students "show researchers how to do theirs better", while the panel "Limits we keep" says "We don't change their research questions, tutor their students, or share what we learn in confidence." Is that a contradiction an attentive reader would catch? Suggest wording that keeps both true.
4. The wbcheck example says "In 2026 staff filled in the code with AI assistance." Is that honest and clear for an RSE audience skeptical of AI, or does it need more or less? Does the example claim more than the evidence supports?
5. The "What adopting takes" list and the closing line "Supervise students? Tell us your hardest obstacle." Is the call to action strong enough for a conversation-driven poster session?
6. Viewing distance: on a 44 in poster read from about 5 feet, is the information hierarchy right? What would you cut or enlarge?
7. The alumni panel shows counts for UCLA only. The poster promises equal presence for both schools. How would you handle a half-empty comparison honestly if Carleton data does not arrive by Oct 14?

B. Credit and release process
8. Is it sound to list people as authors on a permanent DOI who made no commits (a program coordinator, students who worked on the surrounding website and docs) on the strength of "the project evolved with the program"? Where is the line between author, contributor, and acknowledgment under CRediT and under common research-software citation practice? Be specific about what could embarrass the project or the individuals.
9. Is inferring CRediT roles from commit history, then publishing them as a draft, acceptable, or should each person confirm first? Is relying on employment terms in place of explicit consent defensible for public credit? What would you do instead, concretely and quickly?
10. Author order: students first (education site) versus original-authors-first (wbcheck). Which convention would a reviewer expect, and does mixed ordering across two repos look inconsistent?
11. Concept DOI versus version DOI in CITATION.cff and on the poster: which should a poster cite? Is releasing first and adding the DOI to CITATION.cff afterward in a follow-up pull request fine, or does the archived release carry stale metadata?
12. Is a separate CREDITS.md with CRediT roles the right place, or would an .all-contributorsrc, a CONTRIBUTORS file, or Zenodo contributor metadata (DataCite types) be better? What do Zenodo and Google Scholar actually read?

C. Risks and next steps
13. What are the three biggest risks to the poster or the credit decisions before Oct 21, ranked? What single action reduces each?
14. What is the most important thing we have not thought about?

## 6. Output format

Give a table: item number, finding, severity (high, medium, low), concrete fix, confidence. Then a short ranked "do this first" list of at most five items.
