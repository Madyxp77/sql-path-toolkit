-- Chapter 5: Connecting the Dots – JOINS

-- Scenario: Show me the names of customers and the IDs of the orders they placed.
SELECT
    C.first_name,
    C.last_name,
    O.order_id,
    O.order_date
FROM CUSTOMERS AS C -- We use AS C for aliasing, making the query shorter and clearer
INNER JOIN ORDERS AS O
    ON C.customer_id = O.customer_id;

-- Scenario: List all customers and any orders they have placed.
-- If a customer hasn't placed an order, I still want to see their name.
SELECT
    C.first_name,
    C.last_name,
    O.order_id,
    O.order_date
FROM CUSTOMERS AS C
LEFT JOIN ORDERS AS O
    ON C.customer_id = O.customer_id;

-- Scenario: Show me all orders and the customer details if available.
-- (This is less common. Usually you'd swap tables for a LEFT JOIN.)
SELECT
    C.first_name,
    C.last_name,
    O.order_id,
    O.order_date
FROM ORDERS AS O -- ORDERS is now the "left" table conceptually for the RIGHT JOIN
RIGHT JOIN CUSTOMERS AS C -- CUSTOMERS is now the "right" table
    ON O.customer_id = C.customer_id;

-- Scenario: Show me all customers and all orders, even if they don't have a match in the other table.
-- Note: FULL OUTER JOIN support varies by database. MySQL versions before 8.0.14 do not support it directly.
-- For MySQL, you would typically simulate it with UNION of LEFT JOIN and RIGHT JOIN.
SELECT
    C.first_name,
    C.last_name,
    O.order_id,
    O.order_date
FROM CUSTOMERS AS C
FULL OUTER JOIN ORDERS AS O
    ON C.customer_id = O.customer_id;

-- Scenario: I want to see customer names, the products they ordered, and the price of those products for each order.
SELECT
    C.first_name,
    C.last_name,
    P.product_name,
    P.price,
    O.quantity,
    O.order_date
FROM CUSTOMERS AS C
INNER JOIN ORDERS AS O
    ON C.customer_id = O.customer_id -- First join: Customers to Orders
INNER JOIN PRODUCTS AS P
    ON O.product_id = P.product_id; -- Second join: Orders to Products

-- Exercise 5.1: Order Details with Product Categories (Solution)
-- Objective: List the order_id, product_name, and category for all orders.
SELECT
    O.order_id,
    P.product_name,
    P.category
FROM ORDERS AS O
INNER JOIN PRODUCTS AS P
    ON O.product_id = P.product_id;

-- Exercise 5.2: Customer Purchase History (Solution)
-- Objective: Find the first_name and last_name of customers, along with the product_name of everything they've ever ordered.
SELECT
    C.first_name,
    C.last_name,
    P.product_name
FROM CUSTOMERS AS C
INNER JOIN ORDERS AS O
    ON C.customer_id = O.customer_id
INNER JOIN PRODUCTS AS P
    ON O.product_id = P.product_id;

-- Exercise 5.3: Unengaged Customers (Solution)
-- Objective: Identify any customers who have not placed an order. Show their first_name and last_name.
SELECT
    C.first_name,
    C.last_name
FROM CUSTOMERS AS C
LEFT JOIN ORDERS AS O
    ON C.customer_id = O.customer_id
WHERE O.order_id IS NULL;

-- Exercise 5.4: Order Line Item Cost (Solution)
-- Objective: For each order, show the customer_id, product_name, quantity,
-- and the total_cost for that line item (quantity multiplied by price).
SELECT
    O.customer_id,
    P.product_name,
    O.quantity,
    (O.quantity * P.price) AS total_line_item_cost
FROM ORDERS AS O
INNER JOIN PRODUCTS AS P
    ON O.product_id = P.product_id;