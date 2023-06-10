#This is a temporary table I am using to hold the values of all the relevant counties so I don't have to type them in every time.
#In different type of SQL servers, there is a table datatype and you can declare one as a variable, MySQL however does not allow this unfortunately.
#DROP TEMPORARY TABLE GreaterLA, Los_Angeles, Inland_Empire ;
CREATE TEMPORARY TABLE GreaterLA (county VARCHAR(255) ) ;
INSERT INTO GreaterLA
VALUES ("Los Angeles County"), ("Orange County"), ("Riverside County"), ("San Bernardino County"), ("Ventura County");

#This is a query to determine what counties are core counties, meaning 50% of their population is in an Urban area.
#We are specifically looking at Los Angeles (51445) and Riverside-San Bernardino (75340).

SELECT counties.county_name AS county_name, UACE, Population, (Population/counties.county_population)*100 AS Percent_in_UACE
FROM urban_areas
JOIN counties ON counties.county_ID=urban_areas.COUNTY_ID
WHERE county_name IN (SELECT * FROM GreaterLA) AND (UACE = 51445 OR UACE=75340) ;

#From that query, we determined that Los Angeles and Orange County are sufficient to count as core counties for Los Angeles.
#San Bernardino is sufficient to count as a core for Riverside-San Bernardino, although Riverside is slightly under the threshold; we will include it anyway.
#I am going to create two temporary tables to hold these two counties in their own list.

CREATE TEMPORARY TABLE Los_Angeles (county VARCHAR(255));
INSERT INTO Los_Angeles
VALUES ("Los Angeles County"), ("Orange County") ;

CREATE TEMPORARY TABLE Inland_Empire (county VARCHAR(255));
INSERT INTO Inland_Empire
VALUES ("Riverside County"), ("San Bernardino County") ;

#This query is to get the percent of a county's workers reside in each county.
#That is to say, the percent_residing is the percent of workers in workplace_county that are residents of residence_county.

SELECT w.county_name AS workplace_county, 
	case
		when r.county_name IN (SELECT * FROM GreaterLA) then case
			when r.county_name IN (SELECT * FROM Los_Angeles) then "LA Metro"
			when r.county_name IN (SELECT * FROM Inland_Empire) then "Inland Empire"
			ELSE r.county_name
			END
		ELSE "Other Counties"
	END AS residence_county,
	Sum(workers) AS workers_from_residence_county,
	SUM(sum(workers)) OVER(partition BY workplace_county) AS workers_in_workplace_county,
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
	case
		when w.county_name IN (SELECT * FROM GreaterLA) then case
			when w.county_name IN (SELECT * FROM Los_Angeles) then "LA Metro"
			when w.county_name IN (SELECT * FROM Inland_Empire) then "Inland Empire"
			ELSE w.county_name
			END
		ELSE "Other Counties"
	END AS workplace_county,
	Sum(workers) AS workers_in_workplace_county,
	SUM(sum(workers)) OVER(partition BY residence_county) AS workers_from_residence_county,
	sum(workers)/(SUM(SUM(workers)) OVER(partition BY residence_county))*100 AS percent_working
FROM commute
JOIN counties w ON w.county_ID = commute.workplace
JOIN counties r ON r.county_ID = commute.residence
GROUP BY residence_county, workplace_county
HAVING residence_county IN (SELECT * FROM GreaterLA)
ORDER BY residence_county, percent_working DESC;

DROP TEMPORARY TABLE GreaterLA, Los_Angeles, Inland_Empire ;