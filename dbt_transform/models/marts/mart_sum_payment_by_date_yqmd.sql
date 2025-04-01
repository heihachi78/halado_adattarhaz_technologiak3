select 
	dd."year", 
	dd.quarter, 
	dd."month", 
	dd."day",
	sum(fp.amount)
from 
	public.fact_payments fp, 
	dim_dates dd 
where 
	fp.payment_date = dd.date_id
group by
	dd."year", 
	dd.quarter, 
	dd."month", 
	dd."day"
order by
	dd."year", 
	dd.quarter, 
	dd."month", 
	dd."day"