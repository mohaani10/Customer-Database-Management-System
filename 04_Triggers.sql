USE CustomerManagementDB;
GO

/*
Trigger policy:
- When order items are inserted, reduce stock in a set-based manner.
- If any product has insufficient stock, reject the entire statement.
- This starter project intentionally does not restock stock on updates/deletes.
  If you add order editing/cancellation, implement a transaction-safe inventory workflow.
*/
CREATE OR ALTER TRIGGER dbo.trg_OrderItems_CheckAndReduceStock
ON dbo.OrderItems
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    IF EXISTS (
        SELECT 1
        FROM dbo.Products AS p
        JOIN (
            SELECT ProductID, SUM(Quantity) AS RequiredQuantity
            FROM inserted
            GROUP BY ProductID
        ) AS i ON i.ProductID = p.ProductID
        WHERE p.StockQuantity < i.RequiredQuantity
    )
    BEGIN
        THROW 50020, 'Insufficient stock for one or more products.', 1;
    END;

    UPDATE p
    SET StockQuantity = p.StockQuantity - i.RequiredQuantity
    FROM dbo.Products AS p
    JOIN (
        SELECT ProductID, SUM(Quantity) AS RequiredQuantity
        FROM inserted
        GROUP BY ProductID
    ) AS i ON i.ProductID = p.ProductID;
END;
GO

