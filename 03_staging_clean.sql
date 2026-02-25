-- create staging table
CREATE OR REPLACE TABLE noshow_appoint_stg AS
SELECT
    CAST(patient_id AS STRING) AS patient_id,
    appointment_id,
    gender,

    TO_TIMESTAMP_TZ(scheduled_day) AS scheduled_day,
    TO_TIMESTAMP_TZ(appointment_day) AS appointment_day,

    age,
    neighbourhood,
    scholarship,
    hipertension AS hypertension,
    diabetes,
    alcoholism,
    handcap AS handicap,
    sms_received,

    TO_NUMBER(no_show) AS no_show,

    DATEDIFF(
        'day',
        TO_TIMESTAMP_TZ(scheduled_day),
        TO_TIMESTAMP_TZ(appointment_day)
    ) AS waiting_days

FROM RAW.noshow_appointment_raw;


-- check data

SELECT * FROM noshow_appoint_stag;


-- waiting_days check min and max
SELECT
  MIN(waiting_days) AS min_day,
  MAX(waiting_days) AS max_days
FROM
  noshow_appoint_stag;

-- check negative waiting_day
SELECT
  COUNT(*) AS count_waiting_days
FROM
  noshow_appoint_stag
WHERE
  waiting_days <0;

-- Clean Negative Records and create table
CREATE OR REPLACE TABLE noshow_appoint_clean_stag AS
SELECT *
FROM
   STAGING.noshow_appoint_stg
WHERE
  waiting_days >=0
  AND age >=0;

-- check min day 
SELECT MIN(waiting_days) AS minday
FROM
  noshow_appoint_clean_stag;

-- Age Profile Check
SELECT
   MAX(age) AS max_age,
   MIN(age) AS min_age,
   AVG(age) AS avg_age
FROM
   noshow_appoint_clean_stag;

-- count age< 0
SELECT
   COUNT(*) AS count_age
FROM
   noshow_appoint_clean_stag
WHERE
   age < 0;

-- check nowshow rate
SELECT
    no_show, 
    COUNT(*) 
FROM  
   noshow_appoint_clean_stag
GROUP BY no_show;
