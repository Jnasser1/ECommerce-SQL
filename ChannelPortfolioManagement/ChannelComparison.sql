# For bsearch nonbrand campaign, whats the percentage of traffic coming on mobile devices compared to the gsearch percentage?
# Aggregate data since August 22nd 2012   


# gsearch is about 25% mobile sessions, bsearch 8.6% mobile sessions.
select
	website_sessions.utm_source,
    count(distinct website_sessions.website_session_id) as sessions,
    count(distinct case when website_sessions.device_type ='mobile' then website_sessions.website_session_id else null end) as mobile_sessions,
	# Percentage of total traffic
	count(distinct case when  website_sessions.device_type ='mobile'  then website_sessions.website_session_id else null end)/count(distinct website_sessions.website_session_id) as percent_of_total
    from website_sessions 
	where website_sessions.created_at between '2012-08-22' and '2012-11-30'
    and website_sessions.utm_campaign = 'nonbrand'
    group by  1
    order by 2 desc;
    
    
# Should bsearch nonbrand traffic have the same bids as gsearch?
# Director requests nonbrand conversion rates from session to order for gsearch and bsearch, slicing data by device type.alter
# Analyze data from August 22nd to September 18.
# We will display device_type,utm_source, sessions and order volumes, and  conversion rates,


# For desktop gsearch conversion rate 4.5%, bsearch conversion rate 3.8%
# For mobile gsearch 1.2% conv_rate, and bsearch 0.7% conv_rate,
# Therefore Marketing Director could bid down on bsearch.
select
	website_sessions.device_type,
	website_sessions.utm_source,
   count(distinct website_sessions.website_session_id) as sessions,
    count(distinct orders.order_id) as orders,
    count(distinct orders.order_id)/count(distinct website_sessions.website_session_id) as conv_rate
from website_sessions left join orders on website_sessions.website_session_id = orders.website_session_id
where website_sessions.created_at between '2012-08-22' and '2012-09-19'
and website_sessions.utm_campaign = 'nonbrand'
group by website_sessions.device_type, website_sessions.utm_source
order by 3 desc;


# Marketing department bid down bsearch nonbrand on December 2nd.
# Lets compare weekly session volume for gsearch and bsearch, nonbrand, sliced by device_type, since November 4th, to December 22nd.
# -----
# bsearch volume is stable between 7-12% of gsearch volume. The bid down in bsearch on December 22nd decreased the ratio in desktop sessions by 10%, 
# That is desktop bsearch:gsearch volume was 39% Week of November 25, and drops to 23% the week of December 2nd (when Marketing bids down on bsearch)
# However mobile bsearch:gsearch volume increases by 3% in that time frame.
# We conclude bsearch mobile session volume is less sensitive to bid changes, while bsearch desktop volume is more price elastic.

select
min(date(website_sessions.created_at)) as week_start_date,
count(distinct case when website_sessions.device_type = 'desktop' and website_sessions.utm_source='gsearch' then website_sessions.website_session_id else null end ) as g_dt_sessions,
count(distinct case when website_sessions.device_type = 'desktop' and website_sessions.utm_source='bsearch' then website_sessions.website_session_id else null end ) as b_dt_sessions,
count(distinct case when website_sessions.device_type = 'mobile' and website_sessions.utm_source='gsearch' then website_sessions.website_session_id else null end ) as g_mob_sessions,
count(distinct case when website_sessions.device_type = 'mobile' and website_sessions.utm_source='bsearch' then website_sessions.website_session_id else null end ) as b_mob_sessions,

# How is bsearch mobie session volume doing compared to gsearch mobile session volume? bsearch as a percent of gsearch:
count(distinct case when website_sessions.device_type = 'mobile' and website_sessions.utm_source='bsearch' then website_sessions.website_session_id else null end )/
count(distinct case when website_sessions.device_type = 'mobile' and website_sessions.utm_source='gsearch' then website_sessions.website_session_id else null end ) as b_pct_g_mob_vol,

# How is bsearch desktop session volume doing compared to gsearch desktop ession volume? bsearch as a percent of gsearch:
count(distinct case when website_sessions.device_type = 'desktop' and website_sessions.utm_source='bsearch' then website_sessions.website_session_id else null end )/
count(distinct case when website_sessions.device_type = 'desktop' and website_sessions.utm_source='gsearch' then website_sessions.website_session_id else null end ) as b_pct_g_dtop_vol,

# Percent of total sesssions for g/bsearch for each device type
count(distinct website_sessions.website_session_id) as total_sessions,
count(distinct case when website_sessions.device_type = 'desktop' and website_sessions.utm_source='gsearch' then website_sessions.website_session_id else null end )/count(distinct website_sessions.website_session_id) as g_dtop_totvol_pct,
count(distinct case when website_sessions.device_type = 'mobile' and website_sessions.utm_source='gsearch' then website_sessions.website_session_id else null end )/count(distinct website_sessions.website_session_id) as g_mob_totvol_pct,
count(distinct case when website_sessions.device_type = 'desktop' and website_sessions.utm_source='bsearch' then website_sessions.website_session_id else null end )/count(distinct website_sessions.website_session_id) as b_dtop_totvol_pct,

count(distinct case when website_sessions.device_type = 'mobile' and website_sessions.utm_source='bsearch' then website_sessions.website_session_id else null end )/count(distinct website_sessions.website_session_id) as b_mob_totvol_pct

from website_sessions
where website_sessions.created_at between '2012-11-04' and '2012-12-22'
and website_sessions.utm_campaign = 'nonbrand'
group by week(website_sessions.created_at);





# What about orders from bsearch after the bid down? 

# Bidding down on bsearch saved the company money.
# Yes, as bsearch orders are a small part of company revenue and order amounts appear unaffected by the bid down.
# During this time period there was no mobile order loss from bsearch, and bsearch % of total weekly orders reamins stable.
# We find bsearch session volumes and order volumes are bid-change inelastic.


select
min(date(website_sessions.created_at)) as week_start_date,
count(distinct orders.order_id) as weekly_orders,
count(distinct case when website_sessions.device_type = 'desktop' and website_sessions.utm_source='gsearch' then orders.order_id else null end ) as g_dt_orders,
count(distinct case when website_sessions.device_type = 'mobile' and website_sessions.utm_source='gsearch' then orders.order_id  else null end ) as g_mob_orders,
count(distinct case when website_sessions.device_type = 'desktop' and website_sessions.utm_source='bsearch' then orders.order_id else null end ) as b_dt_orders,
count(distinct case when website_sessions.device_type = 'mobile' and website_sessions.utm_source='bsearch' then orders.order_id  else null end ) as b_mob_orders,

# bsearch orders: gsearch
count(distinct case when website_sessions.device_type = 'desktop' and website_sessions.utm_source='bsearch' then orders.order_id else null end )
/count(distinct case when website_sessions.device_type = 'desktop' and website_sessions.utm_source='gsearch' then orders.order_id else null end) as b_pct_of_g_dtop_orders,

# bsearch orders: weekly total orders
count(distinct case when website_sessions.device_type = 'desktop' and website_sessions.utm_source='bsearch' then orders.order_id else null end )
/count(distinct orders.order_id)   as b_pct_of_weekly_orders,


#bsearch session desktop conversion rate for the week
count(distinct case when website_sessions.device_type = 'desktop' and website_sessions.utm_source='bsearch' then orders.order_id else null end )
/count(distinct case when website_sessions.device_type = 'desktop' and website_sessions.utm_source='bsearch' then website_sessions.website_session_id else null end) 
as b_dtop_conv_rate

from website_sessions left join orders on website_sessions.website_session_id = orders.website_session_id
where website_sessions.created_at between '2012-11-04' and '2012-12-22'
and website_sessions.utm_campaign = 'nonbrand'
group by week(website_sessions.created_at);

