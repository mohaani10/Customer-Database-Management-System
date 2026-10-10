# Customer Database Management System (CDMS)

A portfolio project built with Microsoft SQL Server and T-SQL. It demonstrates relational database design, data integrity, customer/order management, reporting, stored procedures, views, indexes, and a stock-validation trigger.

## Features

- Customers, Products, Orders, OrderItems, and Payments tables
- Primary keys, foreign keys, UNIQUE, CHECK, and DEFAULT constraints
- CRUD examples and soft deactivation for customers
- INNER JOIN and LEFT JOIN examples
- Aggregates, GROUP BY, HAVING, and subqueries
- Views for customer directory, order summary, and payments
- Stored procedures for adding, searching, updating, and deactivating customers
- Indexes for common lookups
- Trigger that validates and reduces inventory when order items are inserted
- Reporting queries and security guidance

## Requirements

- SQL Server 2019 or later recommended
- SQL Server Management Studio (SSMS)

## Run the project

1. Open SSMS and connect to your SQL Server instance.
2. Open `01_CreateDatabaseAndTables.sql` and execute it. It creates `CustomerManagementDB` and the tables.
3. Open and execute `02_InsertSampleData.sql`.
4. Execute `03_Views_Indexes_Procedures.sql`.
5. Execute `04_Triggers.sql`.
6. Execute `05_Queries_Reports_Tests.sql`.
7. Read `06_Security_Notes.sql` before configuring application permissions.

Run each script once on a fresh database in the order above. If you rerun the sample-data script, unique email/SKU constraints will cause duplicate-insert errors. To reset a disposable practice database, back up anything important first; then drop and recreate the database deliberately.

## Data model

- One Customer can have many Orders.
- One Order can have many OrderItems.
- One Product can appear in many OrderItems.
- One Order can have many Payments.

`OrderItems` resolves the many-to-many relationship between Orders and Products. `UnitPriceAtPurchase` preserves the product price at the time the order was placed.

## Important implementation notes

- Sample customers, payment references, and records are fictional.
- The trigger handles INSERT into `OrderItems`. This starter project does not automatically restore stock when an order item is updated or deleted; implement and test a transaction-safe workflow before adding those operations.
- Payment totals and order values are different concepts. Order value is calculated from order items; paid amounts are based on completed payment records.
- The email CHECK constraint is a basic sanity check, not full email validation.
- This is an educational portfolio project, not a production-ready payment platform.

## Suggested GitHub description

Professional SQL Server Customer Database Management System with relational design, stored procedures, views, indexes, inventory trigger, and sales reports.

## Portfolio screenshot ideas

Capture screenshots of:
1. Tables and relationships in SSMS.
2. `vw_OrderSummary` output.
3. Customer sales report.
4. Stored procedure execution.
5. Product stock before and after adding an order item.
