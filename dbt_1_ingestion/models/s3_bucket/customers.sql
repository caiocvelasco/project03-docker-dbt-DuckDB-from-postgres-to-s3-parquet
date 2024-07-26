-- models/bronze/customers.sql
-- Transformations:
    -- No transformations were made as the Bronze layer functions as a Raw/Landing layer of the ingestion step.
-- from {{ source('data','customers') }}   -- References the CSV files in a folder external to this dbt project, as defined in "/workspace/dbt_1_ingestion/models/sources/internal.yaml"

-- The line below saves the dbt model externally as parquet. There are also other options. Check: https://github.com/duckdb/dbt-duckdb?tab=readme-ov-file#writing-to-external-files
-- {{ config(materialized='external', location='/workspace/external_ingestion/bronze_parquet_output/customers.parquet') }}

{{ config(materialized='external', location='s3://dbt-duckdb-ingestion-s3-parquet/customers/customers.parquet') }}

select
    "CustomerID" as customer_id,
    "Name" as name,
    "Age" as age,
    "Gender" as gender,
    "SignupDate" as signup_date
    -- "extracted_at",                   -- Does not exist in the CSV file
    -- current_timestamp as inserted_at  -- Overwrite with current timestamp (Does not exist in the CSV file)
from {{ source('data','customers') }}    -- Here, 'data' comes from the 'name:' tag in the sources.yml