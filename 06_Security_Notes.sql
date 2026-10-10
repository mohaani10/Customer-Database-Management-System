/*
SECURITY GUIDANCE — review and adapt before production use.

1. Use a dedicated SQL Server login/user for the application.
2. Grant only the permissions required. Avoid sysadmin/db_owner for application users.
3. Prefer EXECUTE permission on approved stored procedures rather than broad table access.
4. Use parameterized queries from applications; never concatenate user input into SQL.
5. Protect connection strings and credentials; do not commit secrets to GitHub.
6. Use encrypted connections where supported and maintain tested backups.
7. Audit access and review permissions regularly.

Example (run only as a database administrator; change the principal name as needed):
-- CREATE ROLE CustomerAppRole;
-- GRANT SELECT ON dbo.vw_CustomerDirectory TO CustomerAppRole;
-- GRANT SELECT ON dbo.vw_OrderSummary TO CustomerAppRole;
-- GRANT EXECUTE ON dbo.usp_SearchCustomers TO CustomerAppRole;
-- GRANT EXECUTE ON dbo.usp_AddCustomer TO CustomerAppRole;
-- ALTER ROLE CustomerAppRole ADD MEMBER [YourDatabaseUser];

Do not run example GRANT statements until the database user exists and permissions have been reviewed.
*/

