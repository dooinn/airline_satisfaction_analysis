-- 1. Satisfied or dissatisfied?

SELECT 
satisfaction, COUNT(*) AS total,
FROM `data-analysis-practice-314303.airline.train`
GROUP BY satisfaction
ORDER BY total DESC



-- 2. Satisfaction by Customer Type

WITH saitisfied_total AS(
SELECT Customer_Type, satisfaction, COUNT(*) as satisfied
FROM `data-analysis-practice-314303.airline.train`
WHERE satisfaction = 'satisfied'
GROUP BY Customer_Type, satisfaction
),
disatisfied_total AS (
SELECT Customer_Type, satisfaction, COUNT(*) as disatisfied
FROM `data-analysis-practice-314303.airline.train`
WHERE satisfaction = 'neutral or dissatisfied'
GROUP BY Customer_Type, satisfaction
)
SELECT  saitisfied_total.Customer_Type, saitisfied_total.satisfied, disatisfied_total.disatisfied, 
ROUND(saitisfied_total.satisfied/(saitisfied_total.satisfied+disatisfied_total.disatisfied),2) AS satisfied_percentile,
ROUND(disatisfied_total.disatisfied/(saitisfied_total.satisfied+disatisfied_total.disatisfied),2) AS disatisfied_percentile
FROM saitisfied_total
LEFT JOIN disatisfied_total ON saitisfied_total.Customer_Type = disatisfied_total.Customer_Type



--3. Satisfaction by class

WITH satisfied_total AS (
SELECT class, COUNT(*) AS satisfied
FROM `data-analysis-practice-314303.airline.train`
WHERE Satisfaction = 'satisfied'
GROUP BY class, Satisfaction
),
disatisfied_total AS(
SELECT class, COUNT(*) AS disatisfied_or_neutral
FROM `data-analysis-practice-314303.airline.train`
WHERE Satisfaction = 'neutral or dissatisfied'
GROUP BY class, Satisfaction
)
SELECT satisfied_total.class, satisfied_total.satisfied, disatisfied_total.disatisfied_or_neutral
FROM satisfied_total
LEFT JOIN disatisfied_total ON satisfied_total.class = disatisfied_total.class


-- 4. Satisfaction in attributes by class

SELECT Class,
	AVG(Inflight_wifi_service) AS Inflight_wifi_service,
	AVG(Departure_Arrival_time_convenient) AS Departure_Arrival_time_convenient,
	AVG(Ease_of_Online_booking) AS Ease_of_Online_booking,
	AVG(Gate_location) AS Gate_location,
	AVG(Food_and_drink) AS Food_and_drink,
	AVG(Online_boarding) AS Online_boarding,
	AVG(Seat_comfort) AS Seat_comfort,
	AVG(Inflight_entertainment) AS Inflight_entertainment,
	AVG(On_board_service) AS On_board_service,
	AVG(Leg_room_service) AS Leg_room_service,
	AVG(Baggage_handling) AS Baggage_handling,
	AVG(Checkin_service) AS Checkin_service,
	AVG(Inflight_service) AS Inflight_service,
	AVG(Cleanliness) AS Cleanliness
FROM `data-analysis-practice-314303.airline.train`
GROUP BY Class




-- 5. Satisfaction by age


WITH business_total AS (
    SELECT
CASE
    WHEN Age < 90 AND Age >= 80 THEN '90-80'        
    WHEN Age < 80 AND Age >= 70 THEN '80-70'        
    WHEN Age < 70 AND Age >= 60 THEN '70-60'        
    WHEN Age < 60 AND Age >= 50 THEN '60-50'        
    WHEN Age < 50 AND Age >= 40 THEN '50-40'        
    WHEN Age < 40 AND Age >= 30 THEN '40-30'       
    WHEN Age < 30 AND Age >= 20 THEN '30-20'      
    WHEN Age < 20 AND Age >= 10 THEN '20-10'        
    WHEN Age < 10 AND Age >= 0 THEN '10-0'        
    ELSE 'Other'
    END AS age_group,
    COUNT (*) AS business
FROM `data-analysis-practice-314303.airline.train`
WHERE class = 'Business'
GROUP BY class, age_group),
eco_total AS (
SELECT
CASE
    WHEN Age < 90 AND Age >= 80 THEN '90-80'        
    WHEN Age < 80 AND Age >= 70 THEN '80-70'        
    WHEN Age < 70 AND Age >= 60 THEN '70-60'        
    WHEN Age < 60 AND Age >= 50 THEN '60-50'       
    WHEN Age < 50 AND Age >= 40 THEN '50-40'        
    WHEN Age < 40 AND Age >= 30 THEN '40-30'        
    WHEN Age < 30 AND Age >= 20 THEN '30-20'        
    WHEN Age < 20 AND Age >= 10 THEN '20-10'        
    WHEN Age < 10 AND Age >= 0 THEN '10-0'        
    ELSE 'Other'
    END AS age_group,
    COUNT (*) AS eco
FROM `data-analysis-practice-314303.airline.train`
WHERE class = 'Eco'
GROUP BY class, age_group),
ecoplus_total AS (
SELECT
CASE
    WHEN Age < 90 AND Age >= 80 THEN '90-80'        
    WHEN Age < 80 AND Age >= 70 THEN '80-70'        
    WHEN Age < 70 AND Age >= 60 THEN '70-60'        
    WHEN Age < 60 AND Age >= 50 THEN '60-50'        
    WHEN Age < 50 AND Age >= 40 THEN '50-40'        
    WHEN Age < 40 AND Age >= 30 THEN '40-30'     
    WHEN Age < 30 AND Age >= 20 THEN '30-20'       
    WHEN Age < 20 AND Age >= 10 THEN '20-10'        
    WHEN Age < 10 AND Age >= 0 THEN '10-0'        
    ELSE 'Other'
    END AS age_group,
    COUNT (*) AS eco_plus
FROM `data-analysis-practice-314303.airline.train`
WHERE class = 'Eco Plus'
GROUP BY class, age_group)
SELECT business_total.age_group, business_total.business, eco_total.eco, ecoplus_total.eco_plus, (business + eco + eco_plus) AS total
FROM business_total
LEFT JOIN eco_total ON business_total.age_group = eco_total.age_group
LEFT JOIN ecoplus_total ON business_total.age_group =ecoplus_total.age_group
ORDER BY 1 DESC


WITH satisfied_group AS(
SELECT 
CASE WHEN Age < 90 AND Age >= 80 THEN '90-80'   
    WHEN Age < 80 AND Age >= 70 THEN '80-70'        
    WHEN Age < 70 AND Age >= 60 THEN '70-60'        
    WHEN Age < 60 AND Age >= 50 THEN '60-50'        
    WHEN Age < 50 AND Age >= 40 THEN '50-40'        
    WHEN Age < 40 AND Age >= 30 THEN '40-30'       
    WHEN Age < 30 AND Age >= 20 THEN '30-20'       
    WHEN Age < 20 AND Age >= 10 THEN '20-10'       
    WHEN Age < 10 AND Age >= 0 THEN '10-0'  
    ELSE 'Other'
    END AS age_group,
    COUNT(*) as satisfied
FROM `data-analysis-practice-314303.airline.train`
WHERE Satisfaction = 'satisfied'
GROUP BY age_group, satisfaction
),
dissatisfied_group AS(
SELECT 
CASE
    WHEN Age < 90 AND Age >= 80 THEN '90-80'        
    WHEN Age < 80 AND Age >= 70 THEN '80-70'        
    WHEN Age < 70 AND Age >= 60 THEN '70-60'       
    WHEN Age < 60 AND Age >= 50 THEN '60-50'       
    WHEN Age < 50 AND Age >= 40 THEN '50-40'        
    WHEN Age < 40 AND Age >= 30 THEN '40-30'        
    WHEN Age < 30 AND Age >= 20 THEN '30-20'        
    WHEN Age < 20 AND Age >= 10 THEN '20-10'        
    WHEN Age < 10 AND Age >= 0 THEN '10-0'
    ELSE 'Other'
    END AS age_group,
    COUNT(*) as disatisfied
FROM `data-analysis-practice-314303.airline.train`
WHERE Satisfaction = 'neutral or dissatisfied'
GROUP BY age_group, satisfaction
),
total_group AS (
SELECT satisfied_group.age_group, satisfied_group.satisfied, dissatisfied_group.disatisfied, (satisfied + disatisfied) AS total
FROM satisfied_group
LEFT JOIN dissatisfied_group ON satisfied_group.age_group = dissatisfied_group.age_group
ORDER BY 1 DESC
)
SELECT age_group, ROUND((satisfied/total), 2) as satisfied_percentile, ROUND((disatisfied/total),2) as disatisfied_percentile
FROM total_group


