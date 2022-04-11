/*
What is the impact of adding an additional product?

The company has launched a third product on December 12th, 2013, targeting the birthday gift market.

We will run a before-after analysis comparing the month before vs. the month after, pulling:
Session-to-order conversion rate,  (#order/#sessions)
AOV, (#revenue/#orders)
products per orders,  (#products/#orders)
revenue per session (SUM(prices)/#sessions)

*/

select

case 
when website_sessions.created_at < '2013-12-12' then 'Before' 
when website_sessions.created_at > '2013-12-12' then 'After'
else 'Check date logic'
end as time_period,

# count(distinct website_sessions.website_session_id) as sessions,
# count(distinct orders.order_id) as orders,
# SUM(orders.price_usd) as revenue,

count(distinct orders.order_id)/count(distinct website_sessions.website_session_id) as order_conv_rate,
SUM(orders.price_usd)/count(distinct orders.order_id) as AOV,
SUM(orders.price_usd)/count(distinct website_sessions.website_session_id) as revenue_per_session,
SUM(orders.items_purchased)/count(distinct orders.order_id) as products_per_order

from website_sessions left join orders on
    website_sessions.website_session_id = orders.website_session_id
where website_sessions.created_at between '2013-11-12' and '2014-01-12'
group by 1;



/*
Results:

# time_period | order_conv_rate | AOV	  |  revenue_per_session |	products_per_order
After	        0.0702	         56.931319	   3.998763	         1.1234
Before       	0.0608	         54.226502	   3.298677	         1.0464
*/


/*
Findings:
All key metrics are up. Conversion rate is up 1%, AOV up $2, revenue and products per order slightly up.
This trend shows adding the third product did not hurt growth - it increased it.

Next Steps:
Increasing ad-spend to increase revenue/sessions, adding a fourth product. 

*/