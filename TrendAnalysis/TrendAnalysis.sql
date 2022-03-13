
# conversion rates - rate at which session cONverts to sale
SELECT 
WS.utm_content, 
COUNT(distinct WS.website_session_id) as sessions,
COUNT(distinct orders.order_id),
(COUNT(distinct orders.order_id))/(COUNT(distinct WS.website_session_id)) as session_to_order_conv_rate
FROM website_sessions as WS left join orders 
ON WS.website_session_id=orders.website_session_id
WHERE WS.website_session_id between 1000 and 2000
GROUP BY 1
ORDER BY 2 DESC;




-- Top Sources of Traffic, one source gsearch is far contributor.

SELECT
WS.utm_source, 
WS.utm_campaign ,
WS.http_referer,
COUNT(distinct WS.website_session_id) AS number_of_sessions
FROM website_sessions AS WS
WHERE WS. created_at < '2012-04-12'
GROUP by
	WS.utm_source,
	WS.utm_campaign,
	WS.http_referer
ORDER BY number_of_sessions DESC;




--  gsearch analysis, sales conversion rate, looking for atleast 4%
-- We find 0.0296% below the 4% mark.
SELECT
COUNT(distinct WS.website_session_id) AS sessions,
COUNT(distinct O.order_id),
(COUNT(distinct O.order_id))/(COUNT(distinct WS.website_session_id)) AS session_to_order_conv_rate
FROM website_sessions AS WS
LEFT JOIN orders AS O
ON WS.website_session_id = O.website_session_id
WHERE WS.created_at < '2012-04-12' 
AND WS.utm_source = 'gsearch'
AND WS.utm_campaign = 'nonbrand';



##                     Date Function Trend Analysis


SELECT
	 YEAR(created_at),
    WEEK(created_at),
    MIN(DATE(created_at)) AS week_start,
    COUNT(distinct website_session_id) AS sessions
FROM website_sessions
WHERE created_at < '2012-05-10'
GROUP BY 1,2
ORDER BY 3;



-- Pivot table
SELECT
	primary_product_id,
    COUNT(distinct CASE WHEN items_purchased = 	1 THEN order_id ELSE NULL END) AS count_single_item_orders,
    COUNT(distinct CASE WHEN items_purchased = 2 THEN order_id ELSE NULL END) AS count_two_item_orders
FROM orders
WHERE order_id BETWEEN 23000 AND 33000
GROUP BY 1;




-- We want week_start_date and session volume up to 2012-05-10  for source gsearch and campaign nonbrand.

SELECT
MIN(DATE(created_at)) AS week_date_data_started,
COUNT(distinct website_session_id) AS sessions
FROM website_sessions
WHERE created_at < '2012-05-10' 
AND utm_source = 'gsearch'
AND utm_campaign = 'nonbrand'
GROUP BY 
YEAR(created_at),
WEEK(created_at);





-- We can see that users on their mobile device have about a 1% chance to convert to a sale
-- Desktop users have a 3.73%
SELECT
website_sessions.device_type,
COUNT(distinct orders.order_id) as order_amounts,
COUNT(distinct website_sessions.website_session_id) AS sessions,
(COUNT(distinct orders.order_id))/(COUNT(distinct website_sessions.website_session_id)) as session_to_order_conv_rate
FROM website_sessions
left join 
orders on orders.website_session_id=website_sessions.website_session_id 
WHERE website_sessions.created_at < '2012-05-11' 
AND website_sessions.utm_source = 'gsearch'
AND website_sessions.utm_campaign = 'nonbrand'
GROUP BY
1;






# Marketing director increases bid in nonbrand desktop campagins up for 2012-05-19
# From the result set, desktop_sessions saw a sharp 60% increase day after.
SELECT
#	YEAR(created_at) as YR,
#   WEEK(created_at) as WK,
    MIN(DATE(created_at)) AS week_start_date,
    COUNT(distinct CASE WHEN device_type = 'desktop' THEN website_session_id ELSE NULL END ) AS desktop_sessions,
    COUNT(distinct CASE WHEN device_type = 'mobile' THEN website_session_id ELSE NULL END) AS mobile_sessions
FROM website_sessions 
WHERE created_at < '2012-06-09' 
AND created_at > '2012-04-15' 
AND utm_source = 'gsearch'
AND utm_campaign = 'nonbrand'
GROUP BY 
	YEAR(created_at),
    WEEK(created_at)



