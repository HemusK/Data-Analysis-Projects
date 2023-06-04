import pandas as pd

df = pd.read_csv("ca_od_main_JT05_2020.csv", dtype={"w_geocode":str, "h_geocode":str}, usecols = ["w_geocode", "h_geocode", "S000"])

df.rename(columns={"w_geocode":"Workplace", "h_geocode":"Residence", "S000":"Workers"}, inplace=True)

print(df.head())

df2 = pd.DataFrame(df.groupby(["Workplace", "Residence"]).sum())
df2.reset_index()

print(df2.head(25))

df2.to_csv("Workplace Flow.csv")