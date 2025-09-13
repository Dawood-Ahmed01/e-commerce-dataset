📊 SQL Project: E-commerce Sales & Customer Insights
📂 Dataset Overview
This project analyzes data from a fictional e-commerce company that sells products across multiple regions. The goal is to understand sales performance, customer behavior, and product demand using SQL.

🗄️ Database Schema
The dataset consists of 4 relational tables:

Table Name	Description	Key Columns
customers	Customer demographics and signup info	customer_id, name, gender, country
products	Product catalog and pricing	product_id, product_name, category, price
orders	Order-level data including region and payment	order_id, customer_id, order_date, region
order_details	Line-item level details for each order	order_id, product_id, quantity, total_amount
🎯 Project Objectives
✅ Clean and explore the dataset

✅ Solve 10 real-world business questions using SQL

✅ Provide insights & interpretations, not just queries

✅ Demonstrate SQL proficiency in:

Joins

Aggregations

Window Functions

CASE statements

Subqueries

🔟 Business Questions, SQL Queries & Insights
Q1. Customer Base Analysis
📌 Business Need: Marketing team wants total customers + breakdown by gender & country.

sql
SELECT country, gender, COUNT(DISTINCT customer_id) AS total_customers
FROM customers
GROUP BY 1, 2;
💡 Insight: Reveals customer distribution (e.g., Male vs Female in Pakistan). Helps target campaigns.

Q2. Monthly Sales Trend
📌 Business Need: Identify sales growth patterns and peak months.

sql
WITH monthly_sale AS (
  SELECT DATE_TRUNC('Month', o.order_date) AS month,
         SUM(od.total_amount) AS total_sales
  FROM orders o
  JOIN order_details od ON od.order_id = o.order_id
  GROUP BY 1
)
SELECT TO_CHAR(month, 'Mon YYYY') AS months, total_sales
FROM monthly_sale
ORDER BY month;
💡 Insight: Reveals seasonal trends. Peak months = high demand seasons.

Q3. Top-Selling Products
📌 Business Need: Identify revenue-generating products.

sql
SELECT p.product_name, p.category, SUM(od.total_amount) AS total_revenue
FROM products p
JOIN order_details od ON od.product_id = p.product_id
GROUP BY 1, 2
ORDER BY 3 DESC
LIMIT 5;
💡 Insight: Focus on bestsellers for promotions & inventory planning.

Q4. Category-wise Sales Contribution
📌 Business Need: Find category revenue contribution %.

sql
SELECT p.category,
       SUM(od.total_amount) AS total_sales,
       ROUND(SUM(od.total_amount) * 100 / SUM(SUM(od.total_amount)) OVER(), 2) AS revenue_contri
FROM products p
JOIN order_details od ON od.product_id = p.product_id
GROUP BY 1;
💡 Insight: Example – Electronics = 45% → strongest revenue driver.

Q5. Average Order Value (AOV)
📌 Business Need: Track customer spend per order.

sql
SELECT ROUND(AVG(order_total), 2) AS avg_order
FROM (
  SELECT od.order_id, SUM(od.total_amount) AS order_total
  FROM order_details od
  GROUP BY 1
) t;
💡 Insight: Helps management set sales benchmarks.

Q6. Customer Segmentation by Orders
📌 Business Need: Classify customers for loyalty programs.

sql
SELECT c.customer_id, c.name,
       CASE
         WHEN COUNT(order_id) = 1 THEN 'One-time Buyer'
         WHEN COUNT(order_id) >= 6 THEN 'Loyal Buyer'
         ELSE 'Repeat Buyer'
       END AS status
FROM orders o
LEFT JOIN customers c ON o.customer_id = c.customer_id
GROUP BY 1, 2
ORDER BY COUNT(order_id) DESC;
💡 Insight: Loyal buyers = stable revenue, repeat buyers need retention offers.

Q7. Payment Mode Preference
📌 Business Need: Identify most used payment method.

sql
SELECT o.payment_mode,
       SUM(od.total_amount) AS total_sales,
       ROUND(SUM(od.total_amount) * 100 / SUM(SUM(od.total_amount)) OVER(), 2) AS revenue_contri
FROM orders o
JOIN order_details od ON od.order_id = o.order_id
GROUP BY 1;
💡 Insight: Example – 60% revenue via Credit Card → potential for bank partnerships.

Q8. High-Value Customers
📌 Business Need: Find top spenders for premium services.

sql
SELECT c.customer_id, c.name AS customer_name,
       SUM(od.total_amount) AS total_spent
FROM customers c
JOIN orders o ON o.customer_id = c.customer_id
JOIN order_details od ON od.order_id = o.order_id
GROUP BY 1, 2
ORDER BY 3 DESC
LIMIT 10;
💡 Insight: Top 10 customers = VIP loyalty segment.

Q9. Regional Performance
📌 Business Need: Compare sales across regions.

sql
SELECT o.region, SUM(od.total_amount) AS total_sales
FROM orders o
JOIN order_details od ON od.order_id = o.order_id
GROUP BY 1
ORDER BY 2 DESC;
💡 Insight: Strongest region = North. Guides marketing allocation.

Q10. Churn Risk Customers
📌 Business Need: Find customers inactive in last 6 months.

sql
SELECT c.customer_id, c.name AS customer_name
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
  AND o.order_date >= current_date - interval '6 months'
WHERE o.order_id IS NULL;
💡 Insight: Customers at risk of churn → re-engagement campaigns needed.

📑 Final Deliverables
✅ 10 SQL queries solving real business problems

✅ Clear business needs for each question

✅ Actionable insights like a data analyst report

✅ Structured dataset with 4 relational tables

🚀 Key Learnings
Mastering Joins, Aggregates, Window Functions

Writing queries that generate business insights

Applying customer segmentation & sales analysis

Presenting results in a business-friendly format

📜 License
This project is licensed under the MIT License
