use im3a;

DROP TABLE IF EXISTS sales_flat;

CREATE TABLE sales_flat (
    sale_id           INT PRIMARY KEY,
    category_name     VARCHAR(50)    NOT NULL,
    product_name      VARCHAR(50)    NOT NULL,
    sales_date        DATE           NOT NULL, 
    net_sales_amount  DECIMAL(10,2)  NOT NULL
);

INSERT INTO sales_flat
    (sale_id, category_name, product_name, sales_date, net_sales_amount)
VALUES
    -- Accessories / Helmet
    (1,  'Accessories', 'Helmet',        '2025-01-05', 25000.00),
    (2,  'Accessories', 'Helmet',        '2025-01-18', 20000.00),
    (3,  'Accessories', 'Helmet',        '2025-02-04', 28000.00),
    (4,  'Accessories', 'Helmet',        '2025-02-21', 22000.00),
    (5,  'Accessories', 'Helmet',        '2025-03-07', 27000.00),
    (6,  'Accessories', 'Helmet',        '2025-03-24', 20000.00),

    -- Accessories / Bottle
    (7,  'Accessories', 'Bottle',        '2025-01-03', 16000.00),
    (8,  'Accessories', 'Bottle',        '2025-01-19', 14000.00),
    (9,  'Accessories', 'Bottle',        '2025-02-06', 15000.00),
    (10, 'Accessories', 'Bottle',        '2025-02-22', 13000.00),
    (11, 'Accessories', 'Bottle',        '2025-03-02', 17000.00),
    (12, 'Accessories', 'Bottle',        '2025-03-25', 14000.00),

    -- Accessories / Gloves
    (13, 'Accessories', 'Gloves',        '2025-01-09', 10000.00),
    (14, 'Accessories', 'Gloves',        '2025-01-27',  8000.00),
    (15, 'Accessories', 'Gloves',        '2025-02-08', 11000.00),
    (16, 'Accessories', 'Gloves',        '2025-02-23', 10000.00),
    (17, 'Accessories', 'Gloves',        '2025-03-05', 10500.00),
    (18, 'Accessories', 'Gloves',        '2025-03-26',  9000.00),

    -- Bikes / Road Bike
    (19, 'Bikes',       'Road Bike',     '2025-01-03', 70000.00),
    (20, 'Bikes',       'Road Bike',     '2025-01-20', 50000.00),
    (21, 'Bikes',       'Road Bike',     '2025-02-05', 85000.00),
    (22, 'Bikes',       'Road Bike',     '2025-02-24', 65000.00),
    (23, 'Bikes',       'Road Bike',     '2025-03-04', 75000.00),
    (24, 'Bikes',       'Road Bike',     '2025-03-22', 55000.00),

    -- Bikes / Mountain Bike
    (25, 'Bikes',       'Mountain Bike', '2025-01-07', 55000.00),
    (26, 'Bikes',       'Mountain Bike', '2025-01-21', 40000.00),
    (27, 'Bikes',       'Mountain Bike', '2025-02-09', 72000.00),
    (28, 'Bikes',       'Mountain Bike', '2025-02-26', 58000.00),
    (29, 'Bikes',       'Mountain Bike', '2025-03-08', 80000.00),
    (30, 'Bikes',       'Mountain Bike', '2025-03-23', 60000.00),

    -- Bikes / Kids Bike
    (31, 'Bikes',       'Kids Bike',     '2025-01-11', 34000.00),
    (32, 'Bikes',       'Kids Bike',     '2025-01-28', 26000.00),
    (33, 'Bikes',       'Kids Bike',     '2025-02-10', 40000.00),
    (34, 'Bikes',       'Kids Bike',     '2025-02-27', 32000.00),
    (35, 'Bikes',       'Kids Bike',     '2025-03-09', 38000.00),
    (36, 'Bikes',       'Kids Bike',     '2025-03-25', 30000.00);

-- Quick check
SELECT * FROM sales_flat ORDER BY sales_date;

   SELECT
      DATE_FORMAT(sales_date, '%Y-%m') AS sales_month,
       SUM(net_sales_amount) AS revenue
   FROM sales_flat
   GROUP BY DATE_FORMAT(sales_date, '%Y-%m');



-- ============================================================
-- SLIDE 4 — GROUP BY vs window function
-- Same data, two different outputs.
-- ============================================================
 
-- GROUP BY: collapses every row into one summary row per group
SELECT
    category_name,
    product_name,
    SUM(net_sales_amount) AS total_revenue
FROM sales_flat
GROUP BY category_name,product_name;
 
-- Window function: every row survives, each one gains a calculated column
SELECT
    category_name,
    product_name,
    net_sales_amount,
    SUM(net_sales_amount) OVER (
        PARTITION BY category_name
    ) AS category_total
FROM sales_flat
ORDER BY category_name, product_name;
 
 
-- ============================================================
-- SLIDE 7 — Ranking functions: ROW_NUMBER, RANK, DENSE_RANK
-- A tie is the clearest way to see the difference between them.
-- This uses a small standalone example (not sales_flat) so the
-- tie is guaranteed to show up.
-- ============================================================
 
WITH product_revenue (product, revenue) AS (
    VALUES ROW('A', 1000),
           ROW('B', 900),
           ROW('C', 900),
           ROW('D', 700)
)
SELECT
    product,
    revenue,
    ROW_NUMBER() OVER (ORDER BY revenue DESC) AS row_num,
    RANK()       OVER (ORDER BY revenue DESC) AS rnk,
    DENSE_RANK() OVER (ORDER BY revenue DESC) AS dense_rnk
FROM product_revenue;
 
-- Note: MySQL 8.0.19+ supports the VALUES ROW(...) table constructor above.
-- On earlier 8.0.x versions, replace the CTE with:
--   WITH product_revenue AS (
--       SELECT 'A' AS product, 1000 AS revenue
--       UNION ALL SELECT 'B', 900
--       UNION ALL SELECT 'C', 900
--       UNION ALL SELECT 'D', 700
--   )
 
 
-- ============================================================
-- SLIDE 8 — Aggregate window functions: running total
-- ============================================================
 
WITH monthly_revenue AS (
    SELECT
        DATE_FORMAT(sales_date, '%Y-%m') AS sales_month,
        SUM(net_sales_amount) AS revenue
    FROM sales_flat
    GROUP BY DATE_FORMAT(sales_date, '%Y-%m')
)
SELECT
    sales_month,
    revenue,
    SUM(revenue) OVER (
        ORDER BY sales_month
    ) AS running_total
FROM monthly_revenue
ORDER BY sales_month;
 
 
-- ============================================================
-- SLIDE 9 — Value functions: LAG() and LEAD()
-- Reuses the same monthly_revenue CTE as Slide 8.
-- ============================================================
 
WITH monthly_revenue AS (
    SELECT
        DATE_FORMAT(sales_date, '%Y-%m') AS sales_month,
        SUM(net_sales_amount) AS revenue
    FROM sales_flat
    GROUP BY DATE_FORMAT(sales_date, '%Y-%m')
)
SELECT
    sales_month,
    revenue,
    LAG(revenue)  OVER (ORDER BY sales_month) AS previous_month,
    LEAD(revenue) OVER (ORDER BY sales_month) AS next_month
FROM monthly_revenue
ORDER BY sales_month;
 
 
-- ============================================================
-- SLIDE 10 — Value functions: FIRST_VALUE() and LAST_VALUE()
-- LAST_VALUE needs an explicit frame, or it just repeats the
-- current row's own value.
-- ============================================================
 
WITH category_month AS (
    SELECT
        category_name,
        DATE_FORMAT(sales_date, '%Y-%m') AS sales_month,
        SUM(net_sales_amount) AS revenue
    FROM sales_flat
    GROUP BY category_name, DATE_FORMAT(sales_date, '%Y-%m')
)
SELECT
    category_name,
    sales_month,
    revenue,
    FIRST_VALUE(revenue) OVER (
        PARTITION BY category_name ORDER BY sales_month
    ) AS first_month_revenue,
    LAST_VALUE(revenue) OVER (
        PARTITION BY category_name ORDER BY sales_month
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    ) AS latest_month_revenue
FROM category_month
ORDER BY category_name, sales_month;
 
 
 
 
 
-- ============================================================
-- SLIDE 11 — PARTITION BY in depth
-- Same ranking, with and without PARTITION BY.
-- ============================================================
 
WITH product_totals AS (
    SELECT
        category_name,
        product_name,
        SUM(net_sales_amount) AS total_revenue
    FROM sales_flat
    GROUP BY category_name, product_name
)
-- No PARTITION BY — one global ranking across every product
SELECT
    category_name,
    product_name,
    total_revenue,
    RANK() OVER (ORDER BY total_revenue DESC) AS global_rank
FROM product_totals
ORDER BY total_revenue DESC;
 
WITH product_totals AS (
    SELECT
        category_name,
        product_name,
        SUM(net_sales_amount) AS total_revenue
    FROM sales_flat
    GROUP BY category_name, product_name
)
-- PARTITION BY category_name — ranking restarts inside each category
SELECT
    category_name,
    product_name,
    total_revenue,
    RANK() OVER (
        PARTITION BY category_name
        ORDER BY total_revenue DESC
    ) AS category_rank
FROM product_totals
ORDER BY category_name, total_revenue DESC;
 
 
-- ============================================================
-- SLIDE 12 — ORDER BY inside OVER()
-- Flipping ASC/DESC changes which row is treated as "first".
-- ============================================================
 
WITH product_totals AS (
    SELECT
        category_name,
        product_name,
        SUM(net_sales_amount) AS total_revenue
    FROM sales_flat
    WHERE category_name = 'Accessories'
    GROUP BY category_name, product_name
)
SELECT
    product_name,
    total_revenue,
    RANK() OVER (ORDER BY total_revenue DESC) AS rank_desc,
    RANK() OVER (ORDER BY total_revenue ASC)  AS rank_asc
FROM product_totals
ORDER BY total_revenue DESC;
 
 
-- ============================================================
-- SLIDE 13 — The frame clause: ROWS BETWEEN
-- 2-month moving average.
-- ============================================================
 
WITH monthly_revenue AS (
    SELECT
        DATE_FORMAT(sales_date, '%Y-%m') AS sales_month,
        SUM(net_sales_amount) AS revenue
    FROM sales_flat
    GROUP BY DATE_FORMAT(sales_date, '%Y-%m')
)
SELECT
    sales_month,
    revenue,
    AVG(revenue) OVER (
        ORDER BY sales_month
        ROWS BETWEEN 1 PRECEDING AND CURRENT ROW
    ) AS two_month_avg
FROM monthly_revenue
ORDER BY sales_month;
 
 
-- ============================================================
-- SLIDE 14 — Worked example: top product per category,
-- built up in three steps.
-- ============================================================
 
-- STEP 1 — Aggregate
SELECT
    category_name,
    product_name,
    SUM(net_sales_amount) AS total_revenue
FROM sales_flat
GROUP BY category_name, product_name;
 
-- STEP 2 — Rank inside a CTE
WITH product_totals AS (
    SELECT
        category_name,
        product_name,
        SUM(net_sales_amount) AS total_revenue
    FROM sales_flat
    GROUP BY category_name, product_name
)
SELECT
    category_name,
    product_name,
    total_revenue,
    RANK() OVER (
        PARTITION BY category_name
        ORDER BY total_revenue DESC
    ) AS product_rank
FROM product_totals;
 
-- STEP 3 — Filter the outer query
-- (a window function's result can't be filtered directly in WHERE,
-- because it hasn't been calculated yet at that stage of query
-- processing — filter the outer query instead)
WITH product_totals AS (
    SELECT
        category_name,
        product_name,
        SUM(net_sales_amount) AS total_revenue
    FROM sales_flat
    GROUP BY category_name, product_name
),
ranked AS (
    SELECT
        category_name,
        product_name,
        total_revenue,
        RANK() OVER (
            PARTITION BY category_name
            ORDER BY total_revenue DESC
        ) AS product_rank
    FROM product_totals
)
SELECT
    category_name,
    product_name,
    total_revenue
FROM ranked
WHERE product_rank = 1;
 
 
-- ============================================================
-- SLIDE 18 — Cheat sheet (for reference, not a runnable query)
-- ============================================================
-- ROW_NUMBER()                  ... OVER (PARTITION BY ... ORDER BY ...)   Unique row order
-- RANK() / DENSE_RANK()         ... OVER (PARTITION BY ... ORDER BY ...)   Ranking, with or without gaps
-- SUM() / AVG() / COUNT()       ... OVER (ORDER BY ...)                   Running totals, moving averages
-- LAG() / LEAD()                ... OVER (ORDER BY ...)                   Compare to previous / next row
-- FIRST_VALUE() / LAST_VALUE()  ... OVER (... ROWS BETWEEN ...)           Fixed reference point per group
-- ============================================================