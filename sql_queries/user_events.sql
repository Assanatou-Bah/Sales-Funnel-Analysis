
-- How many rows, users, and what event types exist?

SELECT
  COUNT(*)              AS total_rows,
  COUNT(DISTINCT user_id) AS distinct_users,
  MIN(event_date)       AS earliest_date,
  MAX(event_date)       AS latest_date
FROM `marketing-analytics-487718.user_events_dataset_project.user_events`;



-- What event types exist?

SELECT
  event_type,
  COUNT(*) AS event_count
FROM `marketing-analytics-487718.user_events_dataset_project.user_events`
GROUP BY event_type
ORDER BY event_count DESC;



-- What traffic sources exist?

SELECT
  traffic_source,
  COUNT(*) AS event_count
FROM `marketing-analytics-487718.user_events_dataset_project.user_events`
GROUP BY traffic_source
ORDER BY event_count DESC;



-- Check 1: Nulls in key fields

SELECT
  COUNTIF(user_id IS NULL)       AS null_users,
  COUNTIF(event_type IS NULL)    AS null_event_type,
  COUNTIF(event_date IS NULL)    AS null_event_date,
  COUNTIF(traffic_source IS NULL) AS null_traffic_source,
  COUNTIF(amount IS NULL)        AS null_amount
FROM `marketing-analytics-487718.user_events_dataset_project.user_events`;



-- Check 2: Duplicates

SELECT
  user_id,
  event_type,
  event_date,
  COUNT(*) AS occurrences
FROM `marketing-analytics-487718.user_events_dataset_project.user_events`
GROUP BY user_id, event_type, event_date
HAVING COUNT(*) > 1
ORDER BY occurrences DESC
LIMIT 10;



-- stg_events: clean base table for all marts

CREATE OR REPLACE TABLE `marketing-analytics-487718.user_events.stg_events` AS

SELECT
  event_id,
  user_id,
  event_type,
  event_date,
  product_id,
  COALESCE(amount, 0) AS amount,
  
  CASE
  WHEN traffic_source = 'email'    THEN 'Email'
  WHEN traffic_source = 'paid_ads' THEN 'Paid Ads'
  WHEN traffic_source = 'organic'  THEN 'Organic'
  WHEN traffic_source = 'social'   THEN 'Social'
  ELSE traffic_source
END AS traffic_source
FROM `marketing-analytics-487718.user_events_dataset_project.user_events`;



