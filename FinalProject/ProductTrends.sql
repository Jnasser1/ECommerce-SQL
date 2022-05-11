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
 year(orders.created_at) as yr,
 month(orders.created_at) as mth,
 week(orders.created_at) as wk,
/***** product 1 metrics *****/
-- revenue
sum(case when product_level.product_group = 'product-1' then orders.price_usd else null end) as p1_revenue,

sum(case when product_level.product_group = 'product-1' then orders.price_usd - orders.cogs_usd else null end) as p1_profit,


/***** product 2 metrics *****/
sum(case when product_level.product_group = 'product-2' then orders.price_usd else null end) as p2_revenue,

sum(case when product_level.product_group = 'product-2' then orders.price_usd - orders.cogs_usd else null end) as p2_profit,

/***** product 3 metrics *****/
sum(case when product_level.product_group = 'product-3' then orders.price_usd else null end) as p3_revenue,

sum(case when product_level.product_group = 'product-3' then orders.price_usd - orders.cogs_usd else null end) as p3_profit,



/*
Product 4 has not been out long enough to get data from black friday or cyber monday.
*/

 sum(orders.price_usd) as total_revenue,
 sum(orders.price_usd-orders.cogs_usd) as total_profit
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
order by 1, 2, 3 asc;







select 
 year(orders.created_at) as yr,
 month(orders.created_at) as mth,
 week(orders.created_at) as wk,
 day(orders.created_at) as dy,
sum(orders.price_usd) as revenue
from orders
 group by 1,2,3
 order by revenue desc;
 

create temporary table revenue
with weekly_revenue as (
select 
 year(orders.created_at) as yr,
 month(orders.created_at) as mth,
 week(orders.created_at) as wk,
  day(orders.created_at) as dy,
sum(orders.price_usd) as revenue
from orders
 group by 1,2,3
 order by 1,2,3 asc
 ) 
select
 yr,
mth,
wk,
revenue,
LAG(revenue,1) OVER ( ORDER BY yr, mth, wk, dy asc )  as previous_week_revenue,
(revenue/ ( LAG(revenue,1)  OVER ( ORDER BY yr, mth, wk, dy asc )) - 1) as percent_change_from_previous_day
from  weekly_revenue;


select * from revenue
order by percent_change_from_previous_day desc;

