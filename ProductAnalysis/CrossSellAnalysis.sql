/*

As of September 25th 2013, Customers have the option to add a 2nd product while on the /cart page.

What is the impact of this change? 

We will analyze:
click-through-rate from the /cart page, 
Avg Products per Order, 
AOV, 
Overall Revenue per /cart-page view

Step 1. Identify the relevant /cart page sessions
Step 2. See which of those /cart sessions clicked to the shipping page
Step 3. Find the orders associated with /cart sessions. Analyze metrics.
Step 4. Aggregate and analyze a summary of findings.

*/

create temporary table sessions_seeing_cart
select
case
when created_at < '2013-09-25' then 'Before-Cross-Sell'
when created_at >= '2013-01-06' then 'After-Cross-Sell'
else 'Error in date logic'
end as time_period,

website_session_id as cart_session_id,
website_pageview_id as cart_pageview_id

from website_pageviews
where created_at between '2013-08-25' and  '2013-10-25'
and pageview_url = '/cart';




create temporary table sessions_hitting_another_page
select
sessions_seeing_cart.time_period,
sessions_seeing_cart.cart_session_id,
min(website_pageviews.website_pageview_id) as pageview_id_after_cart
from sessions_seeing_cart left join website_pageviews
    on website_pageviews.website_session_id = sessions_seeing_cart.cart_session_id
and sessions_seeing_cart.cart_pageview_id <  website_pageviews.website_pageview_id       # pageviews after cart
group by 
sessions_seeing_cart.time_period, 
sessions_seeing_cart.cart_session_id
having 
min(website_pageviews.website_pageview_id) is not null;


create temporary table before_after_sessions_orders
select
time_period,
cart_session_id,
order_id,
items_purchased,
price_usd
from sessions_seeing_cart inner join orders 
    on sessions_seeing_cart.cart_session_id = orders.website_session_id;





# Subquery:
select 
sessions_seeing_cart.time_period,
sessions_seeing_cart.cart_session_id,
case when sessions_hitting_another_page.cart_session_id is null then 0 else 1 end as hit_another_page,
case when before_after_sessions_orders.order_id is null then 0 else 1 end as placed_order,
before_after_sessions_orders.items_purchased,
before_after_sessions_orders.price_usd

from sessions_seeing_cart
left join sessions_hitting_another_page
    on sessions_seeing_cart.cart_session_id = sessions_hitting_another_page.cart_session_id
left join before_after_sessions_orders 
    on sessions_seeing_cart.cart_session_id = before_after_sessions_orders.cart_session_id
    
order by 
cart_session_id;




select
time_period,
count(distinct cart_session_id) as cart_sessions,
sum(hit_another_page) as clickthroughs,
sum(hit_another_page)/count(distinct cart_session_id) as ctr_rate,
sum(placed_order) as orders_placed,
sum(items_purchased) as products_purchased,
sum(items_purchased)/sum(placed_order) as products_per_order,
sum(price_usd) as revenue,
sum(price_usd)/sum(placed_order) as AOV,
sum(price_usd)/count(distinct cart_session_id) as revenue_per_cart_session
from (
select 
sessions_seeing_cart.time_period,
sessions_seeing_cart.cart_session_id,
case when sessions_hitting_another_page.cart_session_id is null then 0 else 1 end as hit_another_page,
case when before_after_sessions_orders.order_id is null then 0 else 1 end as placed_order,
before_after_sessions_orders.items_purchased,
before_after_sessions_orders.price_usd

from sessions_seeing_cart
left join sessions_hitting_another_page
    on sessions_seeing_cart.cart_session_id = sessions_hitting_another_page.cart_session_id
left join before_after_sessions_orders 
    on sessions_seeing_cart.cart_session_id = before_after_sessions_orders.cart_session_id
    
order by 
cart_session_id
) as full_data

group by time_period;


/*

In general there was benefit from introducting the cross-sell product to customers. 
Most importantly, sessions, clickthroughs, clickthrough_rate, orders, revenue, AOV, and revenue/session
have not decreased.
All metrics are trending positive, indicating this type of new feature could be expanded on.


*/