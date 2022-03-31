/*
Analyzing product sales helps understand how each product contributes to your business,
and how product launches impact the overall portfolio

Common use cases:
1. Analyzing sales and revenue by product
2. Monitoring the impact of adding a new product to your product portfolio
3. Watching product sale trends to understand the overall health of the business.

Key terms;
Orders: Number of orders placed by customers COUNT(order_id)
Revenue: Money that the business brings in SUM(price_usd)
Margin: Revenue - CostOfGoodsSold SUM(price_usd-cogs_usd)
AOV: Average revenue generated per order AVG(price_usd)

We will look into the orders table and join in the specific products within the product table
Looking into how much of our order volumes comes from each product and overall revenue and margin generated.

Margin is more important for a business - we want to steer the company into higher margin opportunities.

*/



# Lets look at orders, revenue, margin and AOV; sliced by product (product id)

select 
products.product_id,
COUNT(orders.order_id) as num_orders,
ROUND(SUM(orders.price_usd),1) as revenue,
ROUND(SUM(orders.price_usd-orders.cogs_usd),1) as margin,
ROUND(AVG(orders.price_usd),1) as AOV
from orders left join products on orders.primary_product_id = products.product_id
where orders.created_at < '2013-01-01'
group by 1
order by 2 desc;

/*
The CEO is about to launch a new product on Janurary 4th 2013.
 We need to do a deep dive on the flagship product.
Requests: monthly trends to date for number of sales, total revenue and total margin generated for the business.

*/


select 
YEAR(orders.created_at) as yr,
MONTH(orders.created_at) as mth,
ROUND(COUNT(orders.order_id),0) as number_of_sales,
ROUND(SUM(orders.price_usd),0) as total_revenue,
ROUND(SUM(orders.price_usd- orders.cogs_usd),0) as total_marign
from orders left join products on orders.primary_product_id = products.product_id
where orders.created_at < '2013-01-04'
and products.product_id = 1   -- flagship product
group by 1,2
order by 2,3;
