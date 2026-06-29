
-- Connect to hr_employee database
USE hr_employee;
GO
-- Truncate all the data that store in the silver.employees table for avoid overwriting
IF OBJECT_ID('silver.employees','U') IS NOT NULL
    TRUNCATE TABLE silver.employees;
GO
/* 
    Create two CTS table for data mainpulating
*/
WITH cte_employees_cleaned AS
(
    SELECT

        /*---------------------------------------------------------
            Employee identifier
            No transformation required because IDs are unique
        ---------------------------------------------------------*/
        Employee_ID,

        /*---------------------------------------------------------
            Remove leading/trailing spaces from names
        ---------------------------------------------------------*/
        TRIM(First_Name) AS First_Name,
        TRIM(Last_Name)  AS Last_Name,

        /*---------------------------------------------------------
            Age remains nullable for later imputation
        ---------------------------------------------------------*/
        Age,

        /*---------------------------------------------------------
            Split Department_Region into:
                - Department
                - Region

            Example:
                IT-NorthAmerica
                -> IT
                -> NorthAmerica

            Defensive logic added in case delimiter is missing
        ---------------------------------------------------------*/
        CASE
            WHEN CHARINDEX('-', Department_Region) > 0
            THEN TRIM(
                    LEFT(
                        Department_Region,
                        CHARINDEX('-', Department_Region) - 1
                    )
                 )
            ELSE NULL
        END AS Department,

        CASE
            WHEN CHARINDEX('-', Department_Region) > 0
            THEN TRIM(
                    SUBSTRING(
                        Department_Region,
                        CHARINDEX('-', Department_Region) + 1,
                        LEN(Department_Region)
                    )
                 )
            ELSE NULL
        END AS Region,

        /*---------------------------------------------------------
            Convert employment status into binary flag

            1 = Active
            0 = Inactive / Pending
        ---------------------------------------------------------*/
        CASE
            WHEN Status IN ('Pending', 'Inactive') THEN 0
            ELSE 1
        END AS Is_Active,

        /*---------------------------------------------------------
            Standardize join date datatype
        ---------------------------------------------------------*/
        TRY_CAST(Join_Date AS DATE) AS Join_Date,

        /*---------------------------------------------------------
            Salary cleaning:
                - Replace N/A with NULL
                - Prevent ETL failure using TRY_CAST
        ---------------------------------------------------------*/
        CASE
            WHEN Salary = 'N/A' THEN NULL
            ELSE TRY_CAST(Salary AS DECIMAL(18,2))
        END AS Salary,

        /*---------------------------------------------------------
            Email retained as-is

            NOTE:
            Duplicate emails detected in source system.
            Requires business/data-owner validation.
        ---------------------------------------------------------*/
        TRIM(Email) AS Email,

        /*---------------------------------------------------------
            Phone numbers are identifiers, not numeric values.
            Casting to decimal and remove minuse only.
        ---------------------------------------------------------*/
        CASE 
            WHEN CHARINDEX('-',Phone)>0 THEN TRIM(REPLACE(Phone,'-',''))
            ELSE TRIM(Phone)
        END AS Phone,

        /*---------------------------------------------------------
            Performance score validated during profiling
        ---------------------------------------------------------*/
        Performance_Score,

        /*---------------------------------------------------------
            Convert Remote_Work flag to binary
        ---------------------------------------------------------*/
        CASE
            WHEN LOWER(TRIM(Remote_Work)) = 'true' THEN 1
            ELSE 0
        END AS Remote_Work

    FROM bronze.employees
),

cte_department_statistics AS
(
    SELECT

        Department,
        Region,
        Remote_Work,

        /*---------------------------------------------------------
            Average values used for NULL imputation
        ---------------------------------------------------------*/
        ROUND(AVG(Age), 0)       AS Avg_Age,
        ROUND(AVG(Salary), 2)    AS Avg_Salary

    FROM cte_employees_cleaned

    WHERE Age IS NOT NULL
      AND Salary IS NOT NULL

    GROUP BY
        Department,
        Region,
        Remote_Work
)

-- Load the transfomated and cleaned data to silver layer

INSERT INTO silver.employees
SELECT

    emp.Employee_ID,
    emp.First_Name,
    emp.Last_Name,

    /*---------------------------------------------------------
        Replace missing Age values using grouped averages
    ---------------------------------------------------------*/
    COALESCE(emp.Age, stats.Avg_Age) AS Age,

    emp.Department,
    emp.Region,
    emp.Is_Active,
    emp.Join_Date,

    /*---------------------------------------------------------
        Replace missing Salary values using grouped averages
    ---------------------------------------------------------*/
    COALESCE(emp.Salary, stats.Avg_Salary) AS Salary,

    emp.Email,
    CAST(emp.Phone AS bigint),
    emp.Performance_Score,
    emp.Remote_Work

FROM cte_employees_cleaned emp

LEFT JOIN cte_department_statistics stats
    ON emp.Department   = stats.Department
   AND emp.Region       = stats.Region
   AND emp.Remote_Work  = stats.Remote_Work;
