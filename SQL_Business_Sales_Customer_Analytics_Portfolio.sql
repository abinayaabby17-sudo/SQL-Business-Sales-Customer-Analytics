-- ============================================================
-- SQL Business Sales & Customer Analytics
-- Tool: SQLite / DB Browser for SQLite
-- Portfolio Project
-- ============================================================

-- Q1. Database overview: customers, products and orders
SELECT
    (SELECT COUNT(*) FROM customers) AS total_customers,
    (SELECT COUNT(*) FROM products) AS total_products,
    (SELECT COUNT(*) FROM orders) AS total_orders;


-- Q2. Total realized revenue from Completed orders
SELECT
    ROUND(SUM(oi.quantity * oi.unit_price * (1 - oi.discount_pct / 100.0)), 2) AS total_realized_revenue
FROM orders AS o
JOIN order_items AS oi
    ON o.order_id = oi.order_id
WHERE o.order_status = 'Completed';


-- Q3. Average Order Value (AOV) for Completed orders
SELECT
    ROUND(AVG(order_revenue), 2) AS average_order_value
FROM (
    SELECT
        o.order_id,
        SUM(oi.quantity * oi.unit_price * (1 - oi.discount_pct / 100.0)) AS order_revenue
    FROM orders AS o
    JOIN order_items AS oi
        ON o.order_id = oi.order_id
    WHERE o.order_status = 'Completed'
    GROUP BY o.order_id
);


-- Q4. Monthly revenue and order count
SELECT
    strftime('%Y-%m', o.order_date) AS order_month,
    COUNT(DISTINCT o.order_id) AS order_count,
    ROUND(SUM(oi.quantity * oi.unit_price * (1 - oi.discount_pct / 100.0)), 2) AS monthly_revenue
FROM orders AS o
JOIN order_items AS oi
    ON o.order_id = oi.order_id
WHERE o.order_status = 'Completed'
GROUP BY strftime('%Y-%m', o.order_date)
ORDER BY order_month;


-- Q5. Top 5 products by realized revenue
SELECT
    p.product_id,
    p.product_name,
    ROUND(SUM(oi.quantity * oi.unit_price * (1 - oi.discount_pct / 100.0)), 2) AS product_revenue
FROM orders AS o
JOIN order_items AS oi
    ON o.order_id = oi.order_id
JOIN products AS p
    ON oi.product_id = p.product_id
WHERE o.order_status = 'Completed'
GROUP BY p.product_id, p.product_name
ORDER BY product_revenue DESC
LIMIT 5;


-- Q6. Revenue by product category
SELECT
    p.category,
    ROUND(SUM(oi.quantity * oi.unit_price * (1 - oi.discount_pct / 100.0)), 2) AS category_revenue
FROM orders AS o
JOIN order_items AS oi
    ON o.order_id = oi.order_id
JOIN products AS p
    ON oi.product_id = p.product_id
WHERE o.order_status = 'Completed'
GROUP BY p.category
ORDER BY category_revenue DESC;


-- Q7. Top 5 customers by realized revenue
SELECT
    c.customer_id,
    c.customer_name,
    ROUND(SUM(oi.quantity * oi.unit_price * (1 - oi.discount_pct / 100.0)), 2) AS customer_revenue
FROM customers AS c
JOIN orders AS o
    ON c.customer_id = o.customer_id
JOIN order_items AS oi
    ON o.order_id = oi.order_id
WHERE o.order_status = 'Completed'
GROUP BY c.customer_id, c.customer_name
ORDER BY customer_revenue DESC
LIMIT 5;


-- Q8. Revenue and Completed-order count by region
SELECT
    c.region,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(oi.quantity * oi.unit_price * (1 - oi.discount_pct / 100.0)), 2) AS revenue
FROM customers AS c
JOIN orders AS o
    ON c.customer_id = o.customer_id
JOIN order_items AS oi
    ON o.order_id = oi.order_id
WHERE o.order_status = 'Completed'
GROUP BY c.region
ORDER BY revenue DESC;


-- Q9. Sales-channel performance
SELECT
    o.sales_channel,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(oi.quantity * oi.unit_price * (1 - oi.discount_pct / 100.0)), 2) AS revenue
FROM orders AS o
JOIN order_items AS oi
    ON o.order_id = oi.order_id
WHERE o.order_status = 'Completed'
GROUP BY o.sales_channel
ORDER BY revenue DESC;


-- Q10. Order-status counts and rates
SELECT
    COUNT(*) AS total_orders,
    SUM(CASE WHEN order_status = 'Completed' THEN 1 ELSE 0 END) AS completed_orders,
    SUM(CASE WHEN order_status = 'Cancelled' THEN 1 ELSE 0 END) AS cancelled_orders,
    SUM(CASE WHEN order_status = 'Returned' THEN 1 ELSE 0 END) AS returned_orders,
    ROUND(100.0 * SUM(CASE WHEN order_status = 'Completed' THEN 1 ELSE 0 END) / COUNT(*), 2) AS completed_rate_pct,
    ROUND(100.0 * SUM(CASE WHEN order_status = 'Cancelled' THEN 1 ELSE 0 END) / COUNT(*), 2) AS cancellation_rate_pct,
    ROUND(100.0 * SUM(CASE WHEN order_status = 'Returned' THEN 1 ELSE 0 END) / COUNT(*), 2) AS return_rate_pct
FROM orders;


-- Q11. Repeat vs one-time customers using Completed orders
SELECT
    customer_type,
    COUNT(*) AS total_customers
FROM (
    SELECT
        c.customer_id,
        CASE
            WHEN COUNT(DISTINCT o.order_id) > 1 THEN 'Repeat Customer'
            ELSE 'One-Time Customer'
        END AS customer_type
    FROM customers AS c
    JOIN orders AS o
        ON c.customer_id = o.customer_id
    WHERE o.order_status = 'Completed'
    GROUP BY c.customer_id
)
GROUP BY customer_type
ORDER BY customer_type;


-- Q12. Product sales volume and revenue
-- This portfolio version keeps the analysis at product level.
-- The advanced above-average-volume/below-average-revenue filter was intentionally not used.
SELECT
    p.product_id,
    p.product_name,
    SUM(oi.quantity) AS total_quantity_sold,
    ROUND(SUM(oi.quantity * oi.unit_price * (1 - oi.discount_pct / 100.0)), 2) AS total_revenue
FROM orders AS o
JOIN order_items AS oi
    ON o.order_id = oi.order_id
JOIN products AS p
    ON oi.product_id = p.product_id
WHERE o.order_status = 'Completed'
GROUP BY p.product_id, p.product_name
ORDER BY total_quantity_sold DESC;


-- Q13. Rank customers by revenue within each region
SELECT
    region,
    customer_id,
    customer_name,
    ROUND(customer_revenue, 2) AS customer_revenue,
    RANK() OVER (
        PARTITION BY region
        ORDER BY customer_revenue DESC
    ) AS revenue_rank
FROM (
    SELECT
        c.region,
        c.customer_id,
        c.customer_name,
        SUM(oi.quantity * oi.unit_price * (1 - oi.discount_pct / 100.0)) AS customer_revenue
    FROM customers AS c
    JOIN orders AS o
        ON c.customer_id = o.customer_id
    JOIN order_items AS oi
        ON o.order_id = oi.order_id
    WHERE o.order_status = 'Completed'
    GROUP BY c.region, c.customer_id, c.customer_name
)
ORDER BY region, revenue_rank;


-- Q14. Monthly revenue percentage change
-- Advanced/window-function analysis: LAG() retrieves the previous month's revenue.
SELECT
    order_month,
    ROUND(monthly_revenue, 2) AS monthly_revenue,
    ROUND(previous_month_revenue, 2) AS previous_month_revenue,
    ROUND(
        100.0 * (monthly_revenue - previous_month_revenue) / previous_month_revenue,
        2
    ) AS revenue_change_pct
FROM (
    SELECT
        order_month,
        monthly_revenue,
        LAG(monthly_revenue) OVER (ORDER BY order_month) AS previous_month_revenue
    FROM (
        SELECT
            strftime('%Y-%m', o.order_date) AS order_month,
            SUM(oi.quantity * oi.unit_price * (1 - oi.discount_pct / 100.0)) AS monthly_revenue
        FROM orders AS o
        JOIN order_items AS oi
            ON o.order_id = oi.order_id
        WHERE o.order_status = 'Completed'
        GROUP BY strftime('%Y-%m', o.order_date)
    )
)
ORDER BY order_month;


-- Q15. Customers with above-average Completed-order revenue
WITH customer_revenue AS (
    SELECT
        c.customer_id,
        c.customer_name,
        SUM(oi.quantity * oi.unit_price * (1 - oi.discount_pct / 100.0)) AS revenue
    FROM customers AS c
    JOIN orders AS o
        ON c.customer_id = o.customer_id
    JOIN order_items AS oi
        ON o.order_id = oi.order_id
    WHERE o.order_status = 'Completed'
    GROUP BY c.customer_id, c.customer_name
)
SELECT
    customer_id,
    customer_name,
    ROUND(revenue, 2) AS customer_revenue
FROM customer_revenue
WHERE revenue > (SELECT AVG(revenue) FROM customer_revenue)
ORDER BY revenue DESC;
