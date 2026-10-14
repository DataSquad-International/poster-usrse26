# Zenodo deposit for the poster PDF (draft, DOI reserved, not published)

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

## Fields

| Field | Value |
|---|---|
| Title | Developing RSE skills at the novice level (confirm it matches the poster and the title in EasyChair, which is still "Is the DataSquad Model For You?") |
| Subtitle (use Additional titles, type Subtitle) | Student RSE model for research support, experiential learning, and technical workforce development |
| Publication date | 2026-10-19 (poster reception) |
| Authors, in poster order | Lackie, Paula (Carleton College; ORCID 0000-0002-0819-2858). Hall, Oliver (Carleton College; ORCID TODO or none). Dennis, Tim (UCLA Library Data Science Center; ORCID 0000-0001-6632-3812). Phan, Leigh (UCLA Library Data Science Center; ORCID 0000-0002-8605-1444) |
| License | Creative Commons Attribution 4.0 International (matches `LICENSE-CONTENT.md`) |
| Keywords | DataSquad; research software engineering education; student workforce development; data services; research support |
| Meeting (Conference) | Title: US-RSE '26. Place: San Jose, California, USA. Dates: TODO exact conference dates (reception is Mon Oct 19, 2026). Session: Poster reception |
| Related identifiers | `https://github.com/DataSquad-International/poster-usrse26` is supplemented by this upload (Is supplement to). `https://datasquad.info` is documented by this upload (Is documented by). Add the DOIs of wbcheck (10.5281/zenodo.23329531) and the UC OSPO Education site (10.5281/zenodo.23330022) as References, since the poster cites them |
| Language | English |
| Version | 1.0 |
| Description | Use the abstract as submitted to EasyChair. The suggested revision is in `submission/usrse26-submission.md`. Do not paste a different text here |

## Check before reserving

- Authors: the poster byline is Lackie, Hall, Dennis, Phan. `CITATION.cff` lists Lackie, Phan, Dennis, **Nakahata**, and no Hall. One of them is wrong. Settle the author list with Paula first, because Zenodo authors are shown on the record and hard to change after publishing.
- `CITATION.cff` is stale: title is the old one, `type` is `software`, and the license is BSD-3-Clause (the code license). After the DOI exists, update the title, the author list, add `doi:`, and keep the content license (CC BY 4.0) in the Zenodo record. Do not change the repository code license.
- The poster contains a third-party photo (Chris Yarzab, CC BY 2.0). Its credit line is on the poster, so a CC BY 4.0 poster is fine. Keep the credit.
- Do not upload the alumni data, the xlsx, or anything in `data/`. The deposit is the PDF only.
- The PDF should have no DRAFT tag in the published version.
