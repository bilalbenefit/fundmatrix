container="datawarehouse"
db_name=${db_name}
user=${db_user}
sql_file="./sql/create_table_fundmetrix.sql"

docker exec -i "$container" psql -U "$user" -d "$db_name" < "$sql_file"