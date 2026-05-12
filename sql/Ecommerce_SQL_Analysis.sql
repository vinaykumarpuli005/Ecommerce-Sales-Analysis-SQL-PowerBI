
IF DB_ID('ecommerce_project') IS NULL
BEGIN
    CREATE DATABASE ecommerce_project;
END;
GO

USE ecommerce_project;
GO


--creating a staging table 
DROP TABLE IF EXISTS dbo.online_retail_staging;

CREATE TABLE dbo.online_retail_staging (
    InvoiceNo NVARCHAR(50),
    StockCode NVARCHAR(50),
    Description NVARCHAR(500),
    Quantity NVARCHAR(50),
    InvoiceDate NVARCHAR(50),
    UnitPrice NVARCHAR(50),
    CustomerID NVARCHAR(50),
    Country NVARCHAR(100)
);


--importing into the staging table
-- Update the file path below before running this script
BULK INSERT dbo.online_retail_staging
FROM 'C:\your_folder\Online_Retail.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDQUOTE = '"',
    ROWTERMINATOR = '0x0a',
    TABLOCK
);

--check  staging data
SELECT TOP 10 *
FROM dbo.online_retail_staging;

--create final clean table
DROP TABLE IF EXISTS dbo.online_retail_clean;

SELECT
    InvoiceNo,
    StockCode,
    Description,
    TRY_CONVERT(INT, Quantity) AS Quantity,
    TRY_CONVERT(DATETIME, InvoiceDate) AS InvoiceDate,
    TRY_CONVERT(DECIMAL(10,2), UnitPrice) AS UnitPrice,
    CustomerID,
    Country
INTO dbo.online_retail_clean
FROM dbo.online_retail_staging;

WHERE TRY_CONVERT(INT, Quantity) > 0
  AND TRY_CONVERT(DECIMAL(10,2), UnitPrice) > 0
  AND NULLIF(CustomerID, '') IS NOT NULL
  AND TRY_CONVERT(DATETIME, InvoiceDate) IS NOT NULL;

--Remove Invalid Records
SELECT *
FROM dbo.online_retail_clean
WHERE Quantity > 0
AND UnitPrice > 0
AND NULLIF(CustomerID, '') IS NOT NULL
AND InvoiceDate IS NOT NULL;


-- Create Analysis View
GO
    
CREATE OR ALTER VIEW dbo.retail_analysis AS
SELECT
    InvoiceNo,
    StockCode,
    Description,
    Quantity,
    InvoiceDate,
    UnitPrice,
    CustomerID,
    Country,
    Quantity * UnitPrice AS Revenue
FROM dbo.online_retail_clean
WHERE Quantity > 0
AND UnitPrice > 0
AND CustomerID IS NOT NULL;

GO

-- SQL Analysis Queries
--Total revenue:
SELECT ROUND(SUM(Revenue), 2) AS Total_Revenue
FROM dbo.retail_analysis;

--Total orders and customers:
SELECT
    COUNT(DISTINCT InvoiceNo) AS Total_Orders,
    COUNT(DISTINCT CustomerID) AS Total_Customers
FROM dbo.retail_analysis;

--Monthly sales:
SELECT
    YEAR(InvoiceDate) AS Sales_Year,
    MONTH(InvoiceDate) AS Sales_Month,
    ROUND(SUM(Revenue), 2) AS Revenue
FROM dbo.retail_analysis
GROUP BY YEAR(InvoiceDate), MONTH(InvoiceDate)
ORDER BY Sales_Year, Sales_Month;

--Top 10 products:
SELECT TOP 10
    Description,
    SUM(Quantity) AS Total_Quantity,
    ROUND(SUM(Revenue), 2) AS Revenue
FROM dbo.retail_analysis
GROUP BY Description
ORDER BY Revenue DESC;

--Top countries:
SELECT
    Country,
    ROUND(SUM(Revenue), 2) AS Revenue
FROM dbo.retail_analysis
GROUP BY Country
ORDER BY Revenue DESC;

--Top customers:
SELECT TOP 10
    CustomerID,
    COUNT(DISTINCT InvoiceNo) AS Total_Orders,
    ROUND(SUM(Revenue), 2) AS Total_Spent
FROM dbo.retail_analysis
GROUP BY CustomerID
ORDER BY Total_Spent DESC;
