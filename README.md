# Bank Loan Analysis & ML Classification Project

A data-driven exploration of bank loan approvals combining SQL-based data engineering, machine learning classification, and business intelligence dashboards. Built out of a personal interest in finance and banking, this project applies a full data science workflow — from raw data ingestion to predictive modeling and visualization.

---

## Project Overview

As someone with a strong interest in finance and personal banking, I wanted to explore how machine learning could help predict loan approvals based on customer data. I gathered a dataset of bank customers, cleaned and preprocessed the data using Pandas, and built classification models with scikit-learn to predict whether a loan would be approved or denied. I evaluated different algorithms, tuned hyperparameters, and visualized results to understand which factors most influenced loan decisions.

This project helped me apply data science techniques to a real-world financial problem while deepening my understanding of end-to-end ML workflows.

---

## Tech Stack

| Layer | Technology |
|---|---|
| Containerization | Docker |
| Database | PostgreSQL / SQL Server |
| Data Transformation | SQL (T-SQL) |
| Data Processing | Python, Pandas |
| Machine Learning | scikit-learn |
| Notebooks | Jupyter Notebook |
| Visualization | Tableau, Excel |
| Project Format | SQL Project (`.sqlproj`) |

---

## Project Structure

```
bankloanDB/
├── analysis.ipynb          # Jupyter Notebook: EDA, ML models, evaluation
├── data_cleaning.sql       # SQL: staging, transformation, type casting
├── kpi.sql                 # SQL: KPI queries (applications, funded amounts, etc.)
├── bankloanDB.sqlproj      # SQL project definition
├── financial_loan.csv      # Raw dataset (excluded from repo via .gitignore)
└── README.md
```

---

## Data Pipeline

### 1. Ingestion & Staging (SQL)
- The raw CSV (`financial_loan.csv`) is loaded into a **staging table** using `BULK INSERT`
- All fields are initially typed as `NVARCHAR` to safely stage the raw data
- A **production table** (`FinancialLoans`) is then created with proper data types after validation

### 2. Data Cleaning & Transformation (SQL)
- Date columns (`issue_date`, `last_payment_date`, etc.) are parsed and cast to `DATE`
- Numeric fields (`loan_amount`, `int_rate`, `dti`, `installment`) are converted from string to appropriate numeric types
- Null handling and conditional updates applied throughout

### 3. KPI Analysis (SQL)
Key business metrics computed directly in SQL:
- Total Loan Applications & Month-to-Date (MTD) Applications
- Total Funded Amount & Total Amount Received
- Average Interest Rate & Debt-to-Income (DTI) Ratio
- Breakdowns by: Loan Status, Purpose, Term, Home Ownership, State, Month

### 4. Exploratory Data Analysis & ML (Python / Jupyter)
- EDA with Pandas: distributions, correlations, feature exploration
- Classification models (e.g., Logistic Regression, Decision Tree, Random Forest) using scikit-learn
- Hyperparameter tuning and cross-validation
- Feature importance analysis to understand key drivers of loan approval

---

## Docker & PostgreSQL Setup

The database is containerized using **Docker** for portability and reproducibility.

```bash
# Pull and run a PostgreSQL container
docker run --name bankloandb \
  -e POSTGRES_USER=admin \
  -e POSTGRES_PASSWORD=yourpassword \
  -e POSTGRES_DB=bankloanDB \
  -p 5432:5432 \
  -v $(pwd)/data:/tmp \
  -d postgres:latest
```

Then connect using your preferred SQL client (e.g., Azure Data Studio, DBeaver, or psql) and run the scripts:

```bash
# Connect to the container
docker exec -it bankloandb psql -U admin -d bankloanDB

# Or run scripts directly
docker exec -i bankloandb psql -U admin -d bankloanDB < data_cleaning.sql
docker exec -i bankloandb psql -U admin -d bankloanDB < kpi.sql
```

---

## Tableau & Excel Dashboards

After computing KPIs in SQL, results were exported and visualized using:

- **Tableau**: Interactive dashboards showing loan status distribution, funded amounts by state, monthly trends, and purpose breakdowns
- **Excel**: Pivot tables and charts used for quick financial summaries, DTI analysis, and interest rate comparisons across loan grades

---

## Key Insights

- Loan purpose, annual income, and DTI ratio are among the strongest predictors of loan status
- Debt consolidation is the most common loan purpose
- Longer-term loans (60 months) tend to have higher interest rates and default risk
- Fully paid loans significantly outnumber charged-off loans, creating a class imbalance that was addressed during modeling

---

## Getting Started

### Prerequisites
- Docker
- Python 3.9+
- Jupyter Notebook
- The dataset (`financial_loan.csv`) placed in the project root

### Install Python dependencies

```bash
pip install pandas scikit-learn matplotlib seaborn jupyter
```

### Run the notebook

```bash
jupyter notebook analysis.ipynb
```

---

## Dataset

The dataset contains anonymized bank customer loan records with the following key fields:

`loan_amount`, `int_rate`, `installment`, `grade`, `sub_grade`, `emp_length`, `home_ownership`, `annual_income`, `verification_status`, `loan_status`, `purpose`, `dti`, `total_payment`, `address_state`, `term`

> The raw CSV file is excluded from version control via `.gitignore` to keep the repository lightweight.

---

## Author

**Kyaw Khaung Myo Lwin**  
Aspiring Data Analyst | Finance & Banking Enthusiast  

---

## License

This project is for educational and portfolio purposes only.
