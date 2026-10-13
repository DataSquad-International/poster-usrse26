#!/usr/bin/env python3
"""Write a synthetic outcomes table (fake people) for outside review. Safe to commit.
Names, emails and employers come from Faker. UCLA group totals and both schools' class-year counts
mirror the real aggregates; titles, descriptions and SOC codes are invented. SOC codes are from
memory and UNVERIFIED against O*NET OnLine. Every person is invented.
Run: uv run --with faker python scripts/make_mock_outcomes.py
"""
import csv, pathlib, random, unicodedata
from faker import Faker

SEED = 26
random.seed(SEED)
fake = Faker("en_US")
people = [Faker(loc) for loc in ["en_US"] * 4 + ["en_IN", "es_MX", "fr_FR", "pt_BR", "it_IT"]]
Faker.seed(SEED)
OUT = pathlib.Path(__file__).resolve().parent.parent / "design" / "mock-outcomes-shape.csv"

G1, G2, G3, G4, G5, G6 = (
    "1 Data science and analytics", "2 Software and engineering", "3 Actuarial, finance and consulting",
    "4 Research and academia", "5 Public sector, nonprofit and information work", "6 Further study")
LEGACY = {G1: "Data / analytics / consulting", G2: "Software / engineering / IT", G3: "Data / analytics / consulting",
          G4: "Research / graduate school", G5: "Nonprofit / public sector", G6: "Research / graduate school"}

# (title, SOC code, SOC title, description, also-group or "")
JOBS = {
    G1: [("Data Scientist", "15-2051.00", "Data Scientists", "Builds models and dashboards for product teams", ""),
         ("Senior Data Scientist", "15-2051.00", "Data Scientists", "Leads ML and MLOps work", ""),
         ("Marketing Data Scientist", "15-2051.00", "Data Scientists", "Customer analytics and experiments", ""),
         ("Data Engineer", "15-1243.00", "Database Architects", "Pipelines and warehouse migration", G2),
         ("Business Intelligence Analyst", "15-2051.01", "Business Intelligence Analysts", "Reporting and metrics", ""),
         ("Statistician", "15-2041.00", "Statisticians", "Survey and A/B test design", ""),
         ("Clinical Data Analyst", "15-2051.00", "Data Scientists", "Cleans and analyzes clinic outcomes data", G4)],
    G2: [("Software Development Engineer", "15-1252.00", "Software Developers", "Backend services", ""),
         ("Software Engineer", "15-1252.00", "Software Developers", "Full-stack web development", ""),
         ("Solutions Engineer", "15-1211.00", "Computer Systems Analysts", "Customer integrations and support engineering", ""),
         ("Systems Administrator", "15-1244.00", "Network and Computer Systems Administrators", "Runs servers and accounts", ""),
         ("Android Developer", "15-1252.00", "Software Developers", "Mobile app for a media company", "")],
    G3: [("Actuarial Analyst", "15-2011.00", "Actuaries", "Reserving and pricing models", G1),
         ("Consultant", "13-1111.00", "Management Analysts", "Client analytics projects", G1),
         ("Senior Analyst", "13-1111.00", "Management Analysts", "Strategy and operations consulting", ""),
         ("Financial Analyst", "13-2051.00", "Financial and Investment Analysts", "Forecasting and reporting", "")],
    G4: [("Research Coordinator", "19-3022.00", "Survey Researchers", "Runs survey studies at a university lab", ""),
         ("Epidemiology Research Analyst", "19-1041.00", "Epidemiologists", "Cohort data analysis", G1),
         ("Research Assistant", "", "(no direct SOC code)", "Lab data processing; also a student", ""),
         ("Biostatistician", "15-2041.01", "Biostatisticians", "Trial analysis support", G1)],
    G5: [("Development Operations Supervisor", "13-1131.00", "Fundraisers", "Runs donor database, giving reports and team processes", G1),
         ("GIS Technician", "15-1299.02", "Geographic Information Systems Technologists", "Spatial data for a park service", G1),
         ("Program Associate", "11-9151.00", "Social and Community Service Managers", "Coordinates community programs", ""),
         ("Library Assistant", "25-4022.00", "Librarians and Media Collections Specialists", "Metadata and digital collections", G1),
         ("Policy Analyst", "13-1111.00", "Management Analysts", "Evaluates public programs", G1)],
    G6: [("MS Student, Data Science", "", "(student, no SOC code)", "Graduate program in data science", ""),
         ("PhD Student, Statistics", "", "(student, no SOC code)", "Doctoral program, research assistantship", ""),
         ("PhD Student, Computer Science", "", "(student, no SOC code)", "Doctoral program", "")],
}
UNIS = ["Stanford University", "NYU", "University of Washington", "Columbia University", "UC San Diego",
        "University of Michigan", "Johns Hopkins University"]
MAJORS = ["Statistics", "Computer Science", "Mathematics", "Economics", "Biology", "Sociology", "Physics",
          "Political Science", "Linguistics", "Data Science", "Cognitive Science", "Psychology",
          "Environmental Studies", "Mathematics and Computer Science"]

def ascii_fold(t):
    return unicodedata.normalize("NFKD", t).encode("ascii", "ignore").decode()

def one_line(t):
    return " ".join(t.split())

def org(group):
    if group in (G4, G6):
        return random.choice(UNIS)
    if group == G5:
        return fake.last_name() + random.choice([" Foundation", " Housing Services", " Public Library", " County"])
    return one_line(fake.company()) + (" Technologies" if group == G2 else "")

COLS = ["FirstName", "LastName", "Email", "GraduationYear", "LinkedIn", "Major", "Program", "Group",
        "Level1Group", "AlsoGroup", "SOCCode", "SOCTitle", "CurrentPosition", "RoleDescription",
        "Organization", "LegacyCategory"]
rows = []
def add(prog, year, group1, grp="alumni"):
    pf = random.choice(people)  # one locale per person so first and last names match
    first, last = pf.first_name(), pf.last_name()
    slug = ascii_fold(f"{first}-{last}").lower().replace(" ", "-").replace("'", "")
    domain = random.choice(["gmail.com", "gmail.com", "outlook.com", "yahoo.com", "icloud.com"])
    row = {"FirstName": first, "LastName": last,
           "Email": (ascii_fold(f"{first}.{last}") + "@" + domain).lower().replace(" ", ""),
           "GraduationYear": year,
           "LinkedIn": f"https://www.linkedin.com/in/{slug}-{fake.hexify('^^^^^^')}" if random.random() > 0.03 else "",
           "Major": random.choice(MAJORS), "Program": prog, "Group": grp}
    if group1:
        t, soc, soct, desc, also = random.choice(JOBS[group1])
        if group1 == G6 and random.random() < 0.4:
            also = G1
        row.update(Level1Group=group1, AlsoGroup=also, SOCCode=soc, SOCTitle=soct, CurrentPosition=t,
                   RoleDescription=desc, Organization=org(group1), LegacyCategory=LEGACY[group1])
    rows.append({c: row.get(c, "") for c in COLS})

# UCLA: 20 alumni with real top-level shape (11 data-ish, 4 software, 2 research, 2 nonprofit) + 1 current student
ucla = [G1] * 7 + [G3] * 4 + [G2] * 4 + [G6] + [G4] + [G5] * 2
random.shuffle(ucla)
years = ["2024"] * 5 + ["2025"] * 4 + ["2026"] * 2 + [""] * 8
random.shuffle(years)
for g, y in zip(ucla, years):
    add("UCLA", y, g)
add("UCLA", "2026", None, grp="current student")

# Carleton: real class-year counts; groups invented, 15 percent not yet looked up
cy = {2005:1,2009:3,2010:4,2011:1,2012:2,2013:2,2014:2,2015:4,2016:5,2017:3,2018:7,
      2019:4,2020:9,2021:5,2022:7,2023:14,2024:7,2025:19,2026:15}
for y, n in cy.items():
    for _ in range(n):
        add("Carleton", str(y), None if random.random() < 0.15 else random.choices([G1, G2, G3, G4, G5, G6], [4, 4, 2, 2, 3, 3])[0])
for _ in range(6):
    add("Carleton", str(random.choice([2027, 2028])), None, grp="current student")

with open(OUT, "w", newline="", encoding="utf-8") as f:
    w = csv.DictWriter(f, COLS)
    w.writeheader(); w.writerows(rows)
print(len(rows), "rows ->", OUT)
