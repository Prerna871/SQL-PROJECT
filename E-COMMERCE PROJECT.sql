CREATE DATABASE EcommerceDB;
USE EcommerceDB;

-- Customers Table
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Email VARCHAR(100),
    City VARCHAR(50),
    Country VARCHAR(50),
    RegistrationDate DATE
);

-- Products Table
CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    Category VARCHAR(50),
    Price DECIMAL(10,2),
    Stock INT
);

-- Orders Table
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    OrderDate DATE,
    TotalAmount DECIMAL(10,2),
    Status VARCHAR(50),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

-- OrderDetails Table
CREATE TABLE OrderDetails (
    OrderDetailID INT PRIMARY KEY,
    OrderID INT,
    ProductID INT,
    Quantity INT,
    UnitPrice DECIMAL(10,2),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

-- Payments Table
CREATE TABLE Payments (
    PaymentID INT PRIMARY KEY,
    OrderID INT,
    PaymentDate DATE,
    PaymentMethod VARCHAR(50),
    Amount DECIMAL(10,2),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);
-- Customers
INSERT INTO Customers VALUES
(1, 'Prerna', 'Priya', 'prerna@example.com', 'Jamshedpur', 'India', '2024-01-10'),
(2, 'Ravi', 'Kumar', 'ravi@example.com', 'Delhi', 'India', '2024-01-15');

-- Products
INSERT INTO Products VALUES
(101, 'Smartphone', 'Electronics', 15000.00, 100),
(102, 'Laptop', 'Electronics', 50000.00, 50),
(103, 'T-shirt', 'Fashion', 799.00, 200),
(104, 'Python Book', 'Books', 599.00, 120);

-- Orders
INSERT INTO Orders VALUES
(1001, 1, '2024-03-01', 15599.00, 'Shipped'),
(1002, 2, '2024-03-05', 50799.00, 'Delivered');

-- OrderDetails
INSERT INTO OrderDetails VALUES
(1, 1001, 101, 1, 15000.00),
(2, 1001, 104, 1, 599.00),
(3, 1002, 102, 1, 50000.00),
(4, 1002, 103, 1, 799.00);

-- Payments
INSERT INTO Payments VALUES
(1, 1001, '2024-03-01', 'Credit Card', 15599.00),
(2, 1002, '2024-03-05', 'UPI', 50799.00);

SELECT * FROM Customers;
SELECT * FROM Products;
SELECT * FROM Orders;
SELECT * FROM OrderDetails;
SELECT * FROM Payments;

-- 1. Total Revenue
SELECT SUM(TotalAmount) AS TotalRevenue 
FROM Orders;

-- 2. Monthly Sales Trend
SELECT FORMAT(OrderDate, 'yyyy-MM') AS Month, SUM(TotalAmount) AS Revenue
FROM Orders
GROUP BY FORMAT(OrderDate, 'yyyy-MM');

-- 3. Top 3 Best-Selling Products
SELECT TOP 3 P.ProductName, SUM(OD.Quantity) AS TotalSold
FROM OrderDetails OD
JOIN Products P 
ON OD.ProductID = P.ProductID
GROUP BY P.ProductName
ORDER BY TotalSold DESC

-- 4. Total Orders by City
SELECT C.City, COUNT(O.OrderID) AS TotalOrders
FROM Orders O
JOIN Customers C 
ON O.CustomerID = C.CustomerID
GROUP BY C.City;

-- 5. Customer Lifetime Value
SELECT C.FirstName + ' ' + C.LastName AS CustomerName,SUM(O.TotalAmount) AS LifetimeValue
FROM Customers C
JOIN Orders O 
ON C.CustomerID = O.CustomerID
GROUP BY C.FirstName, C.LastName;

-- 6. Product Inventory Check
SELECT ProductName, Stock
 FROM Products 
 WHERE Stock < 50;

-- 7. Payment Method Usage
SELECT PaymentMethod, COUNT(*) AS UsageCount
FROM Payments
GROUP BY PaymentMethod;

-- 8. Highest Paying Customer
SELECT TOP 1 C.FirstName, C.LastName, SUM(O.TotalAmount) AS TotalSpent
FROM Customers C
JOIN Orders O 
ON C.CustomerID = O.CustomerID
GROUP BY C.FirstName, C.LastName
ORDER BY TotalSpent DESC;

-- 9. Orders with Multiple Products
SELECT OrderID, COUNT(*) AS NumberOfProducts
FROM OrderDetails
GROUP BY OrderID
HAVING COUNT(*) > 1;

-- 10. Average Order Value
SELECT AVG(TotalAmount) AS AverageOrderValue 
FROM Orders;
