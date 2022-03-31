/*
Company launched a second product on Janurary 6th. Lets pull trended analysis since then to April 5th 2013.
Monthly order volume, overall conversion rates, revenue per session, and a breakdown of sales by product
for the time period April 1, 2012.


*/


# Product-2 had a large order volume when launched but quickly dropped off.

select 
YEAR(website_sessions.created_at) as yr,
MONTH(website_sessions.created_at) as mth,
COUNT(distinct website_sessions.website_session_id) as session_vol,
COUNT(distinct orders.order_id) as order_vol,
COUNT(distinct orders.order_id)
/COUNT(distinct website_sessions.website_session_id) as conversion_rate,
SUM(orders.price_usd)/COUNT(distinct website_sessions.website_session_id)  as revenue_per_session,
COUNT( DISTINCT CASE WHEN orders.primary_product_id = 1 then orders.order_id else null end) as product_1_orders,
COUNT( DISTINCT CASE WHEN orders.primary_product_id  = 2 then orders.order_id else null end) as product_2_orders
from website_sessions left join orders on website_sessions.website_session_id = orders.website_session_id
where website_sessions.created_at between '2012-04-01' and '2013-04-01'
group by 1,2;
