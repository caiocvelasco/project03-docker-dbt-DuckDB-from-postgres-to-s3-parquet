-- models/bronze/support_interactions.sql
-- Transformations:
    -- No transformations were made as the Bronze layer functions as a Raw/Landing layer of the ingestion step.

-- The line below saves the dbt model externally as parquet. There are also other options. Check: https://github.com/duckdb/dbt-duckdb?tab=readme-ov-file#writing-to-external-files
-- {{ config(materialized='external', location='/workspace/external_ingestion/bronze_parquet_output/support_interactions.parquet') }}
{{ config(materialized='external', location='s3://dbt-duckdb-ingestion-s3-parquet/support_interactions/support_interactions.parquet') }}

select
    "InteractionID" as interaction_id,
    "CustomerID" as customer_id,
    "DateID" as date_id,
    "IssueType" as issue_type,
    "ResolutionTime" as resolution_time
    -- "extracted_at",                            -- Does not exist in the CSV file
    -- current_timestamp as inserted_at           -- Overwrite with current timestamp (Does not exist in the CSV file)
from {{ source('data','support_interactions') }}  -- Here, 'data' comes from the 'name:' tag in the sources.yml
