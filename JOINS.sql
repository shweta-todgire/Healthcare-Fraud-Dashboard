/*==============================================================
 Concepts Covered:
 • INNER JOIN
 • LEFT JOIN
 • GROUP BY
 • ORDER BY
 • Aggregate Functions
 • HAVING
==============================================================*/

USE healthcare_insurance_db;


-- Patient details with claim amount

SELECT
    c.Claim_ID,
    p.Patient_ID,
    p.Patient_Gender,
    p.Patient_Age,
    c.Claim_Amount
FROM Claims c
INNER JOIN Patients p
ON c.Patient_ID = p.Patient_ID;


-- Hospital details with claim amount

SELECT
    c.Claim_ID,
    pr.Hospital_ID,
    pr.Provider_Type,
    pr.Provider_Specialty,
    c.Claim_Amount
FROM Claims c
INNER JOIN Providers pr
ON c.Hospital_ID = pr.Hospital_ID;


-- Total claim amount by provider type

SELECT
    pr.Provider_Type,
    ROUND(SUM(c.Claim_Amount),2) AS Total_Claim_Amount
FROM Claims c
INNER JOIN Providers pr
ON c.Hospital_ID = pr.Hospital_ID
GROUP BY pr.Provider_Type
ORDER BY Total_Claim_Amount DESC;


-- Total claim amount by provider specialty

SELECT
    pr.Provider_Specialty,
    ROUND(SUM(c.Claim_Amount),2) AS Total_Claim_Amount
FROM Claims c
INNER JOIN Providers pr
ON c.Hospital_ID = pr.Hospital_ID
GROUP BY pr.Provider_Specialty
ORDER BY Total_Claim_Amount DESC;


-- Fraud count by provider specialty

SELECT
    pr.Provider_Specialty,
    COUNT(*) AS Fraud_Count
FROM Claims c
INNER JOIN Providers pr
ON c.Hospital_ID = pr.Hospital_ID
WHERE c.Is_Fraudulent='Yes'
GROUP BY pr.Provider_Specialty
ORDER BY Fraud_Count DESC;


-- Average claim amount by patient age group

SELECT
    p.Patient_Age_Group,
    ROUND(AVG(c.Claim_Amount),2) AS Average_Claim
FROM Claims c
INNER JOIN Patients p
ON c.Patient_ID = p.Patient_ID
GROUP BY p.Patient_Age_Group;


-- Top 10 hospitals by claim amount

SELECT
    pr.Hospital_ID,
    pr.Provider_Type,
    ROUND(SUM(c.Claim_Amount),2) AS Total_Claim
FROM Claims c
INNER JOIN Providers pr
ON c.Hospital_ID=pr.Hospital_ID
GROUP BY pr.Hospital_ID,pr.Provider_Type
ORDER BY Total_Claim DESC
LIMIT 10;


-- Show all patients and their claims (including patients who have not made any claims)

SELECT
    p.Patient_ID,
    p.Patient_Gender,
    c.Claim_ID,
    c.Claim_Amount
FROM Patients p
LEFT JOIN Claims c
ON p.Patient_ID = c.Patient_ID;


-- Show all policies and their claims (including unused policies)

SELECT
    po.Policy_Number,
    po.Policy_Status,
    c.Claim_ID,
    c.Claim_Amount
FROM Policies po
LEFT JOIN Claims c
ON po.Policy_Number = c.Policy_Number;


-- Count claims for every provider (providers with no claims will show 0)

SELECT
    pr.Hospital_ID,
    pr.Provider_Type,
    COUNT(c.Claim_ID) AS Total_Claims
FROM Providers pr
LEFT JOIN Claims c
ON pr.Hospital_ID = c.Hospital_ID
GROUP BY
    pr.Hospital_ID,
    pr.Provider_Type
ORDER BY Total_Claims DESC;


-- Patient, Provider and Claim Details

SELECT
    c.Claim_ID,
    p.Patient_ID,
    p.Patient_Gender,
    pr.Provider_Type,
    pr.Provider_Specialty,
    c.Claim_Amount
FROM Claims c
INNER JOIN Patients p
    ON c.Patient_ID = p.Patient_ID
INNER JOIN Providers pr
    ON c.Hospital_ID = pr.Hospital_ID;


-- Top States by Claim Amount

SELECT
    p.Patient_State_Name,
    ROUND(SUM(c.Claim_Amount),2) AS Total_Claim
FROM Claims c
INNER JOIN Patients p
    ON c.Patient_ID = p.Patient_ID
GROUP BY p.Patient_State_Name
ORDER BY Total_Claim DESC
LIMIT 5;


-- Provider Types Having More Than 300 Claims

SELECT
    pr.Provider_Type,
    COUNT(*) AS Total_Claims
FROM Claims c
INNER JOIN Providers pr
    ON c.Hospital_ID = pr.Hospital_ID
GROUP BY pr.Provider_Type
HAVING COUNT(*) > 300
ORDER BY Total_Claims DESC;