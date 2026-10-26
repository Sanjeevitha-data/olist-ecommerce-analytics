
WITH delivery_reviews AS (
    SELECT
        o.order_id,
        r.review_score,
        CASE
            WHEN o.order_delivered_customer_date >
                 o.order_estimated_delivery_date
                THEN 'Late'
            WHEN o.order_delivered_customer_date <=
                 o.order_estimated_delivery_date
                THEN 'On time or early'
            ELSE 'Unknown'
        END AS delivery_status
    FROM orders AS o
    JOIN reviews AS r
        ON o.order_id = r.order_id
    WHERE o.order_status = 'delivered'
      AND o.order_delivered_customer_date IS NOT NULL
      AND o.order_estimated_delivery_date IS NOT NULL
)
SELECT
    delivery_status,
    COUNT(*) AS review_records,
    ROUND(AVG(review_score)::numeric, 2) AS average_review_score,
    COUNT(*) FILTER (
        WHERE review_score <= 2
    ) AS low_score_reviews,
    ROUND(
        100.0 * COUNT(*) FILTER (
            WHERE review_score <= 2
        ) / NULLIF(COUNT(*), 0),
        2
    ) AS low_score_percentage
FROM delivery_reviews
GROUP BY delivery_status
ORDER BY delivery_status;
