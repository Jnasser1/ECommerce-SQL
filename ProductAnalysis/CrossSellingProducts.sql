/*

Cross-sell analysis is about understanding which products users are most likely to purchase together,
offering smart product recommendations.

Use cases:
1. Understanding which products are often purchased together
2. Testing and optimizing the way you cross-sell products on your website
3. Understanding the conversion rate impact and the overall revenue impact of trying to cross-sell additional products.

We can analyze orders and order_items to understand which products cross-sell and analyze the impact on revenue
We also wil use website_pageviews data to understand if cross-selling hurts overall conversion rates
Using this data, we can develop a deeper understanding of our customer's purchase behaviors
*/

select
orders.primary_product_id,
count(distinct orders.order_id) as orders,
count(distinct case when order_items.product_id=1 then orders.order_id else null end) as cross_sell_product1,
count(distinct case when order_items.product_id=2 then orders.order_id else null end) as cross_sell_product2,
count(distinct case when order_items.product_id=3 then orders.order_id else null end) as cross_sell_product3
from orders left join order_items
on order_items.order_id = orders.order_id
and order_items.is_primary_item = 0  # Cross sell only
where order_id < 11000
group by 1;