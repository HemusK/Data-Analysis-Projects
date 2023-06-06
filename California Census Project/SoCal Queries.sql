#This is a temporary table I am using to hold the values of all the relevant counties so I don't have to type them in every time.
#In different type of SQL servers, there is a table datatype and you can declare one as a variable, MySQL however does not allow this unfortunately.
#DROP TEMPORARY TABLE GreaterLA ;
CREATE TEMPORARY TABLE GreaterLA (county VARCHAR(255) ) ;
INSERT INTO GreaterLA
VALUES ("Los Angeles County"), ("Orange County"), ("Riverside County"), ("San Bernardino County"), ("Ventura County");

SELECT counties.county_name AS county_name, UACE, Population, (Population/counties.county_population)*100 AS Percent_in_UACE
FROM urban_areas
JOIN counties ON counties.county_ID=urban_areas.COUNTY_ID
WHERE county_name IN (SELECT * FROM GreaterLA) AND (UACE = 51445 OR UACE=75340) ;

#This query is to get the percent of a county's workers reside in each county.
#That is to say, the percent_residing is the percent of workers in workplace_county that are residents of residence_county.

SELECT w.county_name AS workplace_county, 
	Case
	when r.county_name NOT IN (SELECT * from GreaterLA) then "Other Counties"
	ELSE r.county_name
	END AS residence_county,
	sum(workers) AS workers_from_residence_county,
	sum(workers)/(SUM(SUM(workers)) OVER(partition BY workplace_county))*100 AS percent_residing
FROM commute
JOIN counties w ON w.county_ID = commute.workplace
JOIN counties r ON r.county_ID = commute.residence
GROUP BY workplace_county, residence_county
HAVING workplace_county IN (SELECT * FROM GreaterLA)
ORDER BY workplace_county, percent_residing DESC;

#This query is to get what percent of residents in a county work in each county.
#That is to say, the percent_working is the percent of residents in residence_county that work in workplace_county.

SELECT r.county_name AS residence_county, 
	Case
	when w.county_name NOT IN (SELECT * from GreaterLA) then "Other Counties"
	ELSE w.county_name
	END AS workplace_county,
	sum(workers) AS workers_in_workplace_county,
	sum(workers)/(SUM(SUM(workers)) OVER(partition BY residence_county))*100 AS percent_working
FROM commute
JOIN counties w ON w.county_ID = commute.workplace
JOIN counties r ON r.county_ID = commute.residence
GROUP BY residence_county, workplace_county
HAVING residence_county IN (SELECT * FROM GreaterLA)
ORDER BY residence_county, percent_working DESC;

DROP TEMPORARY TABLE GreaterLA ;