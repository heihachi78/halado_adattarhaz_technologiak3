{{ config(
	materialized = 'table',
	unlogged=True,
    indexes=[
      {'columns': ['person_id'], 'unique': True}
    ]
)}}

select
	p.person_id,
	concat(p.first_name, ' ', p.last_name) as person_full_name,
	p.birth_name,
	p.mother_name,
	c."name" as birth_place,
	p.birth_date::date,
	p.death_date::date,
	g."name" as gender
from
	{{ source("staging", "persons") }} p,
	{{ source("staging", "genders") }} g,
	{{ source("staging", "cities") }} c
where
	p.gender_id = g.gender_id and 
	c.city_id = p.birth_place_city_id
