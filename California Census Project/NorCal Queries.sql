#This is a temporary table I am using to hold the values of all the relevant counties so I don't have to type them in every time.
#In different type of SQL servers, there is a table datatype and you can declare one as a variable, MySQL however does not allow this unfortunately.
#DROP TEMPORARY TABLE GreaterBay, San_Francisco_Bay, San_Pablo_Bay ;
CREATE TEMPORARY TABLE GreaterBay (county VARCHAR(255) ) ;
INSERT INTO GreaterBay
VALUES ("San Francisco County"), ("Alameda County"), ("Contra Costa County"), ("San Mateo County"), ("Marin County"), ("Santa Clara County");

SELECT counties.county_name AS county_name, UACE, Population, (Population/counties.county_population)*100 AS Percent_in_UACE
FROM urban_areas
JOIN counties ON counties.county_ID=urban_areas.COUNTY_ID
WHERE county_name IN (SELECT * FROM GreaterBay) AND (UACE = 78904 OR UACE=79039) ;

CREATE TEMPORARY TABLE San_Francisco_Bay (county VARCHAR(255) ) ;
INSERT INTO San_Francisco_Bay
VALUES ("San Francisco County"), ("Alameda County"), ("San Mateo County"), ("Marin County") ;

#This query is to get the percent of a county's workers reside in each county.
#That is to say, the percent_residing is the percent of workers in workplace_county that are residents of residence_county.

SELECT w.county_name AS workplace_county, 
	case
		when r.county_name IN (SELECT * FROM GreaterBay) then 
			case
				when r.county_name IN (SELECT * FROM San_Francisco_Bay) then "Bay Area Core"
				ELSE r.county_name
			end 
		ELSE "Other Counties"
		END AS residence_county,
	Sum(workers) AS workers_from_residence_county,
	SUM(sum(workers)) OVER(partition BY workplace_county) AS workers_in_workplace_county,
	sum(workers)/(SUM(SUM(workers)) OVER(partition BY workplace_county))*100 AS percent_residing
FROM commute
JOIN counties w ON w.county_ID = commute.workplace
JOIN counties r ON r.county_ID = commute.residence
GROUP BY workplace_county, residence_county
HAVING workplace_county IN (SELECT * FROM GreaterBay)
ORDER BY workplace_county, percent_residing DESC;
#This query is to get what percent of residents in a county work in each county.
#That is to say, the percent_working is the percent of residents in residence_county that work in workplace_county.

SELECT r.county_name AS residence_county, 
	case
		when w.county_name IN (SELECT * FROM GreaterBay) then 
			case
				when w.county_name IN (SELECT * FROM San_Francisco_Bay) then "Bay Area Core"
				ELSE w.county_name
			end 
		ELSE "Other Counties"
		END AS workplace_county,
	Sum(workers) AS workers_in_workplace_county,
	SUM(sum(workers)) OVER(partition BY residence_county) AS workers_from_residence_county,
	sum(workers)/(SUM(SUM(workers)) OVER(partition BY residence_county))*100 AS percent_working
FROM commute
JOIN counties w ON w.county_ID = commute.workplace
JOIN counties r ON r.county_ID = commute.residence
GROUP BY residence_county, workplace_county
HAVING residence_county IN (SELECT * FROM GreaterBay)
ORDER BY residence_county, percent_working DESC;

DROP TEMPORARY TABLE GreaterBay, San_Francisco_Bay, San_Pablo_Bay ;