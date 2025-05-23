CREATE DATABASE IF NOT EXISTS nike_analytics_db;

USE nike_analytics_db;

CREATE TABLE customers (
    customer_id INT,
    name VARCHAR(50),
    segment VARCHAR(20),
    location VARCHAR(50),
    created_at DATE
);

CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(50),
    category VARCHAR(20),
    price DECIMAL(10,2),
    launch_date DATE
);

CREATE TABLE sales_transactions (
    transaction_id INT PRIMARY KEY,
    customer_id INT,
    product_id INT,
    quantity INT,
    total_amount DECIMAL(10,2),
    sales_channel VARCHAR(20),
    transaction_date DATE
);

CREATE TABLE campaigns (
    campaign_id INT PRIMARY KEY,
    product_id INT,
    channel VARCHAR(20),
    spend DECIMAL(10,2),
    impressions INT,
    conversions INT,
    start_date DATE,
    end_date DATE,
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

--  Sales by Product  --

SELECT p.product_name, round(SUM(s.total_amount),2) AS product_revenue
FROM sales_transactions s
JOIN products p ON s.product_id = p.product_id
GROUP BY p.product_name
ORDER BY product_revenue DESC
LIMIT 10;

--  Monthly Sales Trend  -- 

SELECT DATE_FORMAT(transaction_date, '%Y-%m') AS month, 
       round(SUM(total_amount),2 )AS monthly_sales
FROM sales_transactions
GROUP BY month
ORDER BY month;

--  Campaign Performance Overview --

SELECT channel, 
       ROUND(AVG(spend), 2) AS avg_spend, 
       ROUND(AVG(impressions), 0) AS avg_impressions,
       ROUND(AVG(conversions), 0) AS avg_conversions
FROM campaigns
GROUP BY channel;

--  Top Products by Revenue and Quantity Sold  --

SELECT 
    p.product_name,
    SUM(s.quantity) AS total_units_sold,
    ROUND(SUM(s.total_amount), 2) AS total_revenue
FROM 
    sales_transactions s
JOIN 
    products p ON s.product_id = p.product_id
GROUP BY 
    p.product_name
ORDER BY 
    total_revenue DESC
LIMIT 10;

--  Customer Segments Driving Highest Sales  --

SELECT 
    c.segment,
    COUNT(DISTINCT s.customer_id) AS unique_customers,
    ROUND(SUM(s.total_amount), 2) AS total_revenue
FROM 
    sales_transactions s
JOIN 
    customers c ON s.customer_id = c.customer_id
GROUP BY 
    c.segment
ORDER BY 
    total_revenue DESC;
    
--  Sales Channel Performance with Average Order Value  --

SELECT 
    sales_channel,
    COUNT(DISTINCT transaction_id) AS total_orders,
    ROUND(SUM(total_amount), 2) AS total_revenue,
    ROUND(AVG(total_amount), 2) AS avg_order_value
FROM 
    sales_transactions
GROUP BY 
    sales_channel
ORDER BY 
    total_revenue DESC;
    
--  Monthly Revenue Trend by Product Category  --

SELECT 
    DATE_FORMAT(s.transaction_date, '%Y-%m') AS month,
    p.category,
    ROUND(SUM(s.total_amount), 2) AS monthly_revenue
FROM 
    sales_transactions s
JOIN 
    products p ON s.product_id = p.product_id
GROUP BY 
    month, p.category
ORDER BY 
    month, monthly_revenue DESC;


