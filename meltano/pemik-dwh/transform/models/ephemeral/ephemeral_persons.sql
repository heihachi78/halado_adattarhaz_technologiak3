{{ config(materialized='ephemeral') }}

select 
    s.*,
    coalesce(s.updated_at, s.created_at) as snapshot_updated_at
from    
    {{ source('staging', 'persons') }} s
