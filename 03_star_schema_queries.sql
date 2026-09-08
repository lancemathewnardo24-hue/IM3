/* ============================================================
   STAR SCHEMA QUERIES
   Database: bi_modeling_star_demo
   ============================================================ */

USE bi_modeling_star_demo;

/* 1. Inspect table row counts */
SELECT 'fact_sales' AS table_name, COUNT(*) AS rows_count FROM fact_sales
UNION ALL SELECT 'dim_date', COUNT(*) FROM dim_date
UNION ALL SELECT 'dim_product', COUNT(*) FROM dim_product
UNION ALL SELECT 'dim_customer', COUNT(*) FROM dim_customer
UNION ALL SELECT 'dim_region', COUNT(*) FROM dim_region;

/* 2. Grain demonstration
   fact_sales grain = one row per order line item.
   COUNT(*) counts order lines.
   COUNT(DISTINCT order_number) counts orders.
*/
SELECT
    COUNT(*) AS sales_order_lines,
    COUNT(DISTINCT order_number) AS distinct_orders
FROM fact_sales;

/* 3. Basic measures from fact table */
SELECT
    ROUND(SUM(net_sales_amount), 2) AS total_revenue,
    ROUND(SUM(cost_amount), 2) AS total_cost,
    ROUND(SUM(profit_amount), 2) AS total_profit,
    COUNT(DISTINCT order_number) AS total_orders,
    SUM(quantity_ordered) AS total_quantity_sold,
    ROUND(SUM(profit_amount) / NULLIF(SUM(net_sales_amount), 0) * 100, 2) AS profit_margin_percent,
    ROUND(COUNT(DISTINCT CASE WHEN return_flag = 1 THEN order_number END)
          / NULLIF(COUNT(DISTINCT order_number), 0) * 100, 2) AS return_rate_percent
FROM fact_sales;


SELECT
    ROUND(SUM(net_sales_amount), 2) AS total_revenue,
    ROUND(SUM(cost_amount), 2) AS total_cost,
    ROUND(SUM(profit_amount), 2) AS total_profit,
    COUNT(DISTINCT order_number) AS total_orders,
    SUM(quantity_ordered) AS total_quantity_sold
  FROM fact_sales;
 
/* 4. Revenue by category */
SELECT
    p.category_name,
    COUNT(DISTINCT f.order_number) AS total_orders,
    SUM(f.quantity_ordered) AS total_quantity_sold,
    ROUND(SUM(f.net_sales_amount), 2) AS total_revenue,
    ROUND(SUM(f.profit_amount), 2) AS total_profit,
    ROUND(SUM(f.profit_amount) / NULLIF(SUM(f.net_sales_amount), 0) * 100, 2) AS profit_margin_percent
FROM fact_sales f
JOIN dim_product p ON p.product_key = f.product_key
GROUP BY p.category_name
ORDER BY total_revenue DESC;

/* 5. Revenue by month */
SELECT
    DATE_FORMAT(d.calendar_date, '%Y-%m') AS sales_month,
    ROUND(SUM(f.net_sales_amount), 2) AS monthly_revenue,
    COUNT(DISTINCT f.order_number) AS monthly_orders
FROM fact_sales f
JOIN dim_date d 
    ON d.date_key = f.date_key
GROUP BY 
    DATE_FORMAT(d.calendar_date, '%Y-%m')
ORDER BY 
    DATE_FORMAT(d.calendar_date, '%Y-%m');

-- Display total orders, total quantity ordered, total revenue and total profi per sales month, category and region
SELECT
    DATE_FORMAT(d.calendar_date, '%Y-%m') AS sales_month,
    p.category_name,
    r.region_name,
    COUNT(DISTINCT f.order_number) AS total_orders,
    SUM(f.quantity_ordered) AS total_quantity,
    ROUND(SUM(f.net_sales_amount), 2) AS total_revenue,
    ROUND(SUM(f.profit_amount), 2) AS total_profit
FROM fact_sales f
JOIN dim_date d 
    ON d.date_key = f.date_key
JOIN dim_product p 
    ON p.product_key = f.product_key
JOIN dim_region r 
    ON r.region_key = f.region_key
GROUP BY 
    DATE_FORMAT(d.calendar_date, '%Y-%m'),
    p.category_name,
    r.region_name
ORDER BY 
    DATE_FORMAT(d.calendar_date, '%Y-%m'),
    total_revenue DESC;
    
-- Compare Actual vs Target, aggregate actual sales to the same grain as the target    
SELECT
    DATE_FORMAT(d.calendar_date, '%Y-%m') AS sales_month,
    r.region_name,

    ROUND(SUM(f.net_sales_amount), 2) AS actual_revenue,
    t.revenue_target,

    ROUND(SUM(f.net_sales_amount) - t.revenue_target, 2) AS revenue_variance,

    ROUND(
        (SUM(f.net_sales_amount) - t.revenue_target)
        / NULLIF(t.revenue_target, 0) * 100,
        2
    ) AS revenue_vs_target_percent

FROM fact_sales f
JOIN dim_date d
    ON d.date_key = f.date_key
JOIN dim_region r
    ON r.region_key = f.region_key
LEFT JOIN fact_sales_target t
    ON t.region_key = f.region_key
   AND t.month_date_key = CAST(CONCAT(DATE_FORMAT(d.calendar_date, '%Y%m'), '01') AS UNSIGNED)

GROUP BY
    DATE_FORMAT(d.calendar_date, '%Y-%m'),
    r.region_name,
    t.revenue_target

ORDER BY
    sales_month,
    r.region_name;
    
    
select count(*) from dim_customer;