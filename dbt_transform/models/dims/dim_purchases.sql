select 
	p.purchase_id,
	p.batch_number,
	p.batch_purchase_value
from 
	{{ source("staging", "purchases") }} p
