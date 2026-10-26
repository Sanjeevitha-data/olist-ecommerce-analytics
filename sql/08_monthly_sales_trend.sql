
SELECT
    DATE_TRUNC('month', o.order_purchase_timestamp)::date
        AS order_month,

    COUNT(DISTINCT o.order_id) AS total_orders,

    ROUND(SUM(i.price)::numeric, 2) AS item_sales,

    ROUND(
        AVG(i.price)::numeric,
        2
    ) AS average_item_price

FROM orders AS o
JOIN items AS i
    ON o.order_id = i.order_id

WHERE o.order_status = 'delivered'

GROUP BY DATE_TRUNC(
    'month',
    o.order_purchase_timestamp
)

ORDER BY order_month;
