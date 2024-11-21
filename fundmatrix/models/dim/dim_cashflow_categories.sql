select * from {{ source('datawarehouse', 'cashflow_categories') }}
