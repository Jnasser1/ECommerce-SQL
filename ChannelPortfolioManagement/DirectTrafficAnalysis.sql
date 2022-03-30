/*

*** Analyzing Direct Traffic:
*Keeping track of how well your brand is doing with consumers and how well the brand drives business.

Use cases:
- Identifying how much revenue the business is generating from direct traffic - high margin revenue without a direct cost of pulling in a customer.
- Understanding whether or not paid traffic is generating a "halo" effect and promoting additional direct traffic
- Asessing impact of various initiatives on how many customers seek out the business


Utilize utm parameters to identify traffic visting the buisness site that we are not paying for.
Non non-paid traffic (organic, search, direct type-in), we analyze data when the utm parameters are NULL

Organic and direct traffic is a health indicator for buisness brand.
*/


# Example: seperating traffic sources
select
	case
		when website_sessions.http_referer is null then "direct_type_in"
		when website_sessions.http_referer = "https://www.gsearch.com" and utm_source is null then "gsearch_organic"
		when website_sessions.http_referer = "https://www.bsearch.com" and utm_source is null then "bsearch_organic"
		else "other"
    end as traffic_cases,
    count(distinct website_session_id) as sessions
from website_sessions
group by 1
order by 2 desc;




/*
A potential investor wants to know if the business is building momentum or if we have to rely on paid traffic

Retrieve data for Executive:
organic search, direct type in, and paid brand search sessions by month, and show those sessions as a % of paid search nonbrand.
*/

select distinct 
	utm_source,
    utm_campaign,
    http_referer
from website_sessions
where created_at < '2012-12-23';


## Buckets of traffic
/*
utm_source - utm_campaign - http

null - null - null        <- direct type-in search
null - null - gsearch     <- organic gsearch
null - null - bsearch     <- organic bsearch

gsearch - brand          <-
bsearch - brand			


gsearch - nonbrand
bsearch - nonbrand

*/


# Now we label those into a channel grouping using case statement.

select distinct 
	case
		when utm_source is null and http_referer in ("https://www.gsearch.com", "https://www.bsearch.com") then "organic_search"
        when utm_campaign = "nonbrand" then "paid_nonbrand"
        when utm_campaign = "brand" then "paid_brand"
        when utm_source is null and http_referer is null then "direct_type_in"
	end as channel_group,
    utm_source,
    utm_campaign,
    http_referer
from website_sessions
where created_at < "2012-12-23";




# For each website_session_id we label it according to channel_group
select
	website_session_id,
    created_at,
    case
		when utm_source is null and http_referer in ("https://www.gsearch.com", "https://www.bsearch.com") then "organic_search"
        when utm_campaign = "nonbrand" then "paid_nonbrand"
        when utm_campaign = "brand" then "paid_brand"
        when utm_source is null and http_referer is null then "direct_type_in"
	end as channel_group
from website_sessions
where created_at < '2012-12-23';




# Organic, direct, and brand, percent of nonbrand have trended from 2 to 7% over the last 8 months.
# Not only are volumes growing, but as a percentage of paid traffic they are increasing.
# This is great to see as it is higher margin traffic since we don't pay for it.

select
	year(created_at) as yr,
    month(created_at) as mth,
    count(distinct case when channel_group = "paid_nonbrand" then website_session_id else null end) as nonbrand,
    count(distinct case when channel_group = "paid_brand" then website_session_id else null end) as brand,
    
    count(distinct case when channel_group = "paid_brand" then website_session_id else null end)
    /count(distinct case when channel_group = "paid_nonbrand" then website_session_id else null end) as brand_pct_of_nonbrand,
    
    count(distinct case when channel_group = "direct_type_in" then website_session_id else null end) as direct,
    
	count(distinct case when channel_group = "direct_type_in" then website_session_id else null end)
	/count(distinct case when channel_group = "paid_nonbrand" then website_session_id else null end) as direct_pct_of_nonbrand,
    
	count(distinct case when channel_group = "organic_search" then website_session_id else null end) as organic,
    
	count(distinct case when channel_group = "organic_search" then website_session_id else null end)
	/count(distinct case when channel_group = "paid_nonbrand" then website_session_id else null end) as organic_pct_of_nonbrand
from (
select
	website_session_id,
    created_at,
    case
		when utm_source is null and http_referer in ("https://www.gsearch.com", "https://www.bsearch.com") then "organic_search"
        when utm_campaign = "nonbrand" then "paid_nonbrand"
        when utm_campaign = "brand" then "paid_brand"
        when utm_source is null and http_referer is null then "direct_type_in"
	end as channel_group
from website_sessions
where created_at < '2012-12-23'
) as sessions_with_channel_grouping
group by
	year(created_at),
    month(created_at)