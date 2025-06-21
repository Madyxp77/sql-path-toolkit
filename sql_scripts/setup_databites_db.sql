-- Databites E-commerce Database Setup Script
-- This script creates the CUSTOMERS, ORDERS, and PRODUCTS tables
-- and populates them with sample data as described in "The SQL Path" book.
--
-- Designed for MySQL/PostgreSQL compatibility.
-- For SQL Server, some data types or syntax might need minor adjustments.

-- Drop tables if they already exist to ensure a clean setup
DROP TABLE IF EXISTS ORDERS;
DROP TABLE IF EXISTS PRODUCTS;
DROP TABLE IF EXISTS CUSTOMERS;

-- 1. Create CUSTOMERS Table
CREATE TABLE CUSTOMERS (
    customer_id INT PRIMARY KEY,
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    country VARCHAR(255) NOT NULL,
    signup_date DATE NOT NULL
);

-- 2. Create PRODUCTS Table
CREATE TABLE PRODUCTS (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(255) NOT NULL,
    category VARCHAR(255) NOT NULL,
    price DECIMAL(10, 2) NOT NULL
);

-- 3. Create ORDERS Table
CREATE TABLE ORDERS (
    order_id INT PRIMARY KEY,
    customer_id INT NOT NULL,
    product_id INT NOT NULL,
    order_date DATE NOT NULL,
    quantity INT NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES CUSTOMERS(customer_id),
    FOREIGN KEY (product_id) REFERENCES PRODUCTS(product_id)
);

-- Insert Sample Data into CUSTOMERS
INSERT INTO CUSTOMERS (customer_id, first_name, last_name, country, signup_date) VALUES
(1, 'Alice', 'Smith', 'USA', '2023-01-10'),
(2, 'Bob', 'Johnson', 'Canada', '2023-01-15'),
(3, 'Carol', 'Williams', 'USA', '2023-02-01'),
(4, 'David', 'Brown', 'UK', '2023-02-05'),
(5, 'Eve', 'Davis', 'USA', '2023-03-10'),
(6, 'Frank', 'Miller', 'Canada', '2023-03-12'),
(7, 'Grace', 'Wilson', 'Germany', '2023-04-01');

-- Insert Sample Data into PRODUCTS
INSERT INTO PRODUCTS (product_id, product_name, category, price) VALUES
(1001, 'Laptop', 'Electronics', 1200.00),
(1002, 'Mouse', 'Electronics', 25.00),
(1003, 'Keyboard', 'Electronics', 75.00),
(1004, 'Desk Chair', 'Furniture', 250.00),
(1005, 'Monitor', 'Electronics', 300.00),
(1006, 'Standing Desk', 'Furniture', 450.00);

-- Insert Sample Data into ORDERS
INSERT INTO ORDERS (order_id, customer_id, product_id, order_date, quantity) VALUES
(101, 1, 1001, '2023-01-12', 2),
(102, 3, 1003, '2023-02-03', 1),
(103, 1, 1002, '2023-02-15', 1),
(104, 2, 1001, '2023-02-20', 3),
(105, 4, 1004, '2023-03-01', 1),
(106, 3, 1001, '2023-03-05', 1),
(107, 5, 1002, '2023-03-15', 2),
(108, 1, 1005, '2023-04-01', 1),
(109, 6, 1003, '2023-04-05', 1),
(110, 7, 1004, '2023-04-10', 2);
