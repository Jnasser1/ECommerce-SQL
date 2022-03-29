# Analyzing a portfolio of marketing channels is about bidding efficienctly
# and using data to maximize the effeciveness of a marketing budget.

# Common Use Cases:
	# Understanding which marketing channel is driving orders and sessions through a website
    # Understanding differences in user characteristic performance across marketing channels
    # Optimizing bids and allocating marketing spend across multi-channel portfolio to achieve max performance.
    
    # Traffic is  tagged with tracking (UTM) parameters
    
    
    
    # Lets get a portfolio of ad's and compare their performance up to November 30 2012
    
	select 
		website_sessions.utm_content	,
        COUNT(distinct website_sessions.website_session_id) as sessions,
        COUNT(distinct orders.order_id) as orders,
		 COUNT(distinct orders.order_id)/COUNT(distinct website_sessions.website_session_id) as order_converion_rate
	from website_sessions 
		left join orders on website_sessions.website_session_id=orders.website_session_id
	where website_sessions.created_at < '2012-11-30'
    group by 1
    order by 4 DESC;
	
    
    
    # Marketing Director requests weekly trended session volume for b_search utm_source,
    # and a comparison to gsearch nonbrand sesson volume to get a sense of the impact on the buisness.
    
    
    select * from website_sessions
    where utm_source =  'bsearch'
    and created_at < '2012-11-29';
    
    
    
    # In general gsearch is about 3x as big of a factor as bsearch.
    select
	#	yearweek(website_sessions.created_at) as year_week,
		MIN(DATE(website_sessions.created_at)) AS week_start,
      # website_sessions.utm_content,
     #   website_sessions.utm_campaign,
        count(distinct case when website_sessions.utm_source ='bsearch' then website_sessions.website_session_id else null end) as b_search_sessions,
        count(distinct case when website_sessions.utm_source ='gsearch' then website_sessions.website_session_id else null end) as g_search_sessions,
		count(distinct case when website_sessions.utm_source ='bsearch' then orders.order_id  else null end) as b_search_orders,
        count(distinct case when website_sessions.utm_source ='gsearch' then orders.order_id  else null end) as g_search_orders,
		count(distinct case when website_sessions.utm_source ='bsearch' then orders.order_id  else null end)/count(distinct website_sessions.website_session_id) as b_search_conv_rate,
        count(distinct case when website_sessions.utm_source ='gsearch' then orders.order_id  else null end)/count(distinct website_sessions.website_session_id) as g_search_conv_rate
    from website_sessions 
    left join orders 
				on website_sessions.website_session_id = orders.website_session_id
	where website_sessions.created_at between '2012-08-22' and '2012-11-29'
    and website_sessions.utm_campaign = 'nonbrand'
    group by yearweek(website_sessions.created_at)
    order by 2;
    
    
    
    
    
    