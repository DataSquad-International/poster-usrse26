# Validation capture: poster layout and outcomes visualization

Prompt: `2026-10-13-validation-prompt-poster-layout-and-outcomes-viz.md`. Reviewer: an external chat model (response pasted 2026-10-13). Status: adjudicated by Claude, awaiting Tim's sign-off. Nothing below has been applied yet.

## Verified against our files

- Mock has 19 UCLA alumni plus 1 current student, 114 Carleton alumni (14 unclassified) plus 6 current students. The reviewer is right; the prompt text "20 alumni plus 1 current student" was our error.
- Mock UCLA has 6 "also" assignments against 2 in the real data; the mock 2024 legacy split is 4 data and 1 software, the real one is 4 data and 1 nonprofit. Both are mock artifacts.
- Mock puts Management Analysts (13-1111.00) in both group 3 (11 rows) and group 5 (5 rows): group cannot be derived from code. Real flaw.
- O*NET codes checked against onetonline.org on 2026-10-13: all 19 codes we use resolve to the titles in the reviewer's table, including 15-1299.02 (full title "Geographic Information Systems Technologists and Technicians") and 13-2051.00 ("Financial and Investment Analysts"). The mock script truncated two titles.

## Adjudication

| # | Claim | Verdict | Where it lands |
|---|---|---|---|
| 1 | Keep the count list, no chart; Sankey rejected (no first job, Carleton blank, one-person ribbons, implies a pathway) | ADOPT | poster stays a list; no Sankey |
| 2 | UCLA-only snapshot if Carleton is blank, with a plain "not assessed" line | FALLBACK ONLY | Tim: Carleton's lookup is under way, so design for both schools (mock stands in); use this only if the data is not in by the freeze |
| 3 | Separate occupation, study status, employer sector, and a data-function tag; further study is not an occupation | ADOPT in principle | taxonomy redesign, Tim to pick the poster display |
| 4 | Coarse poster display (data, software/IT, other, insufficient info) | DEFER | Tim: too coarse for 19 people? |
| 5 | Each SOC code gets one documented default rollup; overrides recorded | ADOPT | rollup table in `taxonomy/`; fixes the 13-1111 split |
| 6 | Count each person once; never show primary plus also as exclusive counts | ADOPT | chart rule |
| 7 | Matcher: candidates, evidence, human selection, versioned lookup, extra fields, 20-person agreement pilot | ADOPT later | fields in sheet; pilot after Oct 21 |
| 8 | Fix the mock: 19+1, 14 unclassified, fewer "also", example.org emails and links, full SOC titles | ADOPT | `make_mock_outcomes.py` |
| 9 | Our prompt exposed UCLA year-by-category cells (single nonprofit people in 2024 and 2026) | ADOPT, our own risk | remove year-by-category cells from the prompt and any committed file |
| 10 | "Start one" in a distinct orange-headed box | DEFER | Tim looks at a render |
| 11 | Cut the "Some projects end as public code" intro paragraph in the middle column | DEFER | Tim; overlaps the closing paragraph |
| 12 | Remove the full-page watermark | DEFER | Paula asked for it; try lower opacity first |
| 13 | Equal-size school identifiers in the header | DEFER | Tim and Paula |
| 14 | Outcomes panel should say UCLA explicitly | ALREADY DONE | panel text says "19 UCLA former student employees" |
| 15 | Body 42 pt is fine; check with an actual-size printed crop | ADOPT | print proof task |
| 16 | Next data to collect: squad role, term dates, project practices before major | NOTE | hub task |
| 17 | Cohort-by-category cells risk re-identification; no per-person marks | ADOPT | no per-person marks on the poster |
