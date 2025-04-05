select 
	dd."year", 
	dd.quarter, 
	dd."month",
	dd.month_name,
	dd."day",
	sum(fp.amount)
from 
	{{ ref("fact_incoming_revenue") }} fp, 
	{{ ref("dim_dates") }} dd 
where 
	fp.payment_date = dd.date_id
group by
	dd."year", 
	dd.quarter, 
	dd."month",
	dd.month_name, 
	dd."day"
order by
	dd."year", 
	dd.quarter, 
	dd."month", 
	dd.month_name,
	dd."day"
