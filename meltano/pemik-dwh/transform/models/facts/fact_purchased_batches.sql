{{ config(
	materialized = 'table',
	unlogged=True,
    indexes=[
      {'columns': ['purchase_id'], 'unique': True},
	  {'columns': ['sector_id']},
	  {'columns': ['partner_id']},
	  {'columns': ['purchased_at']}
    ]
)}}

select
	s.sector_id,
	p.partner_id,
	p.purchase_id,
	p.purchased_at::date,
	p.batch_purchase_value
from
	{{ source("staging", "purchases") }} p,
	{{ source("staging", "partners") }} r,
	{{ source("staging", "sectors") }} s
where
	p.deleted_at is null and
	r.deleted_at is null and
	r.partner_id = p.partner_id and
	s.deleted_at is null and
	s.sector_id = r.sector_id
