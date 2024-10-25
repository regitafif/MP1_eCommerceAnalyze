-- Create tables and importing CSV files, and assigning primary keys for each table
CREATE TABLE if not exists customers (
    customer_id varchar primary key,
	customer_unique_id varchar,
	customer_zip_code_prefix int,
	customer_city varchar,
	customer_state varchar
); 
COPY customers(customer_id, customer_unique_id, customer_zip_code_prefix, customer_city, customer_state)
FROM 'E:/Rakamin/Portofolio/mp1/customers_dataset.csv' DELIMITER ',' CSV HEADER;

CREATE TABLE if not exists geolocation (
	geolocation_zip_code_prefix int primary key,
	geolocation_lat double precision,
	geolocation_lng double precision,
	geolocation_city varchar,
	geolocation_state varchar
);
COPY geolocation(geolocation_zip_code_prefix, geolocation_lat, 
				 geolocation_lng, geolocation_city, geolocation_state)
FROM 'E:/Rakamin/Portofolio/mp1/geolocation_dataset.csv' DELIMITER ',' CSV HEADER;

CREATE TABLE if not exists order_items (
	order_id varchar,
	order_item_id int,
	product_id varchar,
	seller_id varchar,
	shipping_limit_date timestamp,
	price double precision,
	freight_value double precision
);
COPY order_items(order_id, order_item_id, product_id, seller_id, shipping_limit_date, price, freight_value)
FROM 'E:/Rakamin/Portofolio/mp1/order_items_dataset.csv' DELIMITER ',' CSV HEADER;

CREATE TABLE if not exists order_payments (
	order_id varchar,
	payment_sequential int,
	payment_type varchar,
	payment_installments int,
	payment_value double precision
);
COPY order_payments(order_id,payment_sequential,payment_type,payment_installments,payment_value)
FROM 'E:/Rakamin/Portofolio/mp1/order_payments_dataset.csv' DELIMITER ',' CSV HEADER;

CREATE TABLE if not exists order_reviews (
	review_id varchar primary key,
	order_id varchar,
	review_score int,
	review_comment_title varchar,
	review_comment_message varchar,
	review_creation_date timestamp,
	review_answer_timestamp timestamp
);
COPY order_reviews(review_id,order_id,review_score,review_comment_title,
				   review_comment_message,review_creation_date,review_answer_timestamp)
FROM 'E:/Rakamin/Portofolio/mp1/order_reviews_dataset.csv' DELIMITER ',' CSV HEADER;

CREATE TABLE if not exists orders (
	order_id varchar primary key,
	customer_id varchar,
	order_status varchar,
	order_purchase_timestamp timestamp,
	order_approved_at timestamp,
	order_delivered_carrier_date timestamp,
	order_delivered_customer_date timestamp,
	order_estimated_delivery_date timestamp
);
COPY orders(order_id,customer_id,order_status,order_purchase_timestamp,
			order_approved_at,order_delivered_carrier_date,
			order_delivered_customer_date,order_estimated_delivery_date)
FROM 'E:/Rakamin/Portofolio/mp1/orders_dataset.csv' DELIMITER ',' CSV HEADER;

CREATE TABLE if not exists product (
	product_id varchar primary key,
	product_category_name varchar,
	product_name_length double precision,
	product_description_length double precision,
	product_photos_qty double precision,
	product_weight_g double precision,
	product_length_cm double precision,
	product_height_cm double precision,
	product_width_cm double precision
);
COPY product(product_id, product_category_name, product_name_length,
			 product_description_length, product_photos_qty, product_weight_g,
			 product_length_cm, product_height_cm, product_width_cm)
FROM 'E:/Rakamin/Portofolio/mp1/product_dataset.csv' DELIMITER ',' CSV HEADER;

CREATE TABLE if not exists sellers (
	seller_id varchar primary key,
	seller_zip_code_prefix int,
	seller_city varchar,
	seller_state varchar
);
COPY sellers(seller_id,seller_zip_code_prefix,seller_city,seller_state)
FROM 'E:/Rakamin/Portofolio/mp1/sellers_dataset.csv' DELIMITER ',' CSV HEADER;



-- Data preparation before adding constraints
-- adding some zip code that exists in the customer data but not in geolocation data
insert into geolocation (geolocation_zip_code_prefix)
select distinct customer_zip_code_prefix
from customers
where customer_zip_code_prefix not in (select geolocation_zip_code_prefix from geolocation);

-- adding some zip code that exists in the sellers data but not in geolocation data
insert into geolocation (geolocation_zip_code_prefix)
select distinct seller_zip_code_prefix
from sellers



-- Adding constraints (foreign keys)
alter table customers
add foreign key (customer_zip_code_prefix) references geolocation (geolocation_zip_code_prefix);

alter table order_items
add foreign key (order_id) references orders (order_id),
add foreign key (product_id) references product (product_id),
add foreign key (seller_id) references sellers (seller_id);

alter table order_payments
add foreign key (order_id) references orders (order_id);

alter table order_reviews
add foreign key (order_id) references orders (order_id);

alter table orders
add foreign key (customer_id) references customers (customer_id);

alter table sellers
add foreign key (seller_zip_code_prefix) references geolocation (geolocation_zip_code_prefix);
where seller_zip_code_prefix not in (select geolocation_zip_code_prefix from geolocation);
