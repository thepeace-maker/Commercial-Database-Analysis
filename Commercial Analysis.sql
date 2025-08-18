USE SQL_Project_GMC

-- 3. Display in descending order of seniority the male employees whose net salary (salary + commission)
-- is greater than or equal to 8000. The resulting table should include the following columns:
-- Employee Number, First Name and Last Name, Age, and Seniority.

SELECT EMPLOYEE_int, FIRST_NAME, LAST_NAME,
CASE WHEN LOWER(title) = 'mr.' THEN 'Male'
WHEN LOWER(title) IN ('miss', 'mrs.') THEN 'Female'
WHEN LOWER(title) = 'dr.' THEN 'Unknown'
ELSE 'Unknown' END AS Gender,
DATEDIFF(YEAR, BIRTH_DATE, GETDATE()) 
- CASE 
WHEN MONTH(BIRTH_DATE) > MONTH(GETDATE()) 
OR (MONTH(BIRTH_DATE) = MONTH(GETDATE()) AND DAY(BIRTH_DATE) > DAY(GETDATE())) 
THEN 1 ELSE 0 END AS Age,
DATEDIFF(YEAR, hire_date, GETDATE()) 
- CASE WHEN MONTH(hire_date) > MONTH(GETDATE()) 
OR (MONTH(hire_date) = MONTH(GETDATE()) AND DAY(hire_date) > DAY(GETDATE()))
THEN 1 ELSE 0 END AS SENIORITY,
SUM(CASE WHEN (salary + commission) >= 8000 THEN 1 ELSE 0 END) as Net_Salary
FROM EMPLOYEES 
WHERE LOWER(title) = 'mr.'
GROUP BY EMPLOYEE_int, FIRST_NAME, LAST_NAME, TITLE, BIRTH_DATE, HIRE_DATE
ORDER BY SENIORITY DESC;

-- 4. Display products that meet the following criteria: (C1) quantity is packaged in bottle(s),
-- (C2) the third character in the product name is 't' or 'T', 
-- (C3) supplied by suppliers 1, 2, or 3, 
-- (C4) unit price ranges between 70 and 200, 
-- and (C5) units ordered are specified (not null). 
-- The resulting table should include the following columns: 
-- product number, product name, supplier number, units ordered, and unit price.

SELECT p.PRODUCT_REF AS [Product number], p.product_name, 
s.SUPPLIER_int AS [Supplier number], p.QUANTITY,
p.UNITS_ON_ORDER AS [Units Ordered], p.unit_price
FROM PRODUCTS p
INNER JOIN
SUPPLIERS s ON s.SUPPLIER_int = p.SUPPLIER_int
WHERE 
p.QUANTITY LIKE '%bottle%'
AND SUBSTRING(p.product_name, 3, 1) IN ('t', 'T')
OR p.SUPPLIER_int IN (1, 2, 3)
AND p.UNIT_PRICE BETWEEN 70 AND 200
AND p.UNITS_ON_ORDER IS NOT NULL;

-- 5. Display customers who reside in the same region as supplier 1, 
-- meaning they share the same country, city, and the last three digits of the postal code. 
-- The query should utilize a single subquery. The resulting table should include all columns from the customer table.

SELECT * FROM CUSTOMERS
WHERE country = (SELECT country FROM SUPPLIERS WHERE SUPPLIER_int = 1)
AND city = (SELECT city FROM SUPPLIERS WHERE SUPPLIER_int = 1)
AND RIGHT(postal_code, 3) = (
SELECT RIGHT(postal_code, 3) 
FROM SUPPLIERS 
WHERE SUPPLIER_int = 1
);

-- 6. For each order number between 10998 and 11003, do the following: Display the new discount rate, 
-- which should be 0% if the total order amount before discount (unit price * quantity) is between 0 and 2000, 
-- 5% if between 2001 and 10000, 10% if between 10001 and 40000, 15% if between 40001 and 80000, and 20% otherwise.
-- Display the message "apply old discount rate" if the order number is between 10000 and 10999, 
-- and "apply new discount rate" otherwise. The resulting table should display the columns: order number, new discount rate, 
-- and discount rate application note.

SELECT Order_int AS [Order Number],
CASE 
WHEN (UNIT_PRICE * Quantity) BETWEEN 0 AND 2000 THEN '0%'
WHEN (UNIT_PRICE * Quantity) BETWEEN 2001 AND 10000 THEN '5%'
WHEN (UNIT_PRICE * Quantity) BETWEEN 10001 AND 40000 THEN '10%'
WHEN (UNIT_PRICE * Quantity) BETWEEN 40001 AND 80000 THEN '15%'
ELSE '20%'
END AS [New Discount Rate],
CASE 
WHEN ORDER_int BETWEEN 10000 AND 10999 THEN 'apply old discount rate'
ELSE 'apply new discount rate'
END AS [Discount Rate Application Note]
FROM ORDER_DETAILS
WHERE ORDER_int BETWEEN 10998 AND 11003;

-- 7. Display suppliers of beverage products. The resulting table should display the columns: 
-- supplier number, company, address, and phone number.

SELECT
s.SUPPLIER_int AS [Supplier number],
s.COMPANY,
s.ADDRESS,
s.PHONE
FROM SUPPLIERS s
INNER JOIN PRODUCTS p ON s.SUPPLIER_int = p.SUPPLIER_int
INNER JOIN CATEGORIES c ON p.CATEGORY_CODE = c.CATEGORY_CODE
WHERE c.CATEGORY_NAME = 'Beverages';

-- 8. Display customers from Berlin who have ordered at most 1 (0 or 1) dessert product. 
-- The resulting table should display the column: customer code.

SELECT c.CUSTOMER_CODE AS [Customer code]
FROM CUSTOMERS c
LEFT JOIN ORDERS o ON c.CUSTOMER_CODE = o.CUSTOMER_CODE
LEFT JOIN ORDER_DETAILS od ON o.ORDER_int = od.ORDER_int
LEFT JOIN PRODUCTS p ON od.PRODUCT_REF = p.PRODUCT_REF
LEFT JOIN CATEGORIES cat ON p.CATEGORY_CODE = cat.CATEGORY_CODE
WHERE c.city = 'Berlin'
GROUP BY c.CUSTOMER_CODE
HAVING COUNT(CASE WHEN cat.category_name = 'Dessert' THEN 1 END) <= 1;

-- 9. Display customers who reside in France and the total amount of orders they placed every Monday in April 1998 
-- (considering customers who haven't placed any orders yet). The resulting table should display the columns: 
-- customer number, company name, phone number, total amount, and country.

SELECT c.CUSTOMER_CODE AS [CUSTOMER NUMBER], c.COMPANY, c.PHONE,
ISNULL(SUM(od.unit_price * od.quantity), 0) AS [TOTAL AMOUNT], c.COUNTRY
FROM CUSTOMERS c
LEFT JOIN ORDERS o ON c.CUSTOMER_CODE = o.CUSTOMER_CODE
LEFT JOIN ORDER_DETAILS od ON o.ORDER_int = od.ORDER_int
WHERE c.country = 'France'
AND (o.order_date IS NULL
OR (MONTH(o.order_date) = 4 
AND YEAR(o.order_date) = 1998 
AND DATENAME(WEEKDAY, o.order_date) = 'Monday')
)
GROUP BY c.CUSTOMER_CODE, c.COMPANY, c.PHONE, c.COUNTRY;

-- 10. Display customers who have ordered all products. The resulting table should display the columns: 
-- customer code, company name, and telephone number.

SELECT  c.CUSTOMER_CODE, c.COMPANY AS [COMPANY NAME], c.PHONE AS [TELEPHONE NUMBER]
FROM  CUSTOMERS c
INNER JOIN  ORDERS o ON c.CUSTOMER_CODE = o.CUSTOMER_CODE
INNER JOIN  ORDER_DETAILS od ON o.ORDER_int = od.ORDER_int
GROUP BY c.CUSTOMER_CODE, c.COMPANY, c.PHONE
HAVING COUNT(DISTINCT od.PRODUCT_REF) >= (SELECT COUNT(*) FROM PRODUCTS);

 -- 11. Display for each customer from France the number of orders they have placed. 
 -- The resulting table should display the columns: customer code and number of orders.

SELECT c.CUSTOMER_CODE, COUNT(o.ORDER_int) AS [NUMBER OF ORDERS]
FROM CUSTOMERS c
LEFT JOIN ORDERS o ON c.CUSTOMER_CODE = o.CUSTOMER_CODE
WHERE c.COUNTRY = 'France'
GROUP BY c.CUSTOMER_CODE;

-- 12. Display the number of orders placed in 1996, the number of orders placed in 1997, 
-- and the difference between these two numbers. The resulting table should display the columns: 
-- orders in 1996, orders in 1997, and Difference.

SELECT 
COUNT(CASE WHEN YEAR(order_date) = 1996 THEN 1 END) AS [Orders in 1996],
COUNT(CASE WHEN YEAR(order_date) = 1997 THEN 1 END) AS [Orders in 1997],
COUNT(CASE WHEN YEAR(order_date) = 1997 THEN 1 END) - 
COUNT(CASE WHEN YEAR(order_date) = 1996 THEN 1 END) AS [Difference]
FROM ORDERS;