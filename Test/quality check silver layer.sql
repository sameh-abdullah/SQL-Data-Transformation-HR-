/*
	Script purpose: this script for testing the transformated data under correctness, consistancy data check

	Warning: do not run this code untill run firstly the bronze and silver layer script or will show run-time error 

*/

-- Connect to hr_employee dataset
USE hr_employee;
GO

/*	Chect the count of row inside the table
	Expected 1020 rows
*/
SELECT COUNT(*) AS total_rows
FROM silver.employees;
GO

/*	Chect the unwanted space in the name
	NO result expected
*/
SELECT
	First_Name,
	Last_Name
FROM silver.employees
WHERE First_Name !=TRIM(First_Name)
	OR Last_Name !=TRIM(Last_Name);
GO

/*	Chect the employee_id if there is duplication or not
	no expected data (0)
*/
SELECT 
	Employee_ID,
	COUNT(Employee_ID) AS duplications
FROM silver.employees
GROUP BY Employee_ID
HAVING COUNT(Employee_ID)>1;
GO

/*	Chect the age value if there is null data or outlier data
	No null data is expected
*/
SELECT DISTINCT Age
FROM silver.employees
ORDER BY 1 ASC;
GO

/*	Chect the Distinct value of department and if there is invalid value
	6 Department are expected
*/
SELECT DISTINCT Department
FROM silver.employees;
GO

/*	Chect the Distinct value of Region and if there is invalid value
	6 region are expected
*/
SELECT DISTINCT Region
FROM silver.employees;
GO

/*	Chect the salary value if there is null data or outlier data
	No null data is expected
*/
SELECT DISTINCT Salary
FROM silver.employees
ORDER BY 1 ASC;
GO

/*
	Check if there is null values
	No result expected
*/
SELECT 
	Is_Active,
	Join_Date,
	Email,
	Phone,
	Performance_Score,
	Remote_Work
FROM silver.employees
WHERE 
	Is_Active IS NULL
	OR Join_Date IS NULL
	OR Email IS NULL
	OR Phone IS NULL
	OR Performance_Score IS NULL
	OR Remote_Work IS NULL;
GO
