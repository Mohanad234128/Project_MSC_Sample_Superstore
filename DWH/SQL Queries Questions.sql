USE Project_MSC
GO

-- Question 1: Category Performance
-- Write a query to calculate the total sales and total profit for each product Category. Sort the results by total sales in descending order.

SELECT 
    p.Category,
    SUM(f.Sales) AS Total_Sales,
    SUM(f.Profit) AS Total_Profit
FROM FACT_Sales f
JOIN DIM_Products p ON f.Product_ID = p.Product_ID
GROUP BY p.Category
ORDER BY Total_Sales DESC;

-- Question 2: Top Profitable Locations
-- Find the top 5 most profitable cities. The output should include the City, Country, and the total profit generated from each.

SELECT TOP 5
    l.City,
    l.Country,
    SUM(f.Profit) AS Total_Profit
FROM FACT_Sales f
JOIN DIM_Location l ON f.Location_ID = l.Location_ID
GROUP BY l.City, l.Country
ORDER BY Total_Profit DESC;

-- Question 3: VIP Customers 
-- Identify the customers who spend more than the average. Return the Customer_Name and their total spent, but only for customers whose total spending is strictly greater than the overall average spending per customer across the entire database.

SELECT 
    c.Customer_Name, 
    SUM(f.Sales) AS Total_Spent
FROM FACT_Sales f
JOIN DIM_Customers c ON f.Customer_ID = c.Customer_ID
GROUP BY c.Customer_Name
HAVING SUM(f.Sales) > (
    SELECT AVG(Customer_Total) 
    FROM (
        SELECT SUM(Sales) AS Customer_Total 
        FROM FACT_Sales 
        GROUP BY Customer_ID
    ) AS Avg_Table
)
ORDER BY Total_Spent DESC;

-- Question 4: Shipping Efficiency
-- Calculate the average shipping time (the difference in days between the Order_Date and Ship_Date) for each Ship_Mode.

SELECT 
    sh.Ship_Mode,
    AVG(DATEDIFF(DAY, od.Order_Date, sd.Ship_Date)) AS Avg_Shipping_Days
FROM FACT_Sales f
JOIN DIM_Shipping sh ON f.Ship_ID = sh.Ship_ID
JOIN DIM_Order_Date od ON f.Order_Date_ID = od.Order_Date_ID
JOIN DIM_Ship_Date sd ON f.Ship_Date_ID = sd.Ship_Date_ID
GROUP BY sh.Ship_Mode
ORDER BY Avg_Shipping_Days;

-- Question 5: Sales Contribution 
-- For each product Category, display its total sales and the percentage it contributes to the company's overall grand total sales.

SELECT 
    p.Category,
    SUM(f.Sales) AS Category_Sales,
    (SUM(f.Sales) / (SELECT SUM(Sales) FROM FACT_Sales)) * 100 AS Percentage_Of_Total
FROM FACT_Sales f
JOIN DIM_Products p ON f.Product_ID = p.Product_ID
GROUP BY p.Category;

-- Question 6: Never Discounted Products 
-- Find the Product_ID and Product_Name of all products that have never been sold with a discount (Discount > 0) in the sales history.

SELECT 
    Product_ID, 
    Product_Name, 
    Category
FROM DIM_Products
WHERE Product_ID NOT IN (
    SELECT DISTINCT Product_ID 
    FROM FACT_Sales 
    WHERE Discount > 0
);

-- Question 7: High-Volume, Loss-Making Customers
-- List the names of customers who have placed more than 5 distinct orders, but the overall total profit from all their transactions is negative (less than zero).

SELECT 
    c.Customer_Name,
    COUNT(DISTINCT f.Order_ID) AS Total_Orders,
    SUM(f.Profit) AS Total_Profit
FROM FACT_Sales f
JOIN DIM_Customers c ON f.Customer_ID = c.Customer_ID
GROUP BY c.Customer_Name
HAVING COUNT(DISTINCT f.Order_ID) > 5 AND SUM(f.Profit) < 0
ORDER BY Total_Profit ASC;

-- Question 8: Regional Segment Analysis
-- Generate a report showing the total sales and the total number of transactions broken down by Region and customer Segment. Order the results by Region, then by total sales in descending order.

SELECT 
    l.Region,
    c.Segment,
    SUM(f.Sales) AS Total_Sales,
    COUNT(f.Row_ID) AS Number_Of_Transactions
FROM FACT_Sales f
JOIN DIM_Location l ON f.Location_ID = l.Location_ID
JOIN DIM_Customers c ON f.Customer_ID = c.Customer_ID
GROUP BY l.Region, c.Segment
ORDER BY l.Region, Total_Sales DESC;

-- Question 9: Order vs. Sub-Category Average
-- Retrieve the Order_ID, Sub_Category, and the Sales amount for individual orders that have a sales value greater than 1000. Add a fourth column that shows the average sales amount for that specific Sub_Category to compare.

SELECT 
    f.Order_ID,
    p.Sub_Category,
    f.Sales,
    (
        SELECT AVG(f2.Sales) 
        FROM FACT_Sales f2 
        JOIN DIM_Products p2 ON f2.Product_ID = p2.Product_ID 
        WHERE p2.Sub_Category = p.Sub_Category
    ) AS Avg_Category_Sales
FROM FACT_Sales f
JOIN DIM_Products p ON f.Product_ID = p.Product_ID
WHERE f.Sales > 1000; 

-- Question 10: Yearly Top Products
-- Find the top 3 best-selling products (based on total sales amount) within each specific Year based on the order date.

WITH Yearly_Product_Sales AS (
    SELECT 
        YEAR(od.Order_Date) AS Sales_Year,
        p.Product_Name,
        SUM(f.Sales) AS Total_Sales,
        ROW_NUMBER() OVER(PARTITION BY YEAR(od.Order_Date) ORDER BY SUM(f.Sales) DESC) AS Rank
    FROM FACT_Sales f
    JOIN DIM_Products p ON f.Product_ID = p.Product_ID
    JOIN DIM_Order_Date od ON f.Order_Date_ID = od.Order_Date_ID
    GROUP BY YEAR(od.Order_Date), p.Product_Name
)
SELECT 
    Sales_Year, 
    Product_Name, 
    Total_Sales, 
    Rank
FROM Yearly_Product_Sales
WHERE Rank <= 3
ORDER BY Sales_Year DESC, Rank ASC;

-- Question 11: Market Basket Analysis
-- Write a query to identify pairs of products that are frequently purchased together in the same order. Return the names of both products and the frequency of their co-occurrence. Only include product pairs that have been bought together more than 20 times, and sort the results by frequency in descending order.

WITH ProductPairs AS (
    SELECT 
        A.Product_ID AS P1, 
        B.Product_ID AS P2, 
        COUNT(*) AS Frequency
    FROM FACT_Sales A
    JOIN FACT_Sales B 
        ON A.Order_ID = B.Order_ID 
        AND A.Product_ID < B.Product_ID
    GROUP BY A.Product_ID, B.Product_ID
)
SELECT 
    PR1.Product_Name AS Item_1, 
    PR2.Product_Name AS Item_2, 
    Frequency
FROM ProductPairs
JOIN DIM_Products PR1 ON PR1.Product_ID = P1
JOIN DIM_Products PR2 ON PR2.Product_ID = P2
WHERE Frequency > 1
ORDER BY Frequency DESC;