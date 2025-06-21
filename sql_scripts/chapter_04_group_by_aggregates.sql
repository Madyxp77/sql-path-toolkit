-- Chapter 4: The Power of Summaries – GROUP BY and Aggregate Functions

-- Scenario: How many products does Databites sell in total?
SELECT COUNT(*) AS total_products
FROM PRODUCTS;

-- Scenario: What is the most expensive product Databites sells?
SELECT MAX(price) AS highest_price
FROM PRODUCTS;

-- Scenario: Count the number of customers per country.
SELECT
    country,
    COUNT(customer_id) AS total_customers
FROM CUSTOMERS
GROUP BY country;

-- Scenario: What's the average price of products in each category?
SELECT
    category,
    AVG(price) AS average_price
FROM PRODUCTS
GROUP BY category;

-- Scenario: Calculate the total quantity ordered for each specific product.
SELECT
    product_id,
    SUM(quantity) AS total_quantity_ordered
FROM ORDERS
GROUP BY product_id;

-- Scenario: Which product categories have an average price greater than $100?
SELECT
    category,
    AVG(price) AS average_price
FROM PRODUCTS
GROUP BY category
HAVING AVG(price) > 100;

-- Exercise 4.1: Customer Order Counts (Solution)
-- Objective: Calculate the total number of orders placed by each customer.
SELECT
    customer_id,
    COUNT(order_id) AS total_orders
FROM ORDERS
GROUP BY customer_id;

-- Exercise 4.2: Category Pricing Overview (Solution)
-- Objective: Find the maximum price for products in each category.
SELECT
    category,
    MAX(price) AS max_price_in_category
FROM PRODUCTS
GROUP BY category;

-- Exercise 4.3: Popular Categories Identification (Solution)
-- Objective: Determine which categories have more than 2 products.
SELECT
    category,
    COUNT(product_id) AS num_products
FROM PRODUCTS
GROUP BY category
HAVING COUNT(product_id) > 2;

-- Exercise 4.4: Laptop Sales Quantity (Solution)
-- Objective: Calculate the total quantity sold for product_id 1001.
SELECT SUM(quantity) AS total_laptops_sold
FROM ORDERS
WHERE product_id = 1001;