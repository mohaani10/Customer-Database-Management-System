/*
Customer Database Management System
Run this script in SSMS using a login allowed to create databases.
*/
IF DB_ID(N'CustomerManagementDB') IS NULL
    CREATE DATABASE CustomerManagementDB;
GO

USE CustomerManagementDB;
GO

CREATE TABLE dbo.Customers (
    CustomerID INT IDENTITY(1,1) CONSTRAINT PK_Customers PRIMARY KEY,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    Email NVARCHAR(254) NOT NULL CONSTRAINT UQ_Customers_Email UNIQUE,
    Phone NVARCHAR(25) NULL,
    City NVARCHAR(80) NULL,
    Country NVARCHAR(80) NOT NULL CONSTRAINT DF_Customers_Country DEFAULT N'Somalia',
    CreatedAt DATETIME2(0) NOT NULL CONSTRAINT DF_Customers_CreatedAt DEFAULT SYSDATETIME(),
    IsActive BIT NOT NULL CONSTRAINT DF_Customers_IsActive DEFAULT 1,
    CONSTRAINT CK_Customers_Email CHECK (Email LIKE N'%_@_%._%')
);
GO

CREATE TABLE dbo.Products (
    ProductID INT IDENTITY(1,1) CONSTRAINT PK_Products PRIMARY KEY,
    ProductName NVARCHAR(120) NOT NULL,
    SKU NVARCHAR(40) NOT NULL CONSTRAINT UQ_Products_SKU UNIQUE,
    UnitPrice DECIMAL(12,2) NOT NULL,
    StockQuantity INT NOT NULL CONSTRAINT DF_Products_Stock DEFAULT 0,
    IsActive BIT NOT NULL CONSTRAINT DF_Products_IsActive DEFAULT 1,
    CONSTRAINT CK_Products_UnitPrice CHECK (UnitPrice >= 0),
    CONSTRAINT CK_Products_Stock CHECK (StockQuantity >= 0)
);
GO

CREATE TABLE dbo.Orders (
    OrderID INT IDENTITY(1,1) CONSTRAINT PK_Orders PRIMARY KEY,
    CustomerID INT NOT NULL,
    OrderDate DATETIME2(0) NOT NULL CONSTRAINT DF_Orders_OrderDate DEFAULT SYSDATETIME(),
    OrderStatus NVARCHAR(20) NOT NULL CONSTRAINT DF_Orders_Status DEFAULT N'Pending',
    Notes NVARCHAR(500) NULL,
    CONSTRAINT FK_Orders_Customers FOREIGN KEY (CustomerID) REFERENCES dbo.Customers(CustomerID),
    CONSTRAINT CK_Orders_Status CHECK (OrderStatus IN (N'Pending', N'Processing', N'Completed', N'Cancelled'))
);
GO

CREATE TABLE dbo.OrderItems (
    OrderItemID INT IDENTITY(1,1) CONSTRAINT PK_OrderItems PRIMARY KEY,
    OrderID INT NOT NULL,
    ProductID INT NOT NULL,
    Quantity INT NOT NULL,
    UnitPriceAtPurchase DECIMAL(12,2) NOT NULL,
    CONSTRAINT FK_OrderItems_Orders FOREIGN KEY (OrderID) REFERENCES dbo.Orders(OrderID),
    CONSTRAINT FK_OrderItems_Products FOREIGN KEY (ProductID) REFERENCES dbo.Products(ProductID),
    CONSTRAINT UQ_OrderItems_Order_Product UNIQUE (OrderID, ProductID),
    CONSTRAINT CK_OrderItems_Quantity CHECK (Quantity > 0),
    CONSTRAINT CK_OrderItems_Price CHECK (UnitPriceAtPurchase >= 0)
);
GO

CREATE TABLE dbo.Payments (
    PaymentID INT IDENTITY(1,1) CONSTRAINT PK_Payments PRIMARY KEY,
    OrderID INT NOT NULL,
    PaymentDate DATETIME2(0) NOT NULL CONSTRAINT DF_Payments_Date DEFAULT SYSDATETIME(),
    Amount DECIMAL(12,2) NOT NULL,
    PaymentMethod NVARCHAR(30) NOT NULL,
    PaymentStatus NVARCHAR(20) NOT NULL CONSTRAINT DF_Payments_Status DEFAULT N'Completed',
    TransactionReference NVARCHAR(100) NULL,
    CONSTRAINT FK_Payments_Orders FOREIGN KEY (OrderID) REFERENCES dbo.Orders(OrderID),
    CONSTRAINT CK_Payments_Amount CHECK (Amount > 0),
    CONSTRAINT CK_Payments_Method CHECK (PaymentMethod IN (N'Cash', N'Card', N'Mobile Money', N'Bank Transfer')),
    CONSTRAINT CK_Payments_Status CHECK (PaymentStatus IN (N'Pending', N'Completed', N'Failed', N'Refunded'))
);
GO


