## Business context:
# Website Manager wants bounce rates for two groups of landing pages

# Step 1.  find out when \lander-1 page first deployed 
# Step 2. find first_website_pageview_id for relevant sessions
# Step 3.  identifying the landing page of each session 
# Step 4.  counting pageviews for each sesssion, to identify 'bounces'
# Step 5.  summarzing total sessions and bounced sessions by landing page






# identifying the pageview_id and first time lander-1 was shown to a customer

# Time period we're looking at is 2012-06-19 to 2012-07-28, first_pageview_id = 23504


select 
	min(website_pageviews.created_at) as first_created_at,								
	min( website_pageviews.website_pageview_id) as first_pageview_id   
from website_pageviews 
where pageview_url = "/lander-1"
and created_at IS NOT NULL;




create temporary table first_test_pageviews
select 
	website_pageviews.website_session_id,
	min( website_pageviews.website_pageview_id) as first_pageview_id   
from website_pageviews 
	inner join website_sessions 
		on website_sessions.website_session_id = website_pageviews.website_session_id
		and website_sessions.created_at < '2012-07-28'
        and website_pageviews.website_pageview_id > 23504     -- The first pageview_id of lander-1 
		and website_sessions.utm_campaign= 'nonbrand'
		and website_sessions.utm_source = 'gsearch'
group by website_pageviews.website_session_id;



-- select * from first_test_pageviews


create temporary table nonbrand_test_sessions_w_landing_page
select
	first_test_pageviews.website_session_id,
    website_pageviews.pageview_url as landing_page
from first_test_pageviews
	left join website_pageviews
		on website_pageviews.website_pageview_id = first_test_pageviews.first_pageview_id
where website_pageviews.pageview_url IN ('/home', '/lander-1');





create temporary table nonbrand_test_bounced_sessions
select 
	nonbrand_test_sessions_w_landing_page.website_session_id,
    nonbrand_test_sessions_w_landing_page.landing_page,
    count(website_pageviews.website_pageview_id) as count_of_pages_viewed
    
from nonbrand_test_sessions_w_landing_page
left join website_pageviews
	on website_pageviews.website_session_id = nonbrand_test_sessions_w_landing_page.website_session_id

group by
	nonbrand_test_sessions_w_landing_page.website_session_id,
    nonbrand_test_sessions_w_landing_page.landing_page

having 
	count(website_pageviews.website_pageview_id) = 1;
	
    
    
    

select
	nonbrand_test_sessions_w_landing_page.landing_page,
	count(distinct nonbrand_test_sessions_w_landing_page.website_session_id) as sessions,
    count(distinct nonbrand_test_bounced_sessions.website_session_id) as bounced_sessions
from nonbrand_test_sessions_w_landing_page
	LEFT JOIN nonbrand_test_bounced_sessions
		on nonbrand_test_sessions_w_landing_page.website_session_id = nonbrand_test_bounced_sessions.website_session_id
group by
	nonbrand_test_sessions_w_landing_page.landing_page;






-- Final output:



 -- Find out when \lander-1 page first deployed 
 
 
select 
	min(website_pageviews.created_at) as first_created_at,								
	min( website_pageviews.website_pageview_id) as first_pageview_id   
from website_pageviews 
where pageview_url = "/lander-1"
and created_at IS NOT NULL;



# The custom lander-1 home page has a lower bounce rate, 52.22% to 58.36%
select
	nonbrand_test_sessions_w_landing_page.landing_page,
  count(distinct nonbrand_test_sessions_w_landing_page.website_session_id) as sessions,
    count(distinct nonbrand_test_bounced_sessions.website_session_id) as bounced_sessions,
    count(distinct nonbrand_test_bounced_sessions.website_session_id)/count( distinct nonbrand_test_sessions_w_landing_page.website_session_id) as bounce_rate

from nonbrand_test_sessions_w_landing_page
	LEFT JOIN nonbrand_test_bounced_sessions
		on nonbrand_test_sessions_w_landing_page.website_session_id = nonbrand_test_bounced_sessions.website_session_id
group by
	nonbrand_test_sessions_w_landing_page.landing_page;

