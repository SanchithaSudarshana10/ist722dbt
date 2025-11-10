with
  stg_orders as (
    select
      orderid,
      {{ dbt_utils.generate_surrogate_key(['employeeid']) }} as employeekey,
      {{ dbt_utils.generate_surrogate_key(['customerid']) }} as customerkey,
      replace(to_date(orderdate)::varchar, '-', '')::int as orderdatekey
    from {{ source('northwind','Orders') }}
  ),
  stg_order_details as (
    select
      orderid,
      productid,
      quantity,
      unitprice,
      discount
    from {{ source('northwind','Order_Details') }}
  )

select
  od.orderid,
  o.customerkey,
  o.employeekey,
  o.orderdatekey,
  {{ dbt_utils.generate_surrogate_key(['od.productid']) }} as productkey,
  od.quantity,
  (od.quantity * od.unitprice)                                as extendedpriceamount,
  (od.quantity * od.unitprice * od.discount)                  as discountamount,
  (od.quantity * od.unitprice) - (od.quantity * od.unitprice * od.discount) as soldamount
from stg_order_details od
join stg_orders o
  on o.orderid = od.orderid
