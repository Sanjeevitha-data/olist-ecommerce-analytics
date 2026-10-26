
WITH seller_sales AS (
    SELECT
        i.seller_id,
        COUNT(DISTINCT i.order_id) AS total_orders,
        SUM(i.price) AS item_sales
    FROM items AS i
    JOIN orders AS o
        ON i.order_id = o.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY i.seller_id
),
seller_reviews AS (
    SELECT
        i.seller_id,
        AVG(r.review_score) AS average_review_score
    FROM items AS i
    JOIN orders AS o
        ON i.order_id = o.order_id
    JOIN reviews AS r
        ON o.order_id = r.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY i.seller_id
)
SELECT
    s.seller_id,
    s.seller_city,
    s.seller_state,
    ss.total_orders,
    ROUND(ss.item_sales::numeric, 2) AS item_sales,
    ROUND(sr.average_review_score::numeric, 2)
        AS average_review_score
FROM seller_sales AS ss
JOIN sellers AS s
    ON ss.seller_id = s.seller_id
LEFT JOIN seller_reviews AS sr
    ON ss.seller_id = sr.seller_id
ORDER BY ss.item_sales DESC
LIMIT 15;
