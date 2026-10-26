
WITH customer_order_counts AS (
    SELECT
        c.customer_unique_id,
        COUNT(DISTINCT o.order_id) AS total_orders
    FROM customers AS c
    JOIN orders AS o
        ON c.customer_id = o.customer_id
    GROUP BY c.customer_unique_id
)
SELECT
    CASE
        WHEN total_orders = 1 THEN 'One-time'
        WHEN total_orders = 2 THEN 'Two orders'
        ELSE 'Three or more'
    END AS customer_segment,

    COUNT(*) AS total_customers,

    ROUND(
        100.0 * COUNT(*) /
        NULLIF(SUM(COUNT(*)) OVER (), 0),
        2
    ) AS customer_percentage

FROM customer_order_counts
GROUP BY
    CASE
        WHEN total_orders = 1 THEN 'One-time'
        WHEN total_orders = 2 THEN 'Two orders'
        ELSE 'Three or more'
    END
ORDER BY total_customers DESC;
