-- 1. Information Requirements of Company
SELECT c.first_name, c.last_name, ct.business_name, sr.service_description
FROM Clients c
JOIN Contractors ct ON c.client_id = ct.client_id
JOIN Service_Requests sr ON ct.request_id = sr.request_id;

-- 2. Limitation of Rows and Columns
SELECT first_name, last_name 
FROM Clients
WHERE ROWNUM <= 5;

-- 3. Sorting
SELECT first_name, last_name 
FROM Clients 
ORDER BY last_name ASC;

-- 4. LIKE, AND, OR
SELECT * 
FROM Clients
WHERE first_name LIKE 'A%' 
  AND address LIKE '%Street%' 
   OR phone LIKE '%123%';

-- 5. Variables and Character Functions
SELECT first_name || ' ' || last_name AS full_name 
FROM Clients;

-- 6. Round or Trunc
SELECT ROUND(total_amount, 2) AS rounded_amount 
FROM Payments;

-- 7. Date Functions
SELECT SYSDATE AS current_date FROM dual;
SELECT SYSDATE + 7 AS date_in_seven_days FROM dual;

-- 8. Aggregate Functions
SELECT review_score, COUNT(*) AS review_count
FROM Reviews
GROUP BY review_score;

-- 9. Group By and Having
SELECT job_scale, COUNT(*) AS request_count
FROM Service_Requests
GROUP BY job_scale
HAVING COUNT(*) > 1;

-- 10. Joins
SELECT c.first_name, c.last_name, r.review_score, r.review_comment
FROM Clients c
JOIN Reviews r ON c.client_id = r.client_id;

-- 11. Sub-queries
SELECT business_name, fee
FROM Contractors
WHERE fee > (
    SELECT AVG(fee)
    FROM Contractors
);
