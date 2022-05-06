




create temporary table sessions_w_repeats_for_time_difference
select
new_sessions.user_id,
new_sessions.website_session_id as new_session_id,
new_sessions.created_at as new_session_created_date,   -- new session date created at
website_sessions.website_session_id as repeat_session_id,
website_sessions.created_at as repeat_session_created_at -- repeat session date created at
-- New sessions
from (
select
user_id,
website_session_id,
created_at
from website_sessions
where created_at between '2014-01-01' and '2014-11-03'
and is_repeat_session = 0
) as new_sessions
-- Bringing in the repeat sessions
left join website_sessions
on website_sessions.user_id = new_sessions.user_id
and website_sessions.is_repeat_session = 1
and website_sessions.website_session_id > new_sessions.website_session_id   -- second session later than first session
and website_sessions.created_at between '2014-01-01' and '2014-11-03';




create temporary table users_first_to_second
select 
user_id,
datediff(second_session_created_at, new_session_created_date) as days_first_to_repeat_session
from
(
select 
user_id,
new_session_id,
new_session_created_date,
min(repeat_session_id) as second_session_id,
min(repeat_session_created_at) as second_session_created_at
from sessions_w_repeats_for_time_difference
where repeat_session_id is not null
group by 1,2,3
) as first_to_repeat_level;


-- For each user, the days from the first to second session.

select * from users_first_to_second;


-- Final output:

select
AVG(days_first_to_repeat_session),
MIN(days_first_to_repeat_session),
MAX(days_first_to_repeat_session)
from users_first_to_second;