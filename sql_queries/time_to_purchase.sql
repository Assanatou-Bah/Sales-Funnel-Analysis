
-- mart_time_to_purchase: how long users take to convert

CREATE OR REPLACE TABLE `marketing-analytics-487718.user_events.mart_time_to_purchase` AS

WITH user_journey AS (
  SELECT
    user_id,
    MIN(CASE WHEN event_type = 'page_view'      THEN event_date END) AS view_time,
    MIN(CASE WHEN event_type = 'add_to_cart'    THEN event_date END) AS cart_time,
    MIN(CASE WHEN event_type = 'checkout_start' THEN event_date END) AS checkout_time,
    MIN(CASE WHEN event_type = 'purchase'       THEN event_date END) AS purchase_time
  FROM `marketing-analytics-487718.user_events.stg_events`
  GROUP BY user_id
)

SELECT
  COUNT(*)                                                                      AS total_purchasers,
  ROUND(AVG(TIMESTAMP_DIFF(cart_time,     view_time,     MINUTE)), 2)          AS avg_view_to_cart_mins,
  ROUND(AVG(TIMESTAMP_DIFF(checkout_time, cart_time,     MINUTE)), 2)          AS avg_cart_to_checkout_mins,
  ROUND(AVG(TIMESTAMP_DIFF(purchase_time, checkout_time, MINUTE)), 2)          AS avg_checkout_to_purchase_mins,
  ROUND(AVG(TIMESTAMP_DIFF(purchase_time, view_time,     MINUTE)), 2)          AS avg_total_purchase_mins
FROM user_journey
WHERE purchase_time IS NOT NULL;


