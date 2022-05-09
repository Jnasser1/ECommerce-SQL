

/*

Investigating monthly session volume to the /products page, how the % of sessions clicking through another page have changed over time.
*/


/*  Identifying all the views of the products page */
create temporary table products_pageviews
select
website_session_id,
website_pageview_id,
created_at as date_product_page_is_seen
from website_pageviews
where pageview_url = '/products';


/* We've seen a 13% gain in clickthrough rate, and a 6% increase in product rate */
/* This is good to see; The changes the business is making are impacting it in a healthy way */

select
year(date_product_page_is_seen) as yr,
month(date_product_page_is_seen) as mth,

count(distinct products_pageviews.website_session_id) as sessions_to_product_page,
count(distinct website_pageviews.website_session_id) as clicked_to_next_page,
count(distinct website_pageviews.website_session_id) / count(distinct products_pageviews.website_session_id) as clickthrough_rt,
count(distinct orders.order_id) as orders,
count(distinct orders.order_id) / count(distinct products_pageviews.website_session_id) as products_to_order_conv_rt
from products_pageviews
left join website_pageviews 
on website_pageviews.website_session_id = products_pageviews.website_session_id -- Ensuring its the same session
and website_pageviews.website_pageview_id > products_pageviews.website_pageview_id -- Only joining if the visitor saw another page after
left join orders 
on orders.website_session_id = products_pageviews.website_session_id
group by 1,2
order by 1,2 asc;




