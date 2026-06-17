CREATE database HR_ANALYTIC_DASHBOARD; 
USE HR_ANALYTIC_DASHBOARD;
SELECT * FROM DATA;

SELECT DISTINCT Attrition FROM Data;

-- Attrition By Department
SELECT
    Department,
    COUNT(*) AS Total,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Left_Count,
    ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1.0 ELSE 0 END) / COUNT(*) * 100, 1) AS Attrition_Rate_Pct
FROM Data
GROUP BY Department
ORDER BY Attrition_Rate_Pct DESC;

-- Attrition By Job Role

SELECT
    JobRole,
    COUNT(*) AS Total,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Left_Count,
    ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1.0 ELSE 0 END) / COUNT(*) * 100, 1) AS Attrition_Rate_Pct
FROM Data
GROUP BY JobRole
ORDER BY Attrition_Rate_Pct DESC;

-- Salary:Stayed V/s Left

SELECT
    Attrition,
    ROUND(AVG(MonthlyIncome), 0) AS Avg_Salary
FROM Data
GROUP BY Attrition;

-- Marital Status

SELECT
    MaritalStatus,
    COUNT(*) AS Total,
    ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1.0 ELSE 0 END) / COUNT(*) * 100, 1) AS Attrition_Rate_Pct
FROM Data
GROUP BY MaritalStatus
ORDER BY Attrition_Rate_Pct DESC;

-- Age Group

SELECT
    CASE
        WHEN Age <= 25 THEN '18-25'
        WHEN Age <= 35 THEN '26-35'
        WHEN Age <= 45 THEN '36-45'
        ELSE '46+'
    END AS Age_Group,
    COUNT(*) AS Total,
    ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1.0 ELSE 0 END) / COUNT(*) * 100, 1) AS Attrition_Rate_Pct
FROM Data
GROUP BY Age_Group
ORDER BY Age_Group;

-- High Risk Employees

SELECT
    ï»¿EmployeeNumber, Department, JobRole, MonthlyIncome,
    YearsSinceLastPromotion, JobSatisfaction
FROM Data
WHERE Attrition = 'No'
  AND OverTime = 'Yes'
  AND JobSatisfaction <= 2
  AND YearsSinceLastPromotion >= 3
ORDER BY MonthlyIncome ASC;

describe data;

-- Satisfaction Comparision

SELECT
    Attrition,
    ROUND(AVG(JobSatisfaction), 2) AS Avg_Job_Satisfaction,
    ROUND(AVG(EnvironmentSatisfaction), 2) AS Avg_Env_Satisfaction,
    ROUND(AVG(WorkLifeBalance), 2) AS Avg_WorkLife_Balance
FROM Data
GROUP BY Attrition;