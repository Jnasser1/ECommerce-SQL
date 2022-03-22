
# Requested trend data for stakeholders of the company.
# Monthly trends for session volume and orders by device type, and channel between '2012-03-18' and '2012-11-27'




#  Monthly trends for gsearch sessions and orders to showcase growth.

select 
	MONTH(website_sessions.created_at) as MTH,
    COUNT(distinct website_sessions.website_session_id) as sessions,
    COUNT(distinct orders.order_id) as orders
from website_sessions left join orders on website_sessions.website_session_id = orders.website_session_id
where website_sessions.created_at between '2012-03-18' and '2012-11-27'
and website_sessions.utm_source = 'gsearch'
group by 1
order by 1;



# A monthly trend for Gsearch, but splitting out nonbrand and brand campaigns separately. 
#The question is whether brand is starting to pick up traffic, so far nonbrand has driven traffic.


# We find nonbrand sessions still comprimise 95.67% of total sessions as of November 2012.
select 
	MONTH(created_at) as MTH,
 #   MIN(website_sessions.created_at) as week_start_date,
    COUNT(distinct CASE WHEN utm_campaign = 'nonbrand' THEN website_session_id ELSE NULL END ) AS nonbrand_sessions,
    COUNT(distinct CASE WHEN utm_campaign = 'brand' THEN website_session_id ELSE NULL END) AS brand_sessions,
	COUNT(distinct CASE WHEN utm_campaign = 'nonbrand' THEN website_session_id ELSE NULL END )/COUNT(distinct website_sessions.website_session_id)*100 as nonbrand_session_percent_of_total,
    COUNT(distinct CASE WHEN utm_campaign = 'brand' THEN website_session_id ELSE NULL END)/COUNT(distinct website_sessions.website_session_id)*100 as brand_session_percent_of_total
from website_sessions 
where website_sessions.created_at between '2012-03-18' and '2012-11-27'
and website_sessions.utm_source = 'gsearch'
group by 1;



# The CEO requests monthly sessions and orders split by device type for gsearch, nonbrand traffic. 
# We want to show we know where are traffic is coming from.

# Sessions
select 
	MONTH(website_sessions.created_at) as MTH,
 #   MIN(website_sessions.created_at) as week_start_date,
     COUNT(distinct CASE WHEN device_type = 'desktop' THEN website_sessions.website_session_id ELSE NULL END ) AS desktop_sessions,
    COUNT(distinct CASE WHEN device_type = 'mobile' THEN website_sessions.website_session_id ELSE NULL END) AS mobile_sessions,
	COUNT(distinct CASE WHEN device_type = 'desktop' THEN website_sessions.website_session_id ELSE NULL END )/COUNT(distinct website_sessions.website_session_id)*100 as desktop_sessions_percent_of_total,
     COUNT(distinct CASE WHEN device_type = 'mobile' THEN website_sessions.website_session_id ELSE NULL END)/COUNT(distinct website_sessions.website_session_id)*100 as mobile_sessions_percent_of_total
from website_sessions
where website_sessions.created_at between '2012-03-18' and '2012-11-27'
and website_sessions.utm_source = 'gsearch'
and website_sessions.utm_campaign = 'nonbrand'
group by 1;



# Orders  desktop starts 83.3% and at the beginning of Novemeber 2012 makes up 90.73% of total orders.

select 
	MONTH(website_sessions.created_at) as MTH,
    MIN(website_sessions.created_at) as week_start_date,
	COUNT(distinct CASE WHEN device_type = 'desktop' THEN orders.order_id ELSE NULL END ) AS desktop_orders,
    COUNT(distinct CASE WHEN device_type = 'mobile' THEN orders.order_id ELSE NULL END) AS mobile_orders,
    COUNT(distinct CASE WHEN device_type = 'desktop' THEN orders.order_id ELSE NULL END )/COUNT(distinct orders.order_id)*100 as desktop_orders_percent_of_total,
	COUNT(distinct CASE WHEN device_type = 'mobile' THEN orders.order_id ELSE NULL END) /COUNT(distinct orders.order_id)*100 as mobile_orders_percent_of_total
from website_sessions left join orders on website_sessions.website_session_id = orders.website_session_id
where website_sessions.created_at between '2012-03-18' and '2012-11-27'
and website_sessions.utm_source = 'gsearch'
and website_sessions.utm_campaign = 'nonbrand'
group by 1;





# Both Sessions and Orders monthly trend data split by device type for nonbrand, gsearch, up until November 27th, 2012.

select 
	MONTH(website_sessions.created_at) as MTH,
	WEEK(website_sessions.created_at) as WK,
    MIN(website_sessions.created_at) as week_start_date,
     COUNT(distinct CASE WHEN device_type = 'desktop' THEN website_sessions.website_session_id ELSE NULL END ) AS desktop_sessions,
    COUNT(distinct CASE WHEN device_type = 'mobile' THEN website_sessions.website_session_id ELSE NULL END) AS mobile_sessions,
	COUNT(distinct CASE WHEN device_type = 'desktop' THEN website_sessions.website_session_id ELSE NULL END )/COUNT(distinct website_sessions.website_session_id)*100 as desktop_sessions_percent_of_total,
     COUNT(distinct CASE WHEN device_type = 'mobile' THEN website_sessions.website_session_id ELSE NULL END)/COUNT(distinct website_sessions.website_session_id)*100 as mobile_sessions_percent_of_total,
    -- orders
	COUNT(distinct CASE WHEN device_type = 'desktop' THEN orders.order_id ELSE NULL END ) AS desktop_orders,
    COUNT(distinct CASE WHEN device_type = 'mobile' THEN orders.order_id ELSE NULL END) AS mobile_orders,
    COUNT(distinct CASE WHEN device_type = 'desktop' THEN orders.order_id ELSE NULL END )/COUNT(distinct orders.order_id)*100 as desktop_orders_percent_of_total,
	COUNT(distinct CASE WHEN device_type = 'mobile' THEN orders.order_id ELSE NULL END) /COUNT(distinct orders.order_id)*100 as mobile_orders_percent_of_total
    
from website_sessions left join orders on website_sessions.website_session_id = orders.website_session_id
where website_sessions.created_at between '2012-03-18' and '2012-11-27'
and website_sessions.utm_source = 'gsearch'
and website_sessions.utm_campaign = 'nonbrand'
group by 2
order by 3;




# monthly trends for Gsearch, alongside monthly trends for other channels.
# utm_sources are gsearch and bsearch, or neither (NULL)


select 
	MONTH(website_sessions.created_at) as MTH,
	WEEK(website_sessions.created_at) as WK,
    MIN(website_sessions.created_at) as week_start_date,
     COUNT(distinct CASE WHEN utm_source = 'gsearch' THEN website_sessions.website_session_id ELSE NULL END ) AS gsearch_sessions,
    COUNT(distinct CASE WHEN utm_source = 'bsearch' THEN website_sessions.website_session_id ELSE NULL END) AS bsearch_sessions,
        COUNT(distinct CASE WHEN utm_source IS NULL THEN website_sessions.website_session_id ELSE NULL END) AS nullsearch_sessions,
	COUNT(distinct CASE WHEN utm_source = 'gsearch' THEN website_sessions.website_session_id ELSE NULL END )/COUNT(distinct website_sessions.website_session_id)*100 as gsearch_sessions_percent_of_total,
     COUNT(distinct CASE WHEN utm_source = 'bsearch' THEN website_sessions.website_session_id ELSE NULL END)/COUNT(distinct website_sessions.website_session_id)*100 as bsearch_sessions_percent_of_total,
     COUNT(distinct CASE WHEN utm_source IS NULL THEN website_sessions.website_session_id ELSE NULL END)/COUNT(distinct website_sessions.website_session_id)*100 AS null_sessions_percent_of_total
     
    -- orders
#	,COUNT(distinct CASE WHEN utm_source = 'gsearch' THEN orders.order_id ELSE NULL END ) AS gsearch_orders,
#    COUNT(distinct CASE WHEN utm_source = 'bsearch' THEN orders.order_id ELSE NULL END) AS bsearch_orders,
#    COUNT(distinct CASE WHEN utm_source IS NULL THEN orders.order_id ELSE NULL END) AS null_orders,
#    COUNT(distinct CASE WHEN utm_source = 'gsearch' THEN orders.order_id ELSE NULL END )/COUNT(distinct orders.order_id)*100 as gsearch_orders_percent_of_total,
#	COUNT(distinct CASE WHEN utm_source = 'bsearch' THEN orders.order_id ELSE NULL END) /COUNT(distinct orders.order_id)*100 as bsearch_orders_percent_of_total,
#   COUNT(distinct CASE WHEN utm_source IS NULL THEN orders.order_id ELSE NULL END)/COUNT(distinct orders.order_id)*100 AS null_orders_percent_of_total
from website_sessions left join orders on website_sessions.website_session_id = orders.website_session_id
where website_sessions.created_at between '2012-03-18' and '2012-11-27'
group by 2
order by 3;