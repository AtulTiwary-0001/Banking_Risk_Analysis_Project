# 🏦 Banking Domain Data Analysis — Risk Assessment & Portfolio Management

An end-to-end data analysis project exploring customer financial behavior for a leading banking institution — from raw data cleaning to an interactive Power BI dashboard. The goal is to help stakeholders make data-driven decisions around risk management, product strategy, and customer engagement.

---

## 📌 Business Problem

> *"How can the bank leverage customer financial and behavioral data to identify high-risk customers, optimize product offerings, and improve risk-adjusted profitability?"*

A leading banking institution observed variations in customer risk levels, credit utilization, and overall profitability. Management needed answers around how income levels, credit card usage, loan exposure, deposits, account types, and demographics influence financial risk and customer value.

Key focus areas:
- Identifying **high-risk customers** based on loan exposure, income, and risk weighting
- Understanding **loyalty classification** patterns and product adoption behavior
- Comparing **loan vs deposit trends** and credit card utilization across customer segments
- Analyzing **demographic influences** — age, occupation, nationality, gender — on financial behavior

---

## 🗂️ Project Structure

```
Banking_Risk_Analysis/
│
├── data/
│   └── Banking.xlsx                               # Raw dataset (4 sheets)
│
├── python/
│   └── BankingProj.ipynb                          # EDA, feature engineering, correlation
│
├── sql/
│   └── Banking_data_sql.sql                       # Customer segmentation & risk queries
│
├── powerbi/
│   └── Banking_Domain_Data_Analysis_project.pbix  # Interactive dashboard
│
└── README.md
```

---

## 🛠️ Tech Stack

| Tool | Purpose |
|---|---|
| Python (Pandas, Matplotlib, Seaborn) | Data cleaning, feature engineering, EDA |
| MySQL (`banking_case` schema) | Structured storage and querying |
| SQL | Business queries, segmentation, risk analysis |
| Power BI | Interactive dashboard and KPI visualization |
| Excel | Raw data source |

---

## 📊 Dataset Description

The dataset (`Banking.xlsx`) contains **customer-level financial and demographic data** across 4 sheets:

### Sheet 1 — `Clients - Banking` (Main Table)

| Column | Description |
|---|---|
| `Client_ID` | Unique customer identifier (e.g., IND81288) |
| `Name` | Customer full name |
| `Age` | Customer age |
| `Location_ID` | Location reference ID |
| `Joined_Bank` | Date the customer joined the bank |
| `Banking_Contact` | Assigned banker / relationship manager |
| `Nationality` | American, African, Asian, European, Australian |
| `Occupation` | Customer's job role |
| `Fee_Structure` | Low / Mid / High |
| `Loyalty_Classification` | Jade / Silver / Gold / Platinum |
| `Estimated_Income` | Annual income estimate |
| `Superannuation_Savings` | Retirement savings balance |
| `Amount_of_Credit_Cards` | Number of credit cards held (1–3) |
| `Credit_Card_Balance` | Outstanding credit card balance |
| `Bank_Loans` | Total loan exposure |
| `Bank_Deposits` | Total deposit amount |
| `Checking_Accounts` | Checking account balance |
| `Saving_Accounts` | Savings account balance |
| `Foreign_Currency_Account` | Foreign currency holdings |
| `Business_Lending` | Business loan amount |
| `Properties_Owned` | Number of properties owned (0–3) |
| `Risk_Weighting` | Bank-assigned risk score (1–5) |
| `BRId` | Banking relationship type (FK → Sheet 3) |
| `Gender_Id` | Gender reference (FK → Sheet 2) |
| `IAId` | Investment advisor reference (FK → Sheet 4) |

### Sheet 2 — `Gender`
Maps `Gender_Id` → Male (1) / Female (2)

### Sheet 3 — `Banking Relationship`
Maps `BRId` → Retail / Institutional / Private Bank / Commercial

### Sheet 4 — `Investment Advisor`
Maps `IAId` → 22 named investment advisors

---

## ⚙️ Data Preparation & Python EDA (`BankingProj.ipynb`)

### Setup & Data Loading
- Installed `mysql-connector-python` and connected to the MySQL `banking_case` database using `SQLAlchemy`
- Loaded the full `customer` table into a Pandas DataFrame using `pd.read_sql()`
- Used `.head()`, `.info()`, and `.describe()` to explore structure, data types, and summary statistics
- Standardized all column names to lowercase using `.str.lower()`

### Feature Engineering
- **Income Band**: Segmented `Estimated Income` into `Low` (< $100K), `Mid` ($100K–$300K), and `High` (> $300K) using `pd.cut()` with custom bins and labels

### Categorical Analysis
Examined value distributions across 11 categorical columns using `value_counts()`:

`brid` · `genderid` · `iaid` · `amount of credit cards` · `nationality` · `occupation` · `fee structure` · `loyalty classification` · `properties owned` · `risk weighting` · `income band`

### Univariate Analysis
- Individual `sns.countplot()` charts for every categorical column

### Bivariate Analysis
- Count plots with `hue='nationality'` to cross-tabulate all categorical features against nationality
- Histogram (`sns.histplot`) for each categorical column (excluding `occupation`) to examine frequency spread

### Numerical Analysis
Distributions analyzed for 8 numerical columns:

`estimated income` · `superannuation savings` · `credit card balance` · `bank loans` · `bank deposits` · `checking accounts` · `foreign currency account` · `business lending`

- Histogram + KDE plots in a `4×3` subplot grid (`figsize=(15,10)`)
- **Correlation Heatmap**: Full correlation matrix across all 8 numerical columns plotted with `sns.heatmap(cmap='crest', annot=True, fmt=".2f")`

---

## 🗄️ SQL Analysis (`Banking_data_sql.sql`)

All queries run against the `banking_case.customer` table in MySQL.

### Customer Overview

```sql
-- Total customer count
SELECT COUNT(*) AS Total_count FROM customer;

-- Gender distribution (1 = Male, 2 = Female)
SELECT gender_id, COUNT(*) AS count FROM customer GROUP BY gender_id;

-- Age distribution (most common ages)
SELECT age, COUNT(*) AS count FROM customer GROUP BY age ORDER BY count DESC;

-- Average customer income
SELECT AVG(estimated_income) AS AvgIncome FROM customer;
```

### Financial Behavior

```sql
-- Total loans vs total deposits
SELECT SUM(bank_loans) AS total_loans, SUM(bank_deposits) AS total_deposits FROM customer;

-- Customers with high loans but low deposits
SELECT client_id, estimated_income, bank_loans, bank_deposits
FROM customer
WHERE bank_loans > bank_deposits
ORDER BY bank_loans DESC;

-- Customers holding 2 or more credit cards
SELECT COUNT(*) AS amount_of_credit_cards
FROM customer
WHERE amount_of_credit_cards >= 2;

-- Average credit card balance
SELECT AVG(credit_card_balance) AS avg_cc_balance FROM customer;
```

### Customer Segmentation

```sql
-- Income segmentation: Low / Medium / High
SELECT
    CASE
        WHEN estimated_income < 60000 THEN 'Low Income'
        WHEN estimated_income BETWEEN 60000 AND 120000 THEN 'Medium Income'
        ELSE 'High Income'
    END AS income_group,
    COUNT(*) AS customer_count
FROM customer
GROUP BY income_group;

-- Loyalty tier distribution
SELECT loyalty_classification, COUNT(*) AS count
FROM customer
GROUP BY loyalty_classification;

-- Risk weighting distribution
SELECT risk_weighting, COUNT(*) AS customer_count
FROM customer
GROUP BY risk_weighting
ORDER BY risk_weighting DESC;
```

### Risk Analysis

```sql
-- High-risk customers (risk_weighting >= 4)
SELECT client_id, estimated_income, bank_loans, bank_deposits, risk_weighting
FROM customer
WHERE risk_weighting >= 4
ORDER BY risk_weighting DESC;

-- Relationship between income group and average risk
SELECT
    CASE
        WHEN estimated_income < 60000 THEN 'Low Income'
        WHEN estimated_income BETWEEN 60000 AND 120000 THEN 'Medium Income'
        ELSE 'High Income'
    END AS income_group,
    AVG(risk_weighting) AS avg_risk
FROM customer
GROUP BY income_group;

-- Vulnerable customers: high loans + low income + elevated risk
SELECT client_id, estimated_income, bank_loans, risk_weighting
FROM customer
WHERE estimated_income < 80000
  AND bank_loans > 300000
  AND risk_weighting > 2
ORDER BY risk_weighting DESC;

-- Financially strong customers: higher income, deposits exceed loans, low risk
SELECT client_id, estimated_income, bank_deposits, risk_weighting
FROM customer
WHERE estimated_income > 80000
  AND bank_deposits > bank_loans
  AND risk_weighting <= 3;
```

---

## 📈 Power BI Dashboard (`Banking_Domain_Data_Analysis_project.pbix`)

An interactive dashboard developed to surface insights for banking stakeholders.

### Key KPIs
- Total Loans vs Total Deposits
- Average Customer Income
- Credit Card Utilization Rate
- Risk-Weighted Customer Distribution

### Dashboard Views

| View | Focus |
|---|---|
| **Risk Segmentation** | Distribution of customers across risk levels 1–5 |
| **Customer Financial Profile** | Income, deposits, and loan comparisons by segment |
| **Product Utilization** | Credit cards, savings, foreign accounts, business lending |
| **Demographic Insights** | Age-wise risk patterns, occupation-based financial behavior, geographic spread |

---

## 💡 Key Insights

- Customers with **low income + high loan exposure** cluster at risk weights 4–5, signaling default vulnerability
- **High-income customers** (> $80K) where deposits exceed loans represent the bank's most financially stable segment
- **Jade-tier** loyalty customers show higher average loan-to-deposit ratios compared to Platinum/Gold tiers
- A significant portion of customers holds **2+ credit cards**, correlating with higher revolving balances
- **Income band** is a stronger predictor of risk weighting than age or nationality alone
- Low-income customers taking on loans > $300K with risk weights above 2 represent a concentrated area of portfolio risk

---

## 🚀 How to Run

### 1. Clone the Repository
```bash
git clone https://github.com/your-username/Banking_Risk_Analysis.git
cd Banking_Risk_Analysis
```

### 2. Install Python Dependencies
```bash
pip install pandas matplotlib seaborn sqlalchemy mysql-connector-python jupyter
```

### 3. Run the Notebook
Open and run `python/BankingProj.ipynb` cell by cell. Update the MySQL connection string with your credentials:
```python
engine = create_engine("mysql+mysqlconnector://username:password@localhost:3306/banking_case")
```

### SQL Queries
```sql
-- Create and use database
CREATE DATABASE banking_case;
USE banking_case;

-- Import Banking.xlsx data into the `customer` table
-- Then run queries from Banking_data_sql.sql
```


### 5. Open the Dashboard
Open `powerbi/Banking_Domain_Data_Analysis_project.pbix` in **Power BI Desktop** to explore the interactive dashboard.

---

## 👤 Author

**Atul Tiwary**
GitHub • LinkedIn

---

## 📄 License

This project is open-source and available under the MIT License.
