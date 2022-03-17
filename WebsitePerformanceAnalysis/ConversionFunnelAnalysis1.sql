# Conversion funnel analysis about understanding and optimizing each step of the users' experience 
# i.e. homepage -> product page -> add to cart -> sale

# Identifying the most common paths customers take before purchasing products
# Identifying how many users continue on to each next step in conversion flow, how many abandon at each step
# Optimize critical pain points where users abandon to convert more users and sell more products
# How many customers drop off and how many continue at each step?



## Business context:
# build a mini funnel from /lander2 page to the /cart page
# how many people reach each step and also dropoff rates?
# /lander-2 traffic only



# Step 1.  select all relevant pageviews for relevant sessions
# Step 2.  identify each relevant pageview as specific funnel step
# Step 3.  create the session-level conversion funnel view
# Step 4.  aggregate the data assess funnel performance




select
	website_sessions.website_session_id,
    website_pageviews.pageview_url,
    website_pageviews.created_at as pageview_created_at,
    # Flags for the product page
    case when pageview_url = '/products' then 1 else 0 end as products_page,
	case when pageview_url = '/the-original-mr-fuzzy' then 1 else 0 end as mrfuzzy_page,
    case when pageview_url = '/cart' then 1 else 0 end as cart_page
from website_sessions
	left join website_pageviews 
		on website_sessions.website_session_id = website_pageviews.website_session_id
where website_sessions.created_at between '2014-01-01' and '2014-02-01'
	and website_pageviews.pageview_url in ('/lander-2', '/products', '/the-original-mr-fuzzy', '/cart')
order by
	website_sessions.website_session_id,
    website_pageviews.created_at;



# Use the subquery to create temp table

create temporary table sessions_level_made_it_flags
select 
	website_session_id,
    max(products_page) as product_made_it,
    max(mrfuzzy_page) as mrfuzzy_made_it,
    max(cart_page) as cart_made_it
from (

select 
	website_sessions.website_session_id,
    website_pageviews.pageview_url,
    # Flags for the product page
    case when pageview_url = '/products' then 1 else 0 end as products_page,
	case when pageview_url = '/the-original-mr-fuzzy' then 1 else 0 end as mrfuzzy_page,
    case when pageview_url = '/cart' then 1 else 0 end as cart_page
from website_sessions
	left join website_pageviews 
		on website_sessions.website_session_id = website_pageviews.website_session_id
where website_sessions.created_at between '2014-01-01' and '2014-02-01'
	and website_pageviews.pageview_url in ('/lander-2', '/products', '/the-original-mr-fuzzy', '/cart')
order by
	website_sessions.website_session_id,
    website_pageviews.created_at
  )  as pageview_level
  
  group by website_session_id;
  



# select * from sessions_level_made_it_flags;


select 
	count(distinct website_session_id) as sessions,
    count(distinct case when product_made_it = 1 then website_session_id else null end) as to_products,
    count(distinct case when mrfuzzy_made_it = 1 then website_session_id else null end) as to_mrfuzzy,
    count(distinct case when cart_made_it = 1 then website_session_id else null end) as to_cart
from sessions_level_made_it_flags;



# Now we need to translate those counts to click-rates for a final output 


select 
	count(distinct website_session_id) as sessions,
    count(distinct case when product_made_it = 1 then website_session_id else null end)/count(distinct website_session_id)
    as lander_clickthrough_rate,
    count(distinct case when mrfuzzy_made_it = 1 then website_session_id else null end)/count(distinct case when product_made_it = 1 then website_session_id else null end)
    as products_clickthrough_rate,
    count(distinct case when cart_made_it = 1 then website_session_id else null end)/ count(distinct case when mrfuzzy_made_it = 1 then website_session_id else null end)
    as mrfuzzy_clickthrough_rate
from sessions_level_made_it_flags;



# 73.2% of users made it to products, 61.3% then clicked through to products, 60% made it then to mr_fuzzy
