-- Chapter 7: Breaking Down Complexity – Common Table Expressions (WITH CTEs)

-- Scenario: Calculate the total cost for each line item in an order.
WITH OrderLineItemCosts AS (
    SELECT
        O.order_id,
        O.customer_id,
        O.quantity,
        P.price,
        (O.quantity * P.price) AS line_item_total
    FROM ORDERS AS O
    INNER JOIN PRODUCTS AS P ON O.product_id = P.product_id
)
SELECT *
FROM OrderLineItemCosts;

-- Scenario: Identify the top 3 customers by total spending and their order count.
WITH OrderLineItemCosts AS (
    -- Step 1: Calculate the total cost for each individual order line item
    SELECT
        O.order_id,
        O.customer_id,
        O.quantity,
        P.price,
        (O.quantity * P.price) AS line_item_total
    FROM ORDERS AS O
    INNER JOIN PRODUCTS AS P ON O.product_id = P.product_id
),
CustomerSpending AS (
    -- Step 2: Sum up line item costs to get total spending per customer
    -- This CTE references the previous OrderLineItemCosts CTE
    SELECT
        customer_id,
        SUM(line_item_total) AS total_spent,
        COUNT(DISTINCT order_id) AS total_orders -- Count distinct orders per customer
    FROM OrderLineItemCosts
    GROUP BY customer_id
),
CustomerDetailsWithSpending AS (
    -- Step 3: Join customer names to their spending and order counts
    -- This CTE references CustomerSpending and CUSTOMERS tables
    SELECT
        C.first_name,
        C.last_name,
        CS.total_spent,
        CS.total_orders
    FROM CUSTOMERS AS C
    INNER JOIN CustomerSpending AS CS ON C.customer_id = CS.customer_id
)
-- Final Step: Select the top 3, ordered by total spending
SELECT
    first_name,
    last_name,
    total_spent,
    total_orders
FROM CustomerDetailsWithSpending
ORDER BY total_spent DESC
LIMIT 3; -- For MySQL/PostgreSQL. Use TOP 3 for SQL Server: SELECT TOP 3 ... FROM ... ORDER BY ...;

-- Exercise 7.1: Monthly Revenue Analysis (Solution)
-- Objective: Calculate the total_revenue for each month (e.g., '2023-01', '2023-02', etc.).
WITH OrderRevenue AS (
    SELECT
        order_id,
        -- Calculate revenue per line item. A scalar subquery is used here to get price for each product.
        -- For better performance, this could also be done with a JOIN inside the CTE if order details were also needed.
        (quantity * (SELECT price FROM PRODUCTS WHERE product_id = O.product_id)) AS revenue_per_line_item,
        order_date
    FROM ORDERS AS O
)
SELECT
    -- Date formatting function varies by SQL dialect.
    -- MySQL: DATE_FORMAT(order_date, '%Y-%m')
    -- PostgreSQL: TO_CHAR(order_date, 'YYYY-MM')
    -- SQL Server: FORMAT(order_date, 'yyyy-MM')
    -- SQLite: STRFTIME('%Y-%m', order_date)
    DATE_FORMAT(order_date, '%Y-%m') AS sale_month, -- Assuming MySQL-like DATE_FORMAT
    SUM(revenue_per_line_item) AS total_monthly_revenue
FROM OrderRevenue
GROUP BY sale_month
ORDER BY sale_month ASC;

-- Exercise 7.2: Customers Who Spent Above Average (Solution)
-- Objective: List the first_name, last_name, and total_spent for all customers
-- whose total_spent is greater than the overall average total spent by all customers.
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
    first_name,
    last_name,
    total_spent
FROM CustomerTotalSpending
WHERE total_spent > (SELECT AVG(total_spent) FROM CustomerTotalSpending);

-- Exercise 7.3: Top Product Per Category (Solution)
-- Objective: For each category, list the product_name and price of the most expensive product within that category.
-- If there are ties in price, any one of them is fine.
WITH MaxPricePerCategory AS (
    SELECT
        category,
        MAX(price) AS max_price
    FROM PRODUCTS
    GROUP BY category
)
SELECT
    P.category,
    P.product_name,
    P.price
FROM PRODUCTS AS P
INNER JOIN MaxPricePerCategory AS MPC
    ON P.category = MPC.category AND P.price = MPC.max_price;