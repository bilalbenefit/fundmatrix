select * from {{ source('datawarehouse', 'cashflow_details') }}
