-- models/bronze/product_usage.sql
-- Transformations:
    -- No transformations were made as the Bronze layer functions as a Raw/Landing layer of the ingestion step.

-- The line below saves the dbt model externally as parquet. There are also other options. Check: https://github.com/duckdb/dbt-duckdb?tab=readme-ov-file#writing-to-external-files
-- {{ config(materialized='external', location='/workspace/external_ingestion/bronze_parquet_output/product_usage.parquet') }}

{{ config(materialized='external', location='s3://dbt-duckdb-ingestion-s3-parquet/product_usage/product_usage.parquet') }}

select
    "UsageID" as usage_id,
    "CustomerID" as customer_id,
    "DateID" as date_id,
    "ProductID" as product_id,
    "NumLogins" as num_logins,
    "Amount" as amount
    -- "extracted_at",                     -- Does not exist in the CSV file
    -- current_timestamp as inserted_at    -- Overwrite with current timestamp (Does not exist in the CSV file)
from {{ source('data','product_usage') }}  -- Here, 'data' comes from the 'name:' tag in the sources.yml