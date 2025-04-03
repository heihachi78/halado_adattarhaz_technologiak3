select 
	p.partner_id, 
	p."name" as partner_name,
	p.created_at::date
from 
	{{ source("staging", "partners") }} p
