## Business context:
# Website Manager requests volume weekly trend data of paid search nonbrand traffic landing on /home and /lander-1
# Also requests overall paid search bounce rate trended weekly

# Time period we're looking at is 2012-06-01 to 2012-08-31


# Step 1.  finding the first website_pageview_id for relevant sessions
# Step 2.  identifying the landing page of each session
# Step 3.  counting pageviews for each session, to identify "bounces"
# Step 4.  summarizing by week (bounce rate, sessions to lander)




create temporary table sessions_w_min_pageview_id_and_view_count
select
	website_sessions.website_session_id,
    min(website_pageviews.website_pageview_id) as first_pageview_id,
    count(website_pageviews.website_pageview_id) as count_pageviews

from website_sessions
	left join website_pageviews
		on website_sessions.website_session_id = website_pageviews.website_session_id
	
where website_sessions.created_at > '2012-06-01'  -- date by requestor
	and website_sessions.created_at < '2012-08-31'
	and website_sessions.utm_campaign= 'nonbrand'
	and website_sessions.utm_source = 'gsearch'
    
group by 
	website_sessions.website_session_id;
    
    
    
-- select * from sessions_w_min_pageview_id_and_view_count;


create temporary table sessions_with_counts_lander_and_created_at
select 
	sessions_w_min_pageview_id_and_view_count.website_session_id,
    sessions_w_min_pageview_id_and_view_count.first_pageview_id,
    sessions_w_min_pageview_id_and_view_count.count_pageviews,
    website_pageviews.pageview_url as landing_page,
    website_pageviews.created_at as session_created_at
    
from sessions_w_min_pageview_id_and_view_count
	left join website_pageviews
		on sessions_w_min_pageview_id_and_view_count.first_pageview_id = website_pageviews.website_pageview_id;
        
	
    
    
-- Final output

# Bounce rates dropped from 60.7% on June 1st to 50% on August 19th.

select 
#	year(session_created_at) as year_week,
    min(date(session_created_at)) as week_start_date,
#   count(distinct website_session_id) as total_sessions,
#   count(distinct case when count_pageviews = 1 then website_session_id else null end) as bounced_sessions,
    count(distinct case when count_pageviews = 1 then website_session_id else null end)  * 1.0/count(distinct website_session_id) as bounce_rate,
	count(distinct case when landing_page = '/home' then website_session_id else null end) as home_sessions,
    count(distinct case when landing_page = '/lander-1' then website_session_id else null end) as lander_sessions
    
from sessions_with_counts_lander_and_created_at

group by
	yearweek(session_created_at);
    













































