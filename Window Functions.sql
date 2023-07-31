--  Window Functions practice

--- AVG price using OVER

SELECT
	id,
	name,
	neighbourhood_group,
	AVG(price) OVER() -- adding "OVER" will show all columns, instead of a single column
FROM Airbnb_NYC;

--- Difference between AVG price vs price

SELECT
	id,
	name,
	neighbourhood_group,
	neighbourhood,
	round(AVG(price) OVER(),2) as AVG_Price,
	round(price - AVG(price) OVER(),2) as Price_AVG_Diff
FROM Airbnb_NYC;

-- PARTITION BY neighbourhood_group

SELECT
	id,
	name,
	neighbourhood_group,
	neighbourhood,
	round(AVG(price) OVER(PARTITION BY neighbourhood_group),2) as AVG_Price_within_neighbourhood_group -- the "AVG" function now calculates the average by the neighbourhood_group using "PARTITION BY" instead of all rows
FROM Airbnb_NYC;

-- PARTITION BY neighbourhood_group and neighbourhood

SELECT
	id,
	name,
	neighbourhood_group,
	neighbourhood,
	round(AVG(price) OVER(PARTITION BY neighbourhood_group),2) as AVG_Price_within_neighbourhood_group, 
	round(AVG(price) OVER(PARTITION BY neighbourhood_group,neighbourhood),2) as AVG_Price_within_neighbourhood_group_and_neighbourhood -- the "AVG" function now calculates the average by the neighbourhood_group and neighbourhood
FROM Airbnb_NYC;


-- PARTITION BY neighbourhood_group and neighbourhood, and the diff between price and neighbourhood

SELECT
	id,
	name,
	neighbourhood_group,
	neighbourhood,
	round(AVG(price) OVER(PARTITION BY neighbourhood_group),2) as AVG_Price_within_neighbourhood_group, 
	round(AVG(price) OVER(PARTITION BY neighbourhood_group,neighbourhood),2) as AVG_Price_within_neighbourhood_group_and_neighbourhood, 
	round(price - AVG(price) OVER(PARTITION BY neighbourhood_group,neighbourhood),2) as group_and_neighbouhood_diff_vs_price -- diff between the listing price and the avg price of the neighbourhood_group and neighbourhood
FROM Airbnb_NYC;

-- ROW_NUMBER

SELECT
	id,
	name,
	neighbourhood_group,
	neighbourhood,
	price,
	row_number() OVER(ORDER by	price DESC) as price_rank -- ranking all the rows by highest price
FROM Airbnb_NYC;

-- ROW_NUMBER and PARTITION by	neighbourhood_group

SELECT
	id,
	name,
	neighbourhood_group,
	neighbourhood,
	price,
	row_number() OVER(ORDER by	price DESC) as price_rank,
	row_number() OVER(PARTITION by neighbourhood_group ORDER by price DESC) as neighbourhood_group_price_rank -- ranking within the neighbourhood_group
FROM Airbnb_NYC;

-- Top 3 by neighbourhood_group

SELECT
	id,
	name,
	neighbourhood_group,
	neighbourhood,
	price,
	row_number() OVER(ORDER by	price DESC) as price_rank,
	row_number() OVER(PARTITION by neighbourhood_group ORDER by price DESC) as neighbourhood_group_price_rank,
	CASE
		WHEN row_number() OVER(PARTITION by neighbourhood_group ORDER by price desc) <= 3 THEN 'yes'
		ELSE 'no'
	END as is_top3
FROM Airbnb_NYC;

-- Only showing Top 3 ROWS

SELECT * FROM (
SELECT
	id,
	name,
	neighbourhood_group,
	neighbourhood,
	price,
	row_number() OVER(ORDER by	price DESC) as price_rank,
	row_number() OVER(PARTITION by neighbourhood_group ORDER by price DESC) as neighbourhood_group_price_rank,
	CASE
		WHEN row_number() OVER(PARTITION by neighbourhood_group ORDER by price desc) <= 3 THEN 'yes'
		ELSE 'no'
	END as is_top3
FROM Airbnb_NYC
) aaa
WHERE is_top3 = 'yes'; -- same query as before, but only showing the rows where neighbourhood_group is in the top 3


-- RANK function

SELECT
	id,
	name,
	neighbourhood_group,
	neighbourhood,
	price,
	row_number() OVER(ORDER by	price DESC) as price_rank,
	rank() OVER(ORDER by	price DESC) as price_rank_rank, --- RANK function will give the same rank to rows that have the same price value
	row_number() OVER(PARTITION by neighbourhood_group ORDER by price DESC) as neighbourhood_group_price_rank,
	rank() OVER(PARTITION by neighbourhood_group ORDER by price DESC) as neighbourhood_group_price_rank_rank
	
FROM Airbnb_NYC;

-- lag

SELECT
	id,
	name,
	host_name,
	last_review,
	price,
	lag(price, 1) OVER(PARTITION by host_name ORDER by	last_review) as lag -- retrives the price from the previous last_review date (by 1 period)
FROM Airbnb_NYC;

-- lead

SELECT
	id,
	name,
	host_name,
	last_review,
	price,
	lead(price, 1) OVER(PARTITION by host_name ORDER by	last_review) as lead -- retrives the price from the next last_review date (by 1 period)
FROM Airbnb_NYC;

-- by Nikhil B
