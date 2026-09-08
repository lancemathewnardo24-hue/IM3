use im3a;

-- ============================================================
-- SQL Window Functions — Practice Activity
-- Dataset: sales_flat 
--
-- For each question below, write your query underneath the
-- comment block, then run it and check your result against
-- what the question is asking.
-- ============================================================


-- ============================================================
-- PART 1 — Warm-up (no window functions yet)
-- ============================================================

select*
from sales_flat;

-- Q1. List every transaction in the Bikes category, ordered by sales_date.
SELECT*
FROM sales_flat
WHERE category_name = "bikes"
ORDER BY Sales_date;


-- Q2. Calculate total revenue per product (ignore category and month).
SELECT
product_name,
SUM(net_sales_amount)	AS	total_revenue
FROM	sales_flat
GROUP	BY	product_name
ORDER	BY	total_revenue	DESC;


-- Q3. Calculate total revenue per category, per month.
-- Hint: DATE_FORMAT(sales_date, '%Y-%m') and GROUP BY on two columns.

SELECT
category_name,
DATE_FORMAT(sales_date,	'%Y-%m')	AS	sales_month,
SUM(net_sales_amount)	AS	total_revenue
FROM	sales_flat
GROUP	BY	category_name,	DATE_FORMAT(sales_date,	'%Y-%m')
ORDER	BY	category_name,	sales_month;


-- ============================================================
-- PART 2 — Ranking functions
-- ============================================================

-- Q4. Rank all 6 products by total revenue, highest first, using RANK().
-- Which product is #1 overall?
-- Answer: the #1 overall is ROAD BIKE


WITH product_totals AS (
	SELECT product_name, SUM(net_sales_amount) AS total_revenue
    FROM sales_flat
    GROUP BY product_name
)
SELECT
	product_name,
    total_revenue,
    RANK() OVER (ORDER BY total_revenue DESC) AS overall_rank
FROM product_totals;

-- Q5. Take Q4 and add PARTITION BY category_name.
-- Does the top accessory change rank once compared only to other accessories?
-- Answer: yes the rank changed compared to the overall rank because it is now ranked by category, from helmet ranked at 4th now is ranked at 1st and same order as the 5th and 6th.

WITH product_totals AS(
	SELECT category_name, product_name, SUM(net_sales_amount) AS total_revenue
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
        ) AS category_rank
FROM product_totals
ORDER BY category_name, category_rank;


-- Q6. Re-run Q5 using DENSE_RANK() instead of RANK().
-- Do the results differ here? Why or why not?
-- Answer: The results does not differ, because the total revenue is still the same so the functions produced the same ranking

WITH product_totals AS(
	SELECT category_name, product_name, SUM(net_sales_amount) AS total_revenue
    FROM sales_flat
    GROUP BY category_name, product_name
    )
SELECT 
	category_name,
	product_name,
    total_revenue,
    DENSE_RANK()OVER (
		PARTITION BY category_name
        ORDER BY total_revenue DESC
        ) AS category_dense_rank
FROM product_totals
ORDER BY category_name, category_dense_rank;

-- ============================================================
-- PART 3 — Aggregate window functions
-- ============================================================

-- Q7. Build a monthly_revenue CTE (total revenue per month, company-wide),
-- then calculate a running total across the three months.

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
    SUM(revenue) OVER (ORDER BY sales_month) as running_total
    FROM monthly_revenue
    ORDER BY sales_month;


-- Q8. Modify Q7 so the running total is calculated per category instead
-- of company-wide.
-- Hint: include category in your CTE, then PARTITION BY it in OVER().

WITH monthly_revenue AS(
	SELECT
	category_name,
	DATE_FORMAT(sales_date,	'%Y-%m') AS sales_month,
	SUM(net_sales_amount) AS revenue
	FROM sales_flat
	GROUP BY category_name,	DATE_FORMAT(sales_date,	'%Y-%m')
	)
SELECT
	category_name,
	sales_month,
	revenue,
	SUM(revenue) OVER (
		PARTITION BY category_name
		ORDER BY sales_month
		) AS category_running_total
FROM monthly_revenue
ORDER BY category_name, sales_month;


-- Q9. Using your Q7 result, calculate a 2-month moving average of revenue.
-- Which month has the highest smoothed average?
-- Answer: 
WITH monthly_revenue AS(
	SELECT
	category_name,
	DATE_FORMAT(sales_date,	'%Y-%m') AS sales_month,
	SUM(net_sales_amount) AS revenue
	FROM sales_flat
	GROUP BY category_name,	DATE_FORMAT(sales_date,	'%Y-%m')
	)
SELECT
	sales_month,
    revenue,
    AVG(revenue) OVER (
		ORDER BY sales_month
        ROWS BETWEEN 1 PRECEDING AND CURRENT ROW
        ) AS two_month_moving_avg
FROM monthly_revenue
ORDER BY sales_month;


-- ============================================================
-- PART 4 — Value functions
-- ============================================================

-- Q10. Using LAG(), calculate month-over-month revenue growth percentage
-- for total company revenue. Which month had the biggest drop?



-- Q11. Using LEAD() on the same data, add a column showing what next
-- month's revenue was for each row.



-- Q12. For each category, use FIRST_VALUE() and LAST_VALUE() to show that
-- category's first month's revenue and most recent month's revenue side
-- by side. Don't forget the frame clause LAST_VALUE() needs.



-- ============================================================
-- PART 5 — Putting it together
-- ============================================================

-- Q13. Write a query showing the single top-selling product in each
-- category (aggregate -> rank -> filter to rank = 1).



-- Q14. (Challenge) Which product had the largest month-over-month revenue
-- increase, in pesos, between any two consecutive months?
-- Hint: aggregate by product AND month, use LAG(), then find the largest
-- difference.



-- Q15. (Challenge) For each product, use LAG() with PARTITION BY
-- product_name to calculate its month-over-month change. Which products
-- declined from February to March, even though the category as a whole
-- may have grown?
-- Hint: aggregate by product and month first, same as Q14.



-- ============================================================
-- Submission checklist:
--   1. All 15 queries filled in above
--   2. Screenshot of the result for Q13 and Q14
--   3. One sentence of interpretation for each of those two results
-- ============================================================