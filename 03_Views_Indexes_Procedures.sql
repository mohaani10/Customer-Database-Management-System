USE CustomerManagementDB;
GO

CREATE OR ALTER VIEW dbo.vw_CustomerDirectory
AS
SELECT CustomerID, FirstName, LastName,
       CONCAT(FirstName, N' ', LastName) AS FullName,
       Email, Phone, City, Country, CreatedAt, IsActive
FROM dbo.Customers;
GO

CREATE OR ALTER VIEW dbo.vw_OrderSummary
AS
SELECT o.OrderID, o.OrderDate, o.OrderStatus,
       c.CustomerID, CONCAT(c.FirstName, N' ', c.LastName) AS CustomerName,
       COALESCE(SUM(oi.Quantity * oi.UnitPriceAtPurchase), 0) AS OrderTotal
FROM dbo.Orders AS o
JOIN dbo.Customers AS c ON c.CustomerID = o.CustomerID
LEFT JOIN dbo.OrderItems AS oi ON oi.OrderID = o.OrderID
GROUP BY o.OrderID, o.OrderDate, o.OrderStatus, c.CustomerID, c.FirstName, c.LastName;
GO

CREATE OR ALTER VIEW dbo.vw_PaymentSummary
AS
SELECT p.PaymentID, p.OrderID, p.PaymentDate, p.Amount,
       p.PaymentMethod, p.PaymentStatus, p.TransactionReference
FROM dbo.Payments AS p;
GO

CREATE INDEX IX_Orders_CustomerID_OrderDate
ON dbo.Orders(CustomerID, OrderDate DESC);
GO

CREATE INDEX IX_OrderItems_ProductID
ON dbo.OrderItems(ProductID);
GO

CREATE INDEX IX_Payments_OrderID_Status
ON dbo.Payments(OrderID, PaymentStatus);
GO

CREATE OR ALTER PROCEDURE dbo.usp_AddCustomer
    @FirstName NVARCHAR(50),
    @LastName NVARCHAR(50),
    @Email NVARCHAR(254),
    @Phone NVARCHAR(25) = NULL,
    @City NVARCHAR(80) = NULL,
    @Country NVARCHAR(80) = N'Somalia'
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    IF NULLIF(LTRIM(RTRIM(@FirstName)), N'') IS NULL
        THROW 50001, 'First name is required.', 1;
    IF NULLIF(LTRIM(RTRIM(@LastName)), N'') IS NULL
        THROW 50002, 'Last name is required.', 1;
    IF NULLIF(LTRIM(RTRIM(@Email)), N'') IS NULL
        THROW 50003, 'Email is required.', 1;
    IF EXISTS (SELECT 1 FROM dbo.Customers WHERE Email = @Email)
        THROW 50004, 'A customer with this email already exists.', 1;

    INSERT INTO dbo.Customers (FirstName, LastName, Email, Phone, City, Country)
    VALUES (LTRIM(RTRIM(@FirstName)), LTRIM(RTRIM(@LastName)),
            LTRIM(RTRIM(@Email)), @Phone, @City, COALESCE(NULLIF(@Country, N''), N'Somalia'));

    SELECT * FROM dbo.Customers WHERE CustomerID = CONVERT(INT, SCOPE_IDENTITY());
END;
GO

CREATE OR ALTER PROCEDURE dbo.usp_SearchCustomers
    @SearchTerm NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;
    SELECT CustomerID, FirstName, LastName, Email, Phone, City, Country, IsActive
    FROM dbo.Customers
    WHERE FirstName LIKE N'%' + @SearchTerm + N'%'
       OR LastName LIKE N'%' + @SearchTerm + N'%'
       OR Email LIKE N'%' + @SearchTerm + N'%'
       OR City LIKE N'%' + @SearchTerm + N'%'
    ORDER BY LastName, FirstName;
END;
GO

CREATE OR ALTER PROCEDURE dbo.usp_UpdateCustomer
    @CustomerID INT,
    @FirstName NVARCHAR(50),
    @LastName NVARCHAR(50),
    @Email NVARCHAR(254),
    @Phone NVARCHAR(25) = NULL,
    @City NVARCHAR(80) = NULL,
    @Country NVARCHAR(80) = N'Somalia'
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM dbo.Customers WHERE CustomerID = @CustomerID)
        THROW 50005, 'Customer not found.', 1;
    IF EXISTS (SELECT 1 FROM dbo.Customers WHERE Email = @Email AND CustomerID <> @CustomerID)
        THROW 50006, 'Email is already used by another customer.', 1;

    UPDATE dbo.Customers
    SET FirstName = @FirstName, LastName = @LastName, Email = @Email,
        Phone = @Phone, City = @City, Country = @Country
    WHERE CustomerID = @CustomerID;

    SELECT * FROM dbo.Customers WHERE CustomerID = @CustomerID;
END;
GO

CREATE OR ALTER PROCEDURE dbo.usp_DeactivateCustomer
    @CustomerID INT
AS
BEGIN
    SET NOCOUNT ON;
    IF NOT EXISTS (SELECT 1 FROM dbo.Customers WHERE CustomerID = @CustomerID)
        THROW 50007, 'Customer not found.', 1;

    -- Soft delete: preserve historical orders and payments.
    UPDATE dbo.Customers SET IsActive = 0 WHERE CustomerID = @CustomerID;
END;
GO

