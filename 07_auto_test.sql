-- test automation
INSERT INTO RAW.noshow_appointment_raw
SELECT
    patient_id,
    appointment_id + 20000000,
    gender,
    scheduled_day,
    appointment_day,
    age,
    neighbourhood,
    scholarship,
    hipertension,
    diabetes,
    alcoholism,
    handcap,
    sms_received,
    no_show
FROM 
    RAW.noshow_appointment_raw
LIMIT 2;

-- check automation pipelines
SELECT COUNT(*) FROM STAGING.noshow_appoint_clean_stag;
SELECT COUNT(*) FROM ANALYTICS.fact_appointment;
