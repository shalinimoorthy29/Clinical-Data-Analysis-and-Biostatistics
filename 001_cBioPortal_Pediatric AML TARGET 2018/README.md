# **Exploratory Data Analysis of Peadiatric Acute Myeloid Leukaemia Data**
---

## **Dataset Used**

'Pediatric Acute Myeloid Leukemia (TARGET, 2018)'

Link to Dataset for Download: https://www.cbioportal.org/study/summary?id=aml_target_2018_pub


## **Objectives**

1. To explore survival outcomes across various clinical and demographic factors.
2. To identify trends in diagnosis age, sex, race, and bone marrow blast percentages.
3. To examine relationships between clinical parameters using correlation analysis.

## **Sections and Methods**

The analysis was divided into the following key sections:

### **1. Survival Analysis**

- **Kaplan-Meier Survival Curves**:  
  Kaplan-Meier survival curves were generated to assess survival probabilities across different groups:
  - CEBPA Mutation Status (Positive vs Negative)
  - Sex (Male vs Female)
  - Race Categories
  - Minimal Residual Disease (MRD) Levels
- **Statistical Test**:  
  Pairwise log-rank tests were conducted to determine the statistical significance of survival differences.

### **2. Descriptive Statistics and Visualisations**

- **Diagnosis Age**:
  - Summary statistics (mean, median, standard deviation) for diagnosis age.
  - Histograms and boxplots were used to visualise the distribution of diagnosis age across sex and race.
- **Bone Marrow Leukemic Blast Percentages**:
  - Descriptive statistics (mean, median, standard deviation) and histogram for distribution analysis.
  - Boxplots comparing bone marrow blast percentages across sex and risk groups.
- **White Blood Cell Count (WBC)**:
  - Scatterplots were generated to identify any trends or relationships between WBC count and bone marrow blast percentages.

### **3. Correlation Analysis**

- **Correlation Heatmap**:  
  A correlation matrix and heatmap were generated to assess relationships between critical clinical parameters such as:
  - Overall Survival Days, MRD Percentage, Mutation Count, Fraction Genome Altered, WBC, and Risk Group.
- **Kruskal-Wallis Test**:  
  Used to assess differences in MRD percentages across risk groups.

## **Results**

### **Survival Analysis**

- **Mutation Status**:
  - **CEBPA Mutation**:  
    Patients with **CEBPA mutations** demonstrated significantly better survival outcomes compared to patients without the mutation (p = 0.0097). The Kaplan-Meier curve showed a clear separation between the two groups.

  - **FLT3-ITD Mutation**:  
    There was no statistically significant difference in survival between patients with and without **FLT3-ITD mutations** (p = 0.0779), although a trend towards poorer survival outcomes was observed for mutation-positive patients.

  - **NPM Mutation**:  
    No significant difference was observed in survival between patients with and without **NPM mutations** (p = 0.8486). Both groups displayed overlapping survival curves.

- **Sex**:  
  No significant survival difference between male and female patients.

- **Race**:  
  Black or African American patients exhibited lower survival probabilities compared to White patients (p = 0.000001).

- **MRD Levels**:  
  Patients with lower MRD percentages at the end of Course 1 showed significantly better survival outcomes (p < 0.05).

### **Descriptive Statistics**

- **Diagnosis Age**:
  - Mean: 9.96 years, Median: 11 years.
  - Diagnosis age peaks in early childhood (0–5 years).
  - No significant difference in diagnosis age was observed between males and females.
- **Bone Marrow Blast Percentage**:
  - Predominantly high (mean: 65.68%), with most values >60%.
  - Higher MRD percentages were associated with the “High Risk” group.

### **Correlation Analysis**

- **Key Positive Correlations**:
  - Bone Marrow Blast Percentage and Risk Group (0.98).
  - Peripheral Blasts and WBC Count (0.84).
  - Mutation Count and Overall Survival Days (0.79).
- **Key Negative Correlations**:
  - MRD Percentage at Course 1 and Overall Survival Days (-0.45).
  - Diagnosis Age and Risk Group (-0.52).

## **Conclusions**

- Survival outcomes were significantly influenced by **CEBPA mutation** status and **MRD percentages**.
- **Race** also showed disparities in survival, with Black or African American patients experiencing worse outcomes.
- Diagnosis age peaks in early childhood and does not differ significantly by sex or race.
- Higher bone marrow leukemic blast percentages were strongly associated with higher-risk groups.
- Correlation analysis identified strong relationships between mutation counts, WBC counts, and overall survival.

## **Future Work**

1. Further stratify survival analysis based on additional clinical and genomic factors.
2. Integrate multivariate survival models (e.g., Cox Proportional Hazards) to assess combined effects of predictors.
3. Investigate underlying biological mechanisms for observed survival disparities by race.
4. Extend analysis to incorporate genomic signatures for enhanced prognostic accuracy.
5. Perform predictive modelling for risk assessment and treatment response using machine learning techniques.

---
