-- models/bronze/subscriptions.sql
-- Transformations:
    -- No transformations were made as the Bronze layer functions as a Raw/Landing layer of the ingestion step.

-- The line below saves the dbt model externally as parquet. There are also other options. Check: https://github.com/duckdb/dbt-duckdb?tab=readme-ov-file#writing-to-external-files
-- {{ config(materialized='external', location='/workspace/external_ingestion/bronze_parquet_output/subscriptions.parquet') }}

{{ config(materialized='external', location='s3://dbt-duckdb-ingestion-s3-parquet/subscriptions/subscriptions.parquet') }}

select
    "SubscriptionID" as subscription_id,
    "CustomerID" as customer_id,
    "StartDate" as start_date,
    "EndDate" as end_date,
    "Type" as type,
    "Status" as status
    -- "extracted_at",                     -- Does not exist in the CSV file
    -- current_timestamp as inserted_at    -- Overwrite with current timestamp (Does not exist in the CSV file)
from {{ source('data','subscriptions') }}  -- Here, 'data' comes from the 'name:' tag in the sources.yml
