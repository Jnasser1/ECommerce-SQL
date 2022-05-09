/*

Overall session and order volume, trended quarter for the life of the company (2012-03-19 -- 2015-03-19)

*/

select 
year(website_sessions.created_at) as yr,
quarter(website_sessions.created_at) as qtr,
count(distinct website_sessions.website_session_id) as sessions,
count(distinct orders.order_id) as orders,
count(distinct orders.order_id) / count(distinct website_sessions.website_session_id)  as conv_rate
from website_sessions left join orders
on website_sessions.website_session_id = orders.website_session_id
group by 1,2
order by 1,2;



/*

Efficency improvements: Quarterly figures since company launch:  conversion rates, revenue/order, and revenue/session

*/

select 
year(website_sessions.created_at) as yr,
quarter(website_sessions.created_at) as qrt,
count(distinct orders.order_id) / count(distinct website_sessions.website_session_id)  as conv_rate,
sum(orders.price_usd)/ count(distinct orders.order_id) as revenue_per_order,
sum(orders.price_usd) / count(distinct website_sessions.website_session_id) as revenue_per_session
from website_sessions left join orders
on website_sessions.website_session_id = orders.website_session_id
group by 1,2
order by 1,2;


/*

Channel growth: Quarterly view of orders for:
gsearch nonbrand, bsearch nonbrand, brand search overall, organic search, and direct-type-in

*/


/*
Isolating channels for case and pivot

select distinct utm_source, utm_campaign, http_referer
from website_sessions;
*/



select
year(channel_level.created_at) as yr,
quarter(channel_level.created_at) as qrt,
count(distinct case when channel_level.channel_group = 'gsearch_nonbrand' then orders.order_id else null end) as gsearch_nonbrand_orders,
count(distinct case when channel_level.channel_group = 'bsearch_nonbrand' then orders.order_id else null end) as bsearch_nonbrand_orders,
count(distinct case when channel_level.channel_group = 'brand_overall' then orders.order_id else null end) as brand_orders,
count(distinct case when channel_level.channel_group = 'direct_type_in' then orders.order_id else null end) as direct_type_in_orders,
count(distinct case when channel_level.channel_group = 'organic_search' then orders.order_id else null end) as organic_search_orders,
count(distinct case when channel_level.channel_group = 'other_channel' then orders.order_id else null end) as other_channel_orders
from (
select 
website_sessions.website_session_id,
website_sessions.created_at,
case
when utm_source = 'gsearch' and utm_campaign = 'nonbrand' then 'gsearch_nonbrand'
when utm_source = 'bsearch' and utm_campaign = 'nonbrand' then 'bsearch_nonbrand'
when utm_campaign = 'brand' then 'brand_overall'
when utm_source is null and http_referer is null then 'direct_type_in'
when utm_source is null and http_referer in ('https://www.gsearch.com', 'https://www.bsearch.com', 'socialbook.com' ) then 'organic_search'
else 'other_channel'
end as channel_group
from website_sessions
) as channel_level
left join orders
on  orders.website_session_id = channel_level.website_session_id
group by 1,2
order by 1 asc;


/*

Overall rates:
session-to-order conversion rates, trended for the same channels, by quarter
identifying points of website optimization

*/



select
year(channel_level.created_at) as yr,
quarter(channel_level.created_at) as qrt,

## gsearch
count(distinct case when channel_level.channel_group = 'gsearch_nonbrand' then orders.order_id else null end)
/ 
count(distinct case when channel_level.channel_group = 'gsearch_nonbrand' then channel_level.website_session_id else null end)
as gsearch_nonbrand_conv_rate,


## bsearch
count(distinct case when channel_level.channel_group = 'bsearch_nonbrand' then orders.order_id else null end) 
/ 
count(distinct case when channel_level.channel_group = 'bsearch_nonbrand' then channel_level.website_session_id else null end)
as bsearch_nonbrand_conv_rate,


## direct-type-in 
count(distinct case when channel_level.channel_group = 'direct_type_in' then orders.order_id else null end)
/ 
count(distinct case when channel_level.channel_group = 'direct_type_in' then channel_level.website_session_id else null end)
as direct_type_in_conv_rate,


## organic search
count(distinct case when channel_level.channel_group = 'organic_search' then orders.order_id else null end)
/ 
count(distinct case when channel_level.channel_group = 'organic_search' then channel_level.website_session_id else null end)
as organic_search_conv_rate,


## other channels
count(distinct case when channel_level.channel_group = 'other_channel' then orders.order_id else null end) 
/ 
count(distinct case when channel_level.channel_group = 'other_channel' then channel_level.website_session_id else null end)
as other_channels_conv_rate

from (
select 
website_sessions.website_session_id,
website_sessions.created_at,
case
when utm_source = 'gsearch' and utm_campaign = 'nonbrand' then 'gsearch_nonbrand'
when utm_source = 'bsearch' and utm_campaign = 'nonbrand' then 'bsearch_nonbrand'
when utm_campaign = 'brand' then 'brand_overall'
when utm_source is null and http_referer is null then 'direct_type_in'
when utm_source is null and http_referer in ('https://www.gsearch.com', 'https://www.bsearch.com', 'socialbook.com' )  then 'organic_search'
else 'other_channel'
end as channel_group
from website_sessions
) as channel_level
left join orders
on  orders.website_session_id = channel_level.website_session_id
group by 1,2
order by 1 asc;

