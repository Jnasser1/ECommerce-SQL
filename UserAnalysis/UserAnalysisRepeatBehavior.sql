/*
Analyzing Repeat Behavior and Purchase Behavior

Common use cases:
1. Analyzing repeat activity to see how often customers are coming back to vist your site.
2. Understanding which channels they use when they come and whether or not you are paying for 
them through paid channels.
3. Using repeat activity to build a better understanding of the value of a customer in order to better 
optimize marketing channels.

Tracking usually happens with browser cookies. Cookies have unique IDs.

DATEDIFF returns a number of daus but we can convert to other time periods using divison.
*/



/*
Identifying repeat vistors
If customers have repeat sessions, they may be more valuable than we thought.
Lets pull data on how many of our website visitors come back for another session.

*/


/*
Step 1. Identifying the relevant new sessions.
Step 2. User the user_id values from Step 1 to find any repeat sessions those users had
Step 3. Analyze data at user level (how many sessions/user?)
Step 4. Aggregate the user-level analysis to generate behavioral analysis
*/


create temporary table sessions_w_repeats
select
new_sessions.user_id,
new_sessions.website_session_id as new_session_id,
website_sessions.website_session_id as repeat_session_id
from (
select
user_id,
website_session_id
from website_sessions
where created_at between '2014-01-01' and '2014-11-01'
and is_repeat_session = 0
) as new_sessions
left join website_sessions
on website_sessions.user_id = new_sessions.user_id
and website_sessions.is_repeat_session = 1
and website_sessions.website_session_id > new_sessions.website_session_id
and website_sessions.created_at between '2014-01-01' and '2014-11-01';


select
repeat_sessions,
count(distinct user_id) as users
from 
(
select 
user_id,
count(distinct new_session_id) as new_sessions,
count(distinct repeat_session_id) as repeat_sessions
from sessions_w_repeats
group by 1
order by 3 DESC
) as user_level
group by 1;
