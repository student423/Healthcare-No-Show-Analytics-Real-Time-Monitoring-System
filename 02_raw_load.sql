-- create raw table
CREATE OR REPLACE TABLE noshow_appointment_raw(
    patient_id STRING,
    appointment_id NUMBER,
    gender STRING,
    scheduled_day STRING,
    appointment_day STRING,
    age NUMBER,
    neighbourhood STRING,
    scholarship NUMBER,
    hipertension NUMBER,
    diabetes NUMBER,
    alcoholism NUMBER,
    handcap NUMBER,
    sms_received NUMBER,
    no_show STRING
);

-- COPY INTO RAW Table
COPY INTO noshow_appointment_raw
FROM @healthcare_stage
FILE_FORMAT = (FORMAT_NAME = CSV_FILE_FORMAT)
ON_ERROR = 'CONTINUE';

-- check data
SELECT
  COUNT(*)
FROM
  RAW.noshow_appointment_raw
WHERE
   no_show = 0;
  

SELECT
  COUNT(*)
FROM
  noshow_appointment_raw;

-- check null values
SELECT
COUNT_IF(appointment_id IS NULL) AS appointment,
COUNT_IF(gender IS NULL) AS gender,
COUNT_IF(scheduled_day IS NULL) AS schedule,
COUNT_IF(appointment_day IS NULL) AS appointment_day,
COUNT_IF(age IS NULL) AS age,
COUNT_IF(neighbourhood IS NULL) AS neighbour
FROM
  noshow_appointment_raw;
