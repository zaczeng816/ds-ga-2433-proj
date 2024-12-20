# Medical Records Management System

## Overview

This project is a comprehensive medical records management system that combines traditional relational database storage (MySQL) with modern NoSQL solutions (DynamoDB) and includes a machine learning component for insurance premium predictions.

## Features

### 1. Data Storage

-   **MySQL RDS**: Stores customer information, claims, and invoices
-   **DynamoDB**: Handles medical records including health checkups, medical visits, and lab reports
-   **Optimized Database Performance**: Includes indexing, partitioning, and materialized views

### 2. Machine Learning Component

-   Premium prediction based on health metrics using XGBoost
-   Features considered:
    -   BMI
    -   Blood Pressure (Systolic & Diastolic)
    -   Pulse Rate
    -   Temperature
    -   Hypertension Status
-   Model Performance:
    -   RMSE: $76.32
    -   R2 Score: 0.5127

### 3. API Endpoints

-   User Authentication
-   Profile Management
-   Premium Prediction
-   Medical Record Access

## Technical Stack

### Backend

-   Python Flask
-   SQLAlchemy ORM
-   AWS Services:
    -   RDS (MySQL)
    -   DynamoDB
-   XGBoost for ML

### Database Schema

-   Customer Information
-   Medical Records
-   Claims Processing
-   Invoice Management

## Setup Instructions

1. Clone the repository:

```bash
git clone https://github.com/wlw2021/dms-final-4.git
git submodule update --init
```

2. Initialize the databases:

```bash
python initialize_dynamo.py
python final/final-search.py
```

3. Run the Flask application:

```bash
python app.py
```
