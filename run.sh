export DBT_PROFILES_DIR=$(pwd)/dbt-profiles
export $(cat .env | xargs)

docker compose up -d
python data_ingestion.py

container="datawarehouse"
db_name=${db_name}
user=${db_user}
sql_file="./sql/create_table_fundmetrix.sql"

docker exec -i "$container" psql -U "$user" -d "$db_name" < "$sql_file"

cd fundmatrix
dbt run && dbt test