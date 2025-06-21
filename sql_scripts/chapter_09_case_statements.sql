-- Chapter 9: Dynamic Logic – CASE Statements

-- Scenario: Categorize products by price segment.
SELECT
    product_name,
    price,
    CASE
        WHEN price < 100 THEN 'Budget'
        WHEN price BETWEEN 100 AND 500 THEN 'Mid-Range'
        WHEN price > 500 THEN 'Premium'
        ELSE 'Uncategorized' -- Good practice to include an ELSE
    END AS price_segment
FROM PRODUCTS;

-- Scenario: Count how many orders were placed in Q1 (January-March), Q2 (April-June), etc.
SELECT
    CASE
        WHEN order_date BETWEEN '2023-01-01' AND '2023-03-31' THEN 'Q1 2023'
        WHEN order_date BETWEEN '2023-04-01' AND '2023-06-30' THEN 'Q2 2023'
        -- Add more quarters as needed
        ELSE 'Other'
    END AS sales_quarter,
    COUNT(order_id) AS total_orders
FROM ORDERS
GROUP BY sales_quarter
ORDER BY sales_quarter;

-- Scenario: Calculate the total revenue from 'Electronics' products versus 'Furniture' products.
SELECT
    SUM(CASE WHEN P.category = 'Electronics' THEN O.quantity * P.price ELSE 0 END) AS total_electronics_revenue,
    SUM(CASE WHEN P.category = 'Furniture' THEN O.quantity * P.price ELSE 0 END) AS total_furniture_revenue
FROM ORDERS AS O
INNER JOIN PRODUCTS AS P ON O.product_id = P.product_id;

-- Exercise 9.1: Customer Loyalty Segment (Solution)
-- Objective: List customer_id, first_name, last_name, and their loyalty_segment.
SELECT
    C.customer_id,
    C.first_name,
    C.last_name,
    CASE
        WHEN COUNT(O.order_id) = 1 THEN 'New'
        WHEN COUNT(O.order_id) BETWEEN 2 AND 3 THEN 'Loyal'
        WHEN COUNT(O.order_id) >= 4 THEN 'VIP'
        ELSE 'No Orders' -- For customers with 0 orders (due to LEFT JOIN)
    END AS loyalty_segment
FROM CUSTOMERS AS C
LEFT JOIN ORDERS AS O ON C.customer_id = O.customer_id
GROUP BY C.customer_id, C.first_name, C.last_name
ORDER BY C.customer_id;

-- Exercise 9.2: Product Performance Rating (Solution)
-- Objective: List product_name, category, total_quantity_sold, and sales_performance_rating.
SELECT
    P.product_name,
    P.category,
    SUM(O.quantity) AS total_quantity_sold,
    CASE
        WHEN SUM(O.quantity) IS NULL THEN 'No Sales Data' -- Handle products not in orders (due to LEFT JOIN)
        WHEN SUM(O.quantity) < 3 THEN 'Low Sales'
        WHEN SUM(O.quantity) BETWEEN 3 AND 5 THEN 'Medium Sales'
        WHEN SUM(O.quantity) > 5 THEN 'High Sales'
    END AS sales_performance_rating
FROM PRODUCTS AS P
LEFT JOIN ORDERS AS O ON P.product_id = O.product_id
GROUP BY P.product_id, P.product_name, P.category
ORDER BY total_quantity_sold DESC;

-- Exercise 9.3: Order Value Category (Solution)
-- Objective: List order_id, customer_id, order_date, total_order_value, and order_value_category.
WITH OrderValue AS (
    SELECT
        O.order_id,
        O.customer_id,
        O.order_date,
        SUM(O.quantity * P.price) AS total_order_value
    FROM ORDERS AS O
    INNER JOIN PRODUCTS AS P ON O.product_id = P.product_id
    GROUP BY O.order_id, O.customer_id, O.order_date
)
SELECT
    order_id,
    customer_id,
    order_date,
    total_order_value,
    CASE
        WHEN total_order_value < 200 THEN 'Small'
        WHEN total_order_value BETWEEN 200 AND 500 THEN 'Medium'
        WHEN total_order_value > 500 THEN 'Large'
        ELSE 'Unknown' -- Should not happen with current data, but good for completeness
    END AS order_value_category
FROM OrderValue
ORDER BY order_id;
