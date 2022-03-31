/*
Product-focused website analysis focuses on learning how customers interact with each of your products.
How well does each product convert customers?

Common use cases:
1. Understanding which products generate the most interest on multi-product showcase pages.
2. Analyzing the impact on website conversion rates when you add a new product.
3. Building product-specific conversion funnels to understand whether certain products convert better than others.

We will be using website_pageviews data to identify users who viewed the \products page and see which product they clicked.
From specific product pages we can get view-to-order conversion rates and create multi-step conversion funnels

We will be using temporary tables or CTEs to break the query into manageable steps.
*/


/* Lets see which pages the customers are visiting:
 /the-forever-love-bear product has 1531 views
/the-original-mr-fuzzy product has 28214 views
*/

select distinct
# website_session_id,
pageview_url,
count(distinct website_session_id) as session
from website_pageviews
where created_at < '2013-04-05'
and pageview_url in ('/the-original-mr-fuzzy', '/the-forever-love-bear')
group by 1;


/*
Even though the-forever-love-bear has less order and session volume,
when customers do click to its product page they are 5% more likely to place an order.

*/

select distinct
website_pageviews.pageview_url,
count(distinct website_pageviews.website_session_id) as sessions,
count(distinct orders.order_id) as orders,
count(distinct orders.order_id)/count(distinct website_pageviews.website_session_id) as viewed_product_to_order_rate
from website_pageviews left join orders 
on orders.website_session_id = website_pageviews.website_session_id
where website_pageviews.created_at < '2013-04-05'
and website_pageviews.pageview_url in ('/the-original-mr-fuzzy', '/the-forever-love-bear')
group by 1;
