select
	s.sector_id,
	p.partner_id,
	p.purchased_at::date as data_point_date,
    sum(0) as incoming,
	sum(p.batch_purchase_value) as outgoing
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
group by
	s.sector_id,
	p.partner_id,
	p.purchased_at::date
union ALL
select 
	o.sector_id,
	n.partner_id,
	p.payment_date::date as data_point_date,
	sum(p.amount) as incoming,
    sum(0) as outgoing
from
	{{ source("staging", "sectors") }} o,
	{{ source("staging", "partners") }} n,
	{{ source("staging", "purchases") }} r,
	{{ source("staging", "cases") }} c,
	{{ source("staging", "debtors") }} d,
	{{ source("staging", "persons") }} t,
	{{ source("staging", "bank_accounts") }} a,
	{{ source("staging", "payments") }} p
where
	o.sector_id = n.sector_id and 
	n.partner_id = r.partner_id and
	r.purchase_id = c.purchase_id and 
	d.case_id = c.case_id and 
	d.person_id = t.person_id and 
	p.case_id = c.case_id and 
	t.person_id = p.person_id and
	a.bank_account_id = p.bank_account_id and 
	o.deleted_at is null and
	n.deleted_at is null and
	r.deleted_at is null and
	c.deleted_at is null and
	d.deleted_at is null and
	t.deleted_at is null and
	a.deleted_at is null and
	p.deleted_at is null
group by
	o.sector_id,
	n.partner_id,
	p.payment_date::date
