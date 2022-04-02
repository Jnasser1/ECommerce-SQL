/*
With the new product page, lets look at sessions which hit the /products page to see where they went next.
 
Pull clickthrough rates from /products since the new product launched 2013-01-06, split by product,
Then compare the rates to the 3 months leading up to launch as a baseline. 
Date range: 2013-01-06 to 2013-04-06

*/

/*
Step 1: Find the relevant /products pageviews with website_session_id
Step 2: Find the next pageview id that occurs *after the product_pageview
Step 3: find the pageview_url associated with any applicable next pageview
Step 4: summarize the data and analyze the pre vs post periods


*/

# Step 1: Find the relevant /products pageviews with website_session_id


create temporary table products_pageview 
SELECT
website_session_id,
website_pageview_id,
created_at,
CASE
WHEN created_at < '2013-01-06' THEN  'BEFORE-product2'
WHEN created_at >= '2013-01-06' THEN  'AFTER-product2'
else 'error in date logic'
end as time_period
from website_pageviews
where created_at < '2013-04-06'    -- date of request
and created_at > '2012-10-06'
and pageview_url = '/products';


# These are the website_session_ids and pageview_ids that occured in the time period of interest.

select * from products_pageview;


# Step 2. Find the next pageview id that occurs *after the product_pageview

create temporary table sessions_w_next_pageview_id
select
	products_pageview.time_period,
    products_pageview.website_session_id,
# Next pageview_id after the products page. Tracking where users go. Null value means they did not see a next page
    MIN(website_pageviews.website_pageview_id) as min_next_pageview_id
from products_pageview 
left join website_pageviews on 
website_pageviews.website_session_id = products_pageview.website_session_id
# We're only doing a join for pageviews that happened after the products pageview
AND website_pageviews.website_pageview_id > products_pageview.website_pageview_id 
group by 1,2;


# We have the next pageview_id that the user saw after the product page, now we pull that url associated.

# Step 3: find the pageview_url associated with any applicable next pageview

create temporary table sessions_w_next_pageview_url
select
sessions_w_next_pageview_id.time_period,
sessions_w_next_pageview_id.website_session_id,
website_pageviews.pageview_url as next_pageview_url
from sessions_w_next_pageview_id
left join website_pageviews 
on website_pageviews.website_pageview_id = sessions_w_next_pageview_id.min_next_pageview_id;




# Step 4: Summary output
# The percent of pageviews clicked through to product_1 has went down but the overall clickthrough rate has gone up.
# We conclude that product_2 is generating additional product interest overall.

select
time_period,
count(distinct website_session_id) as sessions,
count(distinct case when next_pageview_url is not null then website_session_id else null end) as went_next_pg,

count(distinct case when next_pageview_url is not null then website_session_id else null end) 
/ count(distinct website_session_id) as pct_went_next_pg,

count(distinct case when next_pageview_url = '/the-original-mr-fuzzy' then website_session_id else null end) as went_product1,

count(distinct case when next_pageview_url = '/the-original-mr-fuzzy' then website_session_id else null end) 
/count(distinct website_session_id)  as pct_went_product1,


count(distinct case when next_pageview_url = '/the-forever-love-bear' then website_session_id else null end) as went_product2,

count(distinct case when next_pageview_url ='/the-forever-love-bear' then website_session_id else null end) 
/count(distinct website_session_id)  as pct_went_product2
from sessions_w_next_pageview_url
group by time_period;
