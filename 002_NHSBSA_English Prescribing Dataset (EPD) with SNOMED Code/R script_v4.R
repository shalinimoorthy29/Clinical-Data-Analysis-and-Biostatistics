# Set working directory
setwd("C:/Users/shali/Documents/L&D/GitHub Projects/Clinical Data Analysis/002_NHSBSA_English Prescribing Dataset (EPD) with SNOMED Code")

# Load required packages and libraries
library(tidyverse)
library(ggplot2)
library(scales)     # For nicer axis formatting

# 1. DATA QUALITY CHECKS ------------------------------------------------------

# Load the dataset
epd <- read.csv("EPD_SNOMED_202501.csv")

# Glimpse at the data
dim(epd)
str(epd)
head(epd)
summary(epd)

# Check missing data
missing_summary <- sapply(epd, function(x) {
  if (is.character(x)) {
    mean(is.na(x) | x == "") * 100
  } else {
    mean(is.na(x)) * 100
  }
})
missing_df <- data.frame(
  column = names(missing_summary),
  percent_missing = round(missing_summary, 2)
) %>%
  arrange(desc(percent_missing))
print(missing_df)

# Plot missing data
ggplot(missing_df, aes(x = reorder(column, percent_missing), y = percent_missing)) +
  geom_col(fill = "tomato") +
  coord_flip() +
  labs(title = "Percentage of Missing or Empty Values by Column",
       x = "", y = "% Missing") +
  theme_minimal()

# Lowercase column names for consistency
names(epd) <- tolower(names(epd))

# Remove rows with missing or zero key values
epd_clean <- epd %>%
  filter(
    nic > 0,
    actual_cost > 0,
    total_quantity > 0,
    !is.na(snomed_code),
    snomed_code != ""
  )

# 2. SUMMARY & HIGH-LEVEL SPEND PATTERNS --------------------------------------

# Add BNF chapter variable
epd_clean <- epd_clean %>%
  mutate(bnf_chapter = substr(bnf_code, 1, 2))

# Top 10 BNF chapters by total NIC
top_chapters <- epd_clean %>%
  group_by(bnf_chapter) %>%
  summarise(total_nic = sum(nic, na.rm = TRUE), .groups = "drop") %>%
  arrange(desc(total_nic))
print(top_chapters)
ggplot(top_chapters %>% slice_head(n = 10),
       aes(x = reorder(bnf_chapter, total_nic), y = total_nic)) +
  geom_col(fill = "royalblue") +
  coord_flip() +
  labs(title = "Top 10 BNF Chapters by Total NIC", x = "BNF Chapter", y = "Total NIC (£)") +
  scale_y_continuous(labels = comma) +
  theme_minimal()

# Top 10 medicines by total NIC
bnf_summary <- epd_clean %>%
  group_by(bnf_description) %>%
  summarise(
    total_items = sum(items, na.rm = TRUE),
    total_quantity = sum(total_quantity, na.rm = TRUE),
    total_nic = sum(nic, na.rm = TRUE),
    avg_nic_per_item = total_nic / total_items,
    avg_quantity_per_item = total_quantity / total_items,
    .groups = "drop"
  ) %>%
  arrange(desc(total_nic))
print(head(bnf_summary, 10))
top10_nic <- bnf_summary %>% slice_head(n = 10)
ggplot(top10_nic, aes(x = reorder(bnf_description, total_nic), y = total_nic)) +
  geom_col(fill = "darkgreen") +
  coord_flip() +
  labs(
    title = "Top 10 BNF Items by Total NIC",
    x = "BNF Item",
    y = "Total NIC (£)"
  ) +
  scale_y_continuous(labels = comma) +
  theme_minimal()

# 3. REGIONAL AND PRACTICE VARIATION ------------------------------------------

# Total NIC by NHS region
total_nic_by_region <- epd_clean %>%
  group_by(regional_office_name) %>%
  summarise(total_nic = sum(nic, na.rm = TRUE), .groups = "drop") %>%
  arrange(desc(total_nic))
print(total_nic_by_region)
ggplot(total_nic_by_region, aes(x = reorder(regional_office_name, total_nic), y = total_nic)) +
  geom_col(fill = "steelblue") +
  coord_flip() +
  labs(title = "Total NIC by NHS Region", x = "Region", y = "Total NIC (£)") +
  scale_y_continuous(labels = comma) +
  theme_minimal()

# Average NIC per practice by region
per_practice_average <- epd_clean %>%
  group_by(regional_office_name, practice_code) %>%
  summarise(practice_nic = sum(nic, na.rm = TRUE), .groups = "drop") %>%
  group_by(regional_office_name) %>%
  summarise(avg_nic_per_practice = mean(practice_nic, na.rm = TRUE), .groups = "drop") %>%
  arrange(desc(avg_nic_per_practice))
print(per_practice_average)
per_practice_average %>%
  filter(regional_office_name != "UNIDENTIFIED") %>%
  ggplot(aes(x = reorder(regional_office_name, avg_nic_per_practice), y = avg_nic_per_practice)) +
  geom_col(fill = "darkorange") +
  coord_flip() +
  labs(title = "Average NIC per Practice by NHS Region",
       x = "Region", y = "Avg NIC (£)") +
  scale_y_continuous(labels = comma) +
  theme_minimal()

# Outlier practices (by total NIC)
practice_nic_summary <- epd_clean %>%
  group_by(practice_code, practice_name, regional_office_name) %>%
  summarise(total_nic = sum(nic, na.rm = TRUE), .groups = "drop") %>%
  mutate(z_score = (total_nic - mean(total_nic)) / sd(total_nic)) %>%
  filter(abs(z_score) > 3)
print(practice_nic_summary)

# 4. ITEM-LEVEL & QUANTITY INSIGHTS -------------------------------------------

# Most expensive items per prescription (only if >50 prescriptions)
expensive_per_item <- epd_clean %>%
  group_by(bnf_description) %>%
  summarise(
    total_nic = sum(nic, na.rm = TRUE),
    total_items = sum(items, na.rm = TRUE),
    avg_cost_per_item = total_nic / total_items,
    .groups = "drop"
  ) %>%
  filter(total_items > 50) %>%
  arrange(desc(avg_cost_per_item)) %>%
  slice_head(n = 10)
print(expensive_per_item)

# Distribution of prescription quantity (by item)
quantity_dist <- epd_clean %>%
  group_by(bnf_description) %>%
  summarise(
    avg_quantity = mean(total_quantity, na.rm = TRUE),
    median_quantity = median(total_quantity, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  arrange(desc(avg_quantity)) %>%
  slice_head(n = 10)
print(quantity_dist)

# 5. COST DISTRIBUTION & OUTLIERS ---------------------------------------------

# Distribution of prescription costs (NIC)
ggplot(epd_clean, aes(x = nic)) +
  geom_histogram(bins = 100, fill = "purple", colour = "white") +
  scale_x_log10(labels = comma) +
  labs(title = "Distribution of Prescription Costs (NIC)",
       x = "NIC (£, log scale)", y = "Number of Prescriptions") +
  theme_minimal()

# 6. PRACTICE POPULATION ANALYSIS (if available) ------------------------------

# Read in and tidy population data
practice_pop <- read.csv("gp-reg-pat-prac-all.csv")
colnames(practice_pop) <- tolower(colnames(practice_pop))
practice_pop <- practice_pop %>%
  rename(
    practice_code = code,
    practice_population = number_of_patients
  )
practice_pop$practice_code <- trimws(practice_pop$practice_code)
epd_clean$practice_code   <- trimws(epd_clean$practice_code)

# Join population data and calculate spend per patient
epd_with_pop <- epd_clean %>%
  left_join(practice_pop, by = "practice_code")
spend_per_patient <- epd_with_pop %>%
  filter(!is.na(practice_population) & practice_population > 0) %>%
  group_by(regional_office_name) %>%
  summarise(
    total_nic = sum(nic, na.rm = TRUE),
    total_patients = sum(practice_population, na.rm = TRUE),
    nic_per_patient = total_nic / total_patients,
    .groups = "drop"
  ) %>%
  arrange(desc(nic_per_patient))
print(spend_per_patient)
ggplot(spend_per_patient, aes(x = reorder(regional_office_name, nic_per_patient), y = nic_per_patient)) +
  geom_col(fill = "mediumorchid") +
  coord_flip() +
  labs(title = "NIC per Patient by NHS Region",
       x = "Region", y = "NIC per Patient (£)") +
  scale_y_continuous(labels = comma) +
  theme_minimal()

# 7. COST VOLUME RELATIONSHIP & OTHER VISUALS ---------------------------------

# Scatter: Volume vs. Cost for top 20 medicines
cost_volume <- epd_clean %>%
  group_by(bnf_description) %>%
  summarise(
    total_nic = sum(nic, na.rm = TRUE),
    total_items = sum(items, na.rm = TRUE),
    .groups = "drop"
  )
cost_volume %>%
  top_n(20, total_nic) %>%
  ggplot(aes(x = total_items, y = total_nic, label = bnf_description)) +
  geom_point(colour = "navy", size = 3) +
  geom_text(nudge_y = 1e6, size = 3, check_overlap = TRUE) +
  scale_x_continuous(labels = comma) +
  scale_y_continuous(labels = comma) +
  labs(title = "Top 20 Medicines: Volume vs Total NIC",
       x = "Number of Items",
       y = "Total NIC (£)") +
  theme_minimal()

# Heatmap: Spend on Top 10 Medicines by Region
top5_meds <- epd_clean %>%
  group_by(bnf_description) %>%
  summarise(total_nic = sum(nic, na.rm = TRUE)) %>%
  arrange(desc(total_nic)) %>%
  slice_head(n = 10) %>%
  pull(bnf_description)
heatmap_data <- epd_clean %>%
  filter(bnf_description %in% top5_meds) %>%
  group_by(regional_office_name, bnf_description) %>%
  summarise(total_nic = sum(nic, na.rm = TRUE), .groups = "drop")
ggplot(heatmap_data, aes(x = bnf_description, y = regional_office_name, fill = total_nic)) +
  geom_tile() +
  scale_fill_gradient(low = "white", high = "red", labels = comma) +
  labs(title = "Spend on Top Medicines by Region",
       x = "Medicine", y = "Region", fill = "NIC (£)") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# Pie: Proportion of Spend by Top 5 BNF Chapters
chapter_pie <- epd_clean %>%
  group_by(bnf_chapter) %>%
  summarise(total_nic = sum(nic, na.rm = TRUE)) %>%
  arrange(desc(total_nic)) %>%
  mutate(prop = total_nic / sum(total_nic)) %>%
  slice_head(n = 5)
ggplot(chapter_pie, aes(x = "", y = prop, fill = bnf_chapter)) +
  geom_col(width = 1) +
  coord_polar(theta = "y") +
  labs(title = "Proportion of Spend: Top 5 BNF Chapters",
       fill = "BNF Chapter") +
  scale_y_continuous(labels = percent) +
  theme_void()

# 8. BASIC STATISTICS & BOXPLOTS ----------------------------------------------

# Overall NIC statistics
summary_stats <- epd_clean %>%
  summarise(
    mean_nic = mean(nic, na.rm = TRUE),
    median_nic = median(nic, na.rm = TRUE),
    sd_nic = sd(nic, na.rm = TRUE),
    min_nic = min(nic, na.rm = TRUE),
    max_nic = max(nic, na.rm = TRUE),
    p10_nic = quantile(nic, 0.10, na.rm = TRUE),
    p90_nic = quantile(nic, 0.90, na.rm = TRUE)
  )
print(summary_stats)

# NIC statistics by region
region_stats <- epd_clean %>%
  group_by(regional_office_name) %>%
  summarise(
    mean_nic = mean(nic, na.rm = TRUE),
    median_nic = median(nic, na.rm = TRUE),
    sd_nic = sd(nic, na.rm = TRUE),
    .groups = "drop"
  )
print(region_stats)

# Proportion of high-cost prescriptions (NIC > £100)
high_cost_prop <- epd_clean %>%
  summarise(
    total = n(),
    high_cost = sum(nic > 100, na.rm = TRUE),
    prop_high_cost = high_cost / total
  )
print(high_cost_prop)

# Boxplot: NIC per Prescription by Region
ggplot(epd_clean, aes(x = regional_office_name, y = nic)) +
  geom_boxplot(fill = "skyblue") +
  scale_y_log10(labels = comma) +
  labs(title = "NIC per Prescription by NHS Region",
       x = "NHS Region", y = "NIC (£, log scale)") +
  theme_minimal() +
  coord_flip()

# Boxplot: NIC per Prescription by Top 5 BNF Chapters
top5_chapters <- epd_clean %>%
  group_by(bnf_chapter) %>%
  summarise(total_nic = sum(nic, na.rm = TRUE), .groups = "drop") %>%
  arrange(desc(total_nic)) %>%
  slice_head(n = 5) %>%
  pull(bnf_chapter)
epd_clean %>%
  filter(bnf_chapter %in% top5_chapters) %>%
  ggplot(aes(x = bnf_chapter, y = nic)) +
  geom_boxplot(fill = "orchid") +
  scale_y_log10(labels = comma) +
  labs(title = "NIC per Prescription by Top 5 BNF Chapters",
       x = "BNF Chapter", y = "NIC (£, log scale)") +
  theme_minimal()
