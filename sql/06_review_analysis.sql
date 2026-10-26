SELECT
    review_score,
    COUNT(*) AS review_records,
    ROUND(
        100.0 * COUNT(*) /
        NULLIF(SUM(COUNT(*)) OVER (), 0),
        2
    ) AS review_percentage
FROM reviews
GROUP BY review_score
ORDER BY review_score;
