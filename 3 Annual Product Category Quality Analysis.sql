-- Total revenue per year
create table if not exists total_revenue_per_year as
with total_revenue as (
	select 
		extract (year from o.order_purchase_timestamp) as year,
		oi.order_id,
		o.order_status,
		sum (price + freight_value) as sum_revenue
	from order_items oi
	join orders o
		on o.order_id = oi.order_id
	group by 1,2,3
)	
select
	year,
	sum (sum_revenue) as revenue
from total_revenue
where order_status = 'delivered'
group by 1;

-- Total canceled orders per year
create table if not exists canceled_orders_per_year as 
select
	extract (year from order_purchase_timestamp) as year,
	count (order_id) as total_canceled_orders
from orders
where order_status = 'canceled'
group by 1;

-- Top product sale per year
create table if not exists top_product_category as
with product_rank as (
	select
		extract (year from o.order_purchase_timestamp) as year,
		p.product_category_name,
		sum (oi.price + oi.freight_value) as revenue,
		rank() over (
			partition by extract (year from o.order_purchase_timestamp)
			order by sum (oi.price + oi.freight_value) desc
		) as rank
	from orders o
	join order_items oi
		on o.order_id = oi.order_id
	join product p
		on oi.product_id = p.product_id
	where order_status = 'delivered'
	group by 1,2
)
select
	year,
	product_category_name,
	revenue
from product_rank
where rank = 1
group by 1,2,3;

-- Top canceled product category per year
create table if not exists top_canceled_product_category as
with canceled_product as (
	select
		extract (year from o.order_purchase_timestamp) as year,
		p.product_category_name,
		o.order_status,
		count (oi.order_id) as cancel_order_product,
		rank() over (
			partition by extract (year from o.order_purchase_timestamp)
			order by count (oi.order_id) desc
		) as rank
	from orders o
	join order_items oi
		on o.order_id = oi.order_id
	join product p
		on oi.product_id = p.product_id
	where order_status = 'canceled'
	group by 1,2,3
)
select
	year,
	product_category_name,
	cancel_order_product
from canceled_product
where rank = 1
group by 1,2,3;

-- Combine everything into one table
create table if not exists annual_product_analysis as
select
	tr.year,
	tr.revenue as total_revenue,
	co.total_canceled_orders,
	tp.product_category_name as top_product_ctgr,
	tp.revenue as top_product_revenue,
	tc.product_category_name as top_canceled_product_ctgr,
	tc.cancel_order_product as top_canceled_product_order
from total_revenue_per_year tr
left join canceled_orders_per_year co
	on tr.year = co.year
left join top_product_category tp
	on tr.year = tp.year
left join top_canceled_product_category tc
	on tr.year = tc.year;