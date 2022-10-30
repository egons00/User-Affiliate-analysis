---Analyzing affiliates
SELECT  affiliate_id
       ,SUM(deposit_amount) AS cash
       ,COUNT(userid)       AS user_count
FROM spinwise
GROUP BY 1
ORDER BY 3 desc;



---Analyzing biggest deposits by users
WITH max_cte AS
(
	SELECT  userid
	       ,id_pk
	       ,deposit_date
	       ,MAX(deposit_amount)                                                       AS cash
	       ,ROW_NUMBER() OVER (PARTITION BY userid ORDER BY MAX(deposit_amount) DESC) AS rn
	FROM spinwise
	GROUP BY  1
	         ,2
	         ,3
	ORDER BY 1 desc
	         ,rn asc
)
SELECT  userid
       ,deposit_date
       ,cash
FROM max_cte
WHERE rn = 1
ORDER BY cash desc