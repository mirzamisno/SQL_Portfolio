-- Cleansed FACT_InternetSales Table --
SELECT 
  [ProductKey] AS [Product Key], 
  [OrderDateKey] AS [Order Date Key], 
  [DueDateKey] AS [Due Date Key], 
  [ShipDateKey] AS [Ship Date Key], 
  [CustomerKey] AS [Customer Key], 
  --  ,[PromotionKey]
  --  ,[CurrencyKey]
  --  ,[SalesTerritoryKey]
  [SalesOrderNumber] AS [Sales Order Number], 
  --  [SalesOrderLineNumber], 
  --  ,[RevisionNumber]
  --  ,[OrderQuantity], 
  --  ,[UnitPrice], 
  --  ,[ExtendedAmount]
  --  ,[UnitPriceDiscountPct]
  --  ,[DiscountAmount] 
  --  ,[ProductStandardCost]
  --  ,[TotalProductCost] 
  [SalesAmount] AS [Sales Amount] --  ,[TaxAmt]
  --  ,[Freight]
  --  ,[CarrierTrackingNumber] 
  --  ,[CustomerPONumber] 
  --  ,[OrderDate] 
  --  ,[DueDate] 
  --  ,[ShipDate] 
FROM 
  [AdventureWorksDW2019].[dbo].[FactInternetSales]
WHERE 
  LEFT (OrderDateKey, 4) >= YEAR(GETDATE()) -3 -- Ensures we always only bring three years prior of date from extraction.
ORDER BY
  OrderDateKey ASC;
