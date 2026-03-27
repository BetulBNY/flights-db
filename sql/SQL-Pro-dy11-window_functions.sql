-- QUESTION 1:
/*
Write a query that returns the running total of how late the flights are
(difference between actual_arrival and scheduled arrival) ordered by flight_id including the departure airport.
*/
SELECT 
flight_id,
scheduled_arrival,
actual_arrival,
SUM(actual_arrival - scheduled_arrival) OVER(ORDER BY flight_id),
FROM flights;

-- QUESTION 2:
-- AS a second query, calculate the same running total but partition also by the departure airport.
SELECT 
flight_id,
scheduled_arrival,
actual_arrival,
SUM(actual_arrival - scheduled_arrival) OVER(PARTITION BY departure_airport ORDER BY flight_id),
departure_airport
FROM flights;