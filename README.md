# SQL Business Sales & Customer Analytics

## Project Overview

This portfolio project analyzes a practice multi-channel retail database using SQLite. The objective is to answer business questions related to sales performance, customer behavior, product performance, regional trends, sales channels, order outcomes, and customer retention.

**Tool:** DB Browser for SQLite  
**Language:** SQL  
**Dataset:** Practice / portfolio retail dataset

---

## Database Structure

The database contains five tables:

- `customers` — Customer details, segment, location, region, and signup date
- `products` — Product, category, subcategory, cost, and list price
- `orders` — Customer orders, dates, sales channels, and order status
- `order_items` — Products, quantities, prices, and discounts for each order
- `payments` — Payment date, method, status, and amount paid

---

## Business Questions

The SQL analysis answers the following business questions:

1. How many customers, products, and orders are in the database?
2. What is the total realized revenue from Completed orders?
3. What is the average order value for Completed orders?
4. What are the monthly revenue and order-count trends?
5. Which five products generate the highest revenue?
6. Which product categories generate the highest revenue?
7. Which five customers generate the highest revenue?
8. How do revenue and order count compare by region?
9. How do Online, Retail, and Corporate Sales channels compare?
10. What are the completion, cancellation, and return rates?
11. How many customers are repeat vs one-time customers?
12. What are product sales volume and revenue by product?
13. How do customers rank by revenue within each region?
14. How does monthly revenue change compared with the previous month?
15. Which customers generate above-average customer revenue?

---

## SQL Skills Demonstrated

- SELECT, WHERE, and ORDER BY
- JOIN
- GROUP BY and aggregate functions
- COUNT(DISTINCT ...)
- CASE WHEN
- Subqueries
- Common Table Expressions (CTEs)
- Window functions: RANK() and LAG()
- SQLite date functions using strftime()

---

## Key Findings

- The database contains **400 customers, 24 products, and 1,800 orders**.
- Completed orders generated approximately **₹13.30M in realized revenue**.
- The **Average Order Value (AOV)** was approximately **₹9,142.65**.
- **Online** was the largest sales channel, generating approximately **₹7.64M** from **822 completed orders**.
- **Electronics** was the highest-revenue product category, generating approximately **₹8.32M**.
- **South** was the highest-revenue region, generating approximately **₹4.08M**.
- Among customers with at least one completed order, **354 were repeat customers** and **29 were one-time customers**.
- The **27-inch Monitor** was the highest-revenue product, generating approximately **₹2.15M**.
- Across all 1,800 orders, the **cancellation rate was 10.72%** and the **return rate was 8.44%**.

---

## Analysis Approach

Revenue was calculated using:

`quantity × unit_price × (1 - discount_pct / 100)`

Only orders with an order status of **Completed** were included when calculating realized sales revenue.

The analysis progresses from basic aggregation and filtering to multi-table joins, conditional analysis, subqueries, CTEs, and window functions.

---

## Repository Files

- `SQL_Portfolio_Sales_Customer_Analytics_project1.db` — SQLite practice database
- `SQL_Business_Sales_Customer_Analytics_Portfolio.sql` — Cleaned SQL analysis queries
- `README.md` — Project documentation

---

## How to Run the Project

1. Download the SQLite `.db` file.
2. Open it using **DB Browser for SQLite**.
3. Open the **Execute SQL** tab.
4. Open or copy queries from the `.sql` file.
5. Execute individual queries to reproduce the analysis.

---

## Portfolio Note

This project was created as a hands-on SQL and business analytics learning project. It demonstrates the use of SQL to transform relational data into business-focused analysis and actionable insights.

The dataset is a **practice portfolio dataset** and does not represent the data of a real employer or commercial organization.
