# 🛒 Project MSC — Sample Superstore Analysis

<div align="center">

![SQL Server](https://img.shields.io/badge/Microsoft%20SQL%20Server-CC2927?style=for-the-badge&logo=microsoft%20sql%20server&logoColor=white)
![Power BI](https://img.shields.io/badge/Power%20BI-F2C811?style=for-the-badge&logo=Power%20BI&logoColor=black)
![T-SQL](https://img.shields.io/badge/T--SQL-4479A1?style=for-the-badge&logo=amazon-dynamodb&logoColor=white)
![Star Schema](https://img.shields.io/badge/Star%20Schema-Data%20Warehouse-blueviolet?style=for-the-badge)

*An end-to-end data project — from raw CSV to a structured data warehouse with SQL analytics and a Power BI dashboard.*

</div>

---

## 📌 Table of Contents

- [Business Problem](#-business-problem)
- [Dataset Overview](#-dataset-overview)
- [Project Structure](#-project-structure)
- [Database Design — Star Schema](#-database-design--star-schema)
- [SQL Analytical Queries](#-sql-analytical-queries)
- [Power BI Dashboard](#-power-bi-dashboard)
- [How to Run](#-how-to-run)
- [Tools & Technologies](#-tools--technologies)

---

## 💼 Business Problem

Retail businesses often struggle to answer basic but critical questions:

> *Which products are actually profitable? Which customers are losing us money? Are our shipping methods efficient?*

This project transforms **9,994 raw transactional records** into a clean, query-ready star schema data warehouse — enabling fast answers to real business questions around sales performance, customer value, shipping efficiency, and regional trends.

---

## 📊 Dataset Overview

| Property | Detail |
|---|---|
| **Source** | Sample Superstore (Tableau public dataset) |
| **File** | `Sample_Superstore.csv` |
| **Rows** | 9,994 |
| **Columns** | 21 |
| **Time Range** | 2014 – 2017 |

**Key fields:** `Order ID`, `Order Date`, `Ship Date`, `Ship Mode`, `Customer`, `Segment`, `Region`, `Category`, `Sub-Category`, `Sales`, `Quantity`, `Discount`, `Profit`

---

## 📁 Project Structure

```
Project_MSC/
│
├── 📄 Sample_Superstore.csv           # Raw source data
├── 📄 CREATE_TABLES.sql               # Star schema DDL (database + all tables)
├── 📄 INSERT_DATA_IN_ALL_TABLES.sql   # ETL / data loading scripts
├── 📄 SQL_Queries_Questions.sql       # 11 analytical SQL queries
├── 📊 Project_MSC.pbix                # Power BI dashboard
├── 📁 Assets/                         # Screenshots & diagrams
└── 📄 README.md                       # This file
```

---

## 🗄️ Database Design — Star Schema

The database follows a **Star Schema** design with **1 Fact table** and **6 Dimension tables**, built in Microsoft SQL Server.

![Star Schema Diagram](Assets/ERD_Diagram.png)

### Tables

| Table | Type | Key Columns |
|---|---|---|
| `FACT_Sales` | ⭐ Fact | `Row_ID`, `Sales`, `Quantity`, `Discount`, `Profit` |
| `DIM_Customers` | Dimension | `Customer_ID`, `Customer_Name`, `Segment` |
| `DIM_Products` | Dimension | `Product_ID`, `Product_Name`, `Category`, `Sub_Category` |
| `DIM_Location` | Dimension | `Location_ID`, `City`, `State`, `Region`, `Postal_Code` |
| `DIM_Shipping` | Dimension | `Ship_ID`, `Ship_Mode` |
| `DIM_Order_Date` | Dimension | `Order_Date_ID` (YYYYMMDD), `Order_Date` |
| `DIM_Ship_Date` | Dimension | `Ship_Date_ID` (YYYYMMDD), `Ship_Date` |

### ⚙️ Key Design Decisions

- **`Product_ID`** is generated as `CONCAT(Product_ID, '-', LEFT(Product_Name, 10))` because the original dataset contains **duplicate Product IDs** mapped to different product names — this ensures true uniqueness.
- **Date IDs** use the integer format `YYYYMMDD` (e.g., `20171201`) for efficient joins and range filtering.
- All **Foreign Keys** in `FACT_Sales` reference their respective dimension tables to enforce referential integrity.
- **`DIM_Location`** uses an `IDENTITY` surrogate key because there is no natural unique key for location combinations in the source data.

---

## 🔍 SQL Analytical Queries

11 queries covering a range of SQL techniques — from simple aggregations to CTEs, window functions, and market basket analysis.

| # | Business Question | SQL Techniques |
|---|---|---|
| 1 | **Category Performance** — Total sales & profit per category | `GROUP BY`, `SUM`, `ORDER BY` |
| 2 | **Top Profitable Cities** — Top 5 cities by total profit | `TOP N`, `JOIN`, aggregation |
| 3 | **VIP Customers** — Customers spending above average | Correlated subquery, `HAVING` |
| 4 | **Shipping Efficiency** — Avg. shipping days per ship mode | `DATEDIFF`, `AVG`, multi-table `JOIN` |
| 5 | **Sales Contribution %** — Each category's share of total sales | Scalar subquery, percentage calc |
| 6 | **Never Discounted Products** — Products always sold at full price | `NOT IN`, subquery |
| 7 | **High-Volume Loss Makers** — Many orders but negative total profit | `HAVING` with multiple conditions |
| 8 | **Regional Segment Analysis** — Sales & transactions by region + segment | Multi-column `GROUP BY`, `COUNT` |
| 9 | **Order vs. Sub-Category Average** — High-value orders vs. their sub-category avg | Correlated subquery in `SELECT` |
| 10 | **Yearly Top 3 Products** — Best-selling products per year | `CTE`, `ROW_NUMBER()`, `PARTITION BY` |
| 11 | **Market Basket Analysis** — Product pairs bought together frequently | Self `JOIN`, `CTE`, co-occurrence count |

---

## 📈 Power BI Dashboard

The `Project_MSC.pbix` file connects directly to the SQL Server database and includes visuals covering:

- 📅 Sales & Profit trends over time (2014–2017)
- 📦 Category & Sub-Category performance breakdown
- 🗺️ Regional & Segment analysis
- 👤 Customer analysis — VIP vs. loss-making customers
- 🚚 Shipping efficiency by ship mode

### Overview Page
![Dashboard Overview](Assets/Overview_Page.png)

### Product Analysis
![Product Analysis](Assets/Product_Page.png)

### Customer Analysis
![Customer Analysis](Assets/Customer_Page.png)

---

## 🚀 How to Run

### Prerequisites
- Microsoft SQL Server (2016 or later)
- SQL Server Management Studio (SSMS)
- Power BI Desktop

### Steps

**1. Create the database and tables**
```sql
-- Run in SSMS
CREATE_TABLES.sql
```

**2. Import the raw CSV as a staging table**

Import `Sample_Superstore.csv` into SQL Server as a flat table named `Sample_Superstore` inside the `Project_MSC` database.

> Use SSMS → Right-click database → *Tasks → Import Flat File*, or use `BULK INSERT`.

**3. Populate all dimension and fact tables**
```sql
-- Run in SSMS
INSERT_DATA_IN_ALL_TABLES.sql
```

**4. Run the analytical queries**
```sql
-- Run any or all queries in SSMS
SQL_Queries_Questions.sql
```

**5. Open the Power BI Dashboard**

Open `Project_MSC.pbix` in Power BI Desktop → Update the data source to your SQL Server instance → Refresh.

---

## 🛠️ Tools & Technologies

| Tool | Purpose |
|---|---|
| **Microsoft SQL Server** | Database engine & data warehouse |
| **T-SQL** | DDL, ETL, and analytical queries |
| **Power BI Desktop** | Interactive dashboard & data visualization |
| **SSMS** | Database management and query execution |

---

<div align="center">

*Built as a complete end-to-end data engineering + analytics project.*

⭐ *If you found this useful, consider giving the repo a star!*

</div>