{{ config(
    materialized = 'table',
    unlogged=True,
    indexes=[
      {'columns': ['sector_id'], 'unique': True}
    ]
)}}

select 
    s.sector_id, 
    s."name" as sector_name, 
    s.created_at::date 
from 
    {{ source("staging", "sectors") }} s
