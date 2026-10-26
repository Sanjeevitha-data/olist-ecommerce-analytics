
WITH order_metrics AS (
    SELECT
        COUNT(*) AS total_orders,
        COUNT(*) FILTER (
            WHERE order_status = 'delivered'
        ) AS delivered_orders,
        COUNT(*) FILTER (
            WHERE order_status = 'canceled'
        ) AS canceled_orders
    FROM orders
),
sales_metrics AS (
    SELECT
        ROUND(SUM(i.price)::numeric, 2) AS item_sales,
        ROUND(SUM(i.freight_value)::numeric, 2)
            AS freight_charges,
        COUNT(DISTINCT i.order_id) AS orders_with_items
    FROM items i
    JOIN orders o
        ON i.order_id = o.order_id
    WHERE o.order_status = 'delivered'
),
customer_metrics AS (
    SELECT
        COUNT(DISTINCT customer_unique_id) AS unique_customers
    FROM customers
),
review_metrics AS (
    SELECT
        ROUND(AVG(review_score)::numeric, 2)
            AS average_review_score,
        COUNT(*) FILTER (
            WHERE review_score <= 2
        ) AS low_score_reviews
    FROM reviews
),
delivery_metrics AS (
    SELECT
        ROUND(
            AVG(
                EXTRACT(
                    EPOCH FROM (
                        order_delivered_customer_date -
                        order_purchase_timestamp
                    )
                ) / 86400
            )::numeric,
            2
        ) AS average_delivery_days,
        COUNT(*) FILTER (
            WHERE order_delivered_customer_date >
                  order_estimated_delivery_date
        ) AS late_deliveries
    FROM orders
    WHERE order_status = 'delivered'
      AND order_delivered_customer_date IS NOT NULL
      AND order_purchase_timestamp IS NOT NULL
)
SELECT
    om.total_orders,
    om.delivered_orders,
    om.canceled_orders,
    sm.orders_with_items,
    sm.item_sales AS delivered_item_sales,
    sm.freight_charges AS delivered_freight_charges,
    cm.unique_customers,
    rm.average_review_score,
    rm.low_score_reviews,
    dm.average_delivery_days,
    dm.late_deliveries
FROM order_metrics om
CROSS JOIN sales_metrics sm
CROSS JOIN customer_metrics cm
CROSS JOIN review_metrics rm
CROSS JOIN delivery_metrics dm;
