-- Step 1: Create the database
CREATE DATABASE IF NOT EXISTS ClientData;

-- Step 2: Use the newly created database
USE ClientData;

-- Step 3: Create the table
CREATE TABLE ClientInfo (
    Client_Num VARCHAR(255),
    Card_Cate VARCHAR(50),
    Annual_Fee INT,
    Activation INT,
    Customer_Week INT,
    Week_Start_Date DATE,
    Week_Num VARCHAR(20),
    Qtr VARCHAR(5),
    Current_Year INT,
    Credit_Limit INT,
    Total_Rev INT,
    Total_Trans INT,
    Total_Tran INT,
    Avg_Utilization FLOAT,
    Use_Chip VARCHAR(20),
    Exp_Type VARCHAR(50),
    Interest_E FLOAT,
    Delinquent_Acc INT
);

-- Step 4: Load data from the CSV file

LOAD DATA INFILE 'D:/project/creditcard/dataset.csv'
INTO TABLE ClientInfo
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    Client_Num, 
    Card_Cate, 
    Annual_Fee, 
    Activation, 
    Customer_Week, 
    @Week_Start_Date, -- Capture the raw date as a variable
    Week_Num, 
    Qtr, 
    Current_Year, 
    Credit_Limit, 
    Total_Rev, 
    Total_Trans, 
    Total_Tran, 
    Avg_Utilization, 
    Use_Chip, 
    Exp_Type, 
    Interest_E, 
    Delinquent_Acc
)
SET Week_Start_Date = STR_TO_DATE(@Week_Start_Date, '%d-%m-%Y'); -- Convert to 'YYYY-MM-DD'


-- Create the table
CREATE TABLE CustomerInfo (
    Client_Num BIGINT NOT NULL,
    Customer_Age INT,
    Gender CHAR(1),
    Dependent_Count INT,
    Education_Level VARCHAR(50),
    Marital_Status VARCHAR(20),
    state_cd CHAR(2),
    Zipcode INT,
    Car_Owner ENUM('yes', 'no'),
    House_Owner ENUM('yes', 'no'),
    Personal_loan ENUM('yes', 'no'),
    contact VARCHAR(50),
    Customer_Job VARCHAR(50),
    Income BIGINT,
    Cust_Satisfaction_Score INT
);


LOAD DATA INFILE 'D:/project/creditcard/customer.csv'
INTO TABLE CustomerInfo
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    Client_Num,
    Customer_Age,
    Gender,
    Dependent_Count,
    Education_Level,
    Marital_Status,
    state_cd,
    Zipcode,
    Car_Owner,
    House_Owner,
    Personal_loan,
    contact,
    Customer_Job,
    Income,
    Cust_Satisfaction_Score
);

SELECT COUNT(*) AS Total_Customers FROM CustomerInfo;


SELECT COUNT(*) AS Total_Clients FROM ClientInfo;

-- For ClientInfo
SELECT 
    COUNT(*) AS Missing_Records 
FROM 
    ClientInfo
WHERE 
    Client_Num IS NULL 
    OR Card_Cate IS NULL 
    OR Week_Start_Date IS NULL;

-- For CustomerInfo
SELECT 
    COUNT(*) AS Missing_Records 
FROM 
    CustomerInfo
WHERE 
    Client_Num IS NULL 
    OR Customer_Age IS NULL 
    OR Gender IS NULL;
    
    
SELECT 
    ci.Client_Num,
    c.Customer_Age,
    c.Gender,
    c.Income,
    ci.Card_Cate,
    ci.Credit_Limit,
    ci.Avg_Utilization,
    ci.Total_Rev,
    c.Cust_Satisfaction_Score
FROM 
    ClientInfo ci
INNER JOIN 
    CustomerInfo c 
ON 
    ci.Client_Num = c.Client_Num;


SELECT 
    c.Client_Num,
    c.Customer_Age,
    c.Income,
    ci.Avg_Utilization,
    ci.Credit_Limit
FROM 
    CustomerInfo c
JOIN 
    ClientInfo ci ON c.Client_Num = ci.Client_Num
WHERE 
    c.Income > 100000 AND ci.Avg_Utilization > 0.7;

SELECT 
    Card_Cate, 
    SUM(Total_Rev) AS Total_Revenue, 
    AVG(Avg_Utilization) AS Avg_Utilization
FROM 
    ClientInfo
GROUP BY 
    Card_Cate;

SELECT 
    Client_Num, 
    Use_Chip, 
    Total_Trans
FROM 
    ClientInfo
WHERE 
    Use_Chip = 'yes';

SELECT 
    Client_Num, 
    Credit_Limit
FROM 
    ClientInfo
ORDER BY 
    Credit_Limit DESC
LIMIT 5;

SELECT 
    Education_Level, 
    AVG(Cust_Satisfaction_Score) AS Avg_Satisfaction_Score
FROM 
    CustomerInfo
GROUP BY 
    Education_Level;

SELECT 
    Client_Num, 
    Customer_Age, 
    Gender, 
    Cust_Satisfaction_Score
FROM 
    CustomerInfo
WHERE 
    Cust_Satisfaction_Score < 3;

SELECT 
    Income, 
    Cust_Satisfaction_Score
FROM 
    CustomerInfo;

SELECT 
    Qtr, 
    SUM(Total_Rev) AS Total_Revenue
FROM 
    ClientInfo
GROUP BY 
    Qtr;

SELECT 
    Client_Num, 
    Delinquent_Acc
FROM 
    ClientInfo
WHERE 
    Delinquent_Acc > 0;

SELECT 
    c.state_cd, 
    SUM(ci.Credit_Limit) AS Total_Credit_Limit, 
    AVG(c.Income) AS Avg_Income
FROM 
    CustomerInfo c
JOIN 
    ClientInfo ci ON c.Client_Num = ci.Client_Num
GROUP BY 
    c.state_cd;

SELECT 
    Marital_Status, 
    COUNT(*) AS Total_Customers
FROM 
    CustomerInfo
GROUP BY 
    Marital_Status;

SELECT 
    Client_Num, 
    Customer_Age, 
    Gender, 
    Income
FROM 
    CustomerInfo
WHERE 
    Car_Owner = 'yes' AND House_Owner = 'yes';

SELECT 
    Activation, 
    AVG(Total_Tran) AS Avg_Transactions
FROM 
    ClientInfo
GROUP BY 
    Activation;

SELECT 
    Client_Num, 
    Annual_Fee, 
    Avg_Utilization
FROM 
    ClientInfo
WHERE 
    Annual_Fee > 500 AND Avg_Utilization < 0.5;

SELECT 
    Week_Num, 
    SUM(Total_Tran) AS Total_Transactions
FROM 
    ClientInfo
GROUP BY 
    Week_Num;

SELECT 
    c.Client_Num, 
    c.Customer_Age, 
    ci.Total_Rev, 
    c.Cust_Satisfaction_Score
FROM 
    CustomerInfo c
JOIN 
    ClientInfo ci ON c.Client_Num = ci.Client_Num
WHERE 
    ci.Total_Rev > 100000 AND c.Cust_Satisfaction_Score < 3;

SELECT 
    c.Client_Num, 
    c.Customer_Job, 
    ci.Credit_Limit
FROM 
    CustomerInfo c
JOIN 
    ClientInfo ci ON c.Client_Num = ci.Client_Num
WHERE 
    c.Customer_Job = 'Selfemployeed' AND ci.Credit_Limit > 50000;
