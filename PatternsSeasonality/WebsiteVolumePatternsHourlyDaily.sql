
/*
We are asked to analyze the average website session volume by hour of day and by day of week.
This will help the business staff appropriately
*/

### Average number of sessions per hour per day of the week


## Finding: Sat and Sun to have lower average session volume never going over double digits.
## Most of our traffic comes during the hours 8-17, so for those hours we will need an extra live chat worker.

SELECT
hr,
ROUND(AVG(sessions),1) as avg_sessions,
ROUND(AVG(CASE WHEN wkday = 0 THEN sessions else null end),1)  as monday,
ROUND(AVG(CASE WHEN wkday = 1 THEN sessions else null end),1)  as tuesday,
ROUND(AVG(CASE WHEN wkday = 2 THEN sessions else null end),1)  as wednesday,
ROUND(AVG(CASE WHEN wkday = 3 THEN sessions else null end),1) as thursday,
ROUND(AVG(CASE WHEN wkday = 4 THEN sessions else null end),1)  as friday,
ROUND(AVG(CASE WHEN wkday = 5 THEN sessions else null end),1)  as saturday,
ROUND(AVG(CASE WHEN wkday = 6 THEN sessions else null end),1)  as sunday
FROM(
SELECT
DATE(created_at) as created_date,
WEEKDAY(created_at) as wkday,
HOUR(created_at) as hr,
COUNT(distinct website_sessions.website_session_id) as sessions
FROM website_sessions
WHERE created_at between '2012-09-15' and '2012-11-15'
GROUP by 1,2,3 )
as daily_hour_sessions
GROUP by 1
ORDER by 1;