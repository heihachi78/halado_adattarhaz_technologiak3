select 
	p.partner_id, 
	p."name" as partner_name,
	s."name" as sector_name,
	p.created_at 
from 
	{{ source("staging", "partners") }} p,
	{{ source("staging", "sectors") }} s
where
	p.sector_id = s.sector_id
