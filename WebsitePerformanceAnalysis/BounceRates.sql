# Situation: Website Manager requests sessions, bounced sessions, and bounce rate for traffic landing at the homepage. June 14th 2012

# Bounce rate is single-page sessions divided by all sessions, or the percentage of all sessions
# on your site in which users viewed only a single page and triggered only a single request to the Analytics server


-- Step 1: finding the first website_pageview_id for relevant sessions
-- Step 2: identifying the landing page for each sessions
-- Step 3: counting pageviews for each session, to identify 'bounces'
-- Step 4: summarizing by counting total sessions and bounced sessions



-- Create a temporary table for to see the first pageview for each session, 
create temporary table first_pageviews
select 
	website_session_id,                                 
	min( website_pageview_id) as min_pageview_id   
from website_pageviews
where created_at < '2012-06-14'
group by website_session_id;



-- select * from first_pageviews;


-- Next, bring in the landing page, restricting to home only
create temporary table sessions_with_home_landing_page
select
	first_pageviews.website_session_id,
    website_pageviews.pageview_url as landing_page
from first_pageviews
	left join website_pageviews
		on website_pageviews.website_pageview_id = first_pageviews.min_pageview_id  
where website_pageviews.pageview_url = '/home';      -- Redundant but in general needed


-- select * from sessions_with_home_landing_page;


# These are bounced sessions. Sessions that saw the landing page and nothing else.

create temporary table bounced_sessions
select 
	sessions_with_home_landing_page.website_session_id,
    sessions_with_home_landing_page.landing_page,
    count(website_pageviews.website_pageview_id) as count_of_pages_viewed 		-- count of how many pages that customer saw that session
    
from sessions_with_home_landing_page
left join website_pageviews
	on website_pageviews.website_session_id = sessions_with_home_landing_page.website_session_id

group by 
	sessions_with_home_landing_page.website_session_id,
    sessions_with_home_landing_page.landing_page

having 
	count(website_pageviews.website_pageview_id) = 1;       -- limit to customer session that only saw one page (the home page)
    
    
    
-- select * from bounced_sessions;




# Sessions | bounced_sessions | bounce_rate      
# bounce rate of 60% for paid search

select 
	count(distinct sessions_with_home_landing_page.website_session_id) as sessions,
    count(bounced_sessions.website_session_id) as bounced_sessions,
    count(bounced_sessions.website_session_id)/count(distinct sessions_with_home_landing_page.website_session_id) as bounce_rate
from sessions_with_home_landing_page
	left join bounced_sessions
		on sessions_with_home_landing_page.website_session_id = bounced_sessions.website_session_id;


  
  
  
  