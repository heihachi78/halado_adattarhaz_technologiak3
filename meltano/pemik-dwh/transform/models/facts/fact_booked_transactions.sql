select
	pd.payed_debt_id,
	s.sector_id,
	r.partner_id,
	p.purchase_id,
	c.case_id,
	d.calculated_to as invoice_date,
	d.calculated_to - d.calculated_from as days_covered,
	pd.debt_amount_covered,
	pd.interest_amount_covered,
	pd.overpayment
from
	{{ source("staging", "sectors") }} s,
	{{ source("staging", "partners") }} r,
	{{ source("staging", "purchases") }} p,
	{{ source("staging", "cases") }} c,
	{{ source("staging", "debts") }} d,
	{{ source("staging", "payed_debts") }} pd
where
	s.sector_id = r.sector_id and
	r.partner_id = p.partner_id and
	p.purchase_id = c.purchase_id and
	c.case_id = d.case_id and
	d.debt_id = pd.debt_id and
	s.deleted_at is null and
	r.deleted_at is null and
	p.deleted_at is null and
	c.deleted_at is null and
	d.deleted_at is null and
	pd.deleted_at is null
