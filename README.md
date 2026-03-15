# data-analysis.
Source: Synthetic hospital admissions data (hospital_readmission_dataset1.csv)

Rows: 1,000

Columns: 15
PatientID, Age, Gender, InsuranceType, AdmissionID, AdmissionDate, DischargeDate, LengthOfStay, PriorAdmissions, DiagnosisCategory, DischargeDisposition, FollowUpScheduled, Readmitted30Days

Time Period: Admissions from January 2024 to June 2024
The queries are grouped into the following insight categories:

Overall Hospital Metrics – Total patients, average length of stay, overall readmission rate.

Diagnosis‑Centric Analysis – Most common diagnoses, readmission rates by diagnosis, diagnoses with above‑average risk, age distribution per diagnosis.

Length of Stay (LOS) – Average LOS, patients with above‑average LOS, top longest stays, outliers, LOS by discharge disposition.

Follow‑Up Impact – Readmission rates with/without scheduled follow‑up, effectiveness by diagnosis.

Insurance Type Insights – Patient volume by insurance, readmission rates per insurance, interaction with diagnosis.

Discharge Disposition Analysis – Average LOS and readmission counts by discharge location.

Risk Segmentation – High‑risk patient views, risk stratification (High/Medium/Low) with readmission rates.
Reusable Views – HighRiskPatients, vw_DiagnosisPerformance, vw_DiagnosisInsuranceDistribution.
KEY FINDINGS :
After running the SQL queries on the 1,000‑record sample, the following insights emerged:

Overall readmission rate: 42.3% (423 patients readmitted within 30 days).

Average length of stay: 5.6 days.

Most common diagnoses: COPD (260 patients), Heart Failure (245), Diabetes (210), Infection (185), Kidney Disease (100).

Diagnosis with highest readmission rate: Heart Failure (54%), followed by Infection (48%).

Follow‑up effectiveness: Patients with a scheduled follow‑up had a 35% readmission rate vs. 49% for those without.

Insurance distribution: Medicare 45%, Private 40%, Medicaid 15%.

Readmission by insurance: Medicaid patients had the highest rate (52%), Private the lowest (38%).
High‑risk segment (age >70 & prior admissions ≥2): 180 patients, with a 68% readmission rate.

Average LOS by discharge disposition:

Skilled Nursing Facility: 6.8 days

Home Health: 5.9 days

Home: 4.8 days
