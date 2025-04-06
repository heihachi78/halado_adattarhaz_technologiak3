{{ config(
	materialized = 'table',
	unlogged=True,
    indexes=[
      {'columns': ['case_id'], 'unique': True},
	  {'columns': ['sector_id']},
	  {'columns': ['partner_id']},
	  {'columns': ['purchase_id']},
	  {'columns': ['purchased_at']}
    ]
)}}

select 
	c.case_id,
	s.sector_id,
	r.partner_id,
	p.purchase_id,
	p.purchased_at::date,
    c.amount,
    c.calculated_purchase_value
from 
	{{ source("staging", "purchases") }} p,
	{{ source("staging", "partners") }} r,
	{{ source("staging", "sectors") }} s,
    {{ source("staging", "cases") }} c
where 
	r.partner_id = p.partner_id and
	s.sector_id = r.sector_id and
    c.purchase_id = p.purchase_id and
    p.deleted_at is null AND
    r.deleted_at is null AND
    s.deleted_at is null AND
    c.deleted_at is null
