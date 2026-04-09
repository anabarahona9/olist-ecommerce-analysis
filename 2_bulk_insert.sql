USE olist_ecommerce;

BULK INSERT customers
FROM 'D:\archive\clean\olist_customers_clean.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    TABLOCK
);

BULK INSERT sellers
FROM 'D:\archive\clean\olist_sellers_clean.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    TABLOCK
);

BULK INSERT geolocation
FROM 'D:\archive\clean\olist_geolocation_clean.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    TABLOCK
);

BULK INSERT category
FROM 'D:\archive\clean\olist_category_clean.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    TABLOCK
);

INSERT INTO category VALUES ('unknown', 'unknown')

BULK INSERT products
FROM 'D:\archive\clean\olist_products_clean.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    TABLOCK
);

BULK INSERT orders
FROM 'D:\archive\clean\olist_orders_clean.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    TABLOCK
);


BULK INSERT order_items
FROM 'D:\archive\clean\olist_order_items_clean.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    TABLOCK
);


BULK INSERT order_payments
FROM 'D:\archive\clean\olist_order_payments_clean.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    TABLOCK
);

BULK INSERT reviews
FROM 'D:\archive\clean\olist_reviews_clean.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\r\n',
    FIELDQUOTE = '"',
    TABLOCK
);

SELECT 'customers' as tabla, COUNT(*) as filas FROM customers UNION ALL
SELECT 'sellers', COUNT(*) FROM sellers UNION ALL
SELECT 'geolocation', COUNT(*) FROM geolocation UNION ALL
SELECT 'category', COUNT(*) FROM category UNION ALL
SELECT 'products', COUNT(*) FROM products UNION ALL
SELECT 'orders', COUNT(*) FROM orders UNION ALL
SELECT 'order_items', COUNT(*) FROM order_items UNION ALL
SELECT 'order_payments', COUNT(*) FROM order_payments UNION ALL
SELECT 'reviews', COUNT(*) FROM reviews;
