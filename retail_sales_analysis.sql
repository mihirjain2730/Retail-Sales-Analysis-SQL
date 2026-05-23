-- Retail Sales Analysis using SQL
-- Project: Retail Sales Data Analysis

CREATE DATABASE retail_sales_db;

DROP TABLE IF EXISTS retail_sales;

CREATE TABLE retail_sales (
    transaction_id INT PRIMARY KEY,
    sale_date DATE,
    sale_time TIME,
    customer_id INT,
    gender VARCHAR(15),
    age INT,
    category VARCHAR(20),
    quantity INT,
    price_per_unit NUMERIC(10,2),
    cogs NUMERIC(10,2),
    total_sale NUMERIC(10,2)
);

-- Preview Data
SELECT *
FROM retail_sales
LIMIT 10;

-- Total Records
SELECT COUNT(*) AS total_records
FROM retail_sales;

-- Data Cleaning: Check Null Values
SELECT *
FROM retail_sales
WHERE 
    transaction_id IS NULL
    OR sale_date IS NULL
    OR sale_time IS NULL
    OR customer_id IS NULL
    OR gender IS NULL
    OR age IS NULL
    OR category IS NULL
    OR quantity IS NULL
    OR price_per_unit IS NULL
    OR cogs IS NULL
    OR total_sale IS NULL;

-- Delete Null Records
DELETE FROM retail_sales
WHERE 
    transaction_id IS NULL
    OR sale_date IS NULL
    OR sale_time IS NULL
    OR customer_id IS NULL
    OR gender IS NULL
    OR age IS NULL
    OR category IS NULL
    OR quantity IS NULL
    OR price_per_unit IS NULL
    OR cogs IS NULL
    OR total_sale IS NULL;

-- Total Sales Records
SELECT COUNT(*) AS total_sales_records
FROM retail_sales;

-- Unique Customers
SELECT COUNT(DISTINCT customer_id) AS unique_customers
FROM retail_sales;

-- Product Categories
SELECT DISTINCT category
FROM retail_sales;

-- Sales made on 2022-11-05
SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';

-- Clothing transactions in Nov 2022 with quantity 4 or more
SELECT *
FROM retail_sales
WHERE 
    category = 'Clothing'
    AND TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
    AND quantity >= 4;

-- Total sales by category
SELECT 
    category,
    SUM(total_sale) AS net_sales,
    COUNT(*) AS total_orders
FROM retail_sales
GROUP BY category
ORDER BY net_sales DESC;

-- Average age of customers buying Beauty products
SELECT
    ROUND(AVG(age), 2) AS average_customer_age
FROM retail_sales
WHERE category = 'Beauty';

-- High-value transactions
SELECT *
FROM retail_sales
WHERE total_sale > 1000;

-- Transactions by gender and category
SELECT 
    category,
    gender,
    COUNT(transaction_id) AS total_transactions
FROM retail_sales
GROUP BY category, gender
ORDER BY category, gender;

-- Best-selling month in each year based on average sale
SELECT 
    sales_year,
    sales_month,
    average_sale
FROM (
    SELECT 
        EXTRACT(YEAR FROM sale_date) AS sales_year,
        EXTRACT(MONTH FROM sale_date) AS sales_month,
        ROUND(AVG(total_sale), 2) AS average_sale,
        RANK() OVER (
            PARTITION BY EXTRACT(YEAR FROM sale_date)
            ORDER BY AVG(total_sale) DESC
        ) AS month_rank
    FROM retail_sales
    GROUP BY sales_year, sales_month
) ranked_months
WHERE month_rank = 1;

-- Top 5 customers by total sales
SELECT 
    customer_id,
    SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY customer_id
ORDER BY total_sales DESC
LIMIT 5;

-- Unique customers by category
SELECT 
    category,
    COUNT(DISTINCT customer_id) AS unique_customers
FROM retail_sales
GROUP BY category
ORDER BY unique_customers DESC;

-- Orders by shift
WITH sales_shift AS (
    SELECT 
        *,
        CASE
            WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
            WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
            ELSE 'Evening'
        END AS shift
    FROM retail_sales
)
SELECT 
    shift,
    COUNT(*) AS total_orders
FROM sales_shift
GROUP BY shift
ORDER BY total_orders DESC;