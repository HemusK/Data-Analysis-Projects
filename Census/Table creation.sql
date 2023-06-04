CREATE TABLE counties (
county_ID INT,
county_name VARCHAR(255),
PRIMARY KEY (county_id)
);

CREATE TABLE commute (
id INT NOT NULL AUTO_INCREMENT,
workplace INT,
residence INT,
workers INT,
PRIMARY KEY (id),
FOREIGN KEY (workplace) REFERENCES counties(county_id),
FOREIGN KEY (residence) REFERENCES counties(county_id)
);