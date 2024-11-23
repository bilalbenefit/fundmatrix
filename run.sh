docker volume prune
docker compose up -d
python data_ingestion.py
source raw_table.sh