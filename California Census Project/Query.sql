#This query is to get the percent of a county's workers reside in each county.
#That is to say, the percent_residing is the percent of workers in workplace_county that are residents of residence_county.

SELECT w.county_name AS workplace_county, r.county_name AS residence_county, SUM(workers) AS total_workers,
	(SUM(workers)/SUM(workers) OVER(PARTITION BY workplace)*100) AS percent_residing
FROM commute
JOIN counties w ON w.county_ID = commute.workplace
JOIN counties r ON r.county_ID = commute.residence
GROUP BY workplace_county, residence_county
HAVING workplace_county IN ("Los Angeles County", "Orange County", "Riverside County", "San Bernardino County", "Ventura County") AND residence_county IN ("Los Angeles County", "Orange County", "Riverside County", "San Bernardino County", "Ventura County")
ORDER BY workplace_county, percent_residing DESC;

#This query is to get what percent of residents in a county work in each county.
#That is to say, the percent_working is the percent of residents in residence_county that work in workplace_county.

SELECT r.county_name AS residence_county, w.county_name AS workplace_county, SUM(workers) AS total_workers,
	(SUM(workers)/SUM(workers) OVER(PARTITION BY residence)*100) AS percent_working
FROM commute
JOIN counties w ON w.county_ID = commute.workplace
JOIN counties r ON r.county_ID = commute.residence
GROUP BY residence_county, workplace_county
HAVING workplace_county IN ("Los Angeles County", "Orange County", "Riverside County", "San Bernardino County", "Ventura County") AND residence_county IN ("Los Angeles County", "Orange County", "Riverside County", "San Bernardino County", "Ventura County")
ORDER BY residence_county, percent_working DESC;
