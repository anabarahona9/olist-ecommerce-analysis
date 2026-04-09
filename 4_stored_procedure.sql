USE olist_ecommerce;

/* Procedure */
CREATE PROCEDURE sp_GetStatePerformance
	@StateInitials CHAR(2)
AS 
BEGIN 
	SELECT 
		customer_state AS State,
		SUM(price) AS TotalRevenue,
		AVG(payment_value) AverageTicket,
		AVG (review_score) AS AverageSatisfaction
	FROM vw_Master_Orders
	WHERE customer_state = @StateInitials
	GROUP BY customer_state;
END; 

EXEC sp_GetStatePerformance @StateInitials = 'SP';

CREATE PROCEDURE sp_GetCategoryDeepDive
	@CategoryName VARCHAR(100)
AS
BEGIN
	SELECT 
		product_category_name_english AS Category,
		COUNT(*) AS TotalProductsSold,
		AVG (DATEDIFF (day, order_estimated_delivery_date, order_delivered_customer_date)) AS AverageDeliveryDelay,
		SUM(price) AS TotalSales
	FROM vw_Master_Orders
	WHERE product_category_name_english = @CategoryName
	GROUP BY product_category_name_english;
END;

EXEC sp_GetCategoryDeepDive @CategoryName = 'perfumery'
		
DROP PROCEDURE sp_Get_state_performance;
DROP PROCEDURE sp_Get_Category_deep_dive;


