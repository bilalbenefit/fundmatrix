select * from {{ source('datawarehouse', 'transactions') }}
