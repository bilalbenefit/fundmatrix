# fundmatrix
This project aims to build a **financial data pipeline** to streamline the processing and visualization of monthly income and expenses. The pipeline consists of:

## 1. PostgreSQL Database:

Acts as a centralized data warehouse for storing structured financial data.
Automatically initializes with tables defined in the create_table_fundmetrix.sql script.

## 2. Metabase:

A user-friendly business intelligence tool used for creating interactive dashboards and visualizing financial data.
Connects seamlessly to the PostgreSQL database to generate insights from stored data.

## 3. Docker Compose:

Orchestrates the deployment of PostgreSQL and Metabase services in isolated containers.
Ensures the PostgreSQL container is initialized with required environment variables (POSTGRES_USER, POSTGRES_PASSWORD, POSTGRES_DB) loaded from a .env file for flexibility and security.
Automation Features:

The project automatically executes an SQL script during the PostgreSQL container startup, creating tables required for the financial data schema.
Metabase provides a dashboard interface for analyzing income, expenses, and cash flow trends.

## 4. Future Capabilities:

The pipeline can be extended to include ETL/ELT processes, enabling the ingestion of financial records from external sources such as spreadsheets or APIs.
Potential to integrate Airflow and dbt for advanced orchestration and transformation tasks.


This setup simplifies financial record-keeping by consolidating data storage and visualization in a scalable and portable environment, making it suitable for both personal and small business use.
