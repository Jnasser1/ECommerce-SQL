

/*
Analyzing business patterns is about generating insights to help maximize effiency and anticipate future trends.

Common use cases:
1. Day-parting analysis to understand how much support staff you should have at different parts of the day/
2. Analyzing seasonality allows to better prepare for upcoming spikes or slowdowns in demand.
*/



select 
	website_session_id,
    created_at,
    HOUR(created_at) as hr,
    WEEKDAY(created_at) as weekday,    -- 0 = Monday, ...6 = Sunday'
    CASE
		WHEN  WEEKDAY(created_at) = 0 THEN 'Monday'
        WHEN  WEEKDAY(created_at) = 1 THEN 'Tuesday'
		ELSE 'other_day'
    END AS day_case,
    QUARTER(created_at) as qtr,
    MONTH(created_at) as mth,
    DATE(created_at) as date,
    WEEK(created_at) as wk
from website_sessions;




/*
Lets look at yr, mo, sessions, orders, 
and  week_start, sessions, orders ; -  montly and weekly volume patters for 2012
Date range: before 2013-01-01
*/


# November seems to be peak season. Good growth across the year.

select
YEAR(website_sessions.created_at) as yr,
MONTH(website_sessions.created_at) as mth,
COUNT(distinct website_sessions.website_session_id) as sessions,
COUNT(distinct orders.order_id) as orders
from website_sessions left join orders 
on website_sessions.website_session_id = orders.website_session_id
WHERE website_sessions.created_at < '2013-01-01'
group by 1,2;


# We see a large increase in sessions and orders at weeks  46-48, due to Black Friday and Cyber Monday.
select
YEAR(website_sessions.created_at) as yr,
WEEK(website_sessions.created_at) as wk,
MIN(DATE(website_sessions.created_at)) as week_start,
COUNT(distinct website_sessions.website_session_id) as sessions,
COUNT(distinct orders.order_id) as orders
from website_sessions left join orders 
on website_sessions.website_session_id = orders.website_session_id
WHERE website_sessions.created_at < '2013-01-01'
group by 1,2;



