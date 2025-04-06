{{ config(
	materialized = 'table',
	unlogged=True,
    indexes=[
      {'columns': ['purchase_id'], 'unique': True}
    ]
)}}

select 
	p.purchase_id,
	r."name" as partner_name,
	s."name" as sector_name,
	p.purchased_at::date,
	p.batch_number,
	p.batch_purchase_value
from 
	{{ source("staging", "purchases") }} p,
	{{ source("staging", "partners") }} r,
	{{ source("staging", "sectors") }} s
WHERE
	p.partner_id = r.partner_id
	and r.sector_id = s.sector_id
