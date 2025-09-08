# ERP-Data-Management-and-Audit-Logging-System
 Built SQL scripts for data loading, cleaning, deduplication, and reporting to track user activity, enforce access control, and generate daily operational insights. Demonstrated ability to manage ERP-related data flows and ensure system integrity through structured queries and automation.

 
```
SELECT
    CustomerID,
    FirstName,
    LastName,
    Email
FROM
    Customers
WHERE
    RegistrationDate >= '2025-01-01'
ORDER BY
    LastName, FirstName;

```
