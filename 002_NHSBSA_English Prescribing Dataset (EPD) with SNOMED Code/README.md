# Analysing the English Prescribing Dataset (EPD) with SNOMED Codes: NHS Spend, Patterns, and Outliers (Jan 2025)

## Overview

This project analyses the **NHS English Prescribing Dataset (EPD) with SNOMED Codes** for January 2025.  
It explores high-level spending patterns, regional variation, key cost drivers, and outliers in primary care prescribing across England.  
The analysis is intended to demonstrate real-world NHS data science skills for portfolio, interview, and stakeholder reporting.

---

## Objectives

- **Examine** national and regional patterns in primary care prescribing.
- **Quantify and visualise** high-level spend, cost distributions, and outliers.
- **Explore** regional and practice-level variation in prescription costs.
- **Identify** the top cost drivers by medicine, BNF chapter, and region.
- **Investigate** prescription cost-per-patient and cost-volume relationships.
- **Produce** clear, reproducible visual outputs for health data science audiences.

---

## Data Sources

- **Prescribing Data:** `EPD_SNOMED_202501.csv` (~18.4M records, 27 columns)
- **Practice Populations:** `gp-reg-pat-prac-all.csv` (linked for spend-per-patient analysis)

Key fields: Region, ICB, Practice, BNF/SNOMED, Quantity, Items, NIC (Net Ingredient Cost), Actual Cost.

Missing data is minimal for analytical variables (mostly limited to address fields).

---

## Analysis Workflow

### 1. Data Cleaning & Preparation
- Lowercased all column names for code clarity.
- Filtered out rows with missing/zero values in NIC, Actual Cost, Quantity, or SNOMED Code.
- Created `bnf_chapter` variable (first two characters of BNF code).

### 2. High-Level Spend Patterns
- **Top BNF Chapters:** Identified top 10 therapeutic chapters by total spend.
    - _Key finding:_ Chapters 06 (Endocrinology), 04 (CNS), 03 (Respiratory), 02 (Cardiovascular), and 09 (Nutrition) dominate spend.
- **Top Medicines:** Ranked individual medicines by total NIC.

### 3. Regional & Practice-Level Analysis
- **Total spend by NHS region:** Midlands, North East & Yorkshire, and South East had highest spend.
- **Average NIC per practice:** South East, South West, and East of England led on a per-practice basis (excluding “unidentified” outliers).
- **Practice outliers:** Highlighted practices with total NIC >3 standard deviations above the mean.

### 4. Item-Level & Quantity Insights
- **Most expensive items:** Specialist dressings, rare disease drugs, and high-tech medicines exceed £1,000 per prescription on average.
- **Volume insights:** Enteral feeds and some nutrition/respiratory products had the largest average prescription quantities.

### 5. Spend per Patient
- Linked practice population data to calculate NIC per registered patient at region/practice level.
    - _Key finding:_ North West, Midlands, and North East & Yorkshire regions show the highest per-patient spend.

### 6. Cost Distribution & Outliers
- **NIC per prescription:** Highly skewed, with most items low-cost but a minority >£100.
- **10%** of all prescriptions had NIC >£100.
- **Visualised:** Log-scale histogram and boxplots.

### 7. Visualising Patterns & Cost Drivers
- **Pie chart:** Proportion of spend by top 5 BNF chapters.
- **Boxplots:** NIC per prescription by region and top 5 BNF chapters.
- **Scatterplot:** Top 20 medicines—volume (prescription count) vs. total NIC.
- **Heatmap:** Spend on top 10 medicines by region.

---

## Key Results & Insights

- **Prescribing spend is highly concentrated:** A small number of BNF chapters and medicines account for a large share of costs.
- **Strong regional variation** in total spend, spend per practice, and spend per patient.
- **Significant outliers** at the practice and prescription level, especially for specialist products and dressings.
- **Cost distribution is heavily right-skewed:** Most prescriptions are low-cost; a notable minority are very expensive.
- **Per-patient spend:** Highest in North West and Midlands, lowest in London.
- **Visual outputs** clarify the scale of spend, drivers, and outliers for further policy/action.

---

## Next Steps / Recommendations

- **Drilldown:** Explore high-cost medicines and regions in more detail.
- **Equity:** Assess access and spend equity by region or patient demographics.
- **Benchmarking:** Use outlier analysis to identify practices for review or support.
- **Prediction:** Extend to forecasting, demand modelling, or cost efficiency studies.

---

## How to Reproduce

1. Download the English Prescribing Dataset and practice population file.
2. Clean and preprocess as above (see code and data steps).
3. Use the provided R code to generate all summary tables and plots.
4. Adapt or extend analysis for further questions as needed.

