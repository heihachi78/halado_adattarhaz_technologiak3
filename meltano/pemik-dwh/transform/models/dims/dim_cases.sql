{{ config(
	materialized = 'table',
    indexes=[
      {'columns': ['case_id'], 'unique': True}
    ]
)}}

select 
	c.case_id,
	s."name" as sector,
	r."name" as partner,
	p.batch_number,
	c.partner_case_number,
	p.purchased_at::date,
	c.due_date::date as original_due_date,
	c.closed_at::date,
	c.interest_rate,
	case when c.closed_at is null then 'nyitott' else 'zárt' end as status
from 
	{{ source("staging", "cases") }} c,
	{{ source("staging", "purchases") }} p,
	{{ source("staging", "partners") }} r,
	{{ source("staging", "sectors") }} s
where
	c.purchase_id = p.purchase_id and
	p.partner_id = r.partner_id and 
	r.sector_id = s.sector_id
