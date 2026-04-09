USE olist_ecommerce;

/* RFM Customer Segmentation */ 

WITH BaseRFM AS (
	SELECT 
		customer_id,
		DATEDIFF(day, MAX(order_purchase_timestamp), '2018-09-03') AS Recency,
		COUNT(DISTINCT order_id) AS Frequency,
		SUM(price) AS Monetary
	FROM vw_Master_Orders
	GROUP BY customer_id
),
ScoresRFM AS (
	SELECT *,
		NTILE(5) OVER (ORDER BY Recency DESC) AS R_Score,
		NTILE(5) OVER (ORDER BY Frequency ASC) AS F_Score,
		NTILE(5) OVER (ORDER BY Monetary ASC) AS M_Score
	FROM BaseRFM
), 
FinalRFM AS(
	SELECT *,
	(R_Score + F_Score + M_Score) AS TotalScore
	FROM ScoresRFM
)
SELECT 
	customer_id,
	Recency,
	Frequency,
	Monetary,
	TotalScore,
	CASE 
		WHEN TotalScore >= 11 THEN 'High Value'
		WHEN TotalScore >= 7 THEN 'Mid Range'
		ELSE 'Low Value'
	END AS CustomerSegment
FROM FinalRFM
ORDER BY TotalScore DESC;