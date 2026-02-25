-- create stream on raw
CREATE OR REPLACE STREAM health_db.RAW.health_raw_stream
ON TABLE health_db.RAW.NOSHOW_APPOINTMENT_RAW
APPEND_ONLY = TRUE;

-- create automation task

CREATE OR REPLACE TASK health_db.STAGING.RAW_TO_FACT_HEALTHCARE
WAREHOUSE = healthcare_WH
SCHEDULE = '1 MINUTE'
WHEN SYSTEM$STREAM_HAS_DATA('health_db.RAW.health_raw_stream')
AS

INSERT INTO health_db.STAGING.NOSHOW_APPOINT_CLEAN_STAG
SELECT
    CAST(patient_id AS STRING),
    appointment_id,
    gender,
    TO_TIMESTAMP_TZ(scheduled_day),
    TO_TIMESTAMP_TZ(appointment_day),
    age,
    neighbourhood,
    scholarship,
    hipertension,
    diabetes,
    alcoholism,
    handcap,
    sms_received,
    TO_NUMBER(no_show),
    DATEDIFF('day',
        TO_TIMESTAMP_TZ(scheduled_day),
        TO_TIMESTAMP_TZ(appointment_day)
    )
FROM 
    health_db.RAW.HEALTH_RAW_STREAM
WHERE METADATA$ACTION = 'INSERT';

-- create another stream in stag
CREATE OR REPLACE STREAM health_db.STAGING.health_stag_stream
ON TABLE health_db.STAGING.NOSHOW_APPOINT_CLEAN_STAG
APPEND_ONLY = TRUE;

-- create task in analytics layer

CREATE OR REPLACE TASK health_db.ANALYTICS.STAG_TO_FACT_HEALTHCARE
WAREHOUSE = healthcare_WH
SCHEDULE = '1 MINUTE'
WHEN SYSTEM$STREAM_HAS_DATA('health_db.STAGING.health_stag_stream')
AS

INSERT INTO health_db.ANALYTICS.fact_appointment
SELECT
    appointment_id,
    patient_id,
    neighbourhood,
    DATE(appointment_day),
    DAYOFWEEK(appointment_day),
    waiting_days,
    sms_received,
    no_show
FROM 
    health_db.STAGING.health_stag_stream
WHERE METADATA$ACTION = 'INSERT';

-- Resume Both Tasks
ALTER TASK health_db.STAGING.RAW_TO_FACT_HEALTHCARE RESUME;
ALTER TASK health_db.ANALYTICS.STAG_TO_FACT_HEALTHCARE RESUME;