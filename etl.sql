-- Transfer sales data from TDS to ODS snapshot table
INSERT INTO ODS_SalesSnapshot (SaleID, CustomerID, ProductID, Quantity, SaleDate, TotalAmount, SnapshotDate)
SELECT SaleID, CustomerID, ProductID, Quantity, SaleDate, TotalAmount, CURRENT_DATE
FROM TDS_Sales;


-- Transfer daily snapshots from ODS to DW at month-end for historical storage
INSERT INTO DW_SalesHistory (CustomerID, ProductID, Quantity, SaleDate, TotalAmount, Year, Month, Day)
SELECT CustomerID, ProductID, Quantity, SaleDate, TotalAmount,
       EXTRACT(YEAR FROM SaleDate), EXTRACT(MONTH FROM SaleDate), EXTRACT(DAY FROM SaleDate)
FROM ODS_SalesSnapshot
WHERE SnapshotDate = LAST_DAY(CURRENT_DATE); -- At end of month


-- Aggregate monthly sales data from DW into DM for reporting
INSERT INTO DM_MonthlySales (Month, Year, StoreID, TotalSales, TotalQuantity)
SELECT EXTRACT(MONTH FROM SaleDate) AS Month,
       EXTRACT(YEAR FROM SaleDate) AS Year,
       StoreID,
       SUM(TotalAmount) AS TotalSales,
       SUM(Quantity) AS TotalQuantity
FROM DW_SalesHistory
GROUP BY Year, Month, StoreID;
