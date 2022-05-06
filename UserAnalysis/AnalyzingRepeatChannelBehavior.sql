/*
Date range: 01-01-2014 to 11-05-2014

We want to understand more on repeat customers: what channels are they coming back through?
Are we paying for these customers with paid search ads multiple times?
Lets compare new vs. repeat sessions by channel.

*/



select

-- First use a case statement to isolate the different channels
case
when utm_source is null and http_referer in ('https://www.gsearch.com', 'https://www.bsearch.com') then 'organic_search'
when utm_source is null and http_referer is null then 'direct_type_in'
when utm_source = 'socialbook' then 'paid_social'
when  utm_campaign = 'brand' then 'paid_brand'
when utm_campaign = 'nonbrand' then 'paid_nonbrand'
else  'check logic'
end as channel_group,

-- Now the count and case pivot method to count sessions/repeat sessions for each channel
count(case when is_repeat_session = 0 then website_session_id else null end) as new_sessions,
count(case when is_repeat_session = 1 then website_session_id else null end) as repeat_sessions

from website_sessions
where created_at between '2014-01-01' and '2014-11-05'
group by channel_group
order by repeat_sessions desc;

