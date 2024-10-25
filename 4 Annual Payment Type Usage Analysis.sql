-- Counting the usage frequency for each payment type
select
	payment_type,
	count (order_id) as usage_frequency
from order_payments
group by payment_type
order by count (order_id) desc;


-- Counting the usage frequency for each payment type per year
with payment_type_usage as (
	select
		extract (year from o.order_purchase_timestamp) as year,
		op.payment_type,
		count (o.order_id) as usage_frequency
	from orders o
	join order_payments op
		on op.order_id = o.order_id
	group by 1,2
)
select
	payment_type,
	sum (case when year = 2016 then usage_frequency else 0 end) as used_2016,
	sum (case when year = 2017 then usage_frequency else 0 end) as used_2017,
	sum (case when year = 2018 then usage_frequency else 0 end) as used_2018
from payment_type_usage
group by payment_type
order by 4 desc;