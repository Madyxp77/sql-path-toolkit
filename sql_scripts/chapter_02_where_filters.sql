-- Chapter 2: Precision Power – Filtering Data with WHERE

-- Scenario: Retrieve all customer details for customers located in the 'USA'.
SELECT *
FROM CUSTOMERS
WHERE country = 'USA';

-- Scenario: Find all products that are more expensive than $100.
SELECT
    product_name,
    price
FROM PRODUCTS
WHERE price > 100;

-- Scenario: Show orders for 'Laptop' (product_id 1001) that had a quantity greater than 1.
SELECT *
FROM ORDERS
WHERE product_id = 1001 AND quantity > 1;

-- Scenario: Find customers from either the USA or Canada.
SELECT
    first_name,
    last_name,
    country
FROM CUSTOMERS
WHERE country = 'USA' OR country = 'Canada';

-- Scenario: Show all products that are not in the 'Electronics' category.
SELECT
    product_name,
    category
FROM PRODUCTS
WHERE NOT category = 'Electronics';
-- Alternative using != or <>:
-- WHERE category != 'Electronics';
-- WHERE category <> 'Electronics';

-- Scenario: List all products that are either 'Electronics' or 'Furniture'.
SELECT
    product_name,
    category
FROM PRODUCTS
WHERE category IN ('Electronics', 'Furniture');

-- Scenario: Show me orders placed in February 2023.
SELECT *
FROM ORDERS
WHERE order_date BETWEEN '2023-02-01' AND '2023-02-28';

-- Scenario: Find all products whose names start with 'M'.
SELECT product_name
FROM PRODUCTS
WHERE product_name LIKE 'M%';

-- Scenario: Find products whose names contain 'board'.
SELECT product_name
FROM PRODUCTS
WHERE product_name LIKE '%board%';

-- Scenario: Hypothetically, find customers without a signup date.
SELECT customer_id, first_name
FROM CUSTOMERS
WHERE signup_date IS NULL;

-- Scenario: Hypothetically, find orders that do have a delivery status.
-- (Assumes a 'delivery_status' column in ORDERS table)
-- SELECT order_id, delivery_status
-- FROM ORDERS
-- WHERE delivery_status IS NOT NULL;

-- Exercise 2.1: Recent Sign-ups (Solution)
-- Objective: Find all customers who signed up after '2023-02-01'.
SELECT *
FROM CUSTOMERS
WHERE signup_date > '2023-02-01';

-- Exercise 2.2: Specific Electronics Inventory (Solution)
-- Objective: List all products that are 'Electronics' AND cost less than $100.
SELECT
    product_name,
    price,
    category
FROM PRODUCTS
WHERE category = 'Electronics' AND price < 100;

-- Exercise 2.3: VIP Order Tracking (Solution)
-- Objective: Show orders placed by customer_id 1 OR 3.
SELECT *
FROM ORDERS
WHERE customer_id IN (1, 3);
-- Alternative using OR:
-- WHERE customer_id = 1 OR customer_id = 3;

-- Exercise 2.4: Furniture Product Search (Solution)
-- Objective: Find all products whose names contain the word 'Desk'.
SELECT product_name
FROM PRODUCTS
WHERE product_name LIKE '%Desk%';
-- For case-insensitivity (varies by database):
-- For MySQL: WHERE product_name LIKE '%desk%'; (often case-insensitive by default depending on collation)
-- For PostgreSQL: WHERE LOWER(product_name) LIKE '%desk%';
-- For SQL Server: WHERE product_name LIKE '%Desk%'; (often case-insensitive by default depending on collation)