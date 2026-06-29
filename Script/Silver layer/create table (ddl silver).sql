/*
	Script purpose: this script use to create the silver layers table for data transformation, before that,
		the script check if the table exists or not, if yes, will drop the table and recreate it. the data will transformed
		from the bronze layer.
	
	Warning: run this script will drop the silver layer table and the data inside it.

*/

-- Connect the hr_employees database
USE hr_employee;
GO

-- Check if the table is exists or not, if yes, drop it
IF OBJECT_ID('silver.employees','U') IS NOT NULL
	DROP TABLE silver.employees;
GO

-- Create employees table for storing the clean data
CREATE TABLE silver.employees(
	employee_ID		NVARCHAR(50) NOT NULL,
	First_Name		NVARCHAR(50) NOT NULL,
	Last_Name		NVARCHAR(50) NULL,
	Age				INT NOT NULL,
	Department		NVARCHAR(50) NOT NULL,
	Region			NVARCHAR(50) NOT NULL,
	Is_Active		INT,
	Join_Date		DATE,
	Salary			DECIMAL(18,2) NOT NULL,
	Email			NVARCHAR(50) NOT NULL,
	Phone			BIGINT NOT NULL,
	Performance_Score NVARCHAR(50) NOT NULL,
	Remote_Work		INT NOT NULL
);
GO
