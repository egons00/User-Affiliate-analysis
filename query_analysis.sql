---Analyzing affiliates
SELECT  affiliate_id
       ,SUM(deposit_amount) AS gmv_deposited
       ,COUNT(userid)       AS user_count
FROM spinwise
GROUP BY 1
ORDER BY 3 desc;



---Users with highest deposit sum
SELECT  userid			AS user
       ,SUM(deposit_amount) 	AS deposit_sum
FROM spinwise
GROUP BY 1
ORDER BY 2 desc;



---Analyzing biggest deposits by users
WITH max_cte AS
         (
             SELECT userid
                  , id_pk
                  , deposit_date
                  , MAX(deposit_amount)                                                       AS deposit_amount
                  , ROW_NUMBER() OVER (PARTITION BY userid ORDER BY MAX(deposit_amount) DESC) AS rn
             FROM spinwise
             GROUP BY 1, 2, 3
             ORDER BY 1 desc, rn
         )
SELECT userid
     , deposit_date
     , deposit_amount
FROM max_cte
WHERE rn = 1
ORDER BY 3 desc;



---Analyzing daily deposit frequency
WITH daily_deposit AS
(
	SELECT  userid              AS user_id
	       ,MAX(deposit_amount) AS deposit_amount
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
       CASE WHEN country = 'S' then 'Sweden'
             WHEN country = 'F' then 'Finland'
             WHEN country = 'E' then 'Estonia' else 0::text end 	AS country
       ,COUNT(userid)       						AS deposit_count
       ,SUM(deposit_amount) 						AS deposit_sum
FROM spinwise
GROUP BY 1,2
ORDER BY 1,3 desc;



---Analyzing country performance
SELECT  CASE WHEN country = 'S' THEN 'Sweden'
             WHEN country = 'F' THEN 'Finland'
             WHEN country = 'E' THEN 'Estonia'  ELSE 0::text END AS country
       ,COUNT(userid)                                            AS deposit_count
       ,SUM(deposit_amount)                                      AS cash
FROM spinwise
GROUP BY 1
ORDER BY 3 desc;


---How many users each affiliate brings per week?
SELECT  affiliate_id
       ,cast(date_trunc('week',deposit_date)as date) AS week_date
       ,COUNT(userid)                                AS user_count
       ,SUM(deposit_amount)                          AS deposit_sum
FROM spinwise
GROUP BY 1,2
ORDER BY 1,2;
