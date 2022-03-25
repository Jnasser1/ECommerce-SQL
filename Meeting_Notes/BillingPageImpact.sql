
/*
Quantify the impact of the custom billing page test. 
Analyze the lift generated from the test ( Sep 10 - Nov 10) in terms of revenue per billing page, 
then pull the number of billing page sessions for the past month to understand monthly impact.
*/



#  Subquery: For each session_id from the test date range, 
# we collect what billing version they saw, the order_id, and price of the item they purchased

# From the information in the subquery:
# For each billing version seen we get the total sessions and revenue per billing page




select 
	billing_version_seen,
    count(distinct website_session_id) as sessions,
    sum(price_usd)/count(distinct website_session_id) as revenue_per_billing_page_seen
from (
select
	website_pageviews.website_session_id,
    website_pageviews.pageview_url as billing_version_seen,
    orders.order_id,
    orders.price_usd
from website_pageviews
	left join orders
		on orders.website_session_id = website_pageviews.website_session_id
where website_pageviews.created_at > '2012-09-10' 	
    and website_pageviews.created_at < '2012-11-10'   -- Test date requested 
    and website_pageviews.pageview_url in ('/billing', '/billing-2')
) as billing_pageviews_and_order_data
group by 1;


# Revenue per billing page seen values:
# /billing : $22.83
# /billing-2: $31.34
# Lift : $8.52 per billing page view


# Number of billing page sessions for the past month (Oct 27 - Nov 27) to understand monthly impact




select 
	count(website_session_id) as billing_sessions_past_month
from website_pageviews
where website_pageviews.pageview_url in ('/billing', '/billing-2')
and website_pageviews.created_at between '2012-10-27' and '2012-11-27'

# Total billing sessions the past month = 1194.
# Each billing session is now worth $8.51 more to the company (lift)
# Total revenue impact of billing test: $10,160 over the past month

