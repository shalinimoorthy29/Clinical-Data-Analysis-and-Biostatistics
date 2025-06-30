-- SQL commands of varying complexity
-- LEVEL 1 - Basic Summary Statistics

-- Total number of patients
SELECT 
	COUNT(*) AS TotalPatients
FROM diabetes;

-- Number of diabetic and non-diabetic patients.
-- Note: Outcome = 0 is non diabetic, Outcome = 1 is diabetic.
SELECT Outcome,
	COUNT(*) AS Count
FROM diabetes
GROUP BY Outcome;

-- Average age of all patients
SELECT 
	AVG(Age) AS AverageAge
FROM diabetes;

-- Max and min BMI values
SELECT 
	MIN(BMI) AS MINBMI,
	MAX(BMI) AS MAXBMI
FROM diabetes;

-- Average glucose level of all patients
SELECT 
	AVG(Glucose) AS AverageGlucose
FROM diabetes;

-- Number of unique pregnancy counts recorded
SELECT
	COUNT (DISTINCT Pregnancies) AS UniquePregancyCounts
FROM diabetes;

-- LEVEL 2 - Grouped Analysis in SQL

-- Average glucose level by diabetes outcome
SELECT Outcome,
	AVG(Glucose) AS AverageGlucoseByDiabetesOutcome
FROM diabetes
GROUP BY Outcome;

-- Average BMI by diabetes outcome
SELECT Outcome,
	AVG(BMI) AS AverageBMIByDiabetesOutcome
FROM diabetes
GROUP BY Outcome;

-- Average age by number of pregnancies
SELECT Pregnancies,
	AVG(Age) AS AverageAgeByPregnancyCount
FROM diabetes
GROUP BY Pregnancies
ORDER BY Pregnancies;

-- Count of diabetic patients over the age of 40
SELECT COUNT(*) AS DiabeticOver40
FROM diabetes
WHERE Age > 40 AND Outcome = 1;

-- Distribution of patients by age group (in bins of 10 years)
SELECT
	CASE
		WHEN Age BETWEEN 0 AND 9 THEN '0-9'
		WHEN Age BETWEEN 10 AND 19 THEN '10-19'
		WHEN Age BETWEEN 20 AND 29 THEN '20-29'
		WHEN Age BETWEEN 30 AND 39 THEN '30-39'
		WHEN Age BETWEEN 40 AND 49 THEN '40-49'
		WHEN Age BETWEEN 50 AND 59 THEN '50-59'
		ELSE '60+'
	END AS AgeGroup,
	COUNT(*) AS Count
FROM diabetes
GROUP BY
	CASE
		WHEN Age BETWEEN 0 AND 9 THEN '0-9'
		WHEN Age BETWEEN 10 AND 19 THEN '10-19'
		WHEN Age BETWEEN 20 AND 29 THEN '20-29'
		WHEN Age BETWEEN 30 AND 39 THEN '30-39'
		WHEN Age BETWEEN 40 AND 49 THEN '40-49'
		WHEN Age BETWEEN 50 AND 59 THEN '50-59'
		ELSE '60+'
	END
ORDER BY AgeGroup;

-- Average insulin level for each glucose range
SELECT 
  CASE 
    WHEN Glucose < 80 THEN '<80'
    WHEN Glucose BETWEEN 80 AND 119 THEN '80-119'
    WHEN Glucose BETWEEN 120 AND 159 THEN '120-159'
    ELSE '160+'
  END AS GlucoseRange,
  AVG(Insulin) AS AverageInsulin
FROM diabetes
GROUP BY 
  CASE 
    WHEN Glucose < 80 THEN '<80'
    WHEN Glucose BETWEEN 80 AND 119 THEN '80-119'
    WHEN Glucose BETWEEN 120 AND 159 THEN '120-159'
    ELSE '160+'
  END
ORDER BY GlucoseRange;

-- Count of patients by BMI category
SELECT 
  CASE 
    WHEN BMI < 18.5 THEN 'Underweight'
    WHEN BMI BETWEEN 18.5 AND 24.9 THEN 'Normal weight'
    WHEN BMI BETWEEN 25.0 AND 29.9 THEN 'Overweight'
    ELSE 'Obese'
  END AS BMI_Category,
  COUNT(*) AS PatientCount
FROM diabetes
GROUP BY 
  CASE 
    WHEN BMI < 18.5 THEN 'Underweight'
    WHEN BMI BETWEEN 18.5 AND 24.9 THEN 'Normal weight'
    WHEN BMI BETWEEN 25.0 AND 29.9 THEN 'Overweight'
    ELSE 'Obese'
  END
ORDER BY BMI_Category;

-- Level 3 – Categorisation and Conditional Logic

-- Classify patients into BMI categories
SELECT *,
  CASE 
    WHEN BMI < 18.5 THEN 'Underweight'
    WHEN BMI BETWEEN 18.5 AND 24.9 THEN 'Normal weight'
    WHEN BMI BETWEEN 25.0 AND 29.9 THEN 'Overweight'
    ELSE 'Obese'
  END AS BMI_Category
FROM diabetes;

-- Assign patients a risk category based on glucose and BMI
SELECT *,
  CASE 
    WHEN Glucose > 140 AND BMI > 30 THEN 'High Risk'
    WHEN Glucose BETWEEN 100 AND 140 THEN 'Medium Risk'
    ELSE 'Low Risk'
  END AS RiskCategory
FROM diabetes;-- Assign patients a risk flag based on glucose and BMI
SELECT *,
  CASE 
    WHEN Glucose > 140 AND BMI > 30 THEN 'High Risk'
    WHEN Glucose BETWEEN 100 AND 140 THEN 'Medium Risk'
    ELSE 'Low Risk'
  END AS RiskCategory
FROM diabetes;-- Assign patients a risk flag based on glucose and BMI
SELECT *,
  CASE 
    WHEN Glucose > 140 AND BMI > 30 THEN 'High Risk'
    WHEN Glucose BETWEEN 100 AND 140 THEN 'Medium Risk'
    ELSE 'Low Risk'
  END AS RiskCategory
FROM diabetes;

-- Cross-tabulation: BMI category vs diabetes outcome
SELECT 
  CASE 
    WHEN BMI < 18.5 THEN 'Underweight'
    WHEN BMI BETWEEN 18.5 AND 24.9 THEN 'Normal weight'
    WHEN BMI BETWEEN 25.0 AND 29.9 THEN 'Overweight'
    ELSE 'Obese'
  END AS BMI_Category,
  Outcome,
  COUNT(*) AS Count
FROM diabetes
GROUP BY 
  CASE 
    WHEN BMI < 18.5 THEN 'Underweight'
    WHEN BMI BETWEEN 18.5 AND 24.9 THEN 'Normal weight'
    WHEN BMI BETWEEN 25.0 AND 29.9 THEN 'Overweight'
    ELSE 'Obese'
  END,
  Outcome
ORDER BY BMI_Category, Outcome;

-- Combine age group and diabetes status
SELECT *,
  CASE 
    WHEN Age < 30 AND Outcome = 1 THEN 'Young Diabetic'
    WHEN Age >= 30 AND Outcome = 1 THEN 'Adult Diabetic'
    WHEN Age < 30 AND Outcome = 0 THEN 'Young Non-Diabetic'
    ELSE 'Adult Non-Diabetic'
  END AS PatientProfile
FROM diabetes;





