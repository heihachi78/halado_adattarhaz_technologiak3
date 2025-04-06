{{ config(
	materialized = 'table',
	unlogged=True,
    indexes=[
      {'columns': ['debt_id'], 'unique': True}
    ]
)}}

select
	d.debt_id,
	d.calculated_from::date,
	d.calculated_to::date,
	d.debt_amount,
	d.interest_rate,
	d.interest_amount,
	d.open_debt
from
	{{ source("staging", "debts") }} d
