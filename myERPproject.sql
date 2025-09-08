CREATE TABLE IF NOT EXISTS Roles(
    role_id INT PRIMARY KEY,
    role_name VARCHAR(50) NOT NULL,
);
  
LOAD DATA LOCAL INFILE '/Users/daniel/Downloads/roles.csv'
    INTO TABLE Roles
    FIELDS TERMINATED BY ','
    ENCLOSED BY '"'
    LINES TERMINATED BY '\n'
    IGNORE 1 ROWS;

CREATE TABLE IF NOT EXISTS User(
    user_id INT PRIMARY KEY,
    username VARCHAR(50),
    full_name VARCHAR(50),
    department VARCHAR(50),
    is_active boolean
);
  
LOAD DATA LOCAL INFILE '/Users/daniel/Downloads/users.csv'
    INTO TABLE User
    FIELDS TERMINATED BY ','
    ENCLOSED BY '"'
    LINES TERMINATED BY '\n'
    IGNORE 1 ROWS;

CREATE TABLE IF NOT EXISTS Audit_log(
  log_id INT PRIMARY KEY, 
  user_id INT foreign KEY,
  action_type VARCHAR(50),
  table_name VARCHAR(50),
  record_id NUMERIC(5,1),
  timestamp timestamp
)
LOAD DATA LOCAL INFILE '/Users/daniel/Downloads/audit_log.csv'
    INTO TABLE Audit_log
    FIELDS TERMINATED BY ','
    ENCLOSED BY '"'
    LINES TERMINATED BY '\n'
    IGNORE 1 ROWS;

CREATE TABLE IF NOT EXISTS Audit_log(
  log_id INT PRIMARY KEY, 
  user_id INT foreign KEY,
  action_type VARCHAR(50),
  table_name VARCHAR(50),
  record_id NUMERIC(5,1),
  timestamp timestamp
)
LOAD DATA LOCAL INFILE '/Users/daniel/Downloads/audit_log.csv'
    INTO TABLE your_table_name
    FIELDS TERMINATED BY ','
    ENCLOSED BY '"'
    LINES TERMINATED BY '\n'
    IGNORE 1 ROWS;

CREATE TABLE IF NOT EXISTS User_roles(
  user_role_id INT AUTO_INCREMENT PRIMARY KEY , 
  user_id INT,
  role_id INT,
  foreign KEY(user_id) references User(user_id),
  foreign KEY(role_id) references Roles(role_id)
)
LOAD DATA LOCAL INFILE '/Users/daniel/Downloads/user_roles.csv'
    INTO TABLE your_table_name
    FIELDS TERMINATED BY ','
    ENCLOSED BY '"'
    LINES TERMINATED BY '\n'
    IGNORE 1 ROWS;

SELECT * FROM User
SELECT * FROM Roles
SELECT * FROM User_roles
SELECT * FROM Audit_log

UPDATE USERS 
  SET username= TRIM(username),
   full_name= TRIM(full_name),
   department = TRIM(department);

UPDATE Audit_log
  SET action_type = TRIM(Action_type),
  table_name = TRIM(table_name)
  
  WITH CTE_DUPLICATES AS (
SELECT *, ROW_NUMBER() OVER(PARTITION BY user_id, action_type, timestamp) AS ROW_NUM FROM Audit_log)

DELETE FROM Audit_log
  WHERE log_id IN (SELECT log_id  FROM CTE_DUPLICATES WHERE ROW_NUM>1)
  
SELECT TRIM(SUBSTRING(FULL_NAME,1, LOCATE(' ',FULL_NAME))) 
  FROM USER
  
SELECT SUBSTRING(FULL_NAME, LOCATE(' ',FULL_NAME)+1)
  FROM USER

  ALTER TABLE User
  ADD first_name VARCHAR(50),
  ADD last_name VARCHAR(50);

  UPDATE USER
  SET first_name=TRIM(SUBSTRING(FULL_NAME,1, LOCATE(' ',FULL_NAME))),
  last_name=SUBSTRING(FULL_NAME, LOCATE(' ',FULL_NAME)+1);
    
SELECT Audit_log_empty.action_type, Audit_log_empty.table_name, Audit_log_VALUE.action_type, Audit_log_value.table_name
FROM Audit_log Audit_log_empty
JOIN Audit_log Audit_log_value
ON Audit_log_empty.action_type=Audit_log_empty.action_type
AND Audit_log_empty.log_id<>Audit_log_empty.log_id

UPDATE Audit_log Audit_log_empty
JOIN Audit_log Audit_log_value
ON Audit_log_empty.action_type=Audit_log_empty.action_type
AND Audit_log_empty.log_id<>Audit_log_empty.log_id
  SET Audit_log_empty.table_name=IFNULL(Audit_log_empty.table_name,Audit_log_value.table_name)
WHERE Audit_log_value.table_name IS NULL

-- SELECTING THE EMPLOYEES THAT MADE AN ACTION ACTION OUTSIDE OF WORKING TIME
SELECT U.username, L.action_type, COUNT(L.timestamp) from Audit_log l
JOIN USER u
ON l.user_id=u.user_id
where EXTRACT( HOUR FROM timestamp ) not BETWEEN 8 AND 18
GROUP BY U.username, L.action_type
ORDER BY U.username, L.action_type

SELECT username, COUNT(action_type) from Audit_log l
JOIN USER u
ON l.user_id=u.user_id
where EXTRACT( HOUR FROM timestamp ) not BETWEEN 8 AND 18
group by username
order by COUNT(action_type) DESC
  
SELECT distinct(username) from users 
   JOIN Audit_log
ON users.user_id=Audit_log.user_id
WHERE is_active=0

SELECT EXTRACT(YEAR FROM timestamp) AS year, EXTRACT(MONTH FROM timestamp) AS month, 
  EXTRACT(DAY FROM timestamp) AS day, count(action_type), (count(action_type)) OVER(), EXTRACT(MONTH FROM timestamp), 
  EXTRACT(DAY FROM timestamp))
from Audit_log
group by EXTRACT(YEAR FROM timestamp), EXTRACT(MONTH FROM timestamp), EXTRACT(DAY FROM timestamp)
order by EXTRACT(YEAR FROM timestamp), EXTRACT(MONTH FROM timestamp), EXTRACT(DAY FROM timestamp)

SELECT user.user_id, user.full_name, MIN(user.deleted_at) deletion_time, MIN(Audit_log.timestamp) action_time FROM USER
  JOIN Audit_log
  WHERE Audit_log.timestamp>user.deleted_at
GROUP BY user.user_id, user.full_name

  WITH USER_role_name AS (
WITH user_role AS (
SELECT user.user_id, USER.username, USER.department, USER_ROLES.role_id FROM user
JOIN User_roles
ON user.user_id=User_roles.user_id)

SELECT user_id, username, department, role_name FROM user_role 
JOIN roles 
ON user_role.role_id=roles.role_id
ORDER BY DEPARTMENT, USER_ID)

SELECT user_role_name.department, EXTRACT(YEAR FROM timestamp) as year, EXTRACT(MONTH FROM timestamp) as month,  
  COUNT(action_type) as number_actions,
  RANK() OVER(PARTITION BY EXTRACT(MONTH FROM timestamp) ORDER BY COUNT(action_type) DESC) FROM Audit_log
JOIN user_role_name
ON Audit_log.user_id=user_role_name.user_id
group by user_role_name.department, EXTRACT(YEAR FROM timestamp), EXTRACT(MONTH FROM timestamp)





