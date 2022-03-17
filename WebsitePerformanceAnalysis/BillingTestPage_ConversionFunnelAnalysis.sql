## Business context:
# Website Manager launched new updated billing page, /billing-2,
# Is \billing-2 doing any better than \billing-1?
# What % of sessions on those pages end up placing an order

# Time period November 10 2012 - November 10 2012 



# Step 1.  determine the first time the billing-2 page was shown, first pageview_id
# Step 2.  identify each relevant pageview as specific funnel step
# Step 3.  create the session-level conversion funnel view
# Step 4.  aggregate the data and assess funnel performance



create temporary table first_pageview
select 
	min(created_at) as first_created_at,
    min(website_pageview_id) as min_pageview_id
from website_pageviews
where pageview_url = '/billing-2'
and created_at is not null;

# min_pageview_id = 53550
# first_created_at = 2012-09-10



select 
	website_pageviews.website_session_id,
    website_pageviews.pageview_url as billing_version_seen
from website_pageviews
	left join orders
		on orders.website_session_id = website_pageviews.website_session_id

where website_pageviews.website_pageview_id >= 53550
	and website_pageviews.created_at < '2012-11-10'
    and website_pageviews.pageview_url in ('/billing', '/billing-2');

    
    
select 
	billing_version_seen,
    count(distinct website_session_id) as sessions,
    count(distinct order_id) as orders,
    count(distinct order_id)/count(distinct website_session_id) as billing_to_order_rate
from (
select 
	website_pageviews.website_session_id,
    website_pageviews.pageview_url as billing_version_seen,
    orders.order_id
from website_pageviews
	left join orders
		on orders.website_session_id = website_pageviews.website_session_id

where website_pageviews.website_pageview_id >= 53550
	and website_pageviews.created_at < '2012-11-10'
    and website_pageviews.pageview_url in ('/billing', '/billing-2')
    
) as billing_sessions_with_order

group by billing_version_seen;

    
    
