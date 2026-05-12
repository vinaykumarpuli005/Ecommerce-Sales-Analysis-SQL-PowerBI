# Dataset Details

## Dataset Name
Online Retail Dataset

## Source
UCI Machine Learning Repository

## Dataset Link
https://archive.ics.uci.edu/dataset/352/online+retail

## Dataset Description
This dataset contains transaction records from an online retail business. It includes invoice details, product information, quantity sold, price, customer ID, and country.

## Columns Used
- InvoiceNo
- StockCode
- Description
- Quantity
- InvoiceDate
- UnitPrice
- CustomerID
- Country

## Created Column
- Revenue = Quantity * UnitPrice

## Data Cleaning Performed
- Removed transactions with negative or zero quantity
- Removed transactions with zero or invalid unit price
- Removed records with missing CustomerID
- Converted date, quantity, and price columns into correct data types
- Created a clean SQL view for analysis and Power BI reporting

## Important Note
The raw dataset is not uploaded to this repository because of file size and dataset ownership. Users can download it directly from the official UCI dataset link.
