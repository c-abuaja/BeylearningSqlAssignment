--Create Database SqlAssignment;
use SqlAssignment;
select * from Social_media_usage;

/*Assignment Questions:
Basic Analysis*/
--a. How many unique countries are represented in the dataset?
SELECT COUNT(DISTINCT Country) AS UniqueCountryCount
FROM Social_media_usage;

--b. What is the average rate accross all countries

SELECT AVG(Employment_Rate) AS AverageEmploymentRate
FROM Social_media_usage;

/*Social Media Trends*/
--a. Which social media platform has the highest number of active users? 
SELECT TOP 1
    Platform,
    COUNT(*) AS ActiveUserCount
FROM Social_media_usage
GROUP BY
    Platform
ORDER BY ActiveUserCount DESC;

-- b. Identify the country with the most active users on TikTok in 2023.
SELECT TOP 1 Country,
    COUNT(*) AS ActiveUserCount
FROM
    Social_media_usage
WHERE
    Platform = 'TikTok' AND Year = 2023
GROUP BY Country
ORDER BY ActiveUserCount DESC;

/*Employment vs. Social Media Usage*/
--a. Is there a correlation between employment rate and the number of active users? 
 /*
No
*/

--b. Find the country with the highest employment rate and check which social media platform is most popular there.
WITH HighestEmployment AS (
    SELECT TOP 1 Country, Employment_Rate
    FROM Social_media_usage
    ORDER BY Employment_Rate DESC
),
MostPopularPlatform AS (
    SELECT 
        s.Country,
        s.Platform,
        s.Active_Users,
        RANK() OVER (PARTITION BY s.Country ORDER BY s.Active_Users DESC) AS platform_rank
    FROM Social_media_usage s
    INNER JOIN HighestEmployment h ON s.Country = h.Country
)
SELECT Country, Platform, Active_Users
FROM MostPopularPlatform
WHERE platform_rank = 1;

/*Time-Based Analysis*/
--a. How has social media usage changed over the years in India?
SELECT 
    Year,
    SUM(Active_Users) AS Total_Active_Users
FROM Social_media_usage
WHERE Country = 'India'
GROUP BY Year
ORDER BY Year;

--b. What is the trend in employment rates for the USA from 2010 to 2025? 

SELECT 
    Year,
    AVG(Employment_Rate) AS Avg_Employment_Rate
FROM Social_media_usage
WHERE Country = 'USA'
  AND Year BETWEEN 2010 AND 2025
GROUP BY Year
ORDER BY Year;


/*Advanced Queries*/
-- a. Group the data by country and calculate the total number of active users per country. 
SELECT 
    Country,
    SUM(CAST(Active_Users AS BIGINT)) AS Total_Active_Users
FROM Social_media_usage
GROUP BY Country
ORDER BY Total_Active_Users DESC;

-- b. Determine which country has the highest social media penetration rate (Active Users / Population)

WITH PenetrationRate AS (
    SELECT 
        Country,
        SUM(CAST(Active_Users AS FLOAT)) AS Total_Active_Users,
        SUM(CAST(Population AS FLOAT)) AS Total_Population
    FROM Social_media_usage
    GROUP BY Country
)
SELECT TOP 1 
    Country,
    Total_Active_Users,
    Total_Population,
    (Total_Active_Users / Total_Population) AS Penetration_Rate
FROM PenetrationRate
WHERE Total_Population > 0
ORDER BY Penetration_Rate DESC;