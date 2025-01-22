{{ config(materialized='table') }}

WITH staging AS (
  SELECT * 
  FROM {{ ref('staging_bank_marketing') }}
),

aggregations as (
  SELECT 
    COUNT(*) AS total_contacts,
    SUM(CASE WHEN subscribed_deposit = true then 1 ELSE 0 END) as successful_contacts,
    SAFE_DIVIDE(
          SUM(CASE WHEN subscribed_deposit = true THEN 1 ELSE 0 END),
          COUNT(*)
        ) AS total_conversion_rate
  FROM staging
),

segmentations as (
  SELECT
    age_group,
    job,
    count(*) AS contacts_in_segment,
    SUM(CASE WHEN subscribed_deposit = true THEN 1 ELSE 0 END) AS successful_in_segment,
    SAFE_DIVIDE(
        SUM(CASE WHEN subscribed_deposit = true THEN 1 ELSE 0 END),
        COUNT(*)
    ) AS segment_conversion_rate
  FROM staging
  GROUP BY age_group, job
)

SELECT
  a.*,
  s.age_group,
  s.job,
  s.contacts_in_segment,
  s.successful_in_segment,
  s.segment_conversion_rate
FROM aggregations a
JOIN segmentations s ON TRUE