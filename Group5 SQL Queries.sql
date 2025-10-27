USE cs_rmk03895;

#Query 1: List all stores and their opening years.
SELECT idStore, location, year_opened 
	FROM Store;

#Query 2: Show all employees hired after 2020
SELECT first_name, last_name, hire_date FROM Employees
	WHERE hire_date > '2020-01-01';

#Query 3: Display all suppliers located in a Chicago.
SELECT supplier_name, city FROM Supplier
	WHERE city = 'Chicago';

#Query 4: List all departments in each store.
SELECT department_name, storeid FROM Department
	ORDER BY storeid;

#Query 5: Find the total number of employees per department in each store.
SELECT Department.storeid, Department.department_name, COUNT(Employees.employeeid) AS total_employees 
	FROM Department JOIN Employees ON Department.departmentid = Employees.departmentid
	GROUP BY Department.storeid, Department.department_name 
	ORDER BY Department.storeid;

#Query 6: Identify employees who are managers.
SELECT DISTINCT m.employeeid, m.first_name, m.last_name FROM Employees m
	JOIN Employees e ON m.employeeid = e.managerid;

#Query 7: Find the average hourly wage by department, sorted from highest to lowest.
SELECT Department.department_name, AVG(Employees.hourly_wage) AS avg_wage FROM Employees
	JOIN Department ON Department.departmentid = Department.departmentid 
	GROUP BY Department.department_name
	ORDER BY avg_wage DESC;

#Query 8: Determine which suppliers provide the most products.
SELECT Supplier.supplier_name, COUNT(Products.productid) AS num_products FROM Supplier
	JOIN Products ON Supplier.supplierid = Products.Supplier_supplierid
	GROUP BY Supplier.supplier_name
	ORDER BY num_products DESC;

#Query 9: Show the total number of aisles and capacity per store.
SELECT Store.idStore, COUNT(Aisle.aisle_num) AS total_aisles, SUM(Aisle.capacity) AS total_capacity
	FROM Store JOIN Department ON Store.idStore = Department.storeid
	JOIN Department_has_Aisle ON Department.departmentid = Department_has_Aisle.Department_departmentid
	JOIN Aisle ON Department_has_Aisle.Aisle_aisle_num = Aisle.aisle_num 
	GROUP BY Store.idStore;

#Query 10: Find employees working overlapping shifts on the same date. 
SELECT e1.employeeid AS emp1, e2.employeeid AS emp2, s1.shift_date
	FROM Shift_has_Employees AS s1 JOIN Shift_has_Employees AS s2 
    ON s1.shift_date = s2.shift_date AND s1.Shift_shiftid <> s2.Shift_shiftid
	JOIN Employees AS e1 ON s1.Employees_emplyeeid = e1.employeeid
	JOIN Employees AS e2 ON s2.Employees_emplyeeid = e2.employeeid
	WHERE s1.Shift_shiftid IN (
		SELECT shiftid 
		FROM Shift 
		WHERE start_time < end_time
)
	AND e1.employeeid < e2.employeeid;