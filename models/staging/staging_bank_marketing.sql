{{ config(materialized='view') }}

WITH raw_data AS (
  SELECT *
  FROM {{ source('analytics_deacero', 'raw_bank_marketing') }}
),

cleaned_data AS (
  SELECT
    age,
    CASE 
        WHEN LOWER(TRIM(job)) = 'unknown' THEN NULL 
        ELSE LOWER(TRIM(job)) 
    END AS job,
    CASE 
        WHEN LOWER(TRIM(marital)) = 'unknown' THEN NULL 
        ELSE LOWER(TRIM(marital)) 
    END AS marital,
    CASE
      WHEN LOWER(TRIM(education)) IN ('basic.4y','basic.6y','basic.9y') THEN 'basic'
      WHEN LOWER(TRIM(education)) = 'unknown' THEN NULL
      ELSE LOWER(TRIM(education))
    END AS education_level,
    CASE 
        WHEN LOWER(TRIM(credit_default)) = 'unknown' THEN NULL 
        ELSE LOWER(TRIM(credit_default)) 
    END AS credit_default,
    CASE 
        WHEN LOWER(TRIM(housing)) = 'unknown' THEN NULL 
        ELSE LOWER(TRIM(housing)) 
    END AS housing_loan,
    CASE 
        WHEN LOWER(TRIM(loan)) = 'unknown' THEN NULL 
        ELSE LOWER(TRIM(loan)) 
    END AS personal_loan,
    CASE 
        WHEN LOWER(TRIM(contact)) = 'unknown' THEN NULL 
        ELSE LOWER(TRIM(contact)) 
    END AS contact_type,
    LOWER(TRIM(month)) AS month,
    LOWER(TRIM(day_of_week)) AS day_of_week,
    duration,
    campaign,
    pdays,
    previous,
    emp_var_rate,
    cons_price_idx,
    cons_conf_idx,
    euribor3m,
    nr_employed,
    LOWER(TRIM(poutcome)) as poutcome,
    y as subscribed_deposit,
    CASE
        WHEN age < 30 THEN '<30'
        WHEN age BETWEEN 30 AND 50 THEN '30-50'
        ELSE '>50'
    END AS age_group
  FROM raw_data
)

SELECT *
FROM cleaned_data