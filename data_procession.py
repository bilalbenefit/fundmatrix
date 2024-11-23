import os
import pandas as pd
from dotenv import load_dotenv

pd.set_option('display.max_columns', None)


class DataProcessor:
    def __init__(self) -> None:
        env_path = os.path.join(os.getcwd(), '.env')
        load_dotenv(env_path)

        gids = os.getenv('gids')
        gsheet = os.getenv('gsheet')
        sheet_id = os.getenv('sheet_id')

        if not gids or not gsheet or not sheet_id:
            raise ValueError("gids, gsheet and sheet_id must be in set in .env file") # noqa

        self.gids_list = list(map(int, gids.split(",")))
        self.base_url = f"{gsheet}/{sheet_id}/gviz/tq?tqx=out:csv"
        self.df = None

    def read_sheet(self) -> pd.DataFrame:
        data = []
        for gid in self.gids_list:
            url = f"{self.base_url}&gid={gid}"
            self.df = pd.read_csv(url, usecols=range(10))
            data.append(self.df)
        self.df = pd.concat(data, ignore_index=True)

    def rename_cols(self) -> None:
        self.df = self.df.rename(columns={
            'Tanggal Transaksi': 'transaction_date',
            'Periode Gajian': 'pay_period',
            'Sumber': 'source',
            'Tipe Arus Kas': 'cashflow_type',
            'Tipe Detail Arus Kas': 'cashflow_type_detail',
            'Kategori Arus Kas': 'cashflow_category',
            'Tujuan': 'destination',
            'Metode Transaksi': 'transaction_method',
            'Nominal': 'nominal',
            'Keterangan Transaksi': 'transaction_info'
        })

    def change_type(self) -> None:
        self.df['transaction_date'] = pd.to_datetime(self.df['transaction_date'], format='%d/%m/%Y') # noqa

    def clean_non_digit(self) -> None:
        self.df['nominal'] = self.df['nominal'].str.replace(r'\D', '', regex=True) # noqa

    def process(self) -> pd.DataFrame:
        self.read_sheet()
        self.rename_cols()
        self.change_type()
        self.clean_non_digit()

        return self.df


def main():
    processor = DataProcessor()
    df = processor.process()

    return df


if __name__ == "__main__":
    main()
