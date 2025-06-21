-- Skill Checkpoints Solutions
-- This script contains the solutions to the "Skill Checkpoint" exercises
-- found at the end of each major part of "The SQL Path" book.

-- Skill Checkpoint: Basic Querying Mastery

-- 1. New Customer Report (Solution)
-- Objective: Our marketing team wants a list of the first_name, last_name,
-- and country of all customers who signed up in March 2023. They want this list ordered
-- by signup_date from newest to oldest.
SELECT
    first_name,
    last_name,
    country
FROM CUSTOMERS
WHERE signup_date BETWEEN '2023-03-01' AND '2023-03-31'
ORDER BY signup_date DESC;

-- 2. Expensive Electronics (Solution)
-- Objective: Find the product_name and price of all 'Electronics' products that cost
-- more than $200. Sort them by price from highest to lowest.
SELECT
    product_name,
    price
FROM PRODUCTS
WHERE category = 'Electronics' AND price > 200
ORDER BY price DESC;

-- 3. Specific Order Details (Solution)
-- Objective: Retrieve all details (*) for orders placed by customer_id 1 that had a quantity of 1.
SELECT *
FROM ORDERS
WHERE customer_id = 1 AND quantity = 1;

-- Skill Checkpoint: Aggregation and Joins Expertise

-- 1. Top Selling Categories (Solution)
-- Objective: Find the category and the total_quantity_sold for each product category.
-- Only include categories where the total_quantity_sold is greater than 3.
-- Sort the results by total_quantity_sold in descending order.
SELECT
    P.category,
    SUM(O.quantity) AS total_quantity_sold
FROM ORDERS AS O
INNER JOIN PRODUCTS AS P ON O.product_id = P.product_id
GROUP BY P.category
HAVING SUM(O.quantity) > 3
ORDER BY total_quantity_sold DESC;

-- 2. Customer Order Summary with Product Info (Solution)
-- Objective: For each order, list the customer_id, first_name, last_name, product_name, quantity, and order_date.
-- Sort by customer_id (ascending) then order_date (ascending).
SELECT
    C.customer_id,
    C.first_name,
    C.last_name,
    P.product_name,
    O.quantity,
    O.order_date
FROM CUSTOMERS AS C
INNER JOIN ORDERS AS O ON C.customer_id = O.customer_id
INNER JOIN PRODUCTS AS P ON O.product_id = P.product_id
ORDER BY C.customer_id ASC, O.order_date ASC;

-- 3. Products Purchased by Specific Customer Type (Solution)
-- Objective: List the DISTINCT product_name for products that were purchased by customers
-- from 'Canada' who have made two or more orders.
SELECT DISTINCT P.product_name
FROM PRODUCTS AS P
INNER JOIN ORDERS AS O ON P.product_id = O.product_id
INNER JOIN CUSTOMERS AS C ON O.customer_id = C.customer_id
WHERE C.country = 'Canada'
AND C.customer_id IN (
    SELECT customer_id
    FROM ORDERS
    GROUP BY customer_id
    HAVING COUNT(order_id) >= 2
);

-- Skill Checkpoint: Advanced Techniques Challenge

-- 1. Customer Lifetime Value (Simplified) & Loyalty Tier (Solution)
-- Objective: For each customer, list customer_id, first_name, last_name, total_spent,
-- spending_rank (highest spender = rank 1, use DENSE_RANK()), and a loyalty_tier
-- ('Bronze' if total spent < $500, 'Silver' if $500-$1000, 'Gold' if > $1000).
WITH CustomerTotalSpending AS (
    SELECT
        C.customer_id,
        C.first_name,
        C.last_name,
        SUM(O.quantity * P.price) AS total_spent
    FROM CUSTOMERS AS C
    INNER JOIN ORDERS AS O ON C.customer_id = O.customer_id
    INNER JOIN PRODUCTS AS P ON O.product_id = P.product_id
    GROUP BY C.customer_id, C.first_name, C.last_name
)
SELECT
    CTS.customer_id,
    CTS.first_name,
    CTS.last_name,
    CTS.total_spent,
    DENSE_RANK() OVER (ORDER BY CTS.total_spent DESC) AS spending_rank,
    CASE
        WHEN CTS.total_spent < 500 THEN 'Bronze'
        WHEN CTS.total_spent BETWEEN 500 AND 1000 THEN 'Silver'
        WHEN CTS.total_spent > 1000 THEN 'Gold'
        ELSE 'No Spend' -- For customers with no orders / no spending
    END AS loyalty_tier
FROM CustomerTotalSpending AS CTS
ORDER BY CTS.total_spent DESC;

-- 2. Product Performance by Order Date (Solution)
-- Objective: For each distinct product, for each month it was ordered,
-- show the product_name, the order_month (e.g., '2023-01'), and a
-- running_order_count (which counts orders for that specific product cumulatively over time).
WITH ProductMonthlyOrders AS (
    SELECT
        P.product_id,
        P.product_name,
        -- Date formatting function varies by SQL dialect.
        -- MySQL: DATE_FORMAT(O.order_date, '%Y-%m')
        -- PostgreSQL: TO_CHAR(O.order_date, 'YYYY-MM')
        -- SQL Server: FORMAT(O.order_date, 'yyyy-MM')
        -- SQLite: STRFTIME('%Y-%m', O.order_date)
        DATE_FORMAT(O.order_date, '%Y-%m') AS order_month, -- Assuming MySQL-like DATE_FORMAT
        COUNT(O.order_id) AS monthly_order_count
    FROM ORDERS AS O
    INNER JOIN PRODUCTS AS P ON O.product_id = P.product_id
    GROUP BY P.product_id, P.product_name, order_month
)
SELECT
    product_name,
    order_month,
    monthly_order_count,
    SUM(monthly_order_count) OVER (PARTITION BY product_id ORDER BY order_month ASC) AS running_order_count
FROM ProductMonthlyOrders
ORDER BY product_name, order_month;

-- 3. Categorize Customer Loyalty by Sign-up Month (Revised Objective and Solution)
-- Objective: For each country, count how many customers are 'Recent Signup' (signed up in Feb 2023 or later)
-- and 'Older Signup' (signed up before Feb 2023).
SELECT
    country,
    SUM(CASE WHEN signup_date >= '2023-02-01' THEN 1 ELSE 0 END) AS recent_signups,
    SUM(CASE WHEN signup_date < '2023-02-01' THEN 1 ELSE 0 END) AS older_signups
FROM CUSTOMERS
GROUP BY country
ORDER BY country;
