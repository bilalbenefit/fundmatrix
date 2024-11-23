select * from {{ source('datawarehouse', 'destinations') }}
