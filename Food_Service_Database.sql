-- Task 2- Part 1

-- Create the Database

CREATE DATABASE FoodserviceDB;

-- Run the Database

USE FoodserviceDB;
GO

-- Add Primary Key Constraints in restaurants table

ALTER TABLE restaurants
ADD CONSTRAINT PK_rest PRIMARY KEY	(Restaurant_ID)

-- Add Primary Key Constraints in consumers table

ALTER TABLE consumers
ADD CONSTRAINT PK_cons PRIMARY KEY (Consumer_ID)

-- Add Primary Key Constraints in ratings table

ALTER TABLE ratings
ADD CONSTRAINT PK_rtng PRIMARY KEY (Consumer_ID, Restaurant_ID)

-- Add Foreign Key Constraints in ratings table

ALTER TABLE ratings ADD CONSTRAINT FK_consId 
FOREIGN KEY (Consumer_ID) REFERENCES consumers (Consumer_ID)

ALTER TABLE ratings ADD CONSTRAINT FK_restId 
FOREIGN KEY (Restaurant_ID) REFERENCES restaurants (Restaurant_ID)

-- Add Foreign Key Constraints in restaurant_cuisines table

ALTER TABLE restaurant_cuisines ADD CONSTRAINT FK_rstc 
FOREIGN KEY (Restaurant_ID) REFERENCES restaurants (Restaurant_ID)

-- Task 2- Part 2

-- Q1: Lists of all restaurants with a Medium range price with open area, serving Mexican food.

SELECT r.Restaurant_ID, r.Name, r.Price, r.Area, rc.Cuisine
FROM restaurants AS r
INNER JOIN restaurant_cuisines AS rc
ON r.Restaurant_ID = rc.Restaurant_ID
WHERE r.Price = 'Medium' AND r.Area = 'Open' AND rc.Cuisine = 'Mexican'

-- Q2: Total number of restaurants who have the overall rating as 1 and are serving Mexican food.

WITH cte AS(
SELECT DISTINCT Restaurant_ID
FROM ratings
WHERE Overall_Rating  = 1)

SELECT COUNT(*) AS Total_Number_of_Restaurants
FROM cte AS ct
INNER JOIN restaurant_cuisines AS rc
ON ct.Restaurant_ID = rc.Restaurant_ID
WHERE rc.Cuisine = 'Mexican'

-- Q2: Total number of restaurants who have the overall rating as 1 and are serving Italian food. 

WITH cte AS(
SELECT DISTINCT Restaurant_ID
FROM ratings
WHERE Overall_Rating  = 1)

SELECT COUNT(*) AS Total_Number_of_Restaurants
FROM cte AS ct
INNER JOIN restaurant_cuisines AS rc
ON ct.Restaurant_ID = rc.Restaurant_ID
WHERE rc.Cuisine = 'Italian'

-- Q3: Average age of consumers who have given a 0 rating to the 'Service_rating' column.

SELECT AVG(Age) AS Avgerage_Age
FROM consumers AS c
INNER JOIN ratings AS rt
ON c.Consumer_ID = rt.Consumer_ID
WHERE Service_Rating = 0

-- Q4: Restaurants ranked by the youngest consumer

SELECT r.Name, rt.Food_Rating
FROM restaurants AS r
INNER JOIN ratings AS rt
ON r.Restaurant_ID = rt.Restaurant_ID
INNER JOIN consumers AS c
ON rt.Consumer_ID = c.Consumer_ID
WHERE c.Age = (SELECT MIN(Age) FROM consumers)
ORDER BY rt.Food_Rating DESC
GO

-- Q5: Stored procedure to Update the Service_rating of all restaurants to '2' 
-- if they have parking value as 'Yes' or 'Public'

CREATE PROCEDURE UpdateServiceRating2
AS
	BEGIN
		UPDATE rt
		SET rt.Service_Rating = 2
		FROM ratings AS rt
		INNER JOIN restaurants AS r
		ON rt.Restaurant_ID = r.Restaurant_ID
		WHERE r.Parking IN ('Yes', 'Public')
	END;
GO

--Execute the above procedure

EXEC UpdateServiceRating2
GO

-- View the result of above procedure

SELECT r.Restaurant_ID, r.Name, r.Parking, rt.Service_Rating
FROM restaurants r
INNER JOIN ratings AS rt
ON r.Restaurant_ID = rt.Restaurant_ID
WHERE r.Parking IN ('Yes', 'Public')

-- Q6: Additional Query1: Top Five Cuisines served by Most of the Restaurants 

SELECT Top 5 Cuisine, COUNT(*) AS Num_Restaurants
FROM restaurant_cuisines
GROUP BY Cuisine
HAVING COUNT(*) > 0
ORDER BY Num_Restaurants DESC;

-- Q6:  Additional Query2: Count the number of consumers who are smokers 
-- and drinkers and give Overall_Rating as 1 or 2

SELECT COUNT(*) AS Num_Consumers
FROM consumers
WHERE Smoker = 'Yes'
AND Drink_Level IN ('Social Drinker', 'Casual Drinker')
AND Consumer_ID IN (
    SELECT Consumer_ID
    FROM ratings
    WHERE Overall_Rating > 0
);

-- Q6: Additional Query3: Number of Restaurants with High Price visited by eldest people

SELECT COUNT(DISTINCT r.Restaurant_ID) AS Num_Restaurants_MaxAge
FROM consumers c
JOIN (
    SELECT MAX(Age) AS MaxAge
    FROM consumers
) MaxAge_Sub
ON c.Age = MaxAge_Sub.MaxAge
JOIN ratings rt 
ON c.Consumer_ID = rt.Consumer_ID
JOIN restaurants r
ON rt.Restaurant_ID = r.Restaurant_ID
WHERE r.Price = 'High';

-- Q6: Additional Query4: Average Overall_Rating for Restaurants in each City, 
--but only for Cities where at least one Consumer resides.

SELECT r.City, AVG(rt.Overall_Rating) AS Avg_Overall_Rating
FROM restaurants r
INNER JOIN ratings rt 
ON r.Restaurant_ID = rt.Restaurant_ID
WHERE EXISTS (
    SELECT 1 FROM consumers c WHERE c.City = r.City
)
GROUP BY r.City
ORDER BY Avg_Overall_Rating DESC;
