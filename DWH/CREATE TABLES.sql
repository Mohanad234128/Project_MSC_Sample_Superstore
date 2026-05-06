-------------------------------------------
--       CREATE DataBase Project_MSE
-------------------------------------------

CREATE DATABASE Project_MSC
GO 
USE Project_MSC
GO

-------------------------------------------
--         CREATE ALL TABLES 
-------------------------------------------

-- 1. CREATE TABLE DIM_Customers

CREATE TABLE DIM_Customers(
	Customer_ID VARCHAR(100) PRIMARY KEY,
	Customer_Name VARCHAR(100) NOT NULL,
    Segment VARCHAR(50) NOT NULL
);

-- 2. CREATE TABLE DIM_Location

CREATE TABLE DIM_Location(
	Location_ID INT IDENTITY(1,1) PRIMARY KEY,
    Country VARCHAR(50),
    City VARCHAR(50),
    State VARCHAR(50),
    Postal_Code INT,
    Region VARCHAR(50)
);

-- 3. CREATE TABLE DIM_Products

CREATE TABLE DIM_Products(
	Product_ID VARCHAR(100) PRIMARY KEY,
    Product_Name VARCHAR(255),
    Category VARCHAR(50),
    Sub_Category VARCHAR(50)
);

-- 4. CREATE TABLE DIM_Shipping

CREATE TABLE DIM_Shipping(
	Ship_ID INT IDENTITY(1,1) PRIMARY KEY,
    Ship_Mode VARCHAR(50)
);


-- 5. CREATE TABLE DIM_Order_Date

CREATE TABLE DIM_Order_Date (
    Order_Date_ID INT PRIMARY KEY,
    Order_Date DATE
);

-- 6. CREATE TABLE DIM_Ship_Date

CREATE TABLE DIM_Ship_Date (
    Ship_Date_ID INT PRIMARY KEY,
    Ship_Date DATE
);

-- 7. CREATE TABLE FACT_Sales

CREATE TABLE FACT_Sales (
    Row_ID INT PRIMARY KEY,
    Order_ID VARCHAR(50),
    Order_Date_ID INT,
    Ship_Date_ID INT,
    Customer_ID VARCHAR(100),
    Product_ID VARCHAR(100),
    Location_ID INT,
    Ship_ID INT,
    Sales DECIMAL(18, 2),
    Quantity INT,
    Discount DECIMAL(18, 2),
    Profit DECIMAL(18, 2),
    FOREIGN KEY (Customer_ID) REFERENCES DIM_Customers(Customer_ID),
    FOREIGN KEY (Product_ID) REFERENCES DIM_Products(Product_ID),
    FOREIGN KEY (Location_ID) REFERENCES DIM_Location(Location_ID),
    FOREIGN KEY (Ship_ID) REFERENCES DIM_Shipping(Ship_ID),
    FOREIGN KEY (Order_Date_ID) REFERENCES DIM_Order_Date(Order_Date_ID),
    FOREIGN KEY (Ship_Date_ID) REFERENCES DIM_Ship_Date(Ship_Date_ID)
);