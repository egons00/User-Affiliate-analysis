---Analyzing affiliates
SELECT  affiliate_id
       ,SUM(deposit_amount) AS cash
       ,COUNT(userid)       AS user_count
FROM spinwise
GROUP BY 1
ORDER BY 3 desc;



---Users with highest deposit sum
SELECT  userid				AS user
       ,SUM(deposit_amount) AS cash
FROM spinwise
GROUP BY 1
ORDER BY 2 desc;



---Analyzing biggest deposits by users
WITH max_cte AS
(
	SELECT  userid
	       ,id_pk
	       ,deposit_date
	       ,MAX(deposit_amount)                                                       AS cash
	       ,ROW_NUMBER() OVER (PARTITION BY userid ORDER BY MAX(deposit_amount) DESC) AS rn
	FROM spinwise
	GROUP BY  1,2,3
	ORDER BY 1 desc ,rn
)
SELECT  userid
       ,deposit_date
       ,cash
FROM max_cte
WHERE rn = 1
ORDER BY cash desc



---Analyzing daily deposit frequency
WITH daily_deposit AS
(
	SELECT  userid
	       ,MAX(deposit_amount) AS cash
	       ,COUNT(userid)       AS deposit_day_count
	       ,31                  AS total_days
	FROM spinwise
	GROUP BY 1
	ORDER BY 3 desc
)
SELECT  *
       ,(total_days - deposit_day_count) AS days_not_deposited
FROM daily_deposit
ORDER BY days_not_deposited;



---Analyzing affiliate performance by country
SELECT  affiliate_id,
       country
       ,COUNT(userid)       AS deposit_count
       ,SUM(deposit_amount) AS cash
FROM spinwise
GROUP BY 1,2
ORDER BY 1,3 desc;



---Analyzing country performance
SELECT  country
       ,COUNT(userid)       AS deposit_count
       ,SUM(deposit_amount) AS cash
FROM spinwise
GROUP BY 1
ORDER BY 3 desc;