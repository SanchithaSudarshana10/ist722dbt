with
  f as (select * from {{ ref('fact_sales') }}),
  d_cust as (select * from {{ ref('dim_customer') }}),
  d_emp  as (select * from {{ ref('dim_employee') }}),
  d_prod as (select * from {{ ref('dim_product') }}),
  d_date as (select * from {{ ref('dim_date') }})

select
  -- dimensions first (wide denormalized view)
  d_cust.*,
  d_emp.*,
  d_prod.*,
  d_date.*,

  -- fact columns (no productkey here; it's already in d_prod.*)
  f.orderid,
  f.orderdatekey,
  f.quantity,
  f.extendedpriceamount,
  f.discountamount,
  f.soldamount
from f
left join d_cust on f.customerkey   = d_cust.customerkey
left join d_emp  on f.employeekey   = d_emp.employeekey
left join d_prod on f.productkey    = d_prod.productkey
left join d_date on f.orderdatekey  = d_date.datekey
