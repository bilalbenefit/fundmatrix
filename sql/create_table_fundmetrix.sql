create table cashflow_categories (
    cashflow_category_id serial primary key
    , cashflow_category varchar
);

insert into cashflow_categories (cashflow_category)
select distinct cashflow_category
from fundmatrix;


create table cashflow_details (
    cashflow_detail_id serial primary key
    , cashflow_detail_type varchar
);

insert into cashflow_details (cashflow_detail_type)
select distinct cashflow_type_detail
from fundmatrix;


create table cashflow (
    cashflow_id serial primary key
    , cashflow_type varchar
);

insert into cashflow (cashflow_type)
select distinct cashflow_type
from fundmatrix;


create table destinations (
    destination_id serial primary key
    , destination varchar
);

insert into destinations (destination)
select distinct destination
from fundmatrix;


create table pay_periods (
    pay_period_id serial primary key
    , pay_period varchar
);

insert into pay_periods (pay_period)
select distinct pay_period
from fundmatrix;


create table source_bank (
    source_id serial primary key
    , source_bank varchar
);

insert into source_bank (source_bank)
select distinct source
from fundmatrix;


create table transaction_methods (
    transaction_method_id serial primary key
    , transaction_method varchar
);

insert into transaction_methods (transaction_method)
select distinct transaction_method
from fundmatrix;

create table transactions (
    transaction_id serial primary key
    , transaction_date date
    , pay_period_id int
    , source_id int
    , cashflow_id int
    , cashflow_detail_id int
    , cashflow_category_id int
    , destination_id int
    , transaction_method_id int
    , nominal int
    , transaction_info varchar
    , foreign key (pay_period_id) references pay_periods (pay_period_id) on delete cascade
    , foreign key (source_id) references source_bank (source_id) on delete cascade
    , foreign key (cashflow_id) references cashflow (cashflow_id) on delete cascade
    , foreign key (cashflow_detail_id) references cashflow_details (cashflow_detail_id) on delete cascade
    , foreign key (cashflow_category_id) references cashflow_categories (cashflow_category_id) on delete cascade
    , foreign key (destination_id) references destinations (destination_id) on delete cascade
    , foreign key (transaction_method_id) references transaction_methods (transaction_method_id) on delete cascade
);

insert into transactions (
    transaction_date
    , pay_period_id
    , source_id
    , cashflow_id
    , cashflow_detail_id
    , cashflow_category_id
    , destination_id
    , transaction_method_id
    , nominal
    , transaction_info
)
with trans as (
    select
        fundmatrix.transaction_date
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
        , fundmatrix.nominal
        , fundmatrix.transaction_info
    from fundmatrix as fundmatrix
    left join cashflow_categories as cashflowcategory
        on fundmatrix.cashflow_category = cashflowcategory.cashflow_category
    left join cashflow_details as cashflowdetail
        on fundmatrix.cashflow_type_detail = cashflowdetail.cashflow_detail_type
    left join cashflow as cashflow
        on fundmatrix.cashflow_type = cashflow.cashflow_type
    left join destinations as destination
        on fundmatrix.destination = destination.destination
    left join pay_periods as payperiod
        on fundmatrix.pay_period = payperiod.pay_period
    left join source_bank as sourcebank
        on fundmatrix.source = sourcebank.source_bank
    left join transaction_methods as transactionmethod
        on fundmatrix.transaction_method = transactionmethod.transaction_method
    order by 1
)

select
    transaction_date
    , pay_period_id
    , source_id
    , cashflow_id
    , cashflow_detail_id
    , cashflow_category_id
    , destination_id
    , transaction_method_id
    , nominal
    , transaction_info
from trans
order by 1;
