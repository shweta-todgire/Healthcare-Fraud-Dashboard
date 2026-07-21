/*==============================================================
 Concepts Covered:
 • CASE WHEN
 • Subqueries
 • Correlated Subqueries
 • HAVING
 • EXISTS
 • Common Table Expressions (CTEs)
==============================================================*/

USE healthcare_insurance_db;

-- Categorizing claims using CASE

SELECT
    Claim_ID,
    Claim_Amount,
    CASE
        WHEN Claim_Amount < 500000 THEN 'Low'
        WHEN Claim_Amount < 1000000 THEN 'Medium'
        WHEN Claim_Amount < 2000000 THEN 'High'
        ELSE 'Very High'
    END AS Claim_Category
FROM Claims;


-- Classify Fraud Risk

SELECT
    Claim_ID,
    Is_Fraudulent,
    Claim_Submitted_Late,
    CASE
        WHEN Is_Fraudulent='Yes' AND Claim_Submitted_Late='Yes'
        THEN 'High Risk'
        WHEN Is_Fraudulent='Yes'
        THEN 'Medium Risk'
        ELSE 'Low Risk'
    END AS Risk_Level
FROM Claims;


-- Provider specialties with above average claim amount

SELECT
    pr.Provider_Specialty,
    ROUND(AVG(c.Claim_Amount),2) AS Avg_Claim
FROM Claims c
JOIN Providers pr
ON c.Hospital_ID=pr.Hospital_ID
GROUP BY pr.Provider_Specialty
HAVING AVG(c.Claim_Amount)>
(
SELECT AVG(Claim_Amount)
FROM Claims
);


-- Patients with above average claim amount

SELECT
    Patient_ID,
    Claim_Amount
FROM Claims
WHERE Claim_Amount >
(
SELECT AVG(Claim_Amount)
FROM Claims
);


-- Highest claim amount in the database

SELECT *
FROM Claims
WHERE Claim_Amount =
(
SELECT MAX(Claim_Amount)
FROM Claims
);


-- Providers handling more than 30 claims

SELECT
    Hospital_ID,
    COUNT(*) AS Total_Claims
FROM Claims
GROUP BY Hospital_ID
HAVING COUNT(*)>30;


-- Patients having multiple claims

SELECT
    Patient_ID,
    COUNT(*) AS Claim_Count
FROM Claims
GROUP BY Patient_ID
HAVING COUNT(*)>1;


-- Fraud rate by provider type

SELECT
    pr.Provider_Type,
    ROUND(
        SUM(CASE WHEN c.Is_Fraudulent='Yes' THEN 1 ELSE 0 END)
        *100.0/COUNT(*),2
    ) AS Fraud_Rate
FROM Claims c
JOIN Providers pr
ON c.Hospital_ID=pr.Hospital_ID
GROUP BY pr.Provider_Type;


-- Patients whose claim amount exceeds 2 Million

SELECT
    Patient_ID,
    Claim_Amount
FROM Claims
WHERE Claim_Amount>2000000;


-- Providers with highest total claim amount

SELECT
    Hospital_ID,
    SUM(Claim_Amount) AS Total_Claim
FROM Claims
GROUP BY Hospital_ID
HAVING SUM(Claim_Amount)>
(
SELECT AVG(TotalClaim)
FROM
(
SELECT SUM(Claim_Amount) AS TotalClaim
FROM Claims
GROUP BY Hospital_ID
) t
);


-- CTE - Monthly claim summary

WITH MonthlyClaims AS
(
SELECT
Year,
Claim_Month,
SUM(Claim_Amount) Total_Amount
FROM Claims
GROUP BY Year,Claim_Month
)

SELECT *
FROM MonthlyClaims
ORDER BY Year;


-- CTE - Fraud summary

WITH FraudSummary AS
(
SELECT
Hospital_ID,
COUNT(*) Fraud_Count
FROM Claims
WHERE Is_Fraudulent='Yes'
GROUP BY Hospital_ID
)

SELECT *
FROM FraudSummary
ORDER BY Fraud_Count DESC;


-- EXISTS - Patients with claims

SELECT *
FROM Patients p
WHERE EXISTS
(
SELECT 1
FROM Claims c
WHERE p.Patient_ID=c.Patient_ID
);


-- NOT EXISTS - Patients without claims

SELECT *
FROM Patients p
WHERE NOT EXISTS
(
SELECT 1
FROM Claims c
WHERE p.Patient_ID=c.Patient_ID
);


-- Provider with maximum fraud cases

SELECT
Hospital_ID,
COUNT(*) Fraud_Count
FROM Claims
WHERE Is_Fraudulent='Yes'
GROUP BY Hospital_ID
ORDER BY Fraud_Count DESC
LIMIT 1;


-- Top diagnosis codes by claim amount

SELECT
Diagnosis_Code,
SUM(Claim_Amount) Total_Claim
FROM Claims
GROUP BY Diagnosis_Code
ORDER BY Total_Claim DESC
LIMIT 10;


-- Fraud vs Genuine claims summary

SELECT
Is_Fraudulent,
COUNT(*) Total_Claims,
ROUND(SUM(Claim_Amount),2) Total_Amount
FROM Claims
GROUP BY Is_Fraudulent;