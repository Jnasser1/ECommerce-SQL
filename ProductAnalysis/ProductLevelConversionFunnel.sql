/*

Date range Jan 6th 2014 - Apr 10 2014.
Conversion funnels from each product page to conversion.
Comparison between the two funnels for all website traffic.

*/


/*

Step 1.  select all relevant pageviews for relevant sessions
Step 2.  figure out which pageview urls to look for	
Step 3.  identify each relevant pageview as specific funnel step
Step 4.  create the session-level conversion funnel view
Step 5.  aggregate the data assess funnel performance

*/




create temporary table sessions_seeing_product_page
select
website_session_id,
website_pageview_id,
pageview_url as product_page_seen
from website_pageviews
where pageview_url in ('/the-original-mr-fuzzy', '/the-forever-love-bear')
and created_at < '2013-04-10'
and created_at > '2013-01-06';  # Launch date for product-2


/* ===================================================== */
# Step 2.

select distinct
website_pageviews.pageview_url
from sessions_seeing_product_page
left join website_pageviews 
on website_pageviews.website_session_id = sessions_seeing_product_page.website_session_id
and website_pageviews.website_pageview_id > sessions_seeing_product_page.website_pageview_id;



/* ===================================================== */
# Step 3

create temporary table session_product_flags
select 
website_session_id,
case
when product_page_seen = '/the-original-mr-fuzzy' then 'mrfuzzy'
when product_page_seen = '/the-forever-love-bear' then 'lovebear'
else 'Error in logic'
end as product_seen,
max(cart_flag) as made_it_cart,
max(shipping_flag) as made_it_shipping,
max(billing_flag) as made_it_billing,
max(thankyou_page) as made_it_thankyou
from
(
select 
sessions_seeing_product_page.website_session_id,
sessions_seeing_product_page.product_page_seen,
case when website_pageviews.pageview_url = '/cart' then 1 else 0 end as cart_flag,
case when website_pageviews.pageview_url = '/shipping' then 1 else 0 end shipping_flag,
case when website_pageviews.pageview_url = '/billing-2' then 1 else 0 end as billing_flag,
case when website_pageviews.pageview_url = '/thank-you-for-your-order' then 1 else 0 end as thankyou_page
from sessions_seeing_product_page left join website_pageviews 
on website_pageviews.website_session_id = sessions_seeing_product_page.website_session_id
and website_pageviews.website_pageview_id > sessions_seeing_product_page.website_pageview_id
order by sessions_seeing_product_page.website_session_id,
website_pageviews.created_at
) as pageview_level
group by website_session_id,
case 
when product_page_seen = '/the-original-mr-fuzzy' then 'mrfuzzy'
when product_page_seen = '/the-forever-love-bear' then 'lovebear'
else 'Error in product_page_seen logic'
end;



/* ===================================================== */
# Step 4.
# Volume outputs

select 
product_seen,
count(distinct website_session_id) as sessions,
count(distinct case when made_it_cart = 1 then website_session_id else null end) as to_cart,
count(distinct case when made_it_shipping = 1 then website_session_id else null end) as to_shipping,
count(distinct case when made_it_billing = 1 then website_session_id else null end) as to_billing,
count(distinct case when made_it_thankyou = 1 then website_session_id else null end) as to_thankyou
from session_product_flags
group by product_seen;



# Click-through rates outputs 
select
product_seen,
count(distinct website_session_id) as sessions,
count(distinct case when cart_made_it = 1 then website_session_id else null end)/count(distinct website_session_id) as cart_clickthrough_rate,

count(distinct case when shipping_made_it = 1 then website_session_id else null end)/count(distinct case when cart_made_it = 1 then website_session_id else null end)
as shipping_clickthrough_rate,

count(distinct case when billing_made-it = 1 then website_session_id else null end)/count(distinct case when shipping_made_it = 1 then website_session_id else null end)
as billing_clickthrough_rate,

count(distinct case when thankyou_made_it = 1 then website_session_id else null end)/count(distinct case when billing_made-it = 1 then website_session_id else null end)
as thankyou_clickthrough_rate
from session_product_flags
group by product_seen;


