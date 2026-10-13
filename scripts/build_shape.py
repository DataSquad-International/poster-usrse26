#!/usr/bin/env python3
"""Reshape data/alumni-unified.csv into the outcome-analysis layout (local only).

Columns: FirstName, LastName, Email, GraduationYear, LinkedIn, JobClassification, Major,
plus Program, Group, CurrentPosition, Organization, AlsoClassification for charting.
Email comes from the Carleton export only (UCLA source has none). Major, Level1Group, AlsoGroup
and SOC fields are filled from the UCLA sheet as people are checked (empty until then). Output stays in data/ (git-ignored). Standard library only.
"""
import csv, pathlib

ROOT = pathlib.Path(__file__).resolve().parent.parent
RAW = ROOT / "data" / "raw" / "carleton-alumni-distribution-2025-09-15.csv"
IN = ROOT / "data" / "alumni-unified.csv"
OUT = ROOT / "data" / "outcomes-shape.csv"

def key(first, last):
    return (first.strip().lower(), last.strip().lower())

emails = {}
with open(RAW, encoding="utf-8-sig", newline="") as f:
    for r in csv.DictReader(f):
        emails[key(r["FirstName"], r["LastName"])] = r["Email"].strip()

years = []  # optional local file: UCLA class years (last_name, first_name_prefix, grad_year)
YEARS = ROOT / "data" / "ucla-grad-years.csv"
if YEARS.exists():
    with open(YEARS, encoding="utf-8", newline="") as f:
        years = list(csv.DictReader(f))

def ucla_year(r):
    for y in years:
        if y["last_name"].lower() == r["last_name"].lower() and r["first_name"].lower().startswith(y["first_name_prefix"].lower()):
            return y["grad_year"]
    return ""

cols = ["FirstName", "LastName", "Email", "GraduationYear", "LinkedIn", "JobClassification", "Major",
        "Program", "Group", "CurrentPosition", "Organization", "AlsoClassification",
        "Level1Group", "AlsoGroup", "SOCCode", "SOCTitle"]
with open(IN, encoding="utf-8", newline="") as f, open(OUT, "w", encoding="utf-8", newline="") as g:
    w = csv.DictWriter(g, cols)
    w.writeheader()
    for r in csv.DictReader(f):
        w.writerow({
            "FirstName": r["first_name"], "LastName": r["last_name"],
            "Email": emails.get(key(r["first_name"], r["last_name"]), ""),
            "GraduationYear": r["grad_year"] or (ucla_year(r) if r["program"] == "UCLA" else ""), "LinkedIn": r["linkedin_url"],
            "JobClassification": r["category"], "Major": r["major"],
            "Program": r["program"], "Group": r["group"],
            "CurrentPosition": r["current_position"], "Organization": r["organization"],
            "AlsoClassification": r["also_category"],
            "Level1Group": r["level1_group"], "AlsoGroup": r["also_group"],
            "SOCCode": r["soc_code"], "SOCTitle": r["soc_title"],
        })
print("wrote", OUT)
