import os
import pandas as pd
from dotenv import load_dotenv
from sqlalchemy import create_engine
from sqlalchemy.types import String, Integer, Date
from sqlalchemy.exc import SQLAlchemyError
from data_procession import DataProcessor


class DataIngest():
    def __init__(self, gsheet, sheet_id, gids) -> None:
        env_path = os.path.join(os.getcwd(), '.env')
        # print(f"Loading .env from: {env_path}")
        load_dotenv(env_path)

        self.gsheet = gsheet
        self.sheet_id = sheet_id
        self.gids = gids
        self.df = None
        self.df = pd.DataFrame
        self.db_name = ""
        self.engine = None
        self.connection = None

    def __create_connection(self):
        host = os.getenv('db_host')
        port = os.getenv('db_port')
        name = os.getenv('db_name')
        user = os.getenv('db_user')
        password = os.getenv('db_pass')

        connection = f"postgresql://{user}:{password}@{host}:{port}/{name}"

        self.engine = create_engine(connection)

    def to_postgres(self, db_name: str, data: pd.DataFrame):
        self.db_name = db_name
        self.__create_connection()

        try:
            df_schema = {
                "transaction_date": Date,
                "pay_period": String,
                "source": String,
                "cashflow_type": String,
                "cashflow_type_detail": String,
                "cashflow_category": String,
                "destination": String,
                "transaction_method": String,
                "nominal": Integer,
                "transaction_info": String
            }

            data.to_sql(name=self.db_name, con=self.engine, if_exists="replace", index=False, schema="public", dtype=df_schema, method=None) # noqa
            print(f"Data sucessfully ingested to {self.db_name}.")
        except SQLAlchemyError as err:
            print("error >> ", err.__cause__)

    def ingest(self) -> None:
        processor = DataProcessor()
        df = processor.process()

        self.to_postgres("fundmatrix", df)


def main():
    gsheet = os.getenv('gsheet')
    sheet_id = os.getenv('sheet_id')
    gids = os.getenv('gids')

    data_ingest = DataIngest(gsheet, sheet_id, gids)
    data_ingest.ingest()


if __name__ == "__main__":
    main()
