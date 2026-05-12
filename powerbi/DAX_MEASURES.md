# DAX Measures

```DAX
Total Revenue = SUM(retail_analysis[Revenue])

Total Orders = DISTINCTCOUNT(retail_analysis[InvoiceNo])

Total Customers = DISTINCTCOUNT(retail_analysis[CustomerID])

Total Quantity Sold = SUM(retail_analysis[Quantity])

Average Order Value = DIVIDE([Total Revenue], [Total Orders], 0)
