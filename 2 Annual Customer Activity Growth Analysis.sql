-- Average monthly active user
with mau_per_year as (
    select
        extract(year from o.order_purchase_timestamp) AS year,
		extract(month from o.order_purchase_timestamp) AS month,
        count(distinct c.customer_unique_id) AS mau
    from orders o
    join customers c ON c.customer_id = o.customer_id
	group by 1,2
),
avg_mau_per_year as (
	select
    	year,
    	round(avg(mau), 2) AS avg_mau
	from mau_per_year
	group by year
),

-- Total new customers
new_purchase as (
	select
		c.customer_unique_id,
		min(o.order_purchase_timestamp) as first_purchase
	from orders o
	join customers c
		on c.customer_id = o.customer_id
	group by 1
),
new_customer_per_year as (
	select
		extract (year from first_purchase) as year,
		count (*) as new_customer
	from new_purchase
	group by year
	order by year
),

-- Total repeat order 
customer_purchase as (
	select
		extract (year from o.order_purchase_timestamp) as year,
		c.customer_unique_id,
		count(*) as purchase
	from orders o
	join customers c
		on c.customer_id = o.customer_id
	group by 1,2
	having count(*) > 1
),
repeat_order_per_year as (
	select
		year,
		count (distinct customer_unique_id) as repeat_customer
	from customer_purchase
	group by year
),

-- Average order frequency
purchase_frequency as (
	select
		extract (year from o.order_purchase_timestamp) as year,
		c.customer_unique_id,
		count(*) as order_freq
	from orders o
	join customers c
		on c.customer_id = o.customer_id
	group by 1,2
),
avg_order_freq as (
	select
		year,
		round(avg(order_freq),2) as avg_customer_order
	from purchase_frequency
	group by year
)

-- Join to combine everything in one table
select
    a.year,
    a.avg_mau,
    b.new_customer,
    c.repeat_customer,
    d.avg_customer_order
from avg_mau_per_year a
left join new_customer_per_year b on a.year = b.year
left join repeat_order_per_year c on a.year = c.year
left join avg_order_freq d on a.year = d.year
order by a.year;