# dbt-DuckDB: ETL Pipeline with Medallion Architecture & Star Schema (Dockerized Postgres, Jupyter Notebook, and dbt-DuckDB).

<img src = "img\dbt_1_ingestion.jpg">

## Table of Contents

- [Project Structure](#project-structure)
- [Setup Instructions](#setup-instructions)
  - [Prerequisites](#prerequisites)
  - [Environment Variables](#environment-variables)
  - [Build and Run](#build-and-run)
- [Services](#services)
- [dbt](#dbt)
- [Ingestion Step](#ingestion-step)

## Project Structure

- **name_of_your_project_repo (project-root)/**
    - **.devcontainer/**
      - devcontainer.json
    - **databases/**
      - dev.duckdb
    - **dbt_1_ingestion/** (This is where the dbt project is located)
    - **external_ingestion** (This behaves as a Postgres in Prod, which will be used bydbt-DuckDB for ingestion)
    - **.env**
    - **.gitignore**
    - **.python-version**
    - **Dockerfile**
    - **docker-compose.yml**
    - **requirements.txt**
    - **README.md**

## Setup Instructions

### Prerequisites

Make sure you have the following installed on your local development environment:

- [Docker](https://www.docker.com/get-started)
  - PLEASE NOTE: make sure to Enable
    - Go to: `Docker Desktop > Settings > Resources > WSL integration > Click on Enable Button for Ubuntu-22.04`
- [Docker Compose](https://docs.docker.com/compose/install/)
- [VSCode](https://code.visualstudio.com/) with the [Remote - Containers extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)

Make sure to inclue a .gitignore file with the following information:

*.pyc          (to ignore python bytecode files)
.env           (to ignore sensitive information, such as database credentials)
data/          (to ignore CSV files)
s3_stuff/      (to ignore S3 Access Keys and Credentials)
old_stuff/

### Environment Variables
The .gitignore file, ignores the ´.env´ file for security reasons. However, since this is just for educational purposes, follow the step below to include it in your project. If you do not include it, the docker will not work.

Create a `.env` file in the project root with the following content:

- POSTGRES_USER=your_postgres_user
- POSTGRES_PASSWORD=your_postgres_password
- POSTGRES_DB=your_postgres_db
- POSTGRES_HOST=postgres
- POSTGRES_PORT=5432
- JUPYTER_TOKEN=123
- S3_IAM_ROLE_ARN=arn:aws:s3:::dbt-duckdb-ingestion-s3-parquet (you can get this from the jupiter notebook output)
- S3_ACCESS_KEY_ID=your_s3_access_key_id (you can get this from S3)
- S3_SECRET_ACCESS_KEY=your_s3_secret_access_key_id (you can get this from S3)
- S3_REGION=your_region (you can get this from S3)
- S3_BUCKET_NAME=your_bucket_name (you can get this from S3)
- S3_SNOWFLAKE_IAM_ROLE_ARN=arn:aws:iam::533267405478:role/mysnowflakerole (you can get this from the jupiter notebook output)
- S3_SNOWFLAKE_STORAGE_INTEGRATION=your_s3_integration_name (you will create this, check jupyter notebook)
- S3_SNOWFLAKE_STAGE=your_s3_stage_name (you will create this, check jupyter notebook)
- S3_SNOWFLAKE_FILE_FORMAT=your_file_format_name (you will create this, check jupyter notebook)

If you want to check if your Docker environment can see the environment variables, do:
* cd /workspace
* printenv (this will show if the environmental variables were loaded within the Docker container)
* printenv | grep S3 (this functions as a filter to show only the variables that contain 'S3')

### Build and Run

1. **Clone the repository:**

   ```bash
   git clone https://github.com/caiocvelasco/end-to-end-data-science-project.git
   cd end-to-end-data-science-project

2. **Build and start the containers:**

  When you open VSCode, it will automatically ask if you want to reopen the repo folder in a container and it will build for you.

**Note**: I have included the command `"postCreateCommand": "docker image prune -f"` in the **.devcontainer.json** file. Therefore, whenever the docker containeirs are rebuilt this command will make sure to delete the `unused (dangling)` images. The -f argument ensures you don't need to confirm if you want to perform this action.

### Services

* **Postgres**: 
  * A PostgreSQL database instance.
  * Docker exposes port 5432 of the PostgreSQL container to port 5432 on your host machine. This makes service is accessible via `localhost:5432` on your local machine for visualization tools such as PowerBI and Tableau. However, within the docker container environment, the other services will use the postgres _hostname_ as specified in the `.env` file (`POSTGRES_HOST`).
  * To test the database from within the container's terminal: `psql -h $POSTGRES_HOST -p 5432 -U $POSTGRES_USER -d $POSTGRES_DB`
* **DBT**: The Data Build Tool (dbt) for transforming data in the data warehouse.
* **Jupyter Notebook**: A Jupyter Notebook instance for interactive data analysis and for checking the models materialized by dbt.

### dbt

dbt (Data Build Tool) is a development environment that enables data analysts and engineers to transform data in their warehouse more effectively. To use dbt in this project, follow these steps:

1. **Install dbt**
  * The Dockerfile and Docker Compose file will do this for you.
2. **Configure database connection**
  * The `profiles.yml` is located in a `.dbt` folder at `dbt_1_ingestion/.dbt/profiles.yml`.
  * It defines connections to your data warehouse. It also uses environment variables to specify sensitive information like database credentials (which in this case is making reference to the `.env` file that is being ignored by `.gitignore`, so you should have one in the same level as the `docker-compose.yml` - as shown in the folder structure above.)
3. **Install dbt packages**
  * Never forget to run `dbt deps` so that dbt can install the packages within the `packages.yml` file.
4. **Run DBT**
  * Once dbt is installed and configured, you can use it to build your dbt models, which are SQL scripts that will be materialized in your data warehouse of choice.
  * Use the `dbt run` command to run the models against your database and apply transformations.