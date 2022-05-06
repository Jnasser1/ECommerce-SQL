/*
Date range: 01-01-2014 -- 08-11-2014
Requests:
A comparison of conversion rates and revenue per session for repeat sessions vs new sessions
*/


/*
Repeat sessions are more likely to convert (about 1.3% more likely). They also produce more revenue per session.
Since we aren't paying much for repeat seessions, the company should take them into account when bidding on paid traffic.

*/
select
website_sessions.is_repeat_session,
count(distinct website_sessions.website_session_id) as sessions,
count(distinct orders.order_id) / count(distinct website_sessions.website_session_id) as conv_rate,
sum(orders.price_usd)/count(distinct website_sessions.website_session_id)
 as revenue_per_session
from website_sessions
left join orders on website_sessions.website_session_id = orders.website_session_id
where website_sessions.created_at between '2014-01-01' and '2014-11-08'
group by 1;