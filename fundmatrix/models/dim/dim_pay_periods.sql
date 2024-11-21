select * from {{ source('datawarehouse', 'pay_periods') }}
