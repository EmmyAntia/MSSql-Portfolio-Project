
---ALL QUERIES FROM AdventureWorks2019 TABLE


--1)
/*Retrieve information about the products with colour values except null, red, silver/black, white and list 
price between £75 and £750. Rename the column StandardCost to Price. Also, sort the results in descending order by list price.*/

SELECT ProductID,Name,ProductNumber,MakeFlag,FinishedGoodsFlag,Color,SafetyStockLevel,ReorderPoint,
	StandardCost AS Price,ListPrice,Size,SizeUnitMeasureCode,WeightUnitMeasureCode,DaysToManufacture,
	Weight,ProductLine,Class,Style,ProductSubcategoryID,
	ProductModelID,SellEndDate,SellStartDate,DiscontinuedDate,rowguid,ModifiedDate
FROM Production.Product 
	WHERE Color NOT IN ('NULL','Red','Silver','Black','White') AND ListPrice BETWEEN 75.00 AND 750.00
	ORDER BY ListPrice DESC;


---2)
/*Find all the male employees born between 1962 to 1970 and with hire date greater than 2001 and female 
employees born between 1972 and 1975 and hire date between 2001 and 2002. */

SELECT Gender,BirthDate,HireDate FROM HumanResources.Employee
	WHERE Gender = 'M' AND BirthDate BETWEEN '1962-01-01' AND '1970-12-31' AND HireDate  > '2001-12-31'
	OR
	Gender = 'F' AND BirthDate BETWEEN '1972-01-01' AND '1975-12-31' AND HireDate BETWEEN  '2001-01-01' AND '2002-12-31';


---3)
/*Create a list of 10 most expensive products that have a product number beginning with ‘BK’. 
Include only the product ID, Name and colour. */

SELECT TOP 10 ProductID AS ID,Name,Color FROM Production.Product
	WHERE ProductNumber LIKE 'BK%'
	ORDER BY StandardCost DESC;

	
---4)
/*Create a list of all contact persons, where the first 4 characters of the last name are the same 
as the first four characters of the email address. Also, for all contacts whose first name and the 
last name begin with the same characters, create a new column called full name combining first name and 
the last name only. Also provide the length of the new column full name.*/

SELECT P.FirstName,P.LastName,E.EmailAddress FROM Person.Person P
	LEFT JOIN Person.EmailAddress E
	ON P.BusinessEntityID = E.BusinessEntityID
	WHERE LEFT(P.LastName,4) =  LEFT(E.EmailAddress,4);

SELECT FirstName,LastName, CONCAT(FirstName,' ',LastName) AS FullName, 
LEN(CONCAT(FirstName,' ',LastName)) AS FullNameLength 
	FROM Person.Person 
	WHERE LEFT(FirstName,1) =  LEFT(LastName,1);


---5)
/*Return all product subcategories that take an average of 3 days or longer to manufacture.*/

SELECT PS.Name AS ProductSubCategory_Name, PP.DaysToManufacture
FROM Production.ProductSubcategory PS
	LEFT JOIN Production.Product PP
	ON PS.ProductCategoryID = PP.ProductSubcategoryID
	GROUP BY PS.Name, PP.DaysToManufacture
	HAVING AVG(PP.DaysToManufacture) >= 3
	ORDER BY PP.DaysToManufacture;


---6)
/*Create a list of product segmentation by defining criteria that places each item in a predefined segment
as follows. If price gets less than £200 then low value. If price is between £201 and £750 then mid value. 
If between £750 and £1250 then mid to high value else higher value. Filter the results only for black,
silver and red color products. */

SELECT Name,Color, ListPrice,
CASE
	WHEN ListPrice < 200.99 THEN 'Low value'
	WHEN ListPrice BETWEEN 201.00 AND 750.00 THEN 'Mid value'
	WHEN ListPrice BETWEEN 750.00 AND 1250.00 THEN 'Mid to High value'
ELSE 'Higher value'
END AS 'Product Segment'
FROM Production.Product
WHERE Color IN ('Black','Silver','Red');


---7)
/*How many Distinct Job title is present in the Employee table? */

SELECT COUNT(DISTINCT JobTitle) FROM HumanResources.Employee;


---8)
/*Use employee table and calculate the ages of each employee at the time of hiring. */

SELECT NationalIDNumber, DATEDIFF(YEAR, BirthDate, HireDate ) AS 'Age at time of hire'
FROM HumanResources.Employee;


---9)
/*How many employees will be due a long service award in the next 5 years, if long service is 20 years? */

SELECT COUNT (NationalIDNumber) FROM HumanResources.Employee
WHERE DATEDIFF(YEAR, HireDate,'2027-12-31') >= 20;


---10)
/*How many more years does each employee have to work before reaching sentiment, if sentiment age is 65? */

SELECT NationalIDNumber, 65 - DATEDIFF(YEAR,BirthDate,GETDATE() ) AS sentiment
FROM HumanResources.Employee;


/*11)
Implement new price policy on the product table base on the colour of the item 
If white, increase price by 8%, If yellow, reduce price by 7.5%, If black, increase price by 17.2%.
If multi, silver, silver/black or blue, take the square root of the price and double the value.
Column should be called Newprice.*/

SELECT Color, ListPrice,
CASE
	WHEN Color = 'White' THEN ListPrice +(0.08 * ListPrice)
	WHEN Color = 'Yellow' THEN ListPrice -(0.075 * ListPrice)
	WHEN Color = 'Black' THEN ListPrice +(0.172 * ListPrice)
	WHEN Color IN ('Multi','Silver','Silver/Black','Blue') THEN SQRT(ListPrice)*2
ELSE ListPrice
END AS 'NewPrice'
FROM Production.Product
WHERE Color IN ('White','Yellow','Black','Multi','Silver','Silver/Black','Blue');



/*---12)
Print the information about all the Sales.Person and their sales quota. For every Sales person you should
provide their FirstName, LastName, HireDate, SickLeaveHours and Region where they work. */

SELECT  P.FirstName, P.LastName,S.SalesQuota, E.HireDate, E.SickLeaveHours,R.Name AS Region FROM Sales.SalesPerson S
LEFT JOIN Person.Person P
ON S.BusinessEntityID = P.BusinessEntityID
LEFT JOIN HumanResources.Employee E
ON S.BusinessEntityID = E.BusinessEntityID
LEFT JOIN Sales.SalesTerritory T
ON S.TerritoryID = T.TerritoryID
LEFT JOIN Person.CountryRegion R
ON T.CountryRegionCode = R.CountryRegionCode 



