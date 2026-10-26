WITH order_sales AS (
    SELECT
        order_id,
        SUM(price) AS item_sales,
        SUM(freight_value) AS freight_charges
    FROM items
    GROUP BY order_id
)
SELECT
    COUNT(*) AS total_orders_with_items,

    ROUND(SUM(os.item_sales)::numeric, 2)
        AS total_item_sales,

    ROUND(SUM(os.freight_charges)::numeric, 2)
        AS total_freight_charges,

    ROUND(
        SUM(os.item_sales + os.freight_charges)::numeric,
        2
    ) AS total_order_value,

    ROUND(
        AVG(os.item_sales)::numeric, 2
    ) AS average_item_sales_per_order,

    ROUND(
        SUM(os.item_sales) FILTER (
            WHERE o.order_status = 'delivered'
        )::numeric, 2
    ) AS delivered_item_sales

FROM order_sales AS os
JOIN orders AS o
    ON os.order_id = o.order_id;
