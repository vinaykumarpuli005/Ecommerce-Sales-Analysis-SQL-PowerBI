# DAX Measures

```DAX
Total Revenue = SUM(retail_analysis[Revenue])

Total Orders = DISTINCTCOUNT(retail_analysis[InvoiceNo])

Total Customers = DISTINCTCOUNT(retail_analysis[CustomerID])

Total Quantity Sold = SUM(retail_analysis[Quantity])

Average Order Value = DIVIDE([Total Revenue], [Total Orders], 0)

In SQL file, improve cleaning logic. Your clean table should filter invalid rows while creating the table:
```sql
WHERE TRY_CONVERT(INT, Quantity) > 0
  AND TRY_CONVERT(DECIMAL(10,2), UnitPrice) > 0
  AND NULLIF(CustomerID, '') IS NOT NULL
  AND TRY_CONVERT(DATETIME, InvoiceDate) IS NOT NULL;
