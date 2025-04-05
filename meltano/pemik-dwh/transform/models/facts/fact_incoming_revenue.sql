select 
	o.sector_id,
	n.partner_id,
	r.purchase_id,
	c.case_id,
	d.debtor_id,
	t.person_id,
	a.bank_account_id,
	p.payment_id,
	p.payment_date::date,
	p.amount
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
