WITH customer_orders AS (
    SELECT
        c.customer_unique_id,
        COUNT(DISTINCT o.order_id) AS order_count
    FROM customers AS c
    JOIN orders AS o
        ON c.customer_id = o.customer_id
    GROUP BY c.customer_unique_id
)
SELECT
    COUNT(*) AS total_unique_customers,

    COUNT(*) FILTER (
        WHERE order_count = 1
    ) AS one_time_customers,

    COUNT(*) FILTER (
        WHERE order_count > 1
    ) AS repeat_customers,

    ROUND(
        100.0 * COUNT(*) FILTER (
            WHERE order_count > 1
        ) / NULLIF(COUNT(*), 0),
        2
    ) AS repeat_customer_percentage,

    ROUND(
        AVG(order_count::numeric), 2
    ) AS average_orders_per_customer

FROM customer_orders;