-- Create Dimension – dim_patient
CREATE OR REPLACE TABLE dim_patients AS
SELECT
   patient_id,
   MAX(age) AS age,
   MAX(gender) AS gender,
   CASE
        WHEN MAX(age) <= 18 THEN '0-18'
        WHEN MAX(age) <= 35 THEN '19-35'
        WHEN MAX(age) <= 50 THEN '36-50'
        WHEN MAX(age) <= 65 THEN '51-65'
        ELSE '65+'
    END AS Age_group,
    CASE
        WHEN MAX(age) <= 18 THEN 1
        WHEN MAX(age) <= 35 THEN 2
        WHEN MAX(age) <= 50 THEN 3
        WHEN MAX(age) <= 65 THEN 4
        ELSE 5
    END AS age_sort
FROM
    health_db.STAGING.NOSHOW_APPOINT_CLEAN_STAG
GROUP BY patient_id;


-- Create Dimension – dim_neighbourhood
CREATE OR REPLACE TABLE dim_neighbour AS
SELECT DISTINCT neighbourhood
FROM
   STAGING.NOSHOW_APPOINT_CLEAN_STAG;

-- Create Dimension – dim_date
CREATE OR REPLACE TABLE dim_date AS
SELECT DISTINCT
    appointment_date AS date,
    YEAR(appointment_date) AS year,
    MONTH(appointment_date) AS month,
    DAY(appointment_date) AS day,
    DAYOFWEEK(appointment_date) AS day_of_week
FROM
    fact_appointment;
    

-- Create Fact Table – fact_appointments

CREATE OR REPLACE TABLE fact_appointment AS
SELECT
    appointment_id,
    patient_id,
    neighbourhood,
    DATE(appointment_day) AS appointment_date,
    DAYOFWEEK(appointment_day) AS day_of_weeks,
    waiting_days,
    sms_received,
    no_show,
    
FROM
    STAGING.NOSHOW_APPOINT_CLEAN_STAG;

-- add new column
ALTER TABLE fact_appointment
ADD COLUMN waiting_day_bucket STRING;

UPDATE fact_appointment
SET waiting_day_bucket =
     CASE
        WHEN waiting_days <= 3 THEN '0-3 Days'
        WHEN waiting_days <= 7 THEN '4-7 Days'
        WHEN waiting_days <= 14 THEN '8-14 Days'
        ELSE '15+ Days'
    END;

-- add visit bucket
CREATE OR REPLACE TABLE ANALYTICS.patient_visit_freq AS
SELECT
    patient_id,
    COUNT(*) AS total_visits,
    CASE
        WHEN COUNT(*) = 1 THEN '1 Visit'
        WHEN COUNT(*) <= 3 THEN '2-3 Visits'
        WHEN COUNT(*) <= 5 THEN '4-5 Visits'
        ELSE '6+ Visits'
    END AS visit_bucket
FROM ANALYTICS.fact_appointment
GROUP BY patient_id;
