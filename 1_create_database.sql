CREATE DATABASE olist_ecommerce;
USE olist_ecommerce;

CREATE TABLE customers (
	customer_id VARCHAR(50) PRIMARY KEY,
	customer_unique_id VARCHAR(50),
	customer_zip_code_prefix VARCHAR(10),
	customer_city VARCHAR(100),
	customer_state VARCHAR(5)
);

CREATE TABLE sellers (
	seller_id VARCHAR(50) PRIMARY KEY,
	seller_zip_code_prefix VARCHAR(10),
	seller_city VARCHAR(100),
	seller_state VARCHAR(5)
);

CREATE TABLE geolocation (
	geolocation_zip_code_prefix VARCHAR(10),
	geolocation_lat FLOAT,
	geolocation_long FLOAT,
	geolocation_city VARCHAR(100),
	geolocation_state VARCHAR(5)
);

CREATE TABLE category (
	product_category_name VARCHAR(100) PRIMARY KEY,
	product_category_name_english VARCHAR(100)
);

CREATE TABLE products (
	product_id VARCHAR(50) PRIMARY KEY,
	product_category_name VARCHAR(100) REFERENCES category(product_category_name),
	product_name_lenght INT,
	product_description_lenght INT, 
	product_photos_qty INT,
	product_weight_g INT,
	product_length_cm INT,
	product_height_cm INT,
	product_width_cm INT
);

CREATE TABLE orders (
	order_id VARCHAR(50) PRIMARY KEY, 
	customer_id VARCHAR(50) REFERENCES customers(customer_id),
	order_status VARCHAR(20),
	order_purchase_timestamp DATETIME,
	order_approved_at DATETIME,
	order_delivered_carrier_date DATETIME,
	order_delivered_customer_date DATETIME,
	order_estimated_delivery_date DATETIME
);

CREATE TABLE order_items (
	order_id VARCHAR(50) REFERENCES orders(order_id),
	order_item_id INT,
	product_id VARCHAR(50) REFERENCES products(product_id),
	seller_id VARCHAR(50) REFERENCES sellers(seller_id),
	shipping_limit_date DATETIME,
	price DECIMAL(10,2),
	freight_value DECIMAL (10,2),
	PRIMARY KEY (order_id , order_item_id)
);


CREATE TABLE order_payments (
	order_id VARCHAR(50) REFERENCES orders(order_id),
	payment_sequential INT,
	payment_type VARCHAR(20),
	payment_installments INT,
	payment_value DECIMAL(10,2),
	PRIMARY KEY (order_id, payment_sequential)
);

CREATE TABLE reviews (
	review_id VARCHAR(50),
	order_id VARCHAR(50) REFERENCES orders(order_id),
	review_score INT, 
	review_comment_title VARCHAR(100),
	review_comment_message VARCHAR(MAX),
	review_creation_date DATETIME,
	review_answer_timestamp DATETIME,
	PRIMARY KEY (review_id , order_id)
);
