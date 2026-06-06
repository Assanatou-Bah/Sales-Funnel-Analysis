-- mart_funnel_stages: stage by stage users and conversion rates

CREATE OR REPLACE TABLE `marketing-analytics-487718.user_events.mart_funnel_stages` AS

WITH funnel AS (
  SELECT
    COUNT(DISTINCT CASE WHEN event_type = 'page_view'      THEN user_id END) AS page_views,
    COUNT(DISTINCT CASE WHEN event_type = 'add_to_cart'    THEN user_id END) AS added_to_cart,
    COUNT(DISTINCT CASE WHEN event_type = 'checkout_start' THEN user_id END) AS checkout_started,
    COUNT(DISTINCT CASE WHEN event_type = 'payment_info'   THEN user_id END) AS payment_entered,
    COUNT(DISTINCT CASE WHEN event_type = 'purchase'       THEN user_id END) AS purchased
  FROM `marketing-analytics-487718.user_events.stg_events`
)

SELECT
  page_views,
  added_to_cart,
  checkout_started,
  payment_entered,
  purchased,

  ROUND(added_to_cart    * 100 / page_views,       1) AS view_to_cart_rate,
  ROUND(checkout_started * 100 / added_to_cart,    1) AS cart_to_checkout_rate,
  ROUND(payment_entered  * 100 / checkout_started, 1) AS checkout_to_payment_rate,
  ROUND(purchased        * 100 / payment_entered,  1) AS payment_to_purchase_rate,
  ROUND(purchased        * 100 / page_views,       2) AS overall_conversion_rate

FROM funnel;


