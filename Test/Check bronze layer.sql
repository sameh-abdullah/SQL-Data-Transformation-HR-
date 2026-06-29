
-- Connect hr_employee dataset
USE hr_employee;
GO

-- Check completness load of the bronze data
-- Expected 1020 rows
SELECT COUNT(*) AS total_rows
FROM bronze.employees
