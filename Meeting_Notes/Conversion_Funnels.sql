
/*
Full conversion funnel from each of the home pages ('/home', '/lander-1') to orders
looking at the dates Jun 19 - July 28
*/



# Creating the temporary table for flags 


# For each session_id, which homepage did they see and how far did they make it? 

create temporary table sessions_level_made_it_flagged
select 
	website_session_id,
    max(home_page) as viewed_homepage,
    max(lander1) as viewed_lander1,
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
    # Flags to know which pages are viewed.
    case when pageview_url = '/home' then 1 else 0 end as home_page,
    case when pageview_url = '/lander-1' then 1 else 0 end as lander1,
    case when pageview_url = '/products' then 1 else 0 end as products_page,
	case when pageview_url = '/the-original-mr-fuzzy' then 1 else 0 end as mrfuzzy_page,
    case when pageview_url = '/cart' then 1 else 0 end as cart_page,
	case when pageview_url = '/shipping' then 1 else 0 end as shipping_page,
	case when pageview_url = '/billing' then 1 else 0 end as billing_page,
	case when pageview_url = '/thank-you-for-your-order' then 1 else 0 end as thankyou_page
from website_sessions
	left join website_pageviews 
		on website_sessions.website_session_id = website_pageviews.website_session_id
where website_sessions.created_at between '2012-06-19' and '2012-07-28'
		and website_sessions.utm_source = 'gsearch'
    and website_sessions.utm_campaign = 'nonbrand'
order by
	website_sessions.website_session_id,
    website_pageviews.created_at

  )  as pageview_level
  group by website_session_id;
  


 -- Session volumes 
select 
	case 
		when viewed_homepage = 1 then 'viewed_homepage'
        when viewed_lander1 = 1 then 'viewed custom lander-1'
        else 'Error'
	end as segment,
	count(distinct website_session_id) as sessions,
    count(distinct case when product_made_it = 1 then website_session_id else null end) as to_products,
    count(distinct case when mrfuzzy_made_it = 1 then website_session_id else null end) as to_mrfuzzy,
    count(distinct case when cart_made_it = 1 then website_session_id else null end) as to_cart,
	count(distinct case when shipping_made_it = 1 then website_session_id else null end) as to_shipping,
	count(distinct case when billing_made_it = 1 then website_session_id else null end) as to_billing,
	count(distinct case when thankyou_made_it = 1 then website_session_id else null end) as to_thankyou
from sessions_level_made_it_flagged
group by 1;



# Conversion funnel click-through-rates, for home-page and lander-1. Buckets are mutually exclusive.

select 
	case 
		when viewed_homepage = 1 then 'viewed_homepage'
        when viewed_lander1 = 1 then 'viewed custom lander-1'
        else 'Error'
	end as segment,

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
    
from sessions_level_made_it_flagged
group by 1;


