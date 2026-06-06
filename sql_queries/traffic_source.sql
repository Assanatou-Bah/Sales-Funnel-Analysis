
-- mart_traffic_source: which channels drive the most conversions

CREATE OR REPLACE TABLE `marketing-analytics-487718.user_events.mart_traffic_source` AS

WITH source_funnel AS (
  SELECT
    traffic_source,
    COUNT(DISTINCT CASE WHEN event_type = 'page_view'      THEN user_id END) AS page_views,
    COUNT(DISTINCT CASE WHEN event_type = 'add_to_cart'    THEN user_id END) AS added_to_cart,
    COUNT(DISTINCT CASE WHEN event_type = 'checkout_start' THEN user_id END) AS checkout_started,
    COUNT(DISTINCT CASE WHEN event_type = 'purchase'       THEN user_id END) AS purchased,
    ROUND(SUM(CASE WHEN event_type = 'purchase' THEN amount ELSE 0 END), 2) AS total_revenue
  FROM `marketing-analytics-487718.user_events.stg_events`
  GROUP BY traffic_source
)

SELECT
  traffic_source,
  page_views,
  added_to_cart,
  checkout_started,
  purchased,
  total_revenue,

  ROUND(added_to_cart * 100 / page_views,    1) AS view_to_cart_rate,
  ROUND(purchased     * 100 / page_views,    2) AS overall_conversion_rate,
  ROUND(total_revenue / NULLIF(purchased, 0), 2) AS avg_order_value
FROM source_funnel
ORDER BY total_revenue DESC;


