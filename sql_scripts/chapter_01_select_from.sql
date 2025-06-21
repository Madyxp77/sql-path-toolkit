-- Chapter 1: Unlocking the Vault – SELECT and FROM

-- Scenario: Retrieve all details for all products.
SELECT *
FROM PRODUCTS;

-- Scenario: Get just the names and prices of our products.
SELECT
    product_name,
    price
FROM PRODUCTS;

-- Scenario: Show me details for only the first 3 customers.
-- For MySQL/PostgreSQL:
SELECT *
FROM CUSTOMERS
LIMIT 3;

-- For SQL Server:
-- SELECT TOP 3 *
-- FROM CUSTOMERS;

-- Scenario: Identify all the unique countries our customers are from.
SELECT DISTINCT country
FROM CUSTOMERS;

-- Exercise 1.1: Customer Names (Solution)
-- Objective: Retrieve the first_name and last_name of all customers.
SELECT
    first_name,
    last_name
FROM CUSTOMERS;

-- Exercise 1.2: Top Products Quick Look (Solution)
-- Objective: Show all details for the top 2 products.
-- For MySQL/PostgreSQL:
SELECT *
FROM PRODUCTS
LIMIT 2;

-- For SQL Server:
-- SELECT TOP 2 *
-- FROM PRODUCTS;

-- Exercise 1.3: Product Categories Survey (Solution)
-- Objective: List all the unique categories of products we sell.
SELECT DISTINCT category
FROM PRODUCTS;
