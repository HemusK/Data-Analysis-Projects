import mysql.connector as msql
from mysql.connector import Error
from engine import engine, myurl
import pandas as pd
import dask.dataframe as dd

counties = pd.read_csv("st06_ca_cou2020.csv", usecols=["COUNTYFP", "COUNTYNAME"]) 
counties.rename(columns={"COUNTYFP":"county_ID", "COUNTYNAME":"county_name"}, inplace=True)

fullcommute = pd.read_csv("ca_od_main_JT00_2020.csv", usecols=["w_geocode","h_geocode","S000"], dtype={"w_geocode":str, "h_geocode":str})
commute = pd.DataFrame()
commute["workplace"] = fullcommute["w_geocode"].str.slice(start=2, stop=5)
commute["residence"] = fullcommute["h_geocode"].str.slice(start=2, stop=5)
commute["workers"] = fullcommute["S000"]
commute = commute.groupby(["workplace","residence"], as_index=False).sum()

try:
    counties.to_sql(name="counties", if_exists="append", con=engine, index=False)
    commute.to_sql(name="commute", if_exists="append", con=engine, index=False)
except Error as e:
    print("Error connecting to SQL Server", e)