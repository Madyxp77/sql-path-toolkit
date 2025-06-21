-- Chapter 6: Queries Within Queries – Subqueries

-- Scenario: Find all customers who have ordered a 'Laptop' (product_id 1001).
SELECT
    first_name,
    last_name
FROM CUSTOMERS
WHERE customer_id IN (SELECT customer_id
                      FROM ORDERS
                      WHERE product_id = 1001);

-- Scenario: Find customers who have never ordered a 'Laptop' (product_id 1001).
SELECT
    first_name,
    last_name
FROM CUSTOMERS
WHERE customer_id NOT IN (SELECT customer_id
                          FROM ORDERS
                          WHERE product_id = 1001);

-- Scenario: Find the average quantity ordered for each customer,
-- but only for customers who placed at least 2 orders. (Alternative using a subquery in FROM)
SELECT
    T.customer_id,
    AVG(T.quantity) AS avg_order_quantity
FROM (
    SELECT
        customer_id,
        order_id,
        quantity
    FROM ORDERS
    WHERE customer_id IN (SELECT customer_id FROM ORDERS GROUP BY customer_id HAVING COUNT(order_id) >= 2)
) AS T -- The result of the subquery is now a temporary table named 'T'
GROUP BY T.customer_id;

-- Scenario: For each product, show its name and the number of orders it has appeared in.
SELECT
    product_name,
    (SELECT COUNT(order_id) FROM ORDERS WHERE ORDERS.product_id = PRODUCTS.product_id) AS num_orders_placed
FROM PRODUCTS;

-- Exercise 6.1: Customers Who Ordered Expensive Products (Solution)
-- Objective: List the first_name and last_name of customers who have placed an order for a product with a price > $300.
SELECT
    C.first_name,
    C.last_name
FROM CUSTOMERS AS C
WHERE C.customer_id IN (
    SELECT O.customer_id
    FROM ORDERS AS O
    INNER JOIN PRODUCTS AS P ON O.product_id = P.product_id
    WHERE P.price > 300
);

-- Exercise 6.2: Products Not Yet Ordered (Solution)
-- Objective: List the product_name and category of products that have no entries in the ORDERS table.
SELECT
    product_name,
    category
FROM PRODUCTS
WHERE product_id NOT IN (SELECT DISTINCT product_id FROM ORDERS);

-- Exercise 6.3: Customers with Multiple Orders (using a derived table) (Solution)
-- Objective: Select the customer_id, order_id, and order_date for all orders
-- placed by customers who have placed a total of more than one order.
SELECT
    O.customer_id,
    O.order_id,
    O.order_date
FROM ORDERS AS O
INNER JOIN (
    SELECT customer_id
    FROM ORDERS
    GROUP BY customer_id
    HAVING COUNT(order_id) > 1
) AS MultiOrderCustomers
ON O.customer_id = MultiOrderCustomers.customer_id;

-- Exercise 6.4: Customer Order Summary (Scalar Subquery) (Solution)
-- Objective: For each customer, show first_name, last_name, and a calculated column
-- total_orders_count that shows how many orders each specific customer has made.
SELECT
    C.first_name,
    C.last_name,
    (SELECT COUNT(O.order_id) FROM ORDERS AS O WHERE O.customer_id = C.customer_id) AS total_orders_count
FROM CUSTOMERS AS C;