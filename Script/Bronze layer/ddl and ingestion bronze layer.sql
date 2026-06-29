/*
	Script purpose: this script is use to create employees table for data load, by using the bulk insert, full load to ingest data from csv file
	to the table, using the truncate and insert method

	Warning: run this script will drop the employees table and then ingesting the csv file data to the table.

*/

-- connect hr_employee database
USE hr_employee;
GO

-- check if the table employees is exists or not, if not, we create employees table for ingestion data
IF OBJECT_ID('bronze.employees','U') IS NOT NULL
	DROP TABLE bronze.employees;
GO

CREATE TABLE bronze.employees(
	Employee_ID			NVARCHAR(50),
	First_Name			NVARCHAR(50),
	Last_Name			NVARCHAR(50),
	Age					INT,
	Department_Region	NVARCHAR(50),
	Status				NVARCHAR(50),
	Join_Date			NVARCHAR(50),
	Salary				NVARCHAR(50),
	Email				NVARCHAR(50),
	Phone				NVARCHAR(50),
	Performance_Score	NVARCHAR(50),
	Remote_Work			NVARCHAR(50));
	GO

/*
-- Truncate all the data stored in the employees table for ingestion data from csv file
TRUNCATE TABLE bronze.employees;
GO */

-- Ingesting csv data to the employees table use bulk insert method
BULK INSERT bronze.employees
FROM 'E:\SQL Data Transformation (Employees dataset)\Dataset\Messy_Employee_dataset.CSV'
WITH(
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	TABLOCK
);
GO

-- Test the table whither it store all the data or not
SELECT COUNT(*) FROM bronze.employees;
