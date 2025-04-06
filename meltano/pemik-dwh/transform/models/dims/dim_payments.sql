select 
	p.payment_id,
	a.account_number,
	p.payment_date::date
from
	{{ source("staging", "payments") }} p,
	{{ source("staging", "bank_accounts") }} a
where
	a.bank_account_id = p.bank_account_id