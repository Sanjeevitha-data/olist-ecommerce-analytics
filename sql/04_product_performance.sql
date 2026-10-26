WITH category_sales AS (
    SELECT
        COALESCE(
            ct.product_category_name_english,
            p.product_category_name,
            'unknown'
        ) AS product_category,

        COUNT(DISTINCT i.order_id) AS total_orders,
        SUM(i.price) AS item_sales

    FROM items AS i

    JOIN products AS p
        ON i.product_id = p.product_id

    LEFT JOIN category_translation AS ct
        ON p.product_category_name =
           ct.product_category_name

    GROUP BY
        COALESCE(
            ct.product_category_name_english,
            p.product_category_name,
            'unknown'
        )
)
SELECT
    product_category,
    total_orders,
    ROUND(item_sales::numeric, 2) AS item_sales,
    ROUND(
		(
       	   100.0 * item_sales /
           NULLIF(SUM(item_sales) OVER (), 0)
		)::numeric,
        2
     ) AS sales_percentage

FROM category_sales
ORDER BY item_sales DESC
LIMIT 15;