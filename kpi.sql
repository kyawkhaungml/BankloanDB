-- Total Loan Applications
use bankloanDB
SELECT COUNT(id) as Total_Applications FROM FinancialLoans;

-- MTD Loan Applications
SELECT COUNT(id) AS Total_Applications FROM FinancialLoans
WHERE MONTH(issue_date_dt) = 12;

-- Total Funded Amount
SELECT SUM(loan_amount) AS Total_Funded_Amount FROM FinancialLoans;

-- Total Amount Received
SELECT SUM(total_payment) AS Total_Amount_Received FROM FinancialLoans;

-- Average Interest Rate
SELECT AVG(int_rate) AS Average_Interest_Rate FROM FinancialLoans;

-- Home Ownership
SELECT 
	home_ownership AS Home_Ownership, 
	COUNT(id) AS Total_Loan_Applications,
	SUM(loan_amount) AS Total_Funded_Amount,
	SUM(total_payment) AS Total_Amount_Received
FROM FinancialLoans
GROUP BY home_ownership
ORDER BY home_ownership

-- Purpose
SELECT 
	purpose AS PURPOSE, 
	COUNT(id) AS Total_Loan_Applications,
	SUM(loan_amount) AS Total_Funded_Amount,
	SUM(total_payment) AS Total_Amount_Received
FROM FinancialLoans
GROUP BY purpose
ORDER BY purpose

-- TERM
SELECT 
	term AS Term, 
	COUNT(id) AS Total_Loan_Applications,
	SUM(loan_amount) AS Total_Funded_Amount,
	SUM(total_payment) AS Total_Amount_Received
FROM FinancialLoans
GROUP BY term
ORDER BY term

-- STATE
SELECT 
	address_state AS State, 
	COUNT(id) AS Total_Loan_Applications,
	SUM(loan_amount) AS Total_Funded_Amount,
	SUM(total_payment) AS Total_Amount_Received
FROM FinancialLoans
GROUP BY address_state
ORDER BY address_state

-- MONTH
SELECT 
	MONTH(issue_date_dt) AS Month_Munber, 
	DATENAME(MONTH, issue_date_dt) AS Month_name, 
	COUNT(id) AS Total_Loan_Applications,
	SUM(loan_amount) AS Total_Funded_Amount,
	SUM(total_payment) AS Total_Amount_Received
FROM FinancialLoans
GROUP BY MONTH(issue_date_dt), DATENAME(MONTH, issue_date_dt)
ORDER BY MONTH(issue_date_dt)


-- LOAN STATUS
	SELECT
        loan_status,
        COUNT(id) AS LoanCount,
        SUM(total_payment) AS Total_Amount_Received,
        SUM(loan_amount) AS Total_Funded_Amount,
        AVG(int_rate * 100) AS Interest_Rate,
        AVG(dti * 100) AS DTI
    FROM
        FinancialLoans
    GROUP BY
        loan_status
