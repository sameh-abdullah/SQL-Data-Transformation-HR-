 -- connect master database for initializing dataset
USE master
GO

-- check if the hr_employees dataset exist or not, if exist drop it and create new one
IF EXISTS (SELECT 1 FROM sys.databases WHERE name='hr_employee')
BEGIN 
	DROP DATABASE hr_employee;
END;
GO

-- Create hr_employee database
CREATE DATABASE hr_employee;
GO

-- Connect the new data base for create schema and tables for data transforamtion
USE hr_employee;
GO

-- Create bronze layer for data ingestion
CREATE SCHEMA bronze;
GO
-- Create Silver layer for data transformation
CREATE SCHEMA silver;
GO
