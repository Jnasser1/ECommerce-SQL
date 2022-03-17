## Business context:
# Website Manager wants a conversion funnel from /lander-1 page to thank-you-page
# Time period September 05 2012 - August 5th 2012



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
    case when pageview_url = '/cart' then 1 else 0 end as cart_page,
	case when pageview_url = '/shipping' then 1 else 0 end as shipping_page,
	case when pageview_url = '/billing' then 1 else 0 end as billing_page,
	case when pageview_url = '/thank-you-for-your-order' then 1 else 0 end as thankyou_page
from website_sessions
	left join website_pageviews 
		on website_sessions.website_session_id = website_pageviews.website_session_id
where website_sessions.created_at between '2012-08-05' and '2012-09-05'
	and website_sessions.utm_source = 'gsearch'
    and website_sessions.utm_campaign = 'nonbrand'
	and website_pageviews.pageview_url in ('/lander-1', '/products', '/the-original-mr-fuzzy', '/cart', '/shipping', '/billing', '/thank-you-for-your-order')
order by
	website_sessions.website_session_id,
    website_pageviews.created_at;



# Creating the temporary table



create temporary table sessions_level_made_it_flags
select 
	website_session_id,
    max(products_page) as product_made_it,
    max(mrfuzzy_page) as mrfuzzy_made_it,
    max(cart_page) as cart_made_it,
    max(shipping_page) as shipping_made_it,
    max(billing_page) as billing_made_it,
    max(thankyou_page) as thankyou_made_it
from (

select 
	website_sessions.website_session_id,
    website_pageviews.pageview_url,
    # Flags for the product page
    case when pageview_url = '/products' then 1 else 0 end as products_page,
	case when pageview_url = '/the-original-mr-fuzzy' then 1 else 0 end as mrfuzzy_page,
    case when pageview_url = '/cart' then 1 else 0 end as cart_page,
	case when pageview_url = '/shipping' then 1 else 0 end as shipping_page,
	case when pageview_url = '/billing' then 1 else 0 end as billing_page,
	case when pageview_url = '/thank-you-for-your-order' then 1 else 0 end as thankyou_page
from website_sessions
	left join website_pageviews 
		on website_sessions.website_session_id = website_pageviews.website_session_id
where website_sessions.created_at between '2012-08-05' and '2012-09-05'
	and website_pageviews.pageview_url in ('/lander-1', '/products', '/the-original-mr-fuzzy', '/cart', '/shipping', '/billing', '/thank-you-for-your-order')
	and website_sessions.utm_source = 'gsearch'
    and website_sessions.utm_campaign = 'nonbrand'
order by
	website_sessions.website_session_id,
    website_pageviews.created_at

  )  as pageview_level
  group by website_session_id;
  








 -- Session volumes 
select 
	count(distinct website_session_id) as sessions,
    count(distinct case when product_made_it = 1 then website_session_id else null end) as to_products,
    count(distinct case when mrfuzzy_made_it = 1 then website_session_id else null end) as to_mrfuzzy,
    count(distinct case when cart_made_it = 1 then website_session_id else null end) as to_cart,
	count(distinct case when shipping_made_it = 1 then website_session_id else null end) as to_shipping,
	count(distinct case when billing_made_it = 1 then website_session_id else null end) as to_billing,
	count(distinct case when thankyou_made_it = 1 then website_session_id else null end) as to_thankyou
from sessions_level_made_it_flags;



# Click rates.


select 
	count(distinct website_session_id) as sessions,
    count(distinct case when product_made_it = 1 then website_session_id else null end)/count(distinct website_session_id)
    as lander_clickthrough_rate,
    
    count(distinct case when mrfuzzy_made_it = 1 then website_session_id else null end)/count(distinct case when product_made_it = 1 then website_session_id else null end)
    as products_clickthrough_rate,
    
    count(distinct case when cart_made_it = 1 then website_session_id else null end)/ count(distinct case when mrfuzzy_made_it = 1 then website_session_id else null end)
    as mrfuzzy_clickthrough_rate,
    
	count(distinct case when shipping_made_it = 1 then website_session_id else null end)/count(distinct case when cart_made_it = 1 then website_session_id else null end)
    as shipping_clickthrough_rate,
    
	count(distinct case when billing_made_it = 1 then website_session_id else null end)/count(distinct case when shipping_made_it = 1 then website_session_id else null end)
    as billing_clickthrough_rate,
    
    count(distinct case when thankyou_made_it = 1 then website_session_id else null end)/count(distinct case when billing_made_it = 1 then website_session_id else null end)
    as thankyou_clickthrough_rate
    
from sessions_level_made_it_flags;

