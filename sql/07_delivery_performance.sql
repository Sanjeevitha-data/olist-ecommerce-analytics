
SELECT
    COUNT(*) AS delivered_orders_with_dates,

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
    ) AS avg_delivery_days,

    ROUND(
        PERCENTILE_CONT(0.5) WITHIN GROUP (
            ORDER BY EXTRACT(
                EPOCH FROM (
                    order_delivered_customer_date -
                    order_purchase_timestamp
                )
            ) / 86400
        )::numeric,
        2
    ) AS median_delivery_days,

    COUNT(*) FILTER (
        WHERE order_delivered_customer_date >
              order_estimated_delivery_date
    ) AS late_deliveries,

    COUNT(*) FILTER (
        WHERE order_delivered_customer_date <=
              order_estimated_delivery_date
    ) AS on_time_or_early_deliveries

FROM orders
WHERE order_status = 'delivered'
  AND order_delivered_customer_date IS NOT NULL
  AND order_purchase_timestamp IS NOT NULL;
