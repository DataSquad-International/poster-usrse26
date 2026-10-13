# Job classification v1 (approved by Tim 2026-10-13; shared with Carleton for coding)

One scheme for both schools, so UCLA and Carleton alumni are coded the same way. It builds on O*NET-SOC and keeps four questions separate, because mixing them was the main fault the outside reviewer found in our first six-group draft.

## What gets recorded for each person

| Field | Values | Rule |
|---|---|---|
| `current_title`, `employer` | free text | As shown on the profile. |
| `evidence`, `checked_date`, `coder` | free text, date | Source (LinkedIn, school page), date seen, who coded. Profiles change; date every check. |
| `soc_code` | an O*NET-SOC code, or `none` | Pick from `soc-rollup.csv` when it fits. If no listed code fits, search onetonline.org, write the code, and add it to the table. |
| `occupation_group` | A to E, or `unknown` | Derived from `soc_code` through `soc-rollup.csv`. Do not choose it freehand. |
| `study_status` | `none`, `grad_full_time`, `grad_part_time`, `undergrad` | Is the person enrolled in a degree program now? |
| `sector` | `private`, `nonprofit`, `government`, `higher_ed`, `self_employed`, `none` | Employer type. Never changes the occupation group. |
| `data_work` | `yes`, `no`, `unclear` | Profile documents regular analysis, programming, or data management inside a job whose code is not itself a data or software code. |
| `confidence` | `high`, `medium`, `low` | Low means two coders could reasonably differ. |
| `notes` | free text | Conflicts, things to recheck. |

## Occupation groups

- **A Data, statistics and actuarial.** Data scientists, statisticians, biostatisticians, operations research, business intelligence, actuaries.
- **B Software and IT.** Software developers, systems analysts, database and data engineers, administrators, GIS technologists, security.
- **C Business, finance and consulting.** Management analysts, financial analysts, fundraisers and fundraising managers, marketing, operations.
- **D Research, science and teaching.** Research roles, epidemiology, survey research, lab science, instructors and faculty.
- **E Public service, community and other.** Library and information work, social and community services, government program staff, arts, law, health care delivery, anything not above.
- **unknown.** Not enough evidence yet. Shown as a count, left out of shares.

## Poster category (derived, not coded)

1. If `study_status` is `grad_full_time` and the person has no full-time job outside the university: **Graduate or professional study**. Part-time degrees and university research jobs held by a student do not trigger this.
2. Otherwise the person's **occupation group** A to E, or unknown.

Each person counts once. `data_work` and `sector` are extra detail for the data file and are never added to the poster counts.

## One main code, no secondary group

Each person gets exactly one occupation code and group. There is no "also" group. What used to be a second group is recorded in two other fields instead: `sector` (where they work) and `data_work` (whether the job documents regular analysis or programming). If a second code is plausible, name it in `notes` and set `confidence` to `low`.

## How to choose the code when a job mixes work

Follow the SOC manual: code the occupation that needs the greater skill; if the skills are about equal, the one that takes more time. A profile rarely shows time, so use the title plus the first listed duties, mark `confidence: low`, and record the other plausible code in `notes`. Set `data_work: yes` when the profile documents analysis or programming in a job that is not itself a data or software code.

Do not let a keyword decide. "Development operations" at a nonprofit is fundraising, not software. "Consultant" is Management Analysts only if the duties are advisory; a technical consultant who builds data systems takes the code for what they build.

## Starting examples from the UCLA sheet

| Title | Code | Group | Notes |
|---|---|---|---|
| Data Engineer, health company | 15-1243.00 | B | `data_work: yes`; computer occupation |
| Actuarial analyst, insurer | 15-2011.00 | A | |
| Development operations supervisor, nonprofit | 13-1131.00 | C | Fundraisers; `data_work: yes`; could be 11-2033.00 if the role directs staff and strategy, so `confidence: medium` |
| Consultant, IT services firm, builds data architecture | 13-1111.00 or 15-1211.00 | C or B | `confidence: low`; this is the ambiguous case, decide as a pair of coders |
| Master's student with research assistantship | none | Graduate or professional study | `study_status: grad_full_time` |

## Agreement check before the numbers go on the poster

Two coders code the same 20 people (10 per school, include the ambiguous ones) from the same evidence, without seeing each other's answers or the old labels. Report how often they agree on `soc_code`, on `occupation_group`, and on `data_work`, with the disagreements listed. Settle each disagreement into a written rule above and recode. 18 of 20 on group is a sensible target for a pilot, not a validated standard.

## Known gaps

- SOC has no clean code for student research assistants (19-4061.00 Social Science Research Assistants fits some).
- Alumni 15 to 20 years out hold senior jobs; one scheme still works, but do not read school differences as program effects. Class year and seniority differ.
- Codes were checked against onetonline.org on 2026-10-13. Re-check any added code the same way.
