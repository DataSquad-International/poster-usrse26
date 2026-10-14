#!/usr/bin/env python3
"""Propose job classification v1 categories for Carleton alumni who have a raw job title but no category yet.

Reads  data/alumni-combined.csv   (python3 -I scripts/build_unified.py --combined)
Writes data/carleton-title-coding-proposal.csv   (local only; person_id and title, no names or employers)

This is a PROPOSAL for a coder to review. Rules are first match wins. Where a title alone cannot decide
(no employer, no duties), the row is left uncoded and marked needs_review. Nothing here changes the poster counts.
Standard library only.
"""
import csv, re, pathlib, collections

ROOT = pathlib.Path(__file__).resolve().parent.parent
A, B, C, D, E = ("Data, statistics and actuarial", "Software and IT", "Business, finance and consulting",
                 "Research, science and teaching", "Public service, community and other")
GRAD = "Graduate or professional study"

# (regex on the lower-cased title, category, soc_code, soc_title, confidence, rationale)
RULES = [
    (r"co-founder|^founder|chief executive|\bceo\b|representative director", None, "", "", "low",
     "Founder or CEO: the title does not say what the organization does"),
    (r"undergraduate inter", None, "", "", "low", "Title looks truncated and describes a student role; profile may be stale"),
    (r"research, science and teaching/software", None, "", "", "low", "Sheet lists two categories; a coder must pick one"),
    (r"^teaching assistant$", None, "", "", "low", "Graduate teaching assistant or K-12 aide? Needs the employer"),
    (r"graduate research|predoctoral|graduate.*teaching", GRAD, "none", "grad_full_time", "medium",
     "Graduate student title; confirm full-time enrollment and no outside full-time job"),
    (r"^research assistant$", D, "19-4061.00", "Social Science Research Assistants", "low",
     "Could be a student assistantship (then Graduate study) or a research staff job; the taxonomy flags this gap"),
    (r"research professional", D, "", "Research role; code to a specific SOC", "low", "Research role, field unknown"),
    (r"assistant professor", D, "", "Postsecondary teacher; code to a specific SOC", "high", "Faculty"),
    (r"economist", D, "", "Economists (19-3011.00); add to the rollup", "medium", "Economist; social scientist"),
    (r"attorney", E, "", "Lawyers (23-1011.00); add to the rollup", "high", "Law falls under 'anything not above'"),
    (r"career prep fellow", E, "", "Career or education counseling; code to a specific SOC", "low", "Fellowship in career services"),
    (r"data scientist|quantitative researcher|machine learning lead|data & ai analyst|statistical consultant",
     None, "", "", "", ""),  # placeholder replaced below for finer rules
    (r"investment associate", C, "13-2051.00", "Financial and Investment Analysts", "medium", "Investment role"),
    (r"budget analyst", C, "", "Budget Analysts (13-2031.00); add to the rollup", "medium", "Budget analysis is business and financial operations"),
    (r"pricing insights analyst", C, "13-1111.00", "Management Analysts", "low", "Pricing analysis; could also be market research or data analysis"),
    (r"staff analyst.*(ridership|modeling)", A, "15-2031.00", "Operations Research Analysts", "medium", "Ridership analysis and modeling"),
    (r"data engineer", B, "15-1243.00", "Database Architects", "high", "Taxonomy example: data engineer is B"),
    (r"site reliab", B, "15-1244.00", "Network and Computer Systems Administrators", "high", "Reliability engineering"),
    (r"it systems engineer", B, "15-1244.00", "Network and Computer Systems Administrators", "high", "IT systems"),
    (r"systems analyst", B, "15-1211.00", "Computer Systems Analysts", "high", "Systems analyst"),
    (r"chief technology officer", B, "", "Computer and Information Systems Managers (11-3021.00); add to the rollup", "medium", "Technology executive; company unknown"),
    (r"technical program manager|principal product manager", B, "", "Computer and Information Systems Managers (11-3021.00); add to the rollup", "low", "Technology product or program management; could be C at a non-software firm"),
    (r"r&d computer science", B, "", "Computer and Information Research Scientists (15-1221.00); add to the rollup", "low", "Computer science research and development"),
    (r"software (engineer|developer)", B, "15-1252.00", "Software Developers", "high", "Software developer"),
]
FINE = [
    (r"data scientist", A, "15-2051.00", "Data Scientists", "high", "Data scientist"),
    (r"quantitative researcher", A, "15-2051.00", "Data Scientists", "medium", "Quantitative research; finance or data science"),
    (r"data & ai analyst", A, "15-2051.00", "Data Scientists", "medium", "Data and AI analysis"),
    (r"statistical consultant", A, "15-2041.00", "Statisticians", "medium", "Statistical, not management, consulting"),
    (r"machine learning lead", B, "15-1252.00", "Software Developers", "low", "ML engineering lead; could be A if the work is modeling, not software"),
]

def code(title):
    t = title.lower()
    for pat, cat, soc, st, conf, why in RULES:
        if re.search(pat, t):
            if cat is None and pat.startswith("data scientist"):
                for p2, c2, s2, st2, cf2, w2 in FINE:
                    if re.search(p2, t): return c2, s2, st2, cf2, w2
            if cat is None and "machine learning" in t:
                return B, "15-1252.00", "Software Developers", "low", "ML engineering lead; could be A"
            for p2, c2, s2, st2, cf2, w2 in FINE:
                if re.search(p2, t): return c2, s2, st2, cf2, w2
            return cat, soc, st, conf, why
    return None, "", "", "", "No rule yet for this title"

def is_confident(cat, soc, conf):
    """A proposal the build may apply without review: a category, a SOC code from the rollup, and not low confidence."""
    return bool(cat) and bool(soc) and not soc.startswith("none") and conf in ("high", "medium")

def main():
    rows = list(csv.DictReader(open(ROOT / "data" / "alumni-combined.csv", encoding="utf-8")))
    todo = [r for r in rows if r["program"] == "Carleton" and r["status"] == "alumni"
            and r["job_category_status"] == "title only, not yet coded"]
    out = []
    for r in todo:
        cat, soc, st, conf, why = code(r["job_title"])
        out.append({
            "person_id": r["person_id"], "grad_year": r["grad_year"], "job_title": r["job_title"],
            "proposed_category": cat or "", "soc_code": soc, "soc_title_or_note": st, "confidence": conf,
            "needs_review": "no" if is_confident(cat, soc, conf) else "yes",
            "rationale": why,
        })
    out.sort(key=lambda d: (d["proposed_category"] == "", d["proposed_category"], d["job_title"]))
    path = ROOT / "data" / "carleton-title-coding-proposal.csv"
    with open(path, "w", encoding="utf-8", newline="") as f:
        w = csv.DictWriter(f, fieldnames=list(out[0])); w.writeheader(); w.writerows(out)
    c = collections.Counter(d["proposed_category"] or "(left uncoded)" for d in out)
    print(f"wrote {path.relative_to(ROOT)}: {len(out)} people")
    for k, n in c.most_common(): print(f"  {n:3d}  {k}")
    print("  needs review:", sum(1 for d in out if d["needs_review"] == "yes"))
    print("  confident and in the rollup:", sum(1 for d in out if d["needs_review"] == "no"))

if __name__ == "__main__":
    main()
