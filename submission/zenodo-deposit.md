# Zenodo deposit for the poster PDF (draft, DOI reserved, not published)

**Reserved DOI: 10.5281/zenodo.23381638** (draft record, not published yet). It is in the poster footer (`poster-doi` in `poster.qmd`) and in `CITATION.cff`. It resolves only after the record is published.

Goal: one Zenodo record that holds only `poster.pdf`, with a DOI we can print on the poster, kept as a draft until camera-ready (Wed Oct 21, 2026).

## Why not the GitHub release route

Zenodo's GitHub link archives the whole repository (source, scripts, fonts) and publishes the moment a release is published. It cannot hold "just the PDF" and it cannot stay a draft. A GitHub draft release does not trigger Zenodo at all. Use a direct Zenodo upload instead, and link it to the repository in the metadata.

## Steps (in the Zenodo web page, signed in as the depositor)

1. New upload. Add `poster.pdf`. Use the current draft PDF as a placeholder; replace it before publishing. Do not click Publish.
2. Resource type: **Poster**.
3. Fill the fields below.
4. Click **Reserve DOI** (under Digital Object Identifier). The DOI is fixed from then on. Save as draft.
5. Put the DOI on the poster (footer or next to the QR code) and in `CITATION.cff`, render, and replace the file in the draft.
6. After camera-ready: set `poster-draft: false` in `poster.qmd`, render, check `pdfinfo` (one page, 3168 x 3168 pt), replace the file in the draft, then publish. Published files cannot be changed; later fixes become a new version of the same record.

## Fields (complete; paste into the Zenodo form)

The same record as JSON is in `submission/zenodo-metadata.json` (Zenodo API `metadata` object), for scripting or for checking the form.

| Field | Value |
|---|---|
| Resource type | Poster |
| Title | DataSquad: An entry point for RSE (matches the poster; confirm it is also the title printed in the US-RSE program) |
| Additional title (type: Subtitle) | Student RSE model for research support, experiential learning, and technical workforce development |
| Publication date | 2026-10-19 (poster reception) |
| Authors, in poster order | Lackie, Paula (Carleton College; ORCID 0000-0002-0819-2858). Hall, Oliver (Carleton College; no ORCID given, leave blank unless he has one). Dennis, Tim (UCLA Library Data Science Center; ORCID 0000-0001-6632-3812). Phan, Leigh (UCLA Library Data Science Center; ORCID 0000-0002-8605-1444) |
| Description | The abstract below. Use the version submitted to EasyChair if it differs |
| License | Creative Commons Attribution 4.0 International (CC BY 4.0) |
| Keywords | DataSquad; research software engineering education; student workforce development; data services; research support |
| Language | English |
| Version | 1.0 |
| Meeting: title | US-RSE '26 |
| Meeting: acronym | US-RSE '26 |
| Meeting: website | https://us-rse.org/usrse26/ |
| Meeting: dates | 19-21 October 2026 |
| Meeting: place | San Jose, California, USA |
| Meeting: session | Poster reception |
| Meeting: session part | Monday 19 October 2026, 5:30-7:30 pm |
| Related works | https://github.com/DataSquad-International/poster-usrse26 : is supplemented by (software). 10.5281/zenodo.23329531 (wbcheck) : references. 10.5281/zenodo.23330022 (UC OSPO Education site) : references |
| Notes | Poster presented at the US-RSE '26 poster reception, San Jose Marriott. Source: https://github.com/DataSquad-International/poster-usrse26. AI assistance: Claude (Anthropic) helped write the layout code and some wording, and Gemini Notebook generated the drawings the icons were traced from. The authors reviewed the output and are responsible for the content. |
| Digital Object Identifier | Already reserved: 10.5281/zenodo.23381638. Leave as is |

Conference details come from https://us-rse.org/usrse26/program/ (Mon Oct 19 to Wed Oct 21, 2026; poster reception Mon Oct 19, 5:30 to 7:30 pm, San Jose Ballroom Salon 3 and 4, San Jose Marriott).

### Description (abstract)

A DataSquad is a team of paid undergraduates who provide data and research software support and learn the work by doing it. The model began at Carleton College and now runs at UCLA, and a network, DataSquad International, supports other institutions that want to adopt it. It answers two problems at once. Campuses have limited capacity for data and software support, and students, especially those from underrepresented backgrounds, have few ways to gain practical experience in research software engineering (RSE) and data work, partly because the work is so little known.

The idea that matters most is a change in mindset: developing skilled students is itself a primary service, not only a means of delivering one. Students who move on to labs and offices carry good practice with them. This poster describes the shared model (roles, services, and the limits we keep), what two programs have built, and where student alumni go. The tradeoffs are real: student turnover and learning time slow delivery, and more students means more varied projects and more oversight.

We hope to meet supervisors of student workers who want to compare obstacles and solutions. We will share job descriptions, confidentiality agreements, and project management frameworks that help others start a DataSquad in their own setting, without a dedicated budget or full-time oversight.

This is the suggested revision from `submission/usrse26-submission.md`, not necessarily the text submitted to EasyChair. Replace it with the submitted text if they differ.

## Still open (only you can settle these)

- Oliver Hall's ORCID, or confirm he has none.
- Which abstract was submitted to EasyChair.
- Whether the US-RSE program prints the same title as the poster.
- The author list: `CITATION.cff` still lists Nakahata and no Hall.

## Check before reserving

- Authors: the poster byline is Lackie, Hall, Dennis, Phan. `CITATION.cff` lists Lackie, Phan, Dennis, **Nakahata**, and no Hall. One of them is wrong. Settle the author list with Paula first, because Zenodo authors are shown on the record and hard to change after publishing.
- `CITATION.cff` is stale: title is the old one, `type` is `software`, and the license is BSD-3-Clause (the code license). After the DOI exists, update the title, the author list, add `doi:`, and keep the content license (CC BY 4.0) in the Zenodo record. Do not change the repository code license.
- The poster contains a third-party photo (Chris Yarzab, CC BY 2.0). Its credit line is on the poster, so a CC BY 4.0 poster is fine. Keep the credit.
- Do not upload the alumni data, the xlsx, or anything in `data/`. The deposit is the PDF only.
- The PDF should have no DRAFT tag in the published version.
