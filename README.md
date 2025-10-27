# Retail Store Management Database

**Team Members:**  
Joanne Lee, Arian Mazloom, Bryson Tanner, Jack Cramer, Richard Kimmig  

---

## 📘 Scenario Description

The data model we created is designed to maintain comprehensive records essential for keeping our retail store operations efficient and organized. It contains all information regarding **suppliers, products, departments, aisles, stores, employees, and work shifts**.

To begin with, the supplier data allows us to track each supplier’s **location and name**, ensuring products arrive on time and in excellent condition. Once the products are received, they are organized by **aisle and department**, giving customers an easy and accessible shopping experience.

Each store is composed of multiple departments, which creates an environment that allows shoppers to find various products without visiting multiple locations. Finally, the model includes detailed employee information such as **hire dates, managers, shifts, and wages**, which helps maintain clean employment records and a clear chain of command.

This database provides the foundation for operational efficiency, workforce management, and data-driven decision-making across our business.

---

## 🧩 Data Model
  
![Data Model](database.png)

The data model includes the following main entities:
- **Store** – Contains location and opening year information.
- **Aisle** – Tracks aisles, names, and capacities.
- **Department** – Manages departments within stores.
- **Employees** – Stores employee details, managers, departments, and wages.
- **Supplier** – Contains supplier names and cities.
- **Products** – Tracks product IDs, categories, and suppliers.
- **Shift** – Defines start and end times for work shifts.
- **Relationship Tables** – Manage many-to-many relationships such as department-to-aisle and shift-to-employee.

---

## 📗 Data Dictionary

| Table Name | Key Fields | Description |
|-------------|-------------|--------------|
| **Store** | `idStore`, `location`, `year_opened` | Contains store-level data. |
| **Aisle** | `aisle_num`, `aisle_name`, `capacity` | Defines aisles and their capacity. |
| **Department** | `departmentid`, `department_name`, `storeid` | Organizes store departments. |
| **Employees** | `employeeid`, `first_name`, `last_name`, `hire_date`, `hourly_wage`, `managerid`, `departmentid`, `storeid` | Stores all employee and management details. |
| **Supplier** | `supplierid`, `supplier_name`, `city` | Tracks supplier information and location. |
| **Products** | `productid`, `Supplier_supplierid`, `Product_Category_product_categoryid` | Links products to suppliers and categories. |
| **Shift** | `shiftid`, `start_time`, `end_time` | Represents working hours for each shift. |
| **Shift_has_Employees** | `Shift_shiftid`, `Employees_employeeid`, `shift_date` | Links employees to specific shifts and dates. |
| **Department_has_Aisle** | `Department_departmentid`, `Aisle_aisle_num`, `Department_Store_idStore` | Connects aisles to departments within stores. |

---

## 💻 SQL Queries

Below are the SQL queries developed for managerial insights.  
Each query includes a **description** and **justification** to explain its business relevance.

---

### 1. List all stores and their opening years
```sql
SELECT idStore, location, year_opened 
FROM Store;
```
**Description**: Retrieves each store’s ID, location, and opening year.

**Justification**: Useful for analyzing store age and expansion strategy.

### 2. Show all employees hired after 2020
```sql
SELECT first_name, last_name, hire_date 
FROM Employees
WHERE hire_date > '2020-01-01';
```
**Description**: Displays employees hired after January 1, 2020.

**Justification**: Helps track recent hires for HR and workforce planning.

### 3. Display all suppliers located in a specific city (e.g., Chicago)
```sql
SELECT supplier_name, city 
FROM Supplier
WHERE city = 'Chicago';
```
**Description**: Lists suppliers based in a particular city.

**Justification**: Useful for managing regional supplier relationships.

### 4. List all departments in each store
```sql
SELECT department_name, storeid 
FROM Department
ORDER BY storeid;
```
**Description**: Shows all departments, grouped by store.

**Justification**: Provides an overview of each store’s organizational structure.

### 5. Find the total number of employees per department in each store
```sql
SELECT d.storeid, d.department_name, COUNT(e.employeeid) AS total_employees 
FROM Department d 
JOIN Employees e ON d.departmentid = e.departmentid
GROUP BY d.storeid, d.department_name
ORDER BY d.storeid;
```
**Description**: Calculates how many employees work in each department per store.

**Justification**: Helps identify staffing levels and resource allocation.

### 6. Identify employees who are managers (have subordinates)
```sql
SELECT DISTINCT m.employeeid, m.first_name, m.last_name 
FROM Employees m
JOIN Employees e ON m.employeeid = e.managerid;
```
**Description**: Finds employees managing others.

**Justification**: Identifies leadership roles for performance and payroll review.

### 7. Find the average hourly wage by department, sorted from highest to lowest
```sql
SELECT d.department_name, AVG(e.hourly_wage) AS avg_wage 
FROM Employees e
JOIN Department d ON e.departmentid = d.departmentid 
GROUP BY d.department_name
ORDER BY avg_wage DESC;
```
**Description**: Calculates average hourly wages by department.

**Justification**: Aids in evaluating pay equity and budgeting for raises.

### 8. Determine which suppliers provide the most products
```sql
SELECT s.supplier_name, COUNT(p.productid) AS num_products 
FROM Supplier s
JOIN Products p ON s.supplierid = p.Supplier_supplierid
GROUP BY s.supplier_name
ORDER BY num_products DESC;
```
**Description**: Lists suppliers by the number of products they provide.

**Justification**: Identifies key suppliers and potential supply chain optimizations.

### 9. Show the total number of aisles and capacity per store
```sql
SELECT st.idStore, COUNT(a.aisle_num) AS total_aisles, SUM(a.capacity) AS total_capacity
FROM Store st 
JOIN Department d ON st.idStore = d.storeid
JOIN Department_has_Aisle da ON d.departmentid = da.Department_departmentid
JOIN Aisle a ON da.Aisle_aisle_num = a.aisle_num 
GROUP BY st.idStore;
```
**Description**: Summarizes aisle count and total capacity by store.

**Justification**: Supports store layout optimization and inventory management.

### 10. Find employees working overlapping shifts on the same date
```sql
SELECT e1.employeeid AS emp1, e2.employeeid AS emp2, s1.shift_date 
FROM Shift_has_Employees s1 
JOIN Shift_has_Employees s2 
  ON s1.shift_date = s2.shift_date AND s1.Shift_shiftid <> s2.Shift_shiftid 
JOIN Employees e1 ON s1.Employees_employeeid = e1.employeeid 
JOIN Employees e2 ON s2.Employees_employeeid = e2.employeeid
WHERE s1.Shift_shiftid IN (
    SELECT shiftid FROM Shift WHERE start_time < end_time
)
AND e1.employeeid < e2.employeeid;
```
**Description**: Detects employees with overlapping shifts on the same day.

**Justification**: Helps managers prevent scheduling conflicts and overstaffing.

---

## 🏁 Summary

This database serves as a comprehensive store management tool that:

- Tracks suppliers and products to ensure supply chain efficiency
- Organizes departments and aisles for customer accessibility
- Manages employee data, shifts, and payroll for workforce efficiency

By combining these data sources, managers gain actionable insights into operations, staffing, and store performance, driving data-informed business decisions.

---


