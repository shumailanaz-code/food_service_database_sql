# 🍽️ Food Service Database Project (SQL)

## 📖 Overview

This project involves designing and querying a **relational food service database** using **real-world restaurant data**.
The dataset includes information about restaurants, consumers, cuisines, and ratings.
The database was created as part of a consulting simulation for a food service company.

The project is divided into two parts:
1. **Database creation, schema design, and relationships**
2. **Advanced SQL queries and stored procedures to extract insights**

---

## 🗃️ Dataset Description

The database, named **FoodserviceDB**, is built using four CSV files provided via Blackboard:

| Table Name             | Description |
|------------------------|-------------|
| `Restaurant`           | 130 records with location, price range, alcohol/smoking policies, area type, parking, etc. |
| `Consumers`            | 137 records detailing consumer demographics, lifestyle, and preferences |
| `Ratings`              | 1161 records of consumer ratings with `Overall_Rating`, `Food_Rating`, and `Service_Rating` |
| `Restaurant_Cuisines`  | 112 records mapping restaurants to their respective cuisines |

> Primary and foreign key constraints were added, and an ER diagram was created to visualize relationships.

---

## 🛠️ Technologies Used

- **SQL (MySQL / PostgreSQL)**
- **ER Diagram Design (DrawSQL / dbdiagram.io / Workbench)**
- **CSV Data Import**
- **Stored Procedures, Joins, Grouping, System Functions**

---

## 📊 Key Queries and Tasks

### ✅ Part 1: Schema Design
- Created 4 normalized tables matching the CSV structure
- Assigned primary keys:
  - `Restaurant.Restaurant_id`
  - `Consumers.Consumer_id`
  - Composite PK in `Ratings`: (`Consumer_id`, `Restaurant_id`)
- Assigned foreign key relationships to connect tables properly

### ✅ Part 2: SQL Queries

1. **Find all restaurants** that:
   - Have a `Price` = `'Medium'`
   - Are located in `open` area
   - Serve `'Mexican'` cuisine

2. **Compare**:
   - Total number of restaurants with `Overall_Rating = 1` and Mexican cuisine
   - With Italian cuisine
   - (Includes a written interpretation of the comparison)

3. **Calculate** the **average age** of consumers who gave a `Service_rating = 0`  
   (Rounded to nearest whole number)

4. **Find restaurants** ranked by the **youngest consumer**, showing:
   - Restaurant name
   - Food rating given by the youngest consumer  
   (Sorted by food rating, high to low)

5. **Stored Procedure**:
   - Updates `Service_rating` to `2` for all restaurants with `Parking = 'Yes'` or `'Public'`

6. **Custom Queries**:
   - Use of `EXISTS`
   - Use of `IN`
   - Use of system functions (e.g., `ROUND()`, `NOW()`)
   - Use of `GROUP BY`, `HAVING`, and `ORDER BY`
