/*

Analyzing product refunds:
* controlling for quality 
* Factoring in refunds can identify problems.

Common use cases:
1. Monitoring products from different suppliers.
2. Understanding refund rates for products at different price points.
3. Taking product refund rates and associated costs into account when assessing the overall performance of the business.

The order_item_refund table: refund_id, created_at date, order_item_id, order_id, refund_amount

To do this analysis we will (left) join order_items and order_item_refunds tables.
We left join since not every item is refunded.

We're interested in indicators such as:
* tracking the total amount refunded, 
* the percent of time reach product is refunded,
* overall impact on margin.

*/



/*

Pulling Trended Refund Rates

date: October 15, 2014

Problem Statement:
There is quality issues in a product that were not corrected until September 2013. 
More significant problems occured in August and September of 2014. 
The business found a new supplier on September 16, 2014.

We will pull monthly product refund rates, by product - to confirm the company's quality issues have been resolved.

*/

select
year(order_items.created_at) as yr,
month(order_items.created_at) as mth,

/*             Product 1 metrics               */
count( distinct case when order_items.product_id =1 then order_items.order_item_id else null end) as p1_orders,

count(distinct case when order_items.product_id =1 then order_item_refunds.order_item_id else null end)/
count(distinct case when order_items.product_id=1 then order_items.order_item_id else null end)  as p1_refund_rt,


/*             Product 2 metrics               */
count( distinct case when order_items.product_id =2 then order_items.order_item_id else null end) as p2_orders,

count(distinct case when order_items.product_id =2 then order_item_refunds.order_item_id else null end)/
count(distinct case when order_items.product_id=2 then order_items.order_item_id else null end)  as p2_refund_rt,


/*             Product 3 metrics               */
count( distinct case when order_items.product_id =3 then order_items.order_item_id else null end) as p3_orders,

count(distinct case when order_items.product_id =3 then order_item_refunds.order_item_id else null end)/
count(distinct case when order_items.product_id=3 then order_items.order_item_id else null end)  as p3_refund_rt,


/*             Product 4 metrics               */
count( distinct case when order_items.product_id =4 then order_items.order_item_id else null end) as p4_orders,

count(distinct case when order_items.product_id =4 then order_item_refunds.order_item_id else null end)/
count(distinct case when order_items.product_id=4 then order_items.order_item_id else null end)  as p4_refund_rt


from order_items left join order_item_refunds 
on order_items.order_item_id=order_item_refunds.order_item_id
where order_items.created_at < '2014-11-01'
group by 1,2;



/*

Findings:

For product-1:
Refund rates were initially high between 4% and 9% until September 2013. 
From Steptember 2013 - August 2014, refund rates remained stable between 2% and 4%.
August and September 2014 we saw a spike to 13% refund rates, however as of October 2014 refund rates have dropped back to 2%

* This drop in refund rates the new supplier has been providing superior quality control for the business.

Product-2 refund rates saw a spike in June of 2016 at 5% but have remained stable between 1%-3% since then. 
Product-3 refund rates are slightly high from 6% at launch, as of Oct 2014 the have dropped to 4.6%.
Product-4 refund rates are stable between 1% and 2%.

*/



/*

Query tail snippet:

 yr,	mth,	p1_orders, **p1_refund_rt, p2_orders, p2_refund_rt,	p3_orders, p3_refund_rt, p4_orders,	p4_refund_rt

2014, 8, 961, **0.1374, 239, 0.0167, 295, 0.0678, 307, 0.0065
2014, 9, 1056, **0.1326, 250, 0.0320, 317, 0.0662, 327, 0.0122
2014, 10, 1173, **0.0247, 285, 0.0175, 368, 0.0462, 377, 0.0212

** Note the drop in product1_refund_rates

*/