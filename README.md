# Analyzing eCommerce Business Performance with SQL

## Overview
Measuring business performance is crucial for tracking, monitoring, and evaluating the success or shortcomings of various business processes within a company. This analysis will explain the performance of an eCommerce company, focusing on key business metrics such as customer growth, product quality, and payment methods. There are 3 main analyzes of this data, namely Annual Customer Activity Growth Analysis, Annual Product Category Quality Analysis, and Annual Payment Type Usage Analysis.

### 1. Data Preparation
There is a step that must be taken before the data can be analyzed, namely data preparation.
- **Create tables & Import CSV files**
    <br>Import CSV files into tables created in PostgreSQL using the query tool with the `CREATE TABLE` command while adding a primary key to each table, and then using `COPY` command to import csv files to the tables.
- **Add contraints & Build ERD**
    <br>Add constraints to each table using the `ALTER TABLE` command and define foreign keys and references to make the ERD (Entity Relationship Diagram) between the tables.
ERD Image
![constraints1 pgerd](https://github.com/user-attachments/assets/f66eed8d-274c-404f-af75-f2943bd0fc5b)

### 2. Annual Customer Activity Growth Analysis
Annual customer activity growth analysis contains the data of monthly active users, new customers, customers who make repeat orders, and the average number of orders per year. Also showcasing customer growth in the form of a chart.<br>
<br>**Calculation of Customers per Year** <br>
![image](https://github.com/user-attachments/assets/08ef3e31-efd0-4217-9738-9c3ce2b7a1db)
<br>

### 3. Annual Product Category Quality Analysis
Annual product category quality analysis contains the data of total revenue, number of cancel orders, product categories with the highest sales, and product categories with the most cancel orders each year. Then present insights that can be taken from the data in the form of graphs.<br>

<br>**Calculation of Product Sales per Year** <br>
![image](https://github.com/user-attachments/assets/45f8f18c-96c0-439f-8ad5-c552a06495a7)
<br>

### 4. Annual Payment Type Usage Analysis
Annual payment type usage analysis consist of data that displays the amount of usage of each payment type all time sorted from the most favorite, and detailed information on the amount of usage of each payment type for each year. Then display insights that can be taken from the data in the form of graphs.<br>

<br>**Calculation of Payment Type Usage per Year**<br>
![image](https://github.com/user-attachments/assets/c9631444-f368-4aa0-813d-d39dfa60e2f5)



