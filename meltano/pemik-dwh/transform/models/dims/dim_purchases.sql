select 
	p.purchase_id,
	r."name" as partner_name,
	s."name" as sector_name,
	p.batch_number,
	p.batch_purchase_value
from 
	{{ source("staging", "purchases") }} p,
	{{ source("staging", "partners") }} r,
	{{ source("staging", "sectors") }} s
WHERE
	p.partner_id = r.partner_id
	and r.sector_id = s.sector_id
