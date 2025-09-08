# ERP-Data-Management-and-Audit-Logging-System  
Built SQL scripts for data loading, cleaning, deduplication, and reporting to track user activity, enforce access control, and generate daily operational insights. Demonstrated ability to manage ERP-related data flows and ensure system integrity through structured queries and automation.  
````markdown

```sql
-- SELECTAREA ANGAJAȚILOR ȘI A ACȚIUNILOR CARE AU FOST DESFĂȘURAT ÎN AFARA TIMPULUI DE MUNCA
SELECT U.username, L.action_type, COUNT(L.timestamp) number_of_operations 
FROM Audit_log L
JOIN USER U
ON L.user_id=U.user_id
WHERE EXTRACT(HOUR FROM timestamp) NOT BETWEEN 8 AND 18
GROUP BY U.username, L.action_type
ORDER BY U.username, L.action_type;

SELECT username, COUNT(action_type) AS personal_operations 
FROM Audit_log L
JOIN USER U
ON L.user_id=U.user_id
WHERE EXTRACT(HOUR FROM timestamp) NOT BETWEEN 8 AND 18
GROUP BY username
ORDER BY COUNT(action_type) DESC;
````

<img width="800" height="668" alt="image" src="https://github.com/user-attachments/assets/ba953795-dcda-4662-96f7-50b599740654" />  
<img width="600" height="720" alt="image" src="https://github.com/user-attachments/assets/f5684d41-4e50-43df-b33c-c1bf325911fb" />  

```sql
-- Selectarea utilizatorilor inactivi
SELECT DISTINCT(username) 
FROM USER 
JOIN Audit_log
ON USER.user_id=Audit_log.user_id
WHERE is_active=0;
```

<img width="420" height="680" alt="image" src="https://github.com/user-attachments/assets/0cac1519-2544-41e4-89c1-5f09330f7295" />  

```sql
-- Operatiile zilnice realizate in total in tot timpul
WITH CTE_DAILY_OPERATIONS AS (
  SELECT EXTRACT(YEAR FROM timestamp) AS year, 
         EXTRACT(MONTH FROM timestamp) AS month, 
         EXTRACT(DAY FROM timestamp) AS day, 
         COUNT(action_type) AS operation_count
  FROM Audit_log
  GROUP BY EXTRACT(YEAR FROM timestamp), EXTRACT(MONTH FROM timestamp), EXTRACT(DAY FROM timestamp)
  ORDER BY EXTRACT(YEAR FROM timestamp), EXTRACT(MONTH FROM timestamp), EXTRACT(DAY FROM timestamp)
)
SELECT year, month, day, operation_count, 
       SUM(operation_count) OVER(ORDER BY year, month, day) AS running_sum_of_operation
FROM CTE_DAILY_OPERATIONS;
```

<img width="900" height="840" alt="image" src="https://github.com/user-attachments/assets/7e7520d5-3877-4343-9bcd-a24c7ee1878c" />  

```sql
-- Actiuni lunare per departament, cu clasamentul departamentelor cu cele mai multe actiune pe luna
WITH USER_role_name AS (
  WITH user_role AS (
    SELECT USER.user_id, USER.username, USER.department, USER_ROLES.role_id 
    FROM USER
    JOIN User_roles
    ON USER.user_id=User_roles.user_id
  )
  SELECT user_id, username, department, role_name 
  FROM user_role 
  JOIN roles 
  ON user_role.role_id=roles.role_id
  ORDER BY department, user_id
)
SELECT USER_role_name.department, 
       EXTRACT(YEAR FROM timestamp) AS year, 
       EXTRACT(MONTH FROM timestamp) AS month,  
       COUNT(action_type) AS number_actions,
       RANK() OVER(PARTITION BY EXTRACT(MONTH FROM timestamp) ORDER BY COUNT(action_type) DESC) 
FROM Audit_log
JOIN USER_role_name
ON Audit_log.user_id=USER_role_name.user_id
GROUP BY USER_role_name.department, EXTRACT(YEAR FROM timestamp), EXTRACT(MONTH FROM timestamp);
```

<img width="740" height="960" alt="image" src="https://github.com/user-attachments/assets/e73a2639-0fd5-4b47-997f-ea5a75b26bf1" />  
```
