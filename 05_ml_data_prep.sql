-- Combine Everything into ML-Ready Table
CREATE OR REPLACE TABLE ml_dataset AS
SELECT
    f.appointment_id,
    f.waiting_days,
    f.day_of_weeks,
    f.sms_received,
    p.age,
    p.gender,
    v.total_visits,
    f.no_show
FROM fact_appointment f
JOIN dim_patients p
    ON f.patient_id = p.patient_id
JOIN patient_visit_freq v
    ON f.patient_id = v.patient_id;

SELECT*
FROM
   ml_dataset;