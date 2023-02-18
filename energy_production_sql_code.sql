--- Worldwide ---

-- Q1
-- Electricity generation over time 

SELECT *
FROM 
    (SELECT ROUND(electricity_generation,2) AS EG ,YEAR 
     FROM Energy) AS S
PIVOT
(
SUM(EG) FOR [YEAR] IN ([2000],[2005],[2010],[2015],[2018])
) AS PVT


-- Q2
-- Electricity production by source of energy in 2000 and 2018

SELECT 
    YEAR,
    ROUND(SUM(gas_electricity)     / SUM(electricity_generation),3) * 100 AS 'gas_share',
    ROUND(SUM(coal_electricity)    / SUM(electricity_generation),3) * 100 AS 'coal_share',
    ROUND(SUM(oil_electricity)     / SUM(electricity_generation),3) * 100 AS 'oil_share',
    ROUND(SUM(solar_electricity)   / SUM(electricity_generation),3) * 100 AS 'solar_share',
    ROUND(SUM(wind_electricity)    / SUM(electricity_generation),3) * 100 AS 'wind_share',
    ROUND(SUM(hydro_electricity)   / SUM(electricity_generation),3) * 100 AS 'hydro_share',
    ROUND(SUM(biofuel_electricity) / SUM(electricity_generation),3) * 100 AS 'biofuel_share',
    ROUND(SUM(nuclear_electricity) / SUM(electricity_generation),3) * 100 AS 'nuclear_share'
FROM Energy
WHERE YEAR = 2000
GROUP BY YEAR

SELECT 
    YEAR,
    ROUND(SUM(gas_electricity)     / SUM(electricity_generation),3) * 100 AS 'gas_share',
    ROUND(SUM(coal_electricity)    / SUM(electricity_generation),3) * 100 AS 'coal_share',
    ROUND(SUM(oil_electricity)     / SUM(electricity_generation),3) * 100 AS 'oil_share',
    ROUND(SUM(solar_electricity)   / SUM(electricity_generation),3) * 100 AS 'solar_share',
    ROUND(SUM(wind_electricity)    / SUM(electricity_generation),3) * 100 AS 'wind_share',
    ROUND(SUM(hydro_electricity)   / SUM(electricity_generation),3) * 100 AS 'hydro_share',
    ROUND(SUM(biofuel_electricity) / SUM(electricity_generation),3) * 100 AS 'biofuel_share',
    ROUND(SUM(nuclear_electricity) / SUM(electricity_generation),3) * 100 AS 'nuclear_share'
FROM Energy
WHERE YEAR = 2018
GROUP BY YEAR


-- Q3
-- Electricity generation by source type (renewable vs. conventional) between 1995 and 2018

SELECT YEAR,
       (ROUND(SUM(renewable_electricity),2)    / (LAG(SUM(renewable_electricity),1)    OVER(ORDER BY YEAR))-1) * 100 AS '%_of_renewable_increase',
       (ROUND(SUM(conventional_electricity),2) / (LAG(SUM(conventional_electricity),1) OVER(ORDER BY YEAR))-1) * 100 AS '%_of_conventional_increase'
FROM Energy
WHERE YEAR IN (1990,1995,2000,2005,2010,2015,2018)
GROUP BY YEAR
ORDER BY YEAR


--- Continents ---

-- Q4
-- Electricity generation by continents between 2000 and 2018

SELECT * 
FROM 
    (SELECT CONTINENT AS 'continent',
            ROUND(electricity_generation,2) AS 'electricity_generation',
            YEAR FROM Energy) AS S
PIVOT
(
SUM(electricity_generation) FOR [YEAR] IN ([2000],[2005],[2010],[2015],[2018])
) AS PVT


-- Q5
-- Electricity generation by source type in 2000 and 2018

SELECT Continent,
       ROUND(SUM(renewable_electricity)    / (SUM(renewable_electricity) + SUM(conventional_electricity)),2) AS 'Renewable',
       ROUND(SUM(conventional_electricity) / (SUM(renewable_electricity) + SUM(conventional_electricity)),2) AS 'Conventional'
FROM Energy
WHERE year = 2000
GROUP by Continent
ORDER BY Renewable DESC

SELECT Continent,
       ROUND(SUM(renewable_electricity)    / (SUM(renewable_electricity) + SUM(conventional_electricity)),2) AS 'Renewable',
       ROUND(SUM(conventional_electricity) / (SUM(renewable_electricity) + SUM(conventional_electricity)),2) AS 'Conventional'
FROM Energy
WHERE year = 2018
GROUP by Continent
ORDER BY Renewable DESC


-- Q6 (by PBI)
-- Annually kWh per capita in 2018

WITH Continents AS 
(
    SELECT Continent AS 'Continent',
           YEAR AS 'YEAR',
           ROUND(SUM(electricity_generation) * 1000000000 / SUM(population),0) AS 'energy_per_capita' 
    FROM Energy 
    GROUP BY continent, YEAR 
)

SELECT *
FROM Continents AS S
PIVOT
(
SUM(energy_per_capita) FOR [YEAR] IN ([2000],[2005],[2010],[2015],[2018]) 
) AS PVT


-- Q7 (by python)


--- Countries ---

-- Q8
-- GDP per capita in 2000 and 2018

WITH Countries AS 
(
  SELECT country,
         ROUND(SUM(GDP)/SUM(population),2) AS 'GDP_per_capita'
  FROM Energy
  WHERE YEAR = 2000
  GROUP BY country
)

SELECT *
FROM Countries AS K
PIVOT
(
SUM(GDP_per_capita) FOR [country] IN ([Israel],[Germany],[india],[Egypt],[United States],[Saudi Arabia])
) 
as pvt;

WITH Countries AS 
(
SELECT country,ROUND(SUM(GDP)/SUM(population),2) AS 'GDP_per_capita'
FROM Energy
where year = 2018
group by country
)

SELECT *
FROM Countries AS K
PIVOT
(
SUM(GDP_per_capita) FOR [country] IN ([Israel],[Germany],[india],[Egypt],[United States],[Saudi Arabia])
) 
as pvt;


-- Q9
-- Electricity generation by source type and country in 2000 and 2018

SELECT country,
       ROUND(SUM(renewable_electricity)/(SUM(renewable_electricity)    + SUM(conventional_electricity)),2) AS 'Renewable',
       ROUND(SUM(conventional_electricity)/(SUM(renewable_electricity) + SUM(conventional_electricity)),2) AS 'Conventional'
FROM Energy
WHERE renewable_electricity <> 0 AND conventional_electricity <> 0 AND country in ('Israel','Germany','india','Egypt','United States','Saudi Arabia') AND YEAR = 2000
GROUP BY country

SELECT country,
       ROUND(SUM(renewable_electricity)/(SUM(renewable_electricity)    + SUM(conventional_electricity)),2) AS 'Renewable',
       ROUND(SUM(conventional_electricity)/(SUM(renewable_electricity) + SUM(conventional_electricity)),2) AS 'Conventional'
FROM Energy
WHERE renewable_electricity <> 0 AND conventional_electricity <> 0 AND country in ('Israel','Germany','india','Egypt','United States','Saudi Arabia') AND YEAR = 2018
GROUP BY country


-- Q10
-- Israel electriciy generation by source of energy in 2018

SELECT country,
       ROUND(SUM(gas_electricity)/SUM(electricity_generation),3)     * 100 AS 'gas_share',
       ROUND(SUM(coal_electricity)/SUM(electricity_generation),3)    * 100 AS 'coal_share',
       ROUND(SUM(oil_electricity)/Sum(electricity_generation),3)     * 100 AS 'oil_share',
       ROUND(SUM(solar_electricity)/SUM(electricity_generation),3)   * 100 AS 'solar_share',
       ROUND(SUM(wind_electricity)/SUM(electricity_generation),3)    * 100 AS 'wind_share',
       ROUND(SUM(hydro_electricity)/SUM(electricity_generation),3)   * 100 AS 'hydro_share',
       ROUND(SUM(biofuel_electricity)/SUM(electricity_generation),3) * 100 AS 'biofuel_share',
       ROUND(SUM(nuclear_electricity)/SUM(electricity_generation),3) * 100 AS'nuclear_share'
FROM Energy
WHERE YEAR = 2018 AND country = 'israel'
GROUP BY country
