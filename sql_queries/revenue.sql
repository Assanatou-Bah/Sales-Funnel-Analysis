
-- mart_revenue: revenue metrics

CREATE OR REPLACE TABLE `marketing-analytics-487718.user_events.mart_funnel_revenue` AS

WITH funnel_revenue AS (
  SELECT
    COUNT(DISTINCT CASE WHEN event_type = 'page_view'  THEN user_id END) AS total_visitors,
    COUNT(DISTINCT CASE WHEN event_type = 'purchase'   THEN user_id END) AS total_buyers,
    COUNT(CASE WHEN event_type = 'purchase' THEN 1 END)                  AS total_orders,
    ROUND(SUM(CASE WHEN event_type = 'purchase' THEN amount END), 2)     AS total_revenue
  FROM `marketing-analytics-487718.user_events.stg_events`
)

SELECT
  total_visitors,
  total_buyers,
  total_orders,
  total_revenue,
  ROUND(total_revenue / total_orders,    2) AS avg_order_value,
  ROUND(total_revenue / total_buyers,    2) AS revenue_per_buyer,
  ROUND(total_revenue / total_visitors,  2) AS revenue_per_visitor
FROM funnel_revenue;