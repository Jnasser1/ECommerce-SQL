
# Top content in general
select
	pageview_url,
    count(distinct website_pageview_id) as page_views
from website_pageviews
where website_pageview_id < 1000
group by pageview_url
order by page_views desc;





CREATE temporary table pageview_temp
select 
	website_session_id,
    min(website_pageview_id) as min_pageview_id
from website_pageviews
where website_pageview_id < 1000
group by website_session_id;



select * from pageview_temp;




# Most hit entry page.
select 
    website_pageviews.pageview_url as landing_page, -- or entry page
    count(distinct first_pageview.website_session_id) as sessions_hitting_this_lander
from first_pageview   -- Temp tables
	left join website_pageviews
		on first_pageview.min_pageview_id = website_pageviews.website_pageview_id
group by 
	website_pageviews.pageview_url;
    
    



# Situation: Website Manager requests the most-viewed website pages, ranked by session volume
select
	pageview_url,
    count(distinct website_pageview_id) as page_views
from website_pageviews
where created_at < '2012-06-09'
group by pageview_url
order by page_views desc;




# Situation: Website Manager requests a list of the top entry pages, ranked on entry volume. June 12th 2012
-- STEP 1: find the first pageview for each session
-- STEP 2: find the url the customer saw on that first pageview


-- Create a temporary table for to see the first pageview for each session
CREATE temporary table first_pageview_per_session
select 
	website_session_id,                                 -- the id the customer is assigned 
	min( website_pageview_id) as min_page_view_id    -- the id of the first webpage they end up
from website_pageviews
where created_at < '2012-06-12'
group by website_session_id;


-- Use the temp table first_pageview_per_session to filter website_pageviews table to get entry page information
select
	website_pageviews.pageview_url as landing_page_url,
    COUNT(distinct first_pageview_per_session.website_session_id) as sessions_hitting_page
from first_pageview_per_session 
	left join website_pageviews
		on first_pageview_per_session.min_page_view_id = website_pageviews.website_pageview_id
group by website_pageviews.pageview_url;





    
    


