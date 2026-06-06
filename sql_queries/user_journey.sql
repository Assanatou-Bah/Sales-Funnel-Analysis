
-- mart_user_journey: which funnel stages each user reached

CREATE OR REPLACE TABLE `marketing-analytics-487718.user_events.mart_user_journey` AS

SELECT
  user_id,
  traffic_source,
  MAX(CASE WHEN event_type = 'page_view'      THEN 1 ELSE 0 END) AS reached_page_view,
  MAX(CASE WHEN event_type = 'add_to_cart'    THEN 1 ELSE 0 END) AS reached_add_to_cart,
  MAX(CASE WHEN event_type = 'checkout_start' THEN 1 ELSE 0 END) AS reached_checkout,
  MAX(CASE WHEN event_type = 'payment_info'   THEN 1 ELSE 0 END) AS reached_payment,
  MAX(CASE WHEN event_type = 'purchase'       THEN 1 ELSE 0 END) AS reached_purchase,

  -- How far did this user get?
  CASE
    WHEN MAX(CASE WHEN event_type = 'purchase'       THEN 1 ELSE 0 END) = 1 THEN 'Purchased'
    WHEN MAX(CASE WHEN event_type = 'payment_info'   THEN 1 ELSE 0 END) = 1 THEN 'Dropped at Payment'
    WHEN MAX(CASE WHEN event_type = 'checkout_start' THEN 1 ELSE 0 END) = 1 THEN 'Dropped at Checkout'
    WHEN MAX(CASE WHEN event_type = 'add_to_cart'    THEN 1 ELSE 0 END) = 1 THEN 'Dropped at Cart'
    ELSE 'Bounced'
  END AS furthest_stage

FROM `marketing-analytics-487718.user_events.stg_events`
GROUP BY user_id, traffic_source;


SELECT
  furthest_stage,
  COUNT(*) AS users
FROM `marketing-analytics-487718.user_events.mart_user_journey`
GROUP BY furthest_stage
ORDER BY users DESC;
