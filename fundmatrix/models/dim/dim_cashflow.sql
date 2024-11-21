select * from {{ source('datawarehouse', 'cashflow') }}
