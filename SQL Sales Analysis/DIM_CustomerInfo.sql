/****** Script for SelectTopNRows command from SSMS  ******/
SELECT c.[CustomerKey] AS [Customer Key]
      --,[GeographyKey]
      --,[CustomerAlternateKey]
      --,[Title]
      ,[FirstName] AS [First Name]
      --,[MiddleName]
	  ,[LastName] AS [Last Name]
	  ,[FirstName] + ' '+ [LastName] AS [Full Name]
      --,[NameStyle]
      --,[BirthDate]
      --,[MaritalStatus]
      --,[Suffix]
      ,CASE c.[Gender] WHEN 'M' THEN 'Male'
    WHEN 'F' THEN 'Female'
    ELSE 'Null'  END AS Gender
      --,[EmailAddress]
      --,[YearlyIncome]
      --,[TotalChildren]
      --,[NumberChildrenAtHome]
      --,[EnglishEducation]
      --,[SpanishEducation]
      --,[FrenchEducation]
      --,[EnglishOccupation]
     --,[SpanishOccupation]
      --,[FrenchOccupation]
      --,[HouseOwnerFlag]
     --,[NumberCarsOwned]
      --,[AddressLine1]
      --,[AddressLine2]
      --,[Phone]
      ,c.[DateFirstPurchase] AS [Date First Purchase]
      --,[CommuteDistance]
	  ,g.[City]
  FROM [AdventureWorksDW2019].[dbo].[DimCustomer] c
  LEFT JOIN [AdventureWorksDW2019].[dbo].[DimGeography] g
  ON c.GeographyKey = g.GeographyKey
  ORDER BY CustomerKey ASC

