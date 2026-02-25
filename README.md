## Healthcare-No-Show-Analytics-Real-Time-Monitoring-System

 ## Project Overview

Missed medical appointments (No-Shows) create operational inefficiencies, revenue loss, and resource wastage in healthcare systems.

This project builds an end-to-end analytics pipeline to:

Monitor no-show trends

Identify behavioral risk drivers

Enable real-time dashboard visibility

Automate incremental data processing

Experiment with baseline predictive modeling

The solution integrates Snowflake, SQL, Power BI (DirectQuery), and Python (Scikit-learn).

## 🏗 Architecture Overview
🔹 Data Flow

Raw Data → Staging Layer → Fact & Dimension Modeling → Stream & Task Automation → DirectQuery Power BI Dashboard → ML Baseline Model

🔹 Core Components

Snowflake Data Warehouse

Star Schema Modeling

Incremental Data Processing (Streams & Tasks)

DirectQuery Dashboard for Real-Time Visibility

Baseline Logistic Regression Model

## ⚙️ Data Engineering Implementation
1️⃣ Raw Layer

Raw appointment dataset ingestion

File format & stage configuration

COPY INTO for initial load

2️⃣ Staging Layer

Data type conversion

Cleaning & filtering (invalid ages, negative waiting days removed)

Feature engineering (waiting_days)

3️⃣ Star Schema Modeling
Fact Table:

appointment_id

patient_id

waiting_days

day_of_week

sms_received

no_show

Dimension Tables:

dim_patients (age, gender, age_group)

patient_visit_bucket (visit frequency segmentation)

## 🔁 Automation (Incremental Processing)

Implemented Snowflake:

STREAM on Raw and Staging tables

TASK scheduling for incremental ELT

Automatic Raw → Staging → Fact data flow

This eliminates full reloads and enables near real-time updates.

## 📊 Power BI Dashboard (DirectQuery Mode)

Connected Snowflake using DirectQuery for live reporting.

🔹 Page 1 – Performance Overview

Total Appointments

No-Show Rate

SMS Impact

Geographic Distribution

Trend Analysis

🔹 Page 2 – Risk & Behavioral Insights

Age Segment Risk Analysis

Waiting Time Impact

Visit Frequency Behavior

SMS vs Waiting Interaction

Repeat No-Show Patients KPI

The dashboard focuses on actionable operational insights rather than surface-level reporting.

## 🤖 Baseline Predictive Modeling (Exploratory)

A Logistic Regression model was trained to estimate No-Show probability using:

Waiting Days

Day of Week

SMS Received

Age

Gender

Total Visits

## 📈 Model Performance

Accuracy ≈ 79%

ROC-AUC ≈ 0.65

Addressed class imbalance using stratified split and threshold tuning

The predictive model was implemented as a baseline experiment.
The project’s primary focus remains operational analytics and automation.

## 🧠 Key Insights Generated

Longer waiting times significantly increase no-show probability.

Moderate visit-frequency patients (4–5 visits) show elevated risk.

SMS reminders reduce no-show risk, especially for long-wait appointments.

Younger age segments exhibit higher no-show tendencies.

## 🛠 Tech Stack

Snowflake

SQL

Power BI (DirectQuery)

Python

Scikit-learn

Google Colab

VS Code

GitHub

## 🚀 Skills Demonstrated

Data Warehousing & ELT

Star Schema Design

Incremental Processing using Streams & Tasks

Real-Time BI Reporting

Behavioral Analytics

Model Evaluation & Threshold Tuning

End-to-End Analytics Project Architecture

## 📁 Repository Structure
healthcare-no-show-analytics/
│
├── sql/
├── powerbi/
├── ml/
└── README.md
## 📌 Conclusion

This project demonstrates a production-style healthcare analytics solution integrating:

Automated data pipelines

Structured warehouse modeling

Real-time BI reporting

Baseline predictive experimentation

It reflects practical, job-ready data analyst skills with strong engineering fundamentals.


Phir 01_raw_layer.sql push karte hain.

Ready? 💪
