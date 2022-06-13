---Inspecting data
SELECT * FROM [PortfolioProject].[dbo].[sales_data_sample]

---Inspect Unique values
SELECT 
  DISTINCT STATUS 
FROM 
  [PortfolioProject].[dbo].[sales_data_sample] 
SELECT 
  DISTINCT YEAR_ID 
FROM 
  [PortfolioProject].[dbo].[sales_data_sample] 
SELECT 
  DISTINCT PRODUCTLINE 
FROM 
  [PortfolioProject].[dbo].[sales_data_sample] 
SELECT 
  DISTINCT COUNTRY 
FROM 
  [PortfolioProject].[dbo].[sales_data_sample] 
SELECT 
  DISTINCT DEALSIZE 
FROM 
  [PortfolioProject].[dbo].[sales_data_sample] 
SELECT 
  DISTINCT TERRITORY 
FROM 
  [PortfolioProject].[dbo].[sales_data_sample]

---Grouping sales by productline
SELECT PRODUCTLINE,SUM(SALES) AS REVENUE
FROM [PortfolioProject].[dbo].[sales_data_sample]
GROUP BY PRODUCTLINE
ORDER BY 2 DESC

SELECT YEAR_ID,SUM(SALES) AS REVENUE
FROM [PortfolioProject].[dbo].[sales_data_sample]
GROUP BY YEAR_ID
ORDER BY 2 DESC
--- We can see the sales made in 2005 is a lot less than others
--- We need to check in months to see if there are month that the company not selling anything
SELECT DISTINCT MONTH_ID FROM [PortfolioProject].[dbo].[sales_data_sample]
WHERE YEAR_ID=2004
ORDER BY 1 ASC
---There only 5 months, jan to may. To compare we will need to check the other year as well.
---2004 and 2003 have 12 months, so we can conclude the sample data may be taken in 2005 because the data are only until may.
SELECT DEALSIZE,SUM(SALES) AS REVENUE
FROM [PortfolioProject].[dbo].[sales_data_sample]
GROUP BY DEALSIZE
ORDER BY 2 DESC


SELECT MONTH_ID,SUM(SALES) AS REVENUE, COUNT(ORDERNUMBER) AS FREQUENCY
FROM [PortfolioProject].[dbo].[sales_data_sample]
WHERE YEAR_ID = 2004
GROUP BY MONTH_ID
ORDER BY 3 DESC
---We can see here, november record the higest sales frequency and revenue in 2003 and 2004 respectively


SELECT MONTH_ID, PRODUCTLINE, SUM(SALES) AS REVENUE, COUNT(ORDERNUMBER) AS FREQUENCY
FROM [PortfolioProject].[dbo].[sales_data_sample]
WHERE YEAR_ID = 2004 AND MONTH_ID = 11
GROUP BY MONTH_ID, PRODUCTLINE
ORDER BY 3 DESC


--- Which are our best selling item and create a segment using (RFM) marketing analysis tool 
DROP TABLE IF EXISTS #RFM
;WITH RFM AS 
(
	SELECT 
		CUSTOMERNAME,
		SUM(SALES) AS MONETARY_VALUE,
		AVG(SALES) AS AVG_MONETARY_VALUE,
		COUNT(ORDERNUMBER) FREQUENCY,
		MAX(ORDERDATE) AS LAST_ORDER_DATE,
		(SELECT MAX(ORDERDATE) FROM [PortfolioProject].[dbo].[sales_data_sample]) AS MAX_ORDER_DATE, --- to find last transaction date
		DATEDIFF(DD, MAX(ORDERDATE), (SELECT MAX(ORDERDATE) FROM [PortfolioProject].[dbo].[sales_data_sample])) AS RECENCY
	FROM [PortfolioProject].[dbo].[sales_data_sample]
	GROUP BY CUSTOMERNAME
),
RFM_CALC AS
(
	SELECT R.*,
		NTILE(4) OVER (ORDER BY RECENCY DESC) AS RFM_RECENCY,
		NTILE(4) OVER (ORDER BY FREQUENCY) AS RFM_FREQUENCY,
		NTILE(4) OVER (ORDER BY AVG_MONETARY_VALUE) AS RFM_MONETARY
		
	FROM RFM R
)	
	SELECT C.*, RFM_RECENCY+RFM_FREQUENCY+RFM_MONETARY AS RFM_CELL,
	CAST(RFM_RECENCY AS VARCHAR) + CAST(RFM_FREQUENCY AS VARCHAR) + CAST(RFM_MONETARY AS VARCHAR) AS RFM_CELL_STRING
	INTO #RFM
	FROM RFM_CALC C


SELECT CUSTOMERNAME, RFM_RECENCY, RFM_FREQUENCY, RFM_MONETARY,

	CASE
		WHEN RFM_CELL_STRING IN (111,112,113,114,121,122,131,212,214) THEN 'Lost customer'
		WHEN RFM_CELL_STRING IN (133,134,142,224,221,222,231,241,242)THEN 'Slipping away customer'
		WHEN RFM_CELL_STRING IN (311,312,314,414,421,422,424)THEN 'New customer'
		WHEN RFM_CELL_STRING IN (223,233,321,322,244,234) THEN 'Potential churner'
		WHEN RFM_CELL_STRING IN (332,333,331,341,342,441,442,432)THEN 'Active customer'
		ELSE 'Loyal customer'
	END RFM_SEGMENT

FROM #RFM

--- Which products are often been sold together?
---SELECT * FROM [PortfolioProject].[dbo].[sales_data_sample] WHERE ORDERNUMBER =10156


SELECT DISTINCT ORDERNUMBER, STUFF(
(
	SELECT ',' + PRODUCTCODE
	FROM [PortfolioProject].[dbo].[sales_data_sample] P
	WHERE ORDERNUMBER IN
		(
		SELECT ORDERNUMBER
		FROM(
			SELECT ORDERNUMBER, COUNT(*) AS ROWS_NUMBER
			FROM [PortfolioProject].[dbo].[sales_data_sample]
			WHERE STATUS = 'Shipped'
			GROUP BY ORDERNUMBER
		)M
		WHERE ROWS_NUMBER =2
	)
	AND P.ORDERNUMBER = S.ORDERNUMBER
	FOR XML PATH ('')
	 ), 1, 1, '') PRODUCTCODES

FROM [PortfolioProject].[dbo].[sales_data_sample] S
ORDER BY 2 DESC


