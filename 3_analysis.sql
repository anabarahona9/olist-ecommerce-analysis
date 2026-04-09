USE olist_ecommerce;

CREATE VIEW vw_Master_Orders AS
SELECT 
    o.order_id,
    o.order_purchase_timestamp,
    o.order_estimated_delivery_date,
    o.order_delivered_customer_date,
    op.payment_value,
    ca.product_category_name_english,
    p.product_category_name,
    p.product_id,
    oi.price,
    r.review_score,
    c.customer_state,
    c.customer_id,
    s.seller_id
FROM orders AS o
JOIN order_items AS oi ON o.order_id = oi.order_id
JOIN order_payments AS op ON o.order_id = op.order_id
JOIN products AS p ON oi.product_id = p.product_id
JOIN category AS ca ON p.product_category_name = ca.product_category_name
JOIN reviews AS r ON r.order_id = o.order_id
JOIN customers AS c ON c.customer_id = o.customer_id
JOIN sellers AS s ON s.seller_id = oi.seller_id;


/* Top sales by day of the week */

SELECT 
	DATENAME(weekday, order_purchase_timestamp) as Day,
	SUM(price) as TotalSales 
FROM vw_Master_Orders
GROUP BY DATENAME(weekday, order_purchase_timestamp)
ORDER BY totalSales DESC

/* Top sales by month */

SELECT 
	DATENAME(MONTH, order_purchase_timestamp) as Month,
	SUM(price) as TotalSales 
FROM vw_Master_Orders
GROUP BY DATENAME(MONTH, order_purchase_timestamp)
ORDER BY totalSales DESC


/* Product categories by revenue */

SELECT 
    product_category_name_english AS Category, 
    SUM(payment_value) AS totalSales
FROM vw_Master_Orders
GROUP BY product_category_name_english
ORDER BY SUM(payment_value) DESC;

/* Delivery delay */

SELECT 
    product_category_name_english AS ProductCategory, 
    AVG ( DATEDIFF( day, order_estimated_delivery_date, order_delivered_customer_date)) AS AvgDeliveryDelay
FROM vw_Master_Orders
WHERE order_delivered_customer_date IS NOT NULL 
GROUP BY product_category_name_english
ORDER BY AvgDeliveryDelay;

/* Percentage of late deliveries */ 

SELECT 
	COUNT(*) as TotalDeliveries,
	SUM(CASE WHEN order_delivered_customer_date > order_estimated_delivery_date 
THEN 1 ELSE 0 END) AS DelayedDeliveries,
	(SUM(CASE WHEN order_delivered_customer_date > order_estimated_delivery_date 
THEN 1 ELSE 0 END) * 100.0 / COUNT(*)) AS DelayedDeliveryPercentage
FROM orders
WHERE order_delivered_customer_date IS NOT NULL 

/* Impact of late deliveries on review score */ 

SELECT 
	CASE 
		WHEN order_delivered_customer_date > order_estimated_delivery_date 
		THEN 'Late' ELSE 'On Time' END AS DeliveryStatus, 
	AVG(review_score) as AverageReviewScore, 
	SUM(CASE WHEN review_score >= 3 THEN 1 ELSE 0 END) AS PositiveReviews,
	SUM(CASE WHEN review_score <3 THEN 1 ELSE 0 END) as NegativeReviews 
FROM vw_Master_Orders
WHERE order_delivered_customer_date IS NOT NULL 
GROUP BY 
	CASE 
		WHEN order_delivered_customer_date > order_estimated_delivery_date
	THEN 'Late' ELSE 'On Time' END;

/*  Average Sales by State */

SELECT 
	customer_state AS State, 
	AVG (payment_value) AS AverageSales 
FROM vw_Master_Orders
GROUP BY customer_state 
ORDER BY AverageSales DESC;

/* Sellers Performance by Category */

WITH performance AS( 
	SELECT 
		seller_id, SUM(price) AS TotalSales,
		AVG(review_score) AS AverageReviewScore,
		COUNT(DISTINCT order_id) AS TotalOrders,
		CASE 
			WHEN AVG (review_score) >= 4 AND SUM(price) > 50000 THEN 'Top Seller'
			WHEN AVG (review_score) <=2 THEN 'Poor Performer'
			ELSE 'Average'
		END AS PerformanceCategory
	FROM vw_Master_Orders
	GROUP BY seller_id
)
SELECT 
	PerformanceCategory,
    COUNT(*) AS TotalSellers,
    AVG(TotalSales) AS AverageRevenue,
    AVG(AverageReviewScore) AS AverageScore
FROM performance
GROUP BY PerformanceCategory
ORDER BY AverageRevenue DESC;


