
import streamlit as st
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns

# Set up styling
sns.set_theme()
plt.style.use('seaborn-v0_8-deep')

# Load data
xls = pd.ExcelFile("electronic_market_dataset.xlsx")
orders_raw = xls.parse("orders_cleaned")
orders = orders_raw[1:].copy()
orders.columns = orders_raw.iloc[0]
orders = orders.dropna(subset=["USD_PRICE"])
orders["USD_PRICE"] = orders["USD_PRICE"].astype(float)
orders["PURCHASE_TS_CLEANED"] = pd.to_datetime(orders["PURCHASE_TS_CLEANED"], errors='coerce')
orders["PURCHASE_YEAR"] = pd.to_numeric(orders["PURCHASE_YEAR"], errors='coerce').astype("Int64")
orders["PURCHASE_MONTH"] = pd.to_numeric(orders["PURCHASE_MONTH"], errors='coerce').astype("Int64")
orders["MARKETING_CHANNEL_CLEANED"] = orders["MARKETING_CHANNEL_CLEANED"].str.lower()
orders["Year-Month"] = orders["PURCHASE_TS_CLEANED"].dt.to_period("M").astype(str)

# Filters
st.title("📊 Electronic Market Dashboard")

years = orders["PURCHASE_YEAR"].dropna().unique().tolist()
products = orders["PRODUCT_NAME_CLEANED"].dropna().unique().tolist()
regions = orders["REGION"].dropna().unique().tolist()

selected_years = st.multiselect("Filter by Year", sorted(years), default=years)
selected_products = st.multiselect("Filter by Product", sorted(products), default=products[:5])
selected_regions = st.multiselect("Filter by Region", sorted(regions), default=regions)

filtered_orders = orders[
    orders["PURCHASE_YEAR"].isin(selected_years) &
    orders["PRODUCT_NAME_CLEANED"].isin(selected_products) &
    orders["REGION"].isin(selected_regions)
]

# Monthly Revenue
st.subheader("📅 Monthly Sales Trend")
monthly_rev = filtered_orders.groupby("Year-Month")["USD_PRICE"].sum().reset_index()
fig, ax = plt.subplots(figsize=(10, 5))
sns.lineplot(data=monthly_rev, x="Year-Month", y="USD_PRICE", marker="o", ax=ax)
ax.set_title("Monthly Revenue (USD)")
plt.xticks(rotation=45)
st.pyplot(fig)

# Product Revenue
st.subheader("📦 Top Product Revenue")
product_rev = filtered_orders.groupby("PRODUCT_NAME_CLEANED")["USD_PRICE"].sum().sort_values(ascending=False).head(10)
st.bar_chart(product_rev)

# Regional Revenue
st.subheader("🌍 Regional Sales Breakdown")
region_rev = filtered_orders.groupby("REGION")["USD_PRICE"].sum().sort_values(ascending=False)
st.bar_chart(region_rev)

# Customer Type Pie
st.subheader("👤 Customer Type Distribution")
repeat_df = filtered_orders.groupby("USER_ID")["ORDER_ID"].count().reset_index(name="Order Count")
repeat_df["Type"] = repeat_df["Order Count"].apply(lambda x: "Repeat Buyer" if x > 1 else "One-Time Buyer")
repeat_summary = repeat_df["Type"].value_counts()
st.dataframe(repeat_summary)
