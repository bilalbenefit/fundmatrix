with trans as (
    select
        transactions.transaction_id
        , transactions.transaction_date
        , payperiod.pay_period_id
        , payperiod.pay_period
        , sourcebank.source_id
        , sourcebank.source_bank
        , cashflow.cashflow_id
        , cashflow.cashflow_type
        , cashflowdetail.cashflow_detail_id
        , cashflowdetail.cashflow_detail_type
        , cashflowcategory.cashflow_category_id
        , cashflowcategory.cashflow_category
        , destination.destination_id
        , destination.destination
        , transactionmethod.transaction_method_id
        , transactionmethod.transaction_method
        , transactions.nominal
        , transactions.transaction_info
    from {{ ref('fact_transactions') }} as transactions
    left join {{ ref('dim_cashflow_categories') }} as cashflowcategory
        on transactions.cashflow_category_id = cashflowcategory.cashflow_category_id
    left join {{ ref('dim_cashflow_details') }} as cashflowdetail
        on transactions.cashflow_detail_id = cashflowdetail.cashflow_detail_id
    left join {{ ref('dim_cashflow') }} as cashflow
        on transactions.cashflow_id = cashflow.cashflow_id
    left join {{ ref('dim_destinations') }} as destination
        on transactions.destination_id = destination.destination_id
    left join {{ ref('dim_pay_periods') }} as payperiod
        on transactions.pay_period_id = payperiod.pay_period_id
    left join {{ ref('dim_source_bank') }} as sourcebank
        on transactions.source_id = sourcebank.source_id
    left join {{ ref('dim_transaction_methods') }} as transactionmethod
        on transactions.transaction_method_id = transactionmethod.transaction_method_id
)

select
    transaction_id
    , transaction_date
    , pay_period
    , source_bank
    , cashflow_type
    , cashflow_detail_type
    , cashflow_category
    , destination
    , transaction_method
    , nominal
    , transaction_info
from trans
order by 1
