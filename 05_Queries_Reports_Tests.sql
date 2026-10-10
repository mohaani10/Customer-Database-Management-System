USE CustomerManagementDB;
GO

-- 1. CRUD examples (uncomment carefully when testing).
-- CREATE: INSERT INTO dbo.Customers (FirstName, LastName, Email, City)
-- VALUES (N'Test', N'Customer', N'test.customer@example.com', N'Gaalkacyo');
-- READ:
SELECT * FROM dbo.Customers ORDER BY CustomerID;
-- UPDATE: UPDATE dbo.Customers SET City = N'Garoowe' WHERE CustomerID = 4;
-- DELETE: prefer soft deletion with dbo.usp_DeactivateCustomer to preserve order history.

-- 2. INNER JOIN: orders with customer names.
SELECT o.OrderID, CONCAT(c.FirstName, N' ', c.LastName) AS CustomerName,
       o.OrderDate, o.OrderStatus
FROM dbo.Orders AS o
INNER JOIN dbo.Customers AS c ON c.CustomerID = o.CustomerID
ORDER BY o.OrderDate DESC;

-- 3. LEFT JOIN: include customers with no orders.
SELECT c.CustomerID, CONCAT(c.FirstName, N' ', c.LastName) AS CustomerName,
       COUNT(o.OrderID) AS NumberOfOrders
FROM dbo.Customers AS c
LEFT JOIN dbo.Orders AS o ON o.CustomerID = c.CustomerID
GROUP BY c.CustomerID, c.FirstName, c.LastName
ORDER BY NumberOfOrders DESC;

-- 4. Order line details and totals.
SELECT o.OrderID, c.Email, p.ProductName, oi.Quantity,
       oi.UnitPriceAtPurchase,
       oi.Quantity * oi.UnitPriceAtPurchase AS LineTotal
FROM dbo.Orders AS o
JOIN dbo.Customers AS c ON c.CustomerID = o.CustomerID
JOIN dbo.OrderItems AS oi ON oi.OrderID = o.OrderID
JOIN dbo.Products AS p ON p.ProductID = oi.ProductID
ORDER BY o.OrderID, p.ProductName;

-- 5. Aggregate report: total sales by customer (based on order items).
SELECT c.CustomerID, CONCAT(c.FirstName, N' ', c.LastName) AS CustomerName,
       COALESCE(SUM(oi.Quantity * oi.UnitPriceAtPurchase), 0) AS TotalOrderValue
FROM dbo.Customers AS c
LEFT JOIN dbo.Orders AS o ON o.CustomerID = c.CustomerID
LEFT JOIN dbo.OrderItems AS oi ON oi.OrderID = o.OrderID
GROUP BY c.CustomerID, c.FirstName, c.LastName
ORDER BY TotalOrderValue DESC;

-- 6. HAVING: customers whose order-item value exceeds 30.
SELECT c.CustomerID, c.FirstName, c.LastName,
       SUM(oi.Quantity * oi.UnitPriceAtPurchase) AS TotalOrderValue
FROM dbo.Customers AS c
JOIN dbo.Orders AS o ON o.CustomerID = c.CustomerID
JOIN dbo.OrderItems AS oi ON oi.OrderID = o.OrderID
GROUP BY c.CustomerID, c.FirstName, c.LastName
HAVING SUM(oi.Quantity * oi.UnitPriceAtPurchase) > 30;

-- 7. Subquery: products priced above the average product price.
SELECT ProductID, ProductName, UnitPrice
FROM dbo.Products
WHERE UnitPrice > (SELECT AVG(UnitPrice) FROM dbo.Products);

-- 8. Payments received by status; completed payments only are counted as paid.
SELECT PaymentStatus, COUNT(*) AS PaymentCount, SUM(Amount) AS TotalAmount
FROM dbo.Payments
GROUP BY PaymentStatus;

SELECT OrderID, SUM(Amount) AS AmountPaid
FROM dbo.Payments
WHERE PaymentStatus = N'Completed'
GROUP BY OrderID;

-- 9. Low-stock products.
SELECT ProductID, ProductName, StockQuantity
FROM dbo.Products
WHERE StockQuantity < 25
ORDER BY StockQuantity;

-- 10. Use the views.
SELECT * FROM dbo.vw_CustomerDirectory;
SELECT * FROM dbo.vw_OrderSummary ORDER BY OrderDate DESC;
SELECT * FROM dbo.vw_PaymentSummary;

-- 11. Stored procedure examples.
EXEC dbo.usp_SearchCustomers @SearchTerm = N'Mohamed';
-- EXEC dbo.usp_AddCustomer @FirstName=N'Layla', @LastName=N'Osman',
--      @Email=N'layla.osman@example.com', @Phone=N'+252610000005',
--      @City=N'Garoowe', @Country=N'Somalia';
-- EXEC dbo.usp_UpdateCustomer @CustomerID=1, @FirstName=N'Mohamed',
--      @LastName=N'Abdi', @Email=N'mohamed.abdi@example.com',
--      @Phone=N'+252610000001', @City=N'Gaalkacyo', @Country=N'Somalia';
-- EXEC dbo.usp_DeactivateCustomer @CustomerID=4;

-- 12. Integrity checks: these should return zero rows.
SELECT oi.*
FROM dbo.OrderItems AS oi
LEFT JOIN dbo.Orders AS o ON o.OrderID = oi.OrderID
LEFT JOIN dbo.Products AS p ON p.ProductID = oi.ProductID
WHERE o.OrderID IS NULL OR p.ProductID IS NULL;
GO


