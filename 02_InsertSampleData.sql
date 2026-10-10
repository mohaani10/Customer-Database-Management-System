USE CustomerManagementDB;
GO

INSERT INTO dbo.Customers (FirstName, LastName, Email, Phone, City, Country)
VALUES
(N'Mohamed', N'Abdi', N'mohamed.abdi@example.com', N'+252610000001', N'Gaalkacyo', N'Somalia'),
(N'Amina', N'Hassan', N'amina.hassan@example.com', N'+252610000002', N'Mogadishu', N'Somalia'),
(N'Ahmed', N'Yusuf', N'ahmed.yusuf@example.com', N'+252610000003', N'Hargeisa', N'Somalia'),
(N'Fatima', N'Ali', N'fatima.ali@example.com', N'+252610000004', N'Bosaso', N'Somalia');
GO

INSERT INTO dbo.Products (ProductName, SKU, UnitPrice, StockQuantity)
VALUES
(N'Wireless Mouse', N'ACC-MOUSE-001', 12.50, 50),
(N'Keyboard', N'ACC-KEY-001', 24.99, 35),
(N'USB-C Cable', N'ACC-CABLE-001', 6.75, 100),
(N'Laptop Stand', N'ACC-STAND-001', 29.00, 20);
GO

INSERT INTO dbo.Orders (CustomerID, OrderDate, OrderStatus, Notes)
VALUES
(1, '2026-09-15T10:00:00', N'Completed', N'First sample order'),
(1, '2026-09-22T14:30:00', N'Processing', N'Awaiting dispatch'),
(2, '2026-09-25T09:15:00', N'Completed', NULL),
(3, '2026-10-01T11:45:00', N'Pending', N'Confirm delivery details');
GO

INSERT INTO dbo.OrderItems (OrderID, ProductID, Quantity, UnitPriceAtPurchase)
VALUES
(1, 1, 2, 12.50),
(1, 3, 3, 6.75),
(2, 2, 1, 24.99),
(3, 4, 1, 29.00),
(3, 3, 2, 6.75),
(4, 1, 1, 12.50);
GO

INSERT INTO dbo.Payments (OrderID, Amount, PaymentMethod, PaymentStatus, TransactionReference)
VALUES
(1, 45.25, N'Mobile Money', N'Completed', N'SAMPLE-TXN-1001'),
(2, 10.00, N'Cash', N'Pending', N'SAMPLE-TXN-1002'),
(3, 42.50, N'Card', N'Completed', N'SAMPLE-TXN-1003');
GO

-- These are illustrative sample records, not real customers or transactions.
SELECT * FROM dbo.Customers;
SELECT * FROM dbo.Products;
SELECT * FROM dbo.Orders;
SELECT * FROM dbo.OrderItems;
SELECT * FROM dbo.Payments;
GO


