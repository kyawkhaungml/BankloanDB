SELECT * FROM sys.databases WHERE name = 'bankloanDB';

-- DATA CLEANING AND TRANSFORMATION SCRIPT

USE bankloanDB;
SELECT * FROM FinancialLoans;

USE bankloanDB;
SELECT * FROM stagingTable;

-- delete all the data from FinancialLoans table
DELETE FROM FinancialLoans;

-- delete all dti data from FinancialLoans table
UPDATE FinancialLoans
SET issue_date = NULL;

-- Create staging table
USE bankloanDB;
DROP TABLE IF EXISTS stagingTable;
CREATE TABLE stagingTable (
    -- replace all types with nvarchar for staging
    id BIGINT PRIMARY KEY,
    address_state NVARCHAR(40),
    application_type NVARCHAR(40),
    emp_length NVARCHAR(40),
    emp_title NVARCHAR(100),
    grade NVARCHAR(40),
    home_ownership NVARCHAR(40),
    issue_date NVARCHAR(40),
    last_credit_pull_date NVARCHAR(40),
    last_payment_date NVARCHAR(40),
    loan_status NVARCHAR(40),
    next_payment_date NVARCHAR(40),
    member_id NVARCHAR(40),
    purpose NVARCHAR(40),
    sub_grade NVARCHAR(40),
    term NVARCHAR(40),
    verification_status NVARCHAR(20),
    annual_income NVARCHAR(40),
    dti NVARCHAR(40),
    installment NVARCHAR(40),
    int_rate NVARCHAR(40),
    loan_amount NVARCHAR(40),
    total_acc NVARCHAR(40),
    total_payment NVARCHAR(40)
);

-- Load data from CSV into staging table
USE bankloanDB;
BULK INSERT stagingTable
FROM '/tmp/financial_loan.csv'
WITH (
    FORMAT = 'CSV',
    FIELDTERMINATOR = ',',
    FIELDQUOTE = '"',
    FIRSTROW = 2,  -- Skip header row
    ROWTERMINATOR = '0x0a',
    TABLOCK
);

-- Create FinancialLoans table with proper data types
USE bankloanDB;
DROP TABLE IF EXISTS FinancialLoans;
CREATE TABLE FinancialLoans (
    id BIGINT PRIMARY KEY,
    address_state NVARCHAR(50),
    application_type NVARCHAR(50),
    emp_length NVARCHAR(50),
    emp_title NVARCHAR(200),
    grade NVARCHAR(50),
    home_ownership NVARCHAR(100),
    issue_date NVARCHAR(50),
    last_credit_pull_date NVARCHAR(50),
    last_payment_date NVARCHAR(50),
    loan_status NVARCHAR(50),
    next_payment_date NVARCHAR(50),
    member_id NVARCHAR(50),
    purpose NVARCHAR(50),
    sub_grade NVARCHAR(50),
    term NVARCHAR(50),
    verification_status NVARCHAR(50),
    annual_income  DECIMAL(18,2) NULL,
    dti            DECIMAL(10,4) NULL,
    installment    DECIMAL(18,2) NULL,
    int_rate       DECIMAL(10,4) NULL,
    loan_amount    DECIMAL(18,2) NULL,
    total_acc      INT     NULL,
    total_payment  DECIMAL(18,2) NULL
);

-- select columns and types from stagingTable
USE bankloanDB;
SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'FinancialLoans';


USE bankloanDB;
-- Find rows in stagingTable where annual_income is not null/empty but cannot be converted to
SELECT annual_income
FROM stagingTable
WHERE NULLIF(LTRIM(RTRIM(annual_income)), '') IS NOT NULL
  AND TRY_CONVERT(DECIMAL(18,2), LTRIM(RTRIM(annual_income))) IS NULL;

-- Insert Primary Key from stagingTable to FinancialLoans table
INSERT INTO FinancialLoans (id)
SELECT id FROM stagingTable;

-- Update annual_income in FinancialLoans from stagingTable with proper conversion and cleaning
UPDATE FL
SET FL.annual_income =
    TRY_CONVERT(DECIMAL(18,2),
        NULLIF(
            REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
                LTRIM(RTRIM(ST.annual_income)),
                ',', ''),          -- remove commas
                '$', ''),          -- remove $
                CHAR(9), ''),      -- tab
                CHAR(13), ''),     -- CR
                CHAR(10), ''       -- LF
            ),
        '')
    )
FROM dbo.FinancialLoans FL
JOIN dbo.stagingTable ST ON FL.id = ST.id;

-- Update dti in FinancialLoans from stagingTable with proper conversion and cleaning
UPDATE FL
SET FL.dti =
    TRY_CONVERT(DECIMAL(10,4),
        NULLIF(
            REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
                LTRIM(RTRIM(ST.dti)),
                ',', ''),          -- remove commas
                '$', ''),          -- remove $
                CHAR(9), ''),      -- tab
                CHAR(13), ''),     -- CR
                CHAR(10), ''       -- LF
            ),
        '')
    )
FROM dbo.FinancialLoans FL
JOIN dbo.stagingTable ST ON FL.id = ST.id;

-- Update installment in FinancialLoans from stagingTable with proper conversion and cleaning
UPDATE FL
SET FL.installment =
    TRY_CONVERT(DECIMAL(18,2),
        NULLIF(
            REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
                LTRIM(RTRIM(ST.installment)),
                ',', ''),          -- remove commas
                '$', ''),          -- remove $
                CHAR(9), ''),      -- tab
                CHAR(13), ''),     -- CR
                CHAR(10), ''       -- LF
            ),
        '')
    )
FROM dbo.FinancialLoans FL
JOIN dbo.stagingTable ST ON FL.id = ST.id;

-- Update int_rate in FinancialLoans from stagingTable with proper conversion and cleaning
UPDATE FL
SET FL.int_rate =
    TRY_CONVERT(DECIMAL(10,4),
        NULLIF(
            REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
                LTRIM(RTRIM(ST.int_rate)),
                ',', ''),          -- remove commas
                '$', ''),          -- remove $
                CHAR(9), ''),      -- tab
                CHAR(13), ''),     -- CR
                CHAR(10), ''       -- LF
            ),
        '')
    )
FROM dbo.FinancialLoans FL
JOIN dbo.stagingTable ST ON FL.id = ST.id;

-- Update loan_amount in FinancialLoans from stagingTable with proper conversion and cleaning
UPDATE FL
SET FL.loan_amount =
    TRY_CONVERT(DECIMAL(18,2),
        NULLIF(
            REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
                LTRIM(RTRIM(ST.loan_amount)),
                ',', ''),          -- remove commas
                '$', ''),          -- remove $
                CHAR(9), ''),      -- tab
                CHAR(13), ''),     -- CR
                CHAR(10), ''       -- LF
            ),
        '')
    )
FROM dbo.FinancialLoans FL
JOIN dbo.stagingTable ST ON FL.id = ST.id;  

-- Update total_acc in FinancialLoans from stagingTable with proper conversion and cleaning
UPDATE FL
SET FL.total_acc =
    TRY_CONVERT(INT,
        NULLIF(
            REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
                LTRIM(RTRIM(ST.total_acc)),
                ',', ''),          -- remove commas
                '$', ''),          -- remove $
                CHAR(9), ''),      -- tab
                CHAR(13), ''),     -- CR
                CHAR(10), ''       -- LF
            ),
        '')
    )
FROM dbo.FinancialLoans FL
JOIN dbo.stagingTable ST ON FL.id = ST.id;

-- Update total_payment in FinancialLoans from stagingTable with proper conversion and cleaning
UPDATE FL
SET FL.total_payment =
    TRY_CONVERT(DECIMAL(18,2),
        NULLIF(
            REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
                LTRIM(RTRIM(ST.total_payment)),
                ',', ''),          -- remove commas
                '$', ''),          -- remove $
                CHAR(9), ''),      -- tab
                CHAR(13), ''),     -- CR
                CHAR(10), ''       -- LF
            ),
        '')
    )
FROM dbo.FinancialLoans FL
JOIN dbo.stagingTable ST ON FL.id = ST.id;


-- count number of rows matched between FinancialLoans and stagingTable
SELECT COUNT(*) AS matched_rows
FROM dbo.FinancialLoans FL
JOIN dbo.stagingTable ST ON FL.id = ST.id;

-- Update string columns in FinancialLoans from stagingTable after cleaning
UPDATE FL
SET
    FL.address_state          = NULLIF(LTRIM(RTRIM(REPLACE(ST.address_state, NCHAR(160), ' '))), ''),
    FL.application_type       = NULLIF(LTRIM(RTRIM(REPLACE(ST.application_type, NCHAR(160), ' '))), ''),
    FL.emp_length             = NULLIF(LTRIM(RTRIM(REPLACE(ST.emp_length, NCHAR(160), ' '))), ''),
    FL.emp_title              = NULLIF(LTRIM(RTRIM(REPLACE(ST.emp_title, NCHAR(160), ' '))), ''),
    FL.grade                  = NULLIF(LTRIM(RTRIM(REPLACE(ST.grade, NCHAR(160), ' '))), ''),
    FL.home_ownership         = NULLIF(LTRIM(RTRIM(REPLACE(ST.home_ownership, NCHAR(160), ' '))), ''),
    FL.issue_date             = NULLIF(LTRIM(RTRIM(REPLACE(ST.issue_date, NCHAR(160), ' '))), ''),
    FL.last_credit_pull_date  = NULLIF(LTRIM(RTRIM(REPLACE(ST.last_credit_pull_date, NCHAR(160), ' '))), ''),
    FL.last_payment_date      = NULLIF(LTRIM(RTRIM(REPLACE(ST.last_payment_date, NCHAR(160), ' '))), ''),
    FL.loan_status            = NULLIF(LTRIM(RTRIM(REPLACE(ST.loan_status, NCHAR(160), ' '))), ''),
    FL.next_payment_date      = NULLIF(LTRIM(RTRIM(REPLACE(ST.next_payment_date, NCHAR(160), ' '))), ''),
    FL.member_id              = NULLIF(LTRIM(RTRIM(REPLACE(ST.member_id, NCHAR(160), ' '))), ''),
    FL.purpose                = NULLIF(LTRIM(RTRIM(REPLACE(ST.purpose, NCHAR(160), ' '))), ''),
    FL.sub_grade              = NULLIF(LTRIM(RTRIM(REPLACE(ST.sub_grade, NCHAR(160), ' '))), ''),
    FL.term                   = NULLIF(LTRIM(RTRIM(REPLACE(ST.term, NCHAR(160), ' '))), ''),
    FL.verification_status    = NULLIF(LTRIM(RTRIM(REPLACE(ST.verification_status, NCHAR(160), ' '))), '')
FROM dbo.FinancialLoans FL
JOIN dbo.stagingTable ST
    ON FL.id = ST.id;

-- Best practice: create a new DATE column
use bankloanDB;
ALTER TABLE dbo.FinancialLoans
ADD issue_date_dt DATE NULL;

UPDATE dbo.FinancialLoans
SET issue_date_dt = TRY_CONVERT(DATE, issue_date, 105);

----------------------------------------------------------
-- Total Loan Applications
SELECT COUNT(id) AS total_loan_applications FROM FinancialLoans;

-- Total Loan Applications in December 2021
SELECT COUNT(id) AS total_loan_applications FROM FinancialLoans
WHERE MONTH(issue_date_dt) = 12 AND YEAR(issue_date_dt) = 2021;

-- Total Loan Amount
SELECT SUM(loan_amount) AS total_loan_amount FROM FinancialLoans;