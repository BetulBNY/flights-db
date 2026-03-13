-- CASE-WHEN :
	/*	
	CASE
	WHEN condition1 THEN resulti
	WHEN condition2 THEN result
	WHEN conditionN THEN resultN
	ELSE result
	END
	*/
--COALESCE -->  COALESCE(value1, value2, value3, ...)	
	/*
	Mantık:
	value1 NULL mı?	
	Hayır → value1’i döndür	
	Evet → value2’ye bak	
	value2 NULL mı?	
	Hayır → value2’yi döndür
	Evet → value3’e bak
	*/
	-- SAMPLE: SELECT COALESCE(NULL, NULL, 10, 20);  RETURNS 10
	
-- CAST --> Changes the data type of a value like: timestamp to text
	-- Syntax: CAST(value/column AS data type)
-- REPLACE  --> Replaces text from a string in a column with another text
	--Syntax: REPLACE(column, old_text, new_text)

SELECT
--actual_departure - scheduled_departure,
COUNT(*) AS flights,
CASE
WHEN actual_departure IS Null THEN 'No departure time'
WHEN actual_departure - scheduled_departure < '00:05' THEN 'On Time'
WHEN actual_departure - scheduled_departure < '01:00' THEN 'A bit late'
Else 'Very Late!'
END AS is_late
FROM flights
GROUP BY is_late;

/*
QUESTION 1: 
You need to find out how many tickets you have sold in the following categories:
* Low price ticket: total_amount < 20,000
* Mid price ticket: total_amount between 20,000 and 150,000
* High price ticket: total_amount >= 150,000
How many high price tickets has the company sold?
*/
SELECT
COUNT(*) numb_of_tickets,
CASE
WHEN amount < 20000 THEN 'Low price ticket'
WHEN amount <150000   THEN 'Mid price ticket'
ELSE 'High price ticket'
END as ticket_price
FROM ticket_flights
GROUP BY ticket_price;

/*
QUESTION 2: 
You need to find out how many flights are scheduled for departure in the following seasons:
* Winter:
December, January, Februar
* Spring:
March, April, May
* Summer:
June, July, August
* Fall:
September, October, November
*/

-- 1st Way: Using TO_CHAR
SELECT 
scheduled_departure,
TO_CHAR(scheduled_departure, 'Month'),
CASE
WHEN (TO_CHAR(scheduled_departure, 'FMMonth')) IN ('December', 'January', 'February') THEN 'Winter'
WHEN (TO_CHAR(scheduled_departure, 'FMMonth')) IN ('March', 'April', 'May') THEN 'Spring'
WHEN (TO_CHAR(scheduled_departure, 'FMMonth')) IN ('June', 'July', 'August') THEN 'Summer'
WHEN (TO_CHAR(scheduled_departure, 'FMMonth')) IN ('September', 'October', 'November') THEN 'Fall'
END as season
FROM flights;

-- The Month format produces output with a fixed width. September  (9 letter). So, I put "FM/Fill Mode"
-- For delete these spaces. For check it:
SELECT 
    TO_CHAR(scheduled_departure, 'Month'),
    LENGTH(TO_CHAR(scheduled_departure, 'Month'))
FROM flights;

-- 2nd Way: Using EXTRACT
SELECT 
	COUNT(*) as flights,
    --scheduled_departure,
    CASE
        WHEN EXTRACT(MONTH FROM scheduled_departure) IN (12, 1, 2) THEN 'Winter'
        WHEN EXTRACT(MONTH FROM scheduled_departure) IN (3, 4, 5) THEN 'Spring'
        WHEN EXTRACT(MONTH FROM scheduled_departure) IN (6, 7, 8) THEN 'Summer'
        WHEN EXTRACT(MONTH FROM scheduled_departure) IN (9, 10, 11) THEN 'Fall'
    END AS season
FROM flights
GROUP BY season;


/*
// COALESCE
SAMPLE:
*/
SELECT
COALESCE(actual_arrival - scheduled_arrival, '0:00')
FROM flights;


/*
// CAST
SAMPLE1:
*/
SELECT
COALESCE(CAST(actual_arrival - scheduled_arrival AS VARCHAR), 'not arrived yet')
FROM flights;

-- SAMPLE2:
SELECT
CAST(ticket_no AS bigint)
FROM tickets;

/*
// REPLACE
QUESTION 6: Remove blank area in passenger_id
*/
SELECT 
CAST(REPLACE(passenger_id,' ', '')AS BIGINT)
FROM tickets

