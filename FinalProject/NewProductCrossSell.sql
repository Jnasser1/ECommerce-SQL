/*

Latest (product-4) product launched 12-05-2014 (previously offered as cross-sell item).
Pulling sales data since then, to show how well each product cross-sells from one another.

*/


create temporary table primary_products
select 
order_id,
primary_product_id,
created_at as ordered_at
from orders
where created_at > '2014-12-05';         -- Looking at sales data since launch of product 4



/*

 Product 4 cross sells really well with all the other products.
 Over 20% cross-sell rate for each product. 
 Adding product 4 at a lower price pointboosted sales. 
 Product 3 cross-sells well with product 1.
 
 */
 



select
primary_product_id,
count(distinct order_id) as total_orders,
count(distinct case when cross_sell_product_id = 1 then order_id else null end) as xsold_product1, -- cross sale amount for product1
count(distinct case when cross_sell_product_id = 2 then order_id else null end) as xsold_product2,
count(distinct case when cross_sell_product_id = 3 then order_id else null end) as xsold_product3,
count(distinct case when cross_sell_product_id = 4 then order_id else null end) as xsold_product4,
count(distinct case when cross_sell_product_id = 1 then order_id else null end)/count(distinct order_id) as product1_xsell_rt, -- cross sell rate for product1
count(distinct case when cross_sell_product_id = 2 then order_id else null end)/count(distinct order_id) as product2_xsell_rt,
count(distinct case when cross_sell_product_id = 3 then order_id else null end)/count(distinct order_id) as product3_xsell_rt,
count(distinct case when cross_sell_product_id = 4 then order_id else null end)/count(distinct order_id) as product4_xsell_rt

from (
select

primary_products.*,
order_items.product_id as cross_sell_product_id

from primary_products left join order_items
on order_items.order_id = primary_products.order_id
and order_items.is_primary_item = 0              -- only bringing in cross-sells.

/* is_primary_product is boolean specifying whether that item is the main item or the cross sold item. */

) as primary_w_cross_sell
group by 1


/*

How can we make the business better?

Bounce rates - different areas of the website with dropouts
Adding lower priced products that could cross-sell well

Website improvements: Live chat, phone number line, customer benefits - discounts and email offers,  loyalty rewards,
Dynamic pricing,
Free shipping,
Upselling - offering another product at a higher margin when a customer purchases productX

We could look into the volume of products sold and their seasonality. 
If productY only sells during a certain time of year - then we should take it off the website until that time of year.
*/
