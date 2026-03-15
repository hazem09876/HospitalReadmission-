create database Hospital_Readmissions1;
USE Hospital_Readmissions1;

-- total number of patients 
SELECT COUNT(*) AS TotalPatients
FROM hospital_readmission_dataset1;

-- average kength of stay 
select avg (LengthOfStay) as AvgAgeStay
from hospital_readmission_dataset1;
--READMISSION RATE
SELECT 
COUNT (Case when Readmitted30Days='yes' then 1 End)* 100.0 /Count(*) as ReadMissionRate
from hospital_readmission_dataset1;

---most common diagnosis 
select DiagnosisCategory,
count(*) as TotalCases
from hospital_readmission_dataset1
group by DiagnosisCategory
order by TotalCases desc;

--Diagnoses with Highest Readmission Rate

select DiagnosisCategory,
count(*) as TotalPatients,
sum (case when Readmitted30Days= 'yes ' then 1 else 0 end) as ReadmittedPatients,
sum (case when Readmitted30Days= 'yes ' then 1 else 0 end) * 100.0/count(*) as ReadmissionRate
from hospital_readmission_dataset1
group by DiagnosisCategory
order by ReadmissionRate ;

--Patients with Above Average Length of Stay
select *
from hospital_readmission_dataset1
where LengthOfStay >
(
SELECT AVG(LengthOfStay)
from hospital_readmission_dataset1 
);

--Rank Diagnoses by Readmission Rate
select 
DiagnosisCategory,
Count(*) AS TotalPatients,
sum (case when Readmitted30Days= 'yes' then 1 else 0 end) as ReadmittedPatients,
rank() over (order by sum
(case when readmitted30Days = ' yes' then 1 else 0 end ) desc) as RiskRank
FROM hospital_readmission_dataset1 
GROUP BY DiagnosisCategory ;
--Follow-Up Appointment Impact

SELECT FollowUPScheduled ,
count(*) as TotalPatients,
sum(case when Readmitted30Days= 'yes' then 1 else 0 end) as readmitted 
from hospital_readmission_dataset1
group by FollowUPScheduled;

--Top 5 Longest Hospital Stays
select * from ( 
select * ,
row_number() over( order by lengthOfStay desc) as StayRank
From hospital_readmission_dataset1
) t
where stayrank <= 5 ;

---create a View for High-Risk Patients

create view HighRiskPatients 
AS 
select * 
from hospital_readmission_dataset1 where age > 65
and priorAdmissions >=2
and DiagnosisCategory in ( 'Heart failure', 'copd');
SELECT *FROM HighRiskPatients;


---Patients with Multiple Prior Admissions (High Risk Group)

select 
InsuranceType,
Count(*) as TotalPatients,
sum(case when Readmitted30Days='yes' then 1 else 0 end) 
as ReadmittedPatients,
Sum(case when Readmitted30Days='yes ' then 1 else 0 end) *100.0 / count(*) 
as ReadmissionRate
from hospital_readmission_dataset1
group by InsuranceType
Order by ReadmissionRate DESC ;

--Diagnoses with Above Average Readmission Risk
SELECT * FROM 
(SELECT DiagnosisCategory,
sum(case when Readmitted30Days= 'yes' then 1 else 0 end) *100.0/count(*) as ReadmissionRate
FROM hospital_readmission_dataset1
Group by DiagnosisCategory
) t
where ReadmissionRate >
(
select avg(ReadmissionRate)
from 
(
select 
sum(case when Readmitted30Days= 'yes' then 1 else 0 end)*100.0/count(*) as ReadmissionRate
from hospital_readmission_dataset1 
group by DiagnosisCategory 
) avg_table
);
---Average Stay by Discharge Location
select 
DischargeDisposition,
avg(lengthOfstay) as AvgStay
from hospital_readmission_dataset1
group by DischargeDisposition
order by AvgStay desc ;
--Readmission by Discharge Location

SELECT 
DischargeDisposition,
count(*) as TotalPatients,
Sum(case when Readmitted30Days= 'yes' then 1 else 0 end) as Readmitted
from hospital_readmission_dataset1 
group by DischargeDisposition ;

---Rank Insurance Types by Patient Volume
select 
InsuranceType,
count(*) as PatientCount,
Rank () over (order by  count(*) desc) as volumeRank
From hospital_readmission_dataset1 
group by InsuranceType ;
-- Detect Long-Stay Outliers
select *
from 
(
select *,
avg (LengthOfStay) over() as avgStay
from hospital_readmission_dataset1 
)t
where LengthOfStay > avgStay;

--Diagnosis Distribution by Insurance Type
select 
InsuranceType,
DiagnosisCategory,
Count(*) as PatientCount
from hospital_readmission_dataset1
group by InsuranceType, DiagnosisCategory
order by InsuranceType;

--Patient Segmentation by Risk
with RiskSegment as 
(
select* ,
case 
when age > 70 and PriorAdmissions >= 2 then 'HighRisk'
when age >50 then 'medium Risk'
else 'lowRisk'
END AS RiskLevel
From hospital_readmission_dataset1
)
select 
RiskLevel,
count(*) as patients
from RiskSegment group by RiskLevel;
--Top 3 Diagnoses by Readmissions
select*
from 
(
select
DiagnosisCategory,
Sum(case when Readmitted30Days= 'yes' then 1 else 0 end) as ReadmittedPatients,
Row_Number() over(order by sum(Case when Readmitted30Days='YES' then 1 else 0 end) desc) as RankNumber
from  hospital_readmission_dataset1
group by DiagnosisCategory
)t
where RankNumber<=3;

--High Risk Elderly Patients
with HighRiskElderly as 
(
select * 
from hospital_readmission_dataset1
where age >=70 
AND PriorAdmissions >=2
)
select 
count(*) as HighRiskPatientCount
from HighRiskElderly;

---Diagnosis Performance Dataset
CREATE VIEW vw_DiagnosisPerformance AS
SELECT
DiagnosisCategory,
COUNT(*) AS TotalPatients,
SUM(CASE WHEN Readmitted30Days='Yes' THEN 1 ELSE 0 END) AS ReadmittedPatients,
SUM(CASE WHEN Readmitted30Days='Yes' THEN 1 ELSE 0 END)*100.0/COUNT(*) AS ReadmissionRate
FROM hospital_readmission_dataset1
GROUP BY DiagnosisCategory;

SELECT *
FROM vw_DiagnosisPerformance
ORDER BY ReadmissionRate DESC;

--Diagnosis Distribution by Insurance
create view vw_DiagnosisInsuranceDistribution as 
select InsuranceType,
DiagnosisCategory,
count(*) as patientCount
from hospital_readmission_dataset1
group by InsuranceType, DiagnosisCategory;
SELECT *
FROM vw_DiagnosisInsuranceDistribution;
---Age Distribution per Diagnosis
select 
DiagnosisCategory, 
Avg(age) as AverageAge,
min(age) as YoungestPatient,
Max(age) as OldestPatient
from hospital_readmission_dataset1
group by DiagnosisCategory
Order BY AverageAge ;
--Diagnoses with Above Average Prior Admissions
select DiagnosisCategory,
AVG(PriorAdmissions) AS AvgPriorAdmissions
from hospital_readmission_dataset1
group by DiagnosisCategory Having AVG(priorAdmissions) >
( 
select AVG(PriorAdmissions)
From hospital_readmission_dataset1 
);
--Overall Hospital Readmission Rate
SELECT 
COUNT(*) AS TotalPatients,
SUM(CASE WHEN Readmitted30Days = 'Yes' THEN 1 ELSE 0 END) AS ReadmittedPatients,
ROUND(100.0 * SUM(CASE WHEN Readmitted30Days = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 
2) AS ReadmissionRate
FROM hospital_readmission_dataset1;
--Diagnosis Performance – Readmission Rate & Rank
SELECT 
DiagnosisCategory,
COUNT(*) AS TotalPatients,
SUM(CASE WHEN Readmitted30Days = 'Yes' THEN 1 ELSE 0 END) AS ReadmittedPatients,
ROUND(100.0 * SUM(CASE WHEN Readmitted30Days = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) 
AS ReadmissionRate,
RANK() OVER (ORDER BY SUM(CASE WHEN Readmitted30Days = 'Yes' THEN 1 ELSE 0 END) DESC)
AS RiskRank
FROM hospital_readmission_dataset1
GROUP BY DiagnosisCategory
ORDER BY ReadmissionRate DESC;
-- Risk Stratification – Patient Segments by Age & Prior Admissions
WITH RiskSegment AS
(
SELECT *,
CASE 
WHEN Age > 70 AND PriorAdmissions >= 2 THEN 'High Risk'
WHEN Age > 50 OR PriorAdmissions >= 1 THEN 'Medium Risk'
ELSE 'Low Risk'END AS RiskLevel
FROM hospital_readmission_dataset1
)
SELECT 
RiskLevel,
COUNT(*) AS PatientCount,
ROUND(100.0 * SUM(CASE WHEN Readmitted30Days = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2)
AS ReadmissionRate
FROM RiskSegment
GROUP BY RiskLevel
ORDER BY ReadmissionRate DESC;
--- Effectiveness of Follow‑Up by Diagnosis
SELECT 
DiagnosisCategory,
FollowUpScheduled,
COUNT(*) AS Patients,
ROUND(100.0 * SUM(CASE WHEN Readmitted30Days = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) 
AS ReadmissionRate
FROM hospital_readmission_dataset1
GROUP BY DiagnosisCategory, FollowUpScheduled
ORDER BY DiagnosisCategory, FollowUpScheduled;
--Insurance Type & Diagnosis Interaction
SELECT 
InsuranceType,DiagnosisCategory,
COUNT(*) AS Patients,
ROUND(100.0 * SUM(CASE WHEN Readmitted30Days = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2)
AS ReadmissionRate
FROM hospital_readmission_dataset1
GROUP BY InsuranceType, DiagnosisCategory
ORDER BY InsuranceType, ReadmissionRate DESC;