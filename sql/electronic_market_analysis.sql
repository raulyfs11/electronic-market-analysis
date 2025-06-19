
-- =============================================
-- ELECTRONIC MARKET EXPLORATORY ANALYSIS QUERIES
-- =============================================

-- Section 1: Temporal Trends ---------------------

-- Monthly Sales Trend (USD)
SELECT 
  STRFTIME('%Y-%m', PURCHASE_TS_CLEANED) AS YearMonth,
  SUM(USD_PRICE) AS TotalRevenue
FROM orders_cleaned
GROUP BY YearMonth
ORDER BY YearMonth;

-- Yearly Revenue Growth
SELECT 
  PURCHASE_YEAR,
  SUM(USD_PRICE) AS AnnualRevenue
FROM orders_cleaned
GROUP BY PURCHASE_YEAR
ORDER BY PURCHASE_YEAR;

-- Monthly Seasonality Pattern
SELECT 
  PURCHASE_MONTH,
  SUM(USD_PRICE) AS MonthlyRevenue
FROM orders_cleaned
GROUP BY PURCHASE_MONTH
ORDER BY PURCHASE_MONTH;

-- Section 2: Product Performance ------------------

-- Top Product Revenue Contribution
SELECT 
  PRODUCT_NAME_CLEANED AS Product,
  SUM(USD_PRICE) AS TotalRevenue
FROM orders_cleaned
GROUP BY Product
ORDER BY TotalRevenue DESC
LIMIT 6;

-- Top Product Order Count
SELECT 
  PRODUCT_NAME_CLEANED AS Product,
  COUNT(*) AS OrderCount
FROM orders_cleaned
GROUP BY Product
ORDER BY OrderCount DESC
LIMIT 6;

-- Revenue Share of Top 5 SKUs
SELECT 
  PRODUCT_NAME_CLEANED,
  SUM(USD_PRICE) AS TotalRevenue
FROM orders_cleaned
GROUP BY PRODUCT_NAME_CLEANED
ORDER BY TotalRevenue DESC
LIMIT 5;

-- Section 3: Customer Insights --------------------

-- Customer Type Distribution
SELECT 
  USER_ID,
  COUNT(*) AS OrderCount
FROM orders_cleaned
GROUP BY USER_ID;

-- Yearly Customer Growth
SELECT 
  PURCHASE_YEAR AS Year,
  COUNT(DISTINCT USER_ID) AS NewCustomers
FROM orders_cleaned
GROUP BY Year
ORDER BY Year;

-- Repeat Buyer Ratio by Year
SELECT 
  PURCHASE_YEAR,
  COUNT(DISTINCT USER_ID) AS UniqueCustomers,
  COUNT(USER_ID) AS TotalOrders
FROM orders_cleaned
GROUP BY PURCHASE_YEAR;

-- Section 4: Channel and Platform Analysis --------

-- Sales by Platform
SELECT 
  PURCHASE_PLATFORM,
  COUNT(*) AS OrderCount
FROM orders_cleaned
GROUP BY PURCHASE_PLATFORM;

-- Sales by Marketing Channel
SELECT 
  LOWER(MARKETING_CHANNEL_CLEANED) AS MarketingChannel,
  COUNT(*) AS OrderCount
FROM orders_cleaned
GROUP BY MarketingChannel;

-- Section 5: Regional Analysis --------------------

-- Sales by Region
SELECT 
  REGION,
  SUM(USD_PRICE) AS RegionalRevenue
FROM orders_cleaned
GROUP BY REGION
ORDER BY RegionalRevenue DESC;

-- Product Revenue by Region
SELECT 
  REGION,
  PRODUCT_NAME_CLEANED,
  SUM(USD_PRICE) AS Revenue
FROM orders_cleaned
GROUP BY REGION, PRODUCT_NAME_CLEANED
ORDER BY REGION, Revenue DESC;

-- Regional Revenue YoY Trend
SELECT 
  REGION,
  PURCHASE_YEAR,
  SUM(USD_PRICE) AS Revenue
FROM orders_cleaned
GROUP BY REGION, PURCHASE_YEAR
ORDER BY REGION, PURCHASE_YEAR;

-- Section 6: Operational Metrics ------------------

-- Average Time to Ship by Year
SELECT 
  PURCHASE_YEAR,
  AVG(TIME_TO_SHIP) AS AvgDaysToShip
FROM orders_cleaned
GROUP BY PURCHASE_YEAR;
