-- SQL Select
-- Exercise 1
SELECT * FROM Customers;

-- Exercise 2
Select City FROM Customers;

-- Exercise 3
Select DISTINCT Country From Customers;

-- SQL Where
-- Exercise 1
SELECT * FROM Customers
WHERE City = 'Berlin';

-- Exercise 2
SELECT * FROM Customers
WHERE not City = 'Berlin';

-- Exercise 3
SELECT * FROM Customers
Where CustomerID = 32;

-- Exercise 4
Select * FROM Customers
Where City = 'Berlin'
And PostalCode = 12209;

-- Exercise 5
Select * FROM Customers
Where City = 'Berlin'
Or City = 'London';

-- SQL Order By
-- Exercise 1
SELECT * FROM Customers
ORDER BY City;

-- Exercise 2
SELECT * FROM Customers
Order by City Desc;

-- Exercise 3
SELECT * FROM Customers
Order by Country, City;

-- SQL Insert
-- Exercise 1
INSERT INTO Customers( 
CustomerName, 
Address, 
City, 
PostalCode,
Country)
VALUES(
'Hekkan Burger',
'Gateveien 15',
'Sandnes',
'4306',
'Norway');

-- SQL Null
-- Exercise 1
SELECT * FROM Customers
WHERE PostalCode is Null;

-- Exercise 2
SELECT * FROM Customers
WHERE PostalCode is not Null;

-- SQL Update
-- Exercise 1
Update Customers
Set City = 'Oslo';

-- Exercise 2
Update Customers
Set City = 'Oslo'
Where Country = 'Norway';

-- Exercise 3
Update Customers
Set City = 'Oslo'
Country = 'Norway'
WHERE CustomerID = 32;

-- SQL Delete
-- Exercise 1
Delete From Customers
Where Country = 'Norway';

-- Exercise 2
Delete From Customers;

-- SQL Functions
-- Exercise 1
SELECT min(price)
FROM Products;

-- Exercise 2
SELECT max(price)
FROM Products;

-- Exercise 3
SELECT Count(*)
FROM Products
Where Price = 18;

-- Exercise 4
SELECT avg(price)
FROM Products;

-- Exercise 5
SELECT sum(price)
FROM Products;

-- SQL Like
-- Exercise 1
SELECT * FROM Customers
Where City like 'a%';

-- Exercise 2
SELECT * FROM Customers
Where City like '%a';

-- Exercise 3
SELECT * FROM Customers
Where City like '%a%';

-- Exercise 4
SELECT * FROM Customers
Where City like 'a%b';

-- Exercise 5
SELECT * FROM Customers
Where City not like 'a%';

-- SQL WildCards
-- Exercise 1
SELECT * FROM Customers
WHERE City LIKE '_a%';

-- Exercise 2
SELECT * FROM Customers
WHERE City LIKE '[acs]%';

-- Exercise 3
SELECT * FROM Customers
WHERE City LIKE '[a-f]%';

-- Exercise 4
SELECT * FROM Customers
WHERE City LIKE '[!acf]%';

-- SQL IN
-- Exercise 1
SELECT * FROM Customers
Where Country in ('Norway','France');

-- Exercise 2
SELECT * FROM Customers
Where Country not in ('Norway','France');

-- SQL Between
-- Exercise 1
SELECT * FROM Products
WHERE Price BETWEEN 10 AND 20;

-- Exercise 2
SELECT * FROM Products
WHERE Price NOT BETWEEN 10 AND 20;

-- Exercise 3
SELECT * FROM Products
WHERE ProductName BETWEEN 'Geitost' AND 'Pavlova';

-- SQL Alias
-- Exercise 1
SELECT CustomerName,
Address,
PostalCode AS Pno
FROM Customers;

-- Exercise 2
SELECT *
FROM Customers AS Consumers;

-- SQL JOIN
-- Exercise 1
SELECT *
FROM Orders
LEFT JOIN Customers
ON Orders.CustomerID=Customers.CustomerID;

-- Exercise 2
SELECT *
FROM Orders
INNER JOIN Customers
ON Orders.CustomerID=Customers.CustomerID;

-- Exercise 3
SELECT *
FROM Orders
RIGHT JOIN Customers
ON Orders.CustomerID=Customers.CustomerID;

-- SQL Gtoup By
-- Exercise 1

SELECT COUNT(CustomerID),
Country
FROM Customers
GROUP BY Country;

-- Exercise 2
SELECT COUNT(CustomerID),
Country
FROM Customers
GROUP BY Country
ORDER BY COUNT(CustomerID) DESC;

-- SQL Database
-- Exercise 1
CREATE DATABASE testDB;

-- Exercise 2
DROP DATABASE testDB;

-- Exercise 3
CREATE TABLE Persons(
  PersonID int,
  LastName varchar(255),
  FirstName varchar(255),
  Address varchar(255),
  City varchar(255) 
);

-- Exercise 4
 DROP TABLE Persons;

-- Exercise 5
TRUNCATE TABLE Persons;

-- Exercise 6
ALTER TABLE Persons
ADD Birthday DATE;

-- Exercise 7
ALTER TABLE Persons
DROP COLUMN Birthday;