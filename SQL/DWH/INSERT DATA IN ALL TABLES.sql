USE Project_MSC
GO

-------------------------------------------
--      INSERT TABLE DIM_Customers       --
-------------------------------------------

INSERT INTO DIM_Customers (Customer_ID, Customer_Name, Segment)
SELECT DISTINCT Customer_ID, Customer_Name, Segment FROM Sample_Superstore;

-------------------------------------------
--      INSERT TABLE DIM_Products        --
-------------------------------------------

INSERT INTO DIM_Products (Product_ID, Product_Name, Category, Sub_Category)
SELECT DISTINCT CONCAT([Product_ID], '-', LEFT([Product_Name], 10)) AS Product_ID,
[Product_Name] , Category, [Sub_Category] 
FROM dbo.Sample_Superstore

-------------------------------------------
--      INSERT TABLE DIM_Location        --
-------------------------------------------

INSERT INTO DIM_Location (Country, City, State, Postal_Code, Region)
SELECT DISTINCT Country, City, State, Postal_Code, Region 
FROM Sample_Superstore;

-------------------------------------------
--      INSERT TABLE DIM_Shipping        --
-------------------------------------------

INSERT INTO DIM_Shipping (Ship_Mode)
SELECT DISTINCT Ship_Mode
FROM Sample_Superstore;

-------------------------------------------
--    INSERT DATA INTO DIM_Order_Date    --
-------------------------------------------

INSERT INTO DIM_Order_Date (Order_Date_ID, Order_Date)
SELECT DISTINCT 
    CONVERT(INT, FORMAT(CAST(Order_Date AS DATE), 'yyyyMMdd')) AS Order_Date_ID,
    CAST(Order_Date AS DATE)
FROM Sample_Superstore
WHERE Order_Date IS NOT NULL;

-------------------------------------------
--      INSERT DATA INTO DIM_Ship_Date   --
-------------------------------------------

INSERT INTO DIM_Ship_Date (Ship_Date_ID, Ship_Date)
SELECT DISTINCT 
    CONVERT(INT, FORMAT(CAST(Ship_Date AS DATE), 'yyyyMMdd')) AS Ship_Date_ID,
    CAST(Ship_Date AS DATE)
FROM Sample_Superstore
WHERE Ship_Date IS NOT NULL;

-------------------------------------------
--      INSERT TABLE FACT_Sales        --
-------------------------------------------

    INSERT INTO FACT_Sales (
    Row_ID, Order_ID, Order_Date_ID, Ship_Date_ID, 
    Customer_ID, Product_ID, Location_ID, Ship_ID, 
    Sales, Quantity, Discount, Profit
)
SELECT 
    s.[Row_ID], 
    s.[Order_ID],
    CONVERT(INT, FORMAT(CAST(s.[Order_Date] AS DATE), 'yyyyMMdd')) AS Order_Date_ID,
    CONVERT(INT, FORMAT(CAST(s.[Ship_Date] AS DATE), 'yyyyMMdd')) AS Ship_Date_ID,
    c.[Customer_ID],   
    p.[Product_ID],    
    loc.Location_ID, 
    ship.Ship_ID,
    s.Sales,
    s.Quantity, 
    s.Discount, 
    s.Profit
FROM Sample_Superstore s
LEFT JOIN DIM_Location loc ON 
    s.Country = loc.Country 
    AND s.City = loc.City 
    AND s.State = loc.State 
    AND ISNULL(s.[Postal_Code], 0) = ISNULL(loc.Postal_Code, 0) 
    AND s.Region = loc.Region
LEFT JOIN DIM_Shipping ship ON 
    s.[Ship_Mode] = ship.Ship_Mode
LEFT JOIN DIM_Customers c ON 
    s.[Customer_ID] = c.Customer_ID
LEFT JOIN DIM_Products p ON 
    CONCAT(s.[Product_ID], '-', LEFT(s.[Product_Name], 10)) = p.Product_ID;