
SELECT
    payment_type,
    COUNT(*) AS payment_records,
    COUNT(DISTINCT order_id) AS unique_orders,
    ROUND(SUM(payment_value)::numeric, 2) AS total_payment_value,
    ROUND(AVG(payment_value)::numeric, 2) AS average_payment_value
FROM payments
GROUP BY payment_type
ORDER BY total_payment_value DESC;
