/*

Monthly trending for revenue and margin by product, along with total sales and revenue. Seasonality noted.

*/




select
year(orders.created_at) as yr,
month(orders.created_at) as mth,
week(orders.created_at) as wk,

/***** product 1 metrics *****/
-- revenue
sum(case when product_level.product_group = 'product-1' then orders.price_usd else null end) as p1_revenue,

-- profit
sum(case when product_level.product_group = 'product-1' then orders.price_usd - orders.cogs_usd else null end) as p1_profit,

-- margin
sum(case when product_level.product_group = 'product-1' then orders.price_usd - orders.cogs_usd else null end)
/
sum(case when product_level.product_group = 'product-1' then orders.price_usd else null end) 
as p1_margin,



/***** product 2 metrics *****/
sum(case when product_level.product_group = 'product-2' then orders.price_usd else null end) as p2_revenue,

sum(case when product_level.product_group = 'product-2' then orders.price_usd - orders.cogs_usd else null end) as p2_profit,

sum(case when product_level.product_group = 'product-2' then orders.price_usd - orders.cogs_usd else null end)
/
sum(case when product_level.product_group = 'product-2' then orders.price_usd else null end) 
as p2_margin,



/***** product 3 metrics *****/
sum(case when product_level.product_group = 'product-3' then orders.price_usd else null end) as p3_revenue,

sum(case when product_level.product_group = 'product-3' then orders.price_usd - orders.cogs_usd else null end) as p3_profit,

sum( case when product_level.product_group = 'product-3' then orders.price_usd - orders.cogs_usd else null end)
/
sum(case when product_level.product_group = 'product-3' then orders.price_usd else null end) 
as p3_margin,



/***** product 4 metrics *****/
sum(case when product_level.product_group = 'product-4' then orders.price_usd else null end) as p4_revenue,

sum(case when product_level.product_group = 'product-4' then orders.price_usd - orders.cogs_usd else null end) as p4_profit,

sum(case when product_level.product_group = 'product-4' then orders.price_usd - orders.cogs_usd else null end)
/
sum(case when product_level.product_group = 'product-4' then orders.price_usd else null end) 
as p4_margin,

sum(orders.price_usd) as total_revenue,
sum(orders.price_usd-orders.cogs_usd) as total_profit,
sum(orders.price_usd-orders.cogs_usd)/sum(orders.price_usd)  as total_margin
from (
select 
product_id,
created_at,
case
when product_id = 1 then 'product-1'
when product_id = 2 then 'product-2'
when product_id = 3 then 'product-3'
when product_id = 4 then 'product-4'
else 'check_product_level'
end as product_group
from products
) as product_level
left join orders
on  orders.primary_product_id = product_level.product_id
group by 1,2,3
order by 1,2,3 asc;



/* ************************************************************************************************************************ */

select
year(orders.created_at) as yr,
month(orders.created_at) as mth,
week(orders.created_at) as wk,

/***** product 1 metrics *****/
-- revenue
sum(case when product_level.product_group = 'product-1' then orders.price_usd else null end) as p1_revenue,

-- profit
sum(case when product_level.product_group = 'product-1' then orders.price_usd - orders.cogs_usd else null end) as p1_profit,

-- margin
sum(case when product_level.product_group = 'product-1' then orders.price_usd - orders.cogs_usd else null end)
/
sum(case when product_level.product_group = 'product-1' then orders.price_usd else null end) 
as p1_margin,



/***** product 2 metrics *****/
sum(case when product_level.product_group = 'product-2' then orders.price_usd else null end) as p2_revenue,

sum(case when product_level.product_group = 'product-2' then orders.price_usd - orders.cogs_usd else null end) as p2_profit,

sum(case when product_level.product_group = 'product-2' then orders.price_usd - orders.cogs_usd else null end)
/
sum(case when product_level.product_group = 'product-2' then orders.price_usd else null end) 
as p2_margin,



/***** product 3 metrics *****/
sum(case when product_level.product_group = 'product-3' then orders.price_usd else null end) as p3_revenue,

sum(case when product_level.product_group = 'product-3' then orders.price_usd - orders.cogs_usd else null end) as p3_profit,

sum( case when product_level.product_group = 'product-3' then orders.price_usd - orders.cogs_usd else null end)
/
sum(case when product_level.product_group = 'product-3' then orders.price_usd else null end) 
as p3_margin,



/***** product 4 metrics *****/
sum(case when product_level.product_group = 'product-4' then orders.price_usd else null end) as p4_revenue,

sum(case when product_level.product_group = 'product-4' then orders.price_usd - orders.cogs_usd else null end) as p4_profit,

sum(case when product_level.product_group = 'product-4' then orders.price_usd - orders.cogs_usd else null end)
/
sum(case when product_level.product_group = 'product-4' then orders.price_usd else null end) 
as p4_margin,

sum(orders.price_usd) as total_revenue,
sum(orders.price_usd-orders.cogs_usd) as total_profit,
sum(orders.price_usd-orders.cogs_usd)/sum(orders.price_usd)  as total_margin
from (
select 
product_id,
created_at,
case
when product_id = 1 then 'product-1'
when product_id = 2 then 'product-2'
when product_id = 3 then 'product-3'
when product_id = 4 then 'product-4'
else 'check_product_level'
end as product_group
from products
) as product_level
left join orders
on  orders.primary_product_id = product_level.product_id
group by 1,2, 3
order by 1,2,3 asc;




/*
Product 2: (Month,Week)   (2,6), (1,1), month of janurary
 
 */

/* ************************************************************************************************************************ */
-- Note that  weeks 46-48, Black Friday and Cyber Monday we see seasonality among all products
-- Valentines day generates larger orders Months 3,2, weeks 10,7.
-- Christmas generates larger orders
-- In general months 12, 11, 1, 2, 10, 3


select
week(orders.created_at) as wk,
year(orders.created_at) as yr,
month(orders.created_at) as mth,


/***** product 1 metrics *****/
-- revenue
sum(case when product_level.product_group = 'product-1' then orders.price_usd else null end) as p1_revenue,

sum(case when product_level.product_group = 'product-1' then orders.price_usd - orders.cogs_usd else null end) as p1_profit,

-- margin
sum(case when product_level.product_group = 'product-1' then orders.price_usd - orders.cogs_usd else null end)
/
sum(case when product_level.product_group = 'product-1' then orders.price_usd else null end) 
as p1_margin,



/***** product 2 metrics *****/
sum(case when product_level.product_group = 'product-2' then orders.price_usd else null end) as p2_revenue,

sum(case when product_level.product_group = 'product-2' then orders.price_usd - orders.cogs_usd else null end) as p2_profit,

sum(case when product_level.product_group = 'product-2' then orders.price_usd - orders.cogs_usd else null end)
/
sum(case when product_level.product_group = 'product-2' then orders.price_usd else null end) 
as p2_margin,



/***** product 3 metrics *****/
sum(case when product_level.product_group = 'product-3' then orders.price_usd else null end) as p3_revenue,

sum(case when product_level.product_group = 'product-3' then orders.price_usd - orders.cogs_usd else null end) as p3_profit,

sum( case when product_level.product_group = 'product-3' then orders.price_usd - orders.cogs_usd else null end)
/
sum(case when product_level.product_group = 'product-3' then orders.price_usd else null end) 
as p3_margin,


/*
Product 4 has not been out long enough to get data from black friday or cyber monday.
-- product 4 metrics 
sum(case when product_level.product_group = 'product-4' then orders.price_usd else null end) as p4_revenue,

sum(case when product_level.product_group = 'product-4' then orders.price_usd - orders.cogs_usd else null end) as p4_profit,

sum(case when product_level.product_group = 'product-4' then orders.price_usd - orders.cogs_usd else null end)
/
sum(case when product_level.product_group = 'product-4' then orders.price_usd else null end) 
as p4_margin,

*/


sum(orders.price_usd) as total_revenue,
sum(orders.price_usd-orders.cogs_usd) as total_profit,
sum(orders.price_usd-orders.cogs_usd)/sum(orders.price_usd)  as total_margin
from (
select 
product_id,
created_at,
case
when product_id = 1 then 'product-1'
when product_id = 2 then 'product-2'
when product_id = 3 then 'product-3'
when product_id = 4 then 'product-4'
else 'check_product_level'
end as product_group
from products
) as product_level
left join orders
on  orders.primary_product_id = product_level.product_id
where week(orders.created_at) in ( '44', '45', '46', '47' '48')
group by 1,2
order by 1 asc;



