-- Chapter 3: Order in the Data – Sorting Your Results with ORDER BY

-- Scenario: List all customers, ordered by their signup_date from oldest to newest.
SELECT
    first_name,
    last_name,
    signup_date
FROM CUSTOMERS
ORDER BY signup_date ASC; -- 'ASC' is optional here as it's the default

-- Scenario: List all products from the most expensive to the least expensive.
SELECT
    product_name,
    price
FROM PRODUCTS
ORDER BY price DESC;

-- Scenario: Show all orders, first sorted by the customer who placed them,
-- and then by the date of the order, with the newest order first for each customer.
SELECT
    order_id,
    customer_id,
    order_date,
    quantity
FROM ORDERS
ORDER BY
    customer_id ASC,  -- First, sort by customer ID (lowest to highest)
    order_date DESC;   -- Then, for customers with the same ID, sort by order date (newest to oldest)

-- Exercise 3.1: Oldest Customers First (Solution)
-- Objective: List all customers, ordered by their signup_date from oldest to newest.
SELECT
    first_name,
    last_name,
    signup_date
FROM CUSTOMERS
ORDER BY signup_date ASC;

-- Exercise 3.2: Product Catalog Review (Solution)
-- Objective: Show product_name, category, and price for all products,
-- sorted first by category (A-Z) and then by price (highest to lowest within each category).
SELECT
    product_name,
    category,
    price
FROM PRODUCTS
ORDER BY
    category ASC,
    price DESC;

-- Exercise 3.3: Order Quantity Analysis (Solution)
-- Objective: Retrieve the order_id and quantity for all orders,
-- sorted by quantity in descending order, and then by order_date in ascending order.
SELECT
    order_id,
    quantity,
    order_date
FROM ORDERS
ORDER BY
    quantity DESC,
    order_date ASC;