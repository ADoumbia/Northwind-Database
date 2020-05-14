Select Count(CustomerID) as NumberOfCustomers FROM dbo.Customers;
go
--A query that returns the number of customers in the NorthWind database
--The COUNT Function allows us to only take the quantity of returned values rather than a list of customerID

Select Count(CustomerID) as CustomerNameBeginningWithB FROM dbo.Customers
WHERE ContactName LIKE 'b%';
go
--A query that returns the number of customers with first name beginning with “b”
--Here we are introducing wildcards denoted as a percent sign (%)
--This combined with the LIKE operator allows us to find all name records beginning with the letter B

Select Count(CustomerID) as CustomerNameContainsS FROM dbo.Customers
WHERE ContactName LIKE '%s%';
go
--A query that returns the number of customers whose name contain the letter "s"
--The wildcard can also be used to look for records that contain a certain string value
--By placing 2 wildcards, we can look for all customer names that contain the letter S regardless of its position in the name

Select City, Count(ContactName) as NumberOfCustomers FROM dbo.Customers
Group by City;
go
--A query that returns the number of customers in each city
--We introduce the GROUP BY clause which is done so that multiple instances of a specific city will only appear once i.e. prevents duplicates in the output

Select TOP 3 City, Count(CustomerID) as NumberOfCustomers FROM Customers
Group by City
Order by NumberOfCustomers DESC;
go
--A query that returns the top three cities where Northwind has the most customers
--The TOP statement as it suggests will select the top values of a given table based on a certain quantity, in this case the top cities according to the count of customer IDs 
--We also use an ORDER BY clause which rearranges the order of the count to descending (DESC). By default, SQL orders by ascending (ASC) values

Select Top 1 C.ContactName, C.CompanyName, O.CustomerID, Count(OrderID) as NumberOfOrders
From Customers C, Orders O
Where C.CustomerID = O.CustomerID
Group by C.ContactName, C.CompanyName, O.CustomerID
Order by Count(OrderID) DESC; 
go
--A query that returns the top customer in the Northwind Database organized by CustomerID, CompanyName, and ContactName 
--To find the top customer, we look for the customer ID that is associated with the most Order IDs. However, OrderID is not a field in the customer table
--Therefore, we need to link the Order table to the customer table which is done by linking the primary and foreign keys, which is customerID for customers and orders respectively
--You may also notice I used aliases for customers and orders (C and O respectively), these are declared in the FROM line and can be done to save time 

Select TOP 1 C.ContactName, C.CompanyName, O.CustomerID, Count(OrderID) as NumberOfOrders
From Customers C, Orders O
Where C.CustomerID = O.CustomerID
AND OrderDate BETWEEN '1997/01/01' and '1997/12/31'
Group by C.ContactName, C.CompanyName, O.CustomerID
Order by Count(OrderID) DESC; 
go

--This query narrows down our previous query based on year. This can be done by using the AND and BETWEEN clauses which adds extra conditions to the query
--In this case, we look for Order Dates that are between January 1st and December 31st

Select TOP 3 ShipCountry, Count(OrderID) as NumberOfOrders FROM Orders
Group by ShipCountry
Order by NumberOfOrders DESC;
go
--A query that returns the top 3 shipping destinations by country

Select TOP 3 ShipVia, Count(OrderID) as NumberOfOrders from Orders
Group by ShipVia
Order by NumberOfOrders DESC;
go
--A query that returns the top three shipping companies, represented with numbers 1, 2, and 3 ordered by the number of OrderIDs associated with said numbers

Select 
E.LastName as EmployeeLastName, 
E.FirstName as EmployeeLastName, 
M.LastName as ManagerLastName, 
M.FirstName as ManagerFirstName
From Employees E
Left Join Employees M
ON E.ReportsTo = M.EmployeeID;
go

--A query that returns the Employee ID, Employee LastName, Employee FirstName, ManagerLastName, and ManagerFirstName
--This query is unique because it implements a Self join 
--The Self join is required because the Employee table does not contain a Manager first/last name field. However it does have a ReportsTo field which represents the Employee ID of the reporting manager
--The Self join starts by treating ManagerFirstName and ManagerLastName as their own table (Noted with alias M) and linking this back to the Employee table using a LEFT join 
--What the left join does is ensure that all employee names appear even if they don't have a manager
--We finally link the two tables with ReportsTo (Which can be treated as Manager EmployeeID) and EmployeeID since they are both employee ID fields 

Select LastName, BirthDate From Employees 
Where MONTH(Birthdate) = 11;
go
--A query that returns the last names of all employees who were born in the month of November, or the 11th month of the year

Select T.TerritoryDescription, E.LastName, E.FirstName
From Employees E
Join EmployeeTerritories ET
ON E.EmployeeID = ET.EmployeeID
Join Territories T
ON T.TerritoryID = ET.TerritoryID
ORDER by T.TerritoryDescription, E.LastName;
go
--A query that returns employee lastname, firstname, and territory, sorted by territory and then by employee last name
--JOIN clauses are used to match employeeIDs to the territories they are associated with
--Another JOIN clause is used to retrive the territory name from the Territories table as the Employee Territories table only displays the territory ID

Select Top 1 P.ProductID, P.ProductName, SUM(Quantity*OD.UnitPrice) AS SalesInDollars
From [Order Details] OD
Left Join Products P
ON P.ProductID = OD.ProductID
Group by P.ProductID, P.ProductName
Order by SalesInDollars DESC;
go
--A query that returns the best selling product in the Northwind database
--To find the dollar amount of sales we use a SUM function of total quantity sold times unit price

Select Top 1 P.ProductID, P.ProductName, SUM(Quantity*OD.UnitPrice) AS SalesInDollars
From [Order Details] OD
Left Join Products P
ON P.ProductID = OD.ProductID
Group by P.ProductID, P.ProductName
Order by SalesInDollars ASC;
go
--A query that returns the worst selling product in the Northwind database
--The only difference from this query and the last is that sales are in ascending order (Lowest to highest)
--A left join with order details ensures that we only include products that have been sold at least once

Select Top 1 MONTH(OrderDate) as SalesMonth, SUM(OD.Quantity*OD.UnitPrice) AS SalesInDollars
from Orders O
Left Join [Order Details] OD
ON O.OrderID = OD.OrderID
Group by MONTH(OrderDate)
Order by SalesInDollars DESC;
go
--A query that returns the best month for sales

Select Top 1 O.EmployeeID, E.LastName, E.FirstName, Count(O.OrderID) as NumberOfOrders
From Orders O
Join Employees E
ON E.EmployeeID = O.EmployeeID
Group by E.LastName, E.FirstName, O.EmployeeID
Order by Count(OrderID) DESC;
go
--A query that returns the name of Northwind's best salesperson
--This is done by linking the employee ID associated with the most Order IDs

Select P.ProductID, P.ProductName, S.CompanyName, P.CategoryID
From Products P
Join Suppliers S
ON S.SupplierID = P.SupplierID
Order by P.CategoryID
go
--A query that returns ProductID, ProductName, Supplier Name, Product Category, ordered by product category

Select Count(ET.EmployeeID) as NumberOfEmployees, R.RegionDescription
From EmployeeTerritories ET
Left Join Territories T
ON ET.TerritoryID = T.TerritoryID
Left Join Region R
ON R.RegionID = T.RegionID
Group by R.RegionDescription;
go
--A query that returns a count of employees by each sales region

Select O.ShipRegion, ROUND(SUM(Quantity*OD.UnitPrice*(1-OD.Discount)),2) AS SalesInDollars
From [Order Details] OD
Left Join Orders O
ON O.OrderID = OD.OrderID
Group by O.ShipRegion
Order by SalesInDollars;
go

--A query that returns the dollar values for sales by region
--Note our SUM function, since some products are discounted, our dollar value for sales is equal to Quantity x Unit Price after the discount
--Also Note, I nested the SUM function within a ROUND function to retain only 2 decimal points

Select ROUND(AVG(Quantity*OD.UnitPrice*(1-OD.Discount)),2) as AverageOrderValue
From [Order Details] OD;
go
--A query that returns the average dollar value of sales with the use of the AVG function

Select *
From (Select C.CompanyName, OD.OrderID, O.OrderDate, ROUND(SUM(Quantity*OD.UnitPrice*(1-OD.Discount)),2) as OrderValue 
		From [Order Details] OD 
		Join Orders O 
		ON OD.OrderID = O.OrderID
		Join Customers C
		ON C.CustomerID = O.CustomerID
		Group by C.CompanyName, OD.OrderID, O.OrderDate) as TotalOrder

Where OrderValue > (Select ROUND(AVG(Quantity*OD.UnitPrice*(1-OD.Discount)),2) as OrderAVG From [Order Details] OD)
Order by OrderValue ASC;
go
--A query that returns a lists orders where the total order value is greater than the average value of a sales order
--This is a complicated query, first we need a select all followed by a Subquery where the result of this subquery will be used to find orders that are greater than the average order value
--The Subquery allows us to create our own table that can be modified based on given parameters. Without it, we would not be able to use the average OrderValue condition


Select C.CustomerID, C.ContactName, SUM(Quantity*OD.UnitPrice*(1-OD.Discount)) as TotalSales
From Customers C
Full Outer Join Orders O
ON O.CustomerID = C.CustomerID
Full Outer Join [Order Details] OD
ON OD.OrderID = O.OrderID
Group by C.CustomerID, C.ContactName;
go
--A query that returns CustomerID, Customer name and total sales made to that customer, including those we have not yet done business with NorthWind
--The important distinction to note is the FULL OUTER JOIN that will take all values from the Customers, Order, and OrderDetails even if there is no order associated with a customer. In this case, it will return null

Select * from Products
Where UnitsInStock = 0
And Discontinued = 0;
go
--A query that returns all products that need to be re-stocked
--Since we are only looking at products that are not discontinued, we use 0 as a condition, which means "False"


Select CustomerID, OrderDate from Orders
Where YEAR(OrderDate) = 1996;
go
--A query that returns all customers that purchased products in the year 1996

Select CustomerID, OrderDate from Orders
Where YEAR(OrderDate) <> 1996;
go
--A query that lists all customers that did not purchase a product in the year 1996
--Notice the operator <>, it functions as a "Does not Equal" and will exclude results where the year is 1996
