drop table if exists Zepto;

create table Zepto(
sku_id SERIAL PRIMARY KEY,
category VARCHAR(120),
name VARCHAR(150) NOT NULL,
mrp NUMERIC(8,2),
DiscountPercent NUMERIC(5,2),
availableQuantity INTEGER,
discountedSellingPrice NUMERIC(8,2),
weightInGms INTEGER,
outOfStock BOOLEAN,
quantity INTEGER
);

-- Data exploration 

-- count of rows
SELECT COUNT(*) FROM Zepto;

-- Sample data
SELECT * FROM zepto
LIMIT 10;

-- null values
SELECT * FROM zepto
WHERE NAME IS NULL
OR
CATEGORY IS NULL
OR
MRP IS NULL
OR
DISCOUNTPERCENT IS NULL
OR
DISCOUNTEDSELLINGPRICE IS NULL
OR
WEIGHTINGMS IS NULL
OR
AVAILABLEQUANTITY IS NULL
OR
OUTOFSTOCK IS NULL
OR
QUANTITY IS NULL;

-- Different product category

SELECT DISTINCT CATEGORY
FROM ZEPTO
ORDER BY CATEGORY;

-- Product in stock vs out of stock

SELECT OUTOFSTOCK, COUNT(SKU_ID)
FROM ZEPTO
GROUP BY OUTOFSTOCK;

-- Product name present multiple times

SELECT name, COUNT(sku_id) as "Number of SKUs"
FROM zepto
GROUP BY name
HAVING COUNT(sku_id) > 1
ORDER BY COUNT(sku_id) DESC;

-- Data cleaning

-- products with price = 0
SELECT * FROM zepto
WHERE mrp = 0 OR discountedsellingprice = 0;

DELETE from zepto
WHERE mrp = 0;

-- Converting paise to rupees

UPDATE zepto
SET mrp = mrp/100.0,
discountedsellingprice = discountedsellingprice/100;

SELECT mrp, discountedsellingprice FROM zepto;

-- Business Insights

-- 1) Found top 10 best-value products based on discount percentage

SELECT DISTINCT name, mrp, discountpercent
FROM zepto
ORDER BY discountpercent DESC
LIMIT 10;

-- 2) Identified high-MRP products that are currently out of stock

SELECT DISTINCT name, mrp 
FROM zepto
WHERE outofstock = TRUE and mrp > 300
ORDER BY mrp DESC;

-- 3) Estimated potential revenue for each product category

SELECT category,
SUM(discountedsellingprice * availablequantity) AS total_revenue
FROM zepto
GROUP BY category
ORDER BY total_revenue;

-- 4) Filtered expensive products (MRP > ₹500) with minimal discount

SELECT DISTINCT name, mrp, discountpercent
FROM zepto
WHERE mrp > 500 AND discountpercent < 10
ORDER BY mrp DESC, discountpercent DESC;

-- 5) Ranked top 5 categories offering highest average discounts

SELECT category,
ROUND(AVG(discountpercent),2) AS avg_discount
FROM zepto
GROUP BY category
ORDER BY avg_discount DESC
LIMIT 5;

-- 6) Calculated price per gram to identify value-for-money products

SELECT DISTINCT name, Weightingms, discountedsellingprice,
ROUND((discountedsellingprice/weightingms),2) AS Price_per_gram
FROM zepto
WHERE weightingms >=100
ORDER BY price_per_gram; 

-- 7) Grouped products based on weight into Low, Medium, and Bulk categories

SELECT DISTINCT name, Weightingms,
CASE WHEN Weightingms < 1000 THEN 'LOW'
WHEN Weightingms < 5000 THEN 'MEDIUM'
ELSE 'BULK'
END AS weight_category
FROM zepto;

-- 8) Measured total inventory weight per product category

SELECT category,
SUM(Weightingms * availableQuantity) AS total_weight
FROM zepto
GROUP BY Category
ORDER BY total_weight;
