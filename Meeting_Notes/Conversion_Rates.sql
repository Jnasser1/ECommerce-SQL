
# Monthly trends for order rates.

select 
	year(website_sessions.created_at) as YR,
	month(website_sessions.created_at) as MTH,
    min(website_sessions.created_at) as week_start,
    count(distinct website_sessions.website_session_id) as sessions,
    count(distinct orders.order_id) as orders,
    count(distinct orders.order_id)/count(distinct website_sessions.website_session_id) as conversion_rate
from website_sessions left join orders on website_sessions.website_session_id = orders.website_session_id
where website_sessions.created_at between '2012-03-18' and '2012-11-27'
group by 1,2;











/*
Gsearch lander test estimate of revenue gain.
*/

select
	min(website_pageview_id) as first_test_pv
from website_pageviews
where website_pageviews.pageview_url = '/lander-1';


# first_test_pv = 23504




create temporary table first_test_pageviews
select 
	website_pageviews.website_session_id,
    min(website_pageviews.website_pageview_id) as min_pageview_id
from website_pageviews
	inner join website_sessions
    on website_sessions.website_session_id = website_pageviews.website_session_id
    and website_sessions.created_at < '2012-07-28' 		-- prescribed date from CEO
	and website_pageviews.website_pageview_id >= 23504
    and utm_source = 'gsearch'
    and utm_campaign = 'nonbrand'
group by website_pageviews.website_session_id;


# We bring in the landing page to each session, restricting to home or lander-1
create temporary table nonbrand_test_sessions_w_landing_page
select 
	first_test_pageviews.website_session_id,
    website_pageviews.pageview_url as landing_page
from first_test_pageviews
	left join website_pageviews
		on website_pageviews.website_pageview_id = first_test_pageviews.min_pageview_id
where website_pageviews.pageview_url in ('/home', '/lander-1');



# Need a table to bring in orders

create temporary table nonbrand_test_sessions_w_orders
select
	nonbrand_test_sessions_w_landing_page.website_session_id,
    nonbrand_test_sessions_w_landing_page.landing_page,
    orders.order_id as order_id
from nonbrand_test_sessions_w_landing_page
	left join orders
			on orders.website_session_id = nonbrand_test_sessions_w_landing_page.website_session_id;
            
            

# Finding difference between conversion rates:
# /home - 0.0319
# /lander1 - 0.0406
select 
	landing_page,
    count(distinct website_session_id) as sessions,
    count(distinct order_id) as orders,
    count(distinct order_id)/count(distinct website_session_id) as conversion_rate
from nonbrand_test_sessions_w_orders
group by 1;





# Finding the most recent pageview for gsearch nonbrand where the traffic was sent to /home
# since then all traffic has been re-routed
select
	max(website_sessions.website_session_id) as most_recent_gsearch_nonbrand_home_pageview
from website_sessions
	left join website_pageviews
		on website_pageviews.website_session_id = website_sessions.website_sessin_id
where utm_source = 'gsearch'
	and utm_campaign = 'nonbrand'
    and pageview_url = '/home'
    and website_sessions.created_at < '2012-11-27';

# max website_session_id = 17145


# How many sessions since that test?

select 
	count(website_session_id) as sessions_since_test
from website_sessions
where created_at < '2012-11-27'
	and website_session_id > 17145
    and utm_source = 'gsearch'
    and utm_campaign = 'nonbrand';
   

# 22972 sessons_since_test

## difference in conversion rate = (0.0406-0.0319) = 0.0087  = lift
## 22972 * 0.0087 ~ 200 so for four months roughly 50 extra orders per month from the new home-page



