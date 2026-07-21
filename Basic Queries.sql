/*==============================================================
 Concepts Covered:
 • SELECT
 • WHERE
 • ORDER BY
 • GROUP BY
 • Aggregate Functions (COUNT, SUM, AVG, MIN, MAX)
 • DISTINCT
 • BETWEEN
 • LIMIT
==============================================================*/

USE healthcare_insurance_db;

-- 1. View all records from tables

SELECT * FROM Claims;

SELECT * FROM Patients;

SELECT * FROM Providers;

SELECT * FROM Policies;


-- Count total claims

SELECT COUNT(*) AS Total_Claims FROM Claims;


-- Total claim amount

SELECT ROUND(SUM(Claim_Amount),2) AS Total_Claim_Amount FROM Claims;


-- Average claim amount

SELECT ROUND(AVG(Claim_Amount),2) AS Average_Claim_Amount FROM Claims;


-- Highest claim amount

SELECT MAX(Claim_Amount) AS Highest_Claim FROM Claims;


-- Lowest claim amount

SELECT MIN(Claim_Amount) AS Lowest_Claim FROM Claims;


-- Average length of stay

SELECT ROUND(AVG(Length_of_Stay_Days),2) AS Average_Stay_Days FROM Claims;


-- Total fraud claims

SELECT COUNT(*) AS Fraud_Claims
FROM Claims
WHERE Is_Fraudulent = 'Yes';


-- Total genuine claims

SELECT COUNT(*) AS Genuine_Claims
FROM Claims
WHERE Is_Fraudulent = 'No';


-- Fraud percentage

SELECT
ROUND(
SUM(CASE
        WHEN Is_Fraudulent='Yes' THEN 1
        ELSE 0
    END)*100.0/COUNT(*),2
) AS Fraud_Percentage
FROM Claims;


-- Claims above 2 Million

SELECT *
FROM Claims
WHERE Claim_Amount > 2000000;


-- Claims between 500K and 1 Million

SELECT *
FROM Claims
WHERE Claim_Amount BETWEEN 500000 AND 1000000;


-- Emergency admissions

SELECT *
FROM Claims
WHERE Admission_Type='Emergency';


-- Urgent admissions

SELECT *
FROM Claims
WHERE Admission_Type='Urgent';


-- Late submitted claims

SELECT *
FROM Claims
WHERE Claim_Submitted_Late='Yes';


-- Hospital stay greater than 20 days

SELECT *
FROM Claims
WHERE Length_of_Stay_Days > 20;


-- Top 10 highest claim amounts

SELECT
Claim_ID,
Claim_Amount
FROM Claims
ORDER BY Claim_Amount DESC
LIMIT 10;


-- Top 10 lowest claim amounts

SELECT
Claim_ID,
Claim_Amount
FROM Claims
ORDER BY Claim_Amount ASC
LIMIT 10;


-- Distinct service types

SELECT DISTINCT Service_Type FROM Claims;


-- Distinct provider specialties

SELECT DISTINCT Provider_Specialty FROM Providers;


-- Number of provider specialties

SELECT COUNT(DISTINCT Provider_Specialty) AS Total_Specialties
FROM Providers;


-- Number of claims by month

SELECT
Claim_Month,
COUNT(*) AS Total_Claims
FROM Claims
GROUP BY Claim_Month;


-- Patients older than 60 years

SELECT *
FROM Patients
WHERE Patient_Age > 60;


-- Claims with zero length of stay

SELECT *
FROM Claims
WHERE Length_of_Stay_Days = 0;