/*==============================================================
 Concepts Covered:
 • ROW_NUMBER()
 • RANK()
 • DENSE_RANK()
 • NTILE()
 • LAG()
 • LEAD()
 • FIRST_VALUE()
 • LAST_VALUE()
 • SUM() OVER()
 • AVG() OVER()
 • PARTITION BY
==============================================================*/

USE healthcare_insurance_db;

-- Assign row numbers to claims by amount

SELECT
    Claim_ID,
    Claim_Amount,
    ROW_NUMBER() OVER(ORDER BY Claim_Amount DESC) AS Row_Num
FROM Claims;


-- Rank claims by amount

SELECT
    Claim_ID,
    Claim_Amount,
    RANK() OVER(ORDER BY Claim_Amount DESC) AS Claim_Rank
FROM Claims;


-- Dense rank claims by amount

SELECT
    Claim_ID,
    Claim_Amount,
    DENSE_RANK() OVER(ORDER BY Claim_Amount DESC) AS Dense_Rank
FROM Claims;


-- Rank hospitals by total claim amount

SELECT
    Hospital_ID,
    SUM(Claim_Amount) AS Total_Claim,
    RANK() OVER(ORDER BY SUM(Claim_Amount) DESC) AS Hospital_Rank
FROM Claims
GROUP BY Hospital_ID;


-- Rank providers within each provider type

SELECT
    p.Provider_Type,
    c.Hospital_ID,
    SUM(c.Claim_Amount) AS Total_Claim,
    DENSE_RANK() OVER(
        PARTITION BY p.Provider_Type
        ORDER BY SUM(c.Claim_Amount) DESC
    ) AS Provider_Rank
FROM Claims c
JOIN Providers p
ON c.Hospital_ID = p.Hospital_ID
GROUP BY p.Provider_Type, c.Hospital_ID;


-- Running total of claim amount

SELECT
    Claim_ID,
    Claim_Date,
    Claim_Amount,
    SUM(Claim_Amount)
    OVER(ORDER BY Claim_Date) AS Running_Total
FROM Claims;


-- Running average of claim amount

SELECT
    Claim_ID,
    Claim_Date,
    Claim_Amount,
    ROUND(
        AVG(Claim_Amount)
        OVER(ORDER BY Claim_Date),2
    ) AS Running_Average
FROM Claims;


-- Previous claim amount using LAG

SELECT
    Claim_ID,
    Claim_Date,
    Claim_Amount,
    LAG(Claim_Amount)
    OVER(ORDER BY Claim_Date) AS Previous_Claim
FROM Claims;


-- Next claim amount using LEAD

SELECT
    Claim_ID,
    Claim_Date,
    Claim_Amount,
    LEAD(Claim_Amount)
    OVER(ORDER BY Claim_Date) AS Next_Claim
FROM Claims;


-- Difference from previous claim

SELECT
    Claim_ID,
    Claim_Date,
    Claim_Amount,
    Claim_Amount -
    LAG(Claim_Amount)
    OVER(ORDER BY Claim_Date) AS Difference
FROM Claims;


-- First claim amount for each hospital

SELECT
    Hospital_ID,
    Claim_ID,
    Claim_Date,
    FIRST_VALUE(Claim_Amount)
    OVER(
        PARTITION BY Hospital_ID
        ORDER BY Claim_Date
    ) AS First_Claim
FROM Claims;


-- Moving average of claim amount

SELECT
    Claim_ID,
    Claim_Date,
    Claim_Amount,
    ROUND(
        AVG(Claim_Amount)
        OVER(
            ORDER BY Claim_Date
            ROWS BETWEEN 2 PRECEDING
            AND CURRENT ROW
        ),2
    ) AS Moving_Average
FROM Claims;


-- Divide claims into four quartiles

SELECT
    Claim_ID,
    Claim_Amount,
    NTILE(4)
    OVER(ORDER BY Claim_Amount DESC) AS Quartile
FROM Claims;


-- Highest claim in each provider type

SELECT
    p.Provider_Type,
    c.Claim_ID,
    c.Claim_Amount,
    ROW_NUMBER()
    OVER(
        PARTITION BY p.Provider_Type
        ORDER BY c.Claim_Amount DESC
    ) AS RowNum
FROM Claims c
JOIN Providers p
ON c.Hospital_ID = p.Hospital_ID;


-- Running total by hospital

SELECT
    Hospital_ID,
    Claim_Date,
    Claim_Amount,
    SUM(Claim_Amount)
    OVER(
        PARTITION BY Hospital_ID
        ORDER BY Claim_Date
    ) AS Running_Total
FROM Claims;


-- Running fraud count

SELECT
    Claim_ID,
    Claim_Date,
    Is_Fraudulent,
    SUM(
        CASE
            WHEN Is_Fraudulent='Yes' THEN 1
            ELSE 0
        END
    ) OVER(
        ORDER BY Claim_Date
    ) AS Running_Fraud_Count
FROM Claims;


-- Rank patients by total claim amount

SELECT
    Patient_ID,
    SUM(Claim_Amount) AS Total_Claim,
    DENSE_RANK()
    OVER(
        ORDER BY SUM(Claim_Amount) DESC
    ) AS Patient_Rank
FROM Claims
GROUP BY Patient_ID;


-- Monthly running total

SELECT
    Year,
    Claim_Month,
    SUM(Claim_Amount) AS Monthly_Total,
    SUM(SUM(Claim_Amount))
    OVER(
        ORDER BY Year,
        MONTH(STR_TO_DATE(Claim_Month,'%M'))
    ) AS Running_Total
FROM Claims
GROUP BY Year, Claim_Month;


-- Average claim amount by provider type

SELECT
    p.Provider_Type,
    c.Claim_ID,
    c.Claim_Amount,
    ROUND(
        AVG(c.Claim_Amount)
        OVER(PARTITION BY p.Provider_Type),2
    ) AS Avg_Provider_Claim
FROM Claims c
JOIN Providers p
ON c.Hospital_ID = p.Hospital_ID;


-- Last claim amount for each hospital

SELECT
    Hospital_ID,
    Claim_ID,
    Claim_Date,
    LAST_VALUE(Claim_Amount)
    OVER(
        PARTITION BY Hospital_ID
        ORDER BY Claim_Date
        ROWS BETWEEN UNBOUNDED PRECEDING
        AND UNBOUNDED FOLLOWING
    ) AS Last_Claim
FROM Claims;


-- Percent Rank of Claims

SELECT
    Claim_ID,
    Claim_Amount,
    PERCENT_RANK()
    OVER(ORDER BY Claim_Amount DESC) AS Percent_Rank
FROM Claims;



