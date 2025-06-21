-- Chapter 8: Data Comparisons & Rankings – Window Functions

-- Scenario: For each order, show its details and the total quantity for all orders (overall).
SELECT
    order_id,
    customer_id,
    product_id,
    quantity,
    SUM(quantity) OVER () AS overall_total_quantity -- No PARTITION BY, no ORDER BY means sum over entire result set
FROM ORDERS;

-- Scenario: For each order, show its details and the total quantity ordered by that specific customer.
SELECT
    order_id,
    customer_id,
    product_id,
    quantity,
    SUM(quantity) OVER (PARTITION BY customer_id) AS customer_total_quantity
FROM ORDERS;

-- Scenario: For each order, calculate a running total of quantity ordered for that customer, ordered by date.
SELECT
    order_id,
    customer_id,
    order_date,
    quantity,
    SUM(quantity) OVER (PARTITION BY customer_id ORDER BY order_date ASC) AS running_customer_quantity
FROM ORDERS;

-- Scenario: Rank each customer's orders from their first to their last.
SELECT
    order_id,
    customer_id,
    order_date,
    ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY order_date ASC) AS order_rank
FROM ORDERS;

-- Scenario: Rank products by price within each category, showing ties.
SELECT
    product_name,
    category,
    price,
    RANK() OVER (PARTITION BY category ORDER BY price DESC) AS price_rank
FROM PRODUCTS;

-- Scenario: Rank products by price within each category, no skipped ranks.
SELECT
    product_name,
    category,
    price,
    DENSE_RANK() OVER (PARTITION BY category ORDER BY price DESC) AS dense_price_rank
FROM PRODUCTS;

-- Scenario: For each product, calculate its price's percentage contribution to its category's total price.
SELECT
    product_name,
    category,
    price,
    SUM(price) OVER (PARTITION BY category) AS category_total_price,
    (price / SUM(price) OVER (PARTITION BY category)) * 100 AS pct_of_category_price
FROM PRODUCTS;

-- Scenario: For each order, show the order date and the date of the customer's previous order.
-- DATEDIFF function varies by SQL dialect:
-- MySQL: DATEDIFF(current_date, previous_date)
-- PostgreSQL: (current_date - previous_date)
-- SQL Server: DATEDIFF(day, previous_date, current_date)
-- SQLite: JULIANDAY(current_date) - JULIANDAY(previous_date)
SELECT
    order_id,
    customer_id,
    order_date,
    LAG(order_date, 1, '1900-01-01') OVER (PARTITION BY customer_id ORDER BY order_date ASC) AS previous_order_date
FROM ORDERS;

-- Scenario: For each order, show the order date and the date of the customer's next order.
-- Date arithmetic for interval can be done as above with LEAD.
SELECT
    order_id,
    customer_id,
    order_date,
    LEAD(order_date, 1, '2999-12-31') OVER (PARTITION BY customer_id ORDER BY order_date ASC) AS next_order_date
FROM ORDERS;

-- Exercise 8.1: Customer Lifetime Value (Simplified Running Total) (Solution)
-- Objective: For each order, list the customer_id, order_date, product_name, quantity,
-- and a running_total_quantity column that sums quantities for that customer up to the current order date.
SELECT
    O.customer_id,
    O.order_date,
    P.product_name,
    O.quantity,
    SUM(O.quantity) OVER (PARTITION BY O.customer_id ORDER BY O.order_date ASC) AS running_total_quantity
FROM ORDERS AS O
INNER JOIN PRODUCTS AS P ON O.product_id = P.product_id;

-- Exercise 8.2: Product Price Ranking within Categories (Solution)
-- Objective: For all products, list product_name, category, price, and a price_rank_in_category
-- column that ranks products by price (highest price = rank 1) within their respective categories. Use DENSE_RANK().
SELECT
    product_name,
    category,
    price,
    DENSE_RANK() OVER (PARTITION BY category ORDER BY price DESC) AS price_rank_in_category
FROM PRODUCTS;

-- Exercise 8.3: Time Between Orders (Solution)
-- Objective: For each order, list customer_id, order_id, order_date, and a days_since_previous_order column.
-- This column should show the number of days between the current order and the customer's immediate previous order.
-- For a customer's first order, this column should be NULL.
SELECT
    customer_id,
    order_id,
    order_date,
    -- Date difference function varies by SQL dialect.
    -- MySQL: DATEDIFF(order_date, LAG(order_date, 1) OVER (PARTITION BY customer_id ORDER BY order_date ASC))
    -- PostgreSQL: (order_date - LAG(order_date, 1) OVER (PARTITION BY customer_id ORDER BY order_date ASC))
    -- SQL Server: DATEDIFF(day, LAG(order_date, 1) OVER (PARTITION BY customer_id ORDER BY order_date ASC), order_date)
    -- SQLite (Using JULIANDAY for numerical difference):
    JULIANDAY(order_date) - JULIANDAY(LAG(order_date, 1) OVER (PARTITION BY customer_id ORDER BY order_date ASC)) AS days_since_previous_order
FROM ORDERS;