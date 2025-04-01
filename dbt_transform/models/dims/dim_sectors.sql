select 
    s.sector_id, 
    s."name" as sector_name, 
    s.created_at::date 
from 
    {{ source("staging", "sectors") }} s
