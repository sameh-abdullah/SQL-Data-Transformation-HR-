# ETL Process
-------------
This project demonstrates an ETL (Extract, Transform, Load) pipeline implemented in SQL Server for cleaning, standardizing, and enriching employee data from the `bronze.employees` source table.

The pipeline applies multiple data quality operations including:

- Data standardization
- String cleaning
- Type conversion
- Missing value imputation
- Feature engineering
- Data normalization
- Data validation
---------
## 1. Data Cleaning (`cte_employees_cleaned`)

The first Common Table Expression (CTE) performs all cleansing and transformation logic.

---

## 2. Employee Identifier Validation

```sql
Employee_ID
```

- Employee IDs are retained without transformation.
- Assumed to be unique identifiers.

---

## 3. String Standardization

### First Name & Last Name Cleaning

```sql
TRIM(First_Name)
TRIM(Last_Name)
```

### Purpose
- Remove leading spaces
- Remove trailing spaces
- Improve consistency for reporting and matching

---

## 4. Department & Region Extraction

The `Department_Region` column contains concatenated values:

Example:

```text
IT-NorthAmerica
```

The pipeline splits this into:

| Department | Region |
|---|---|
| IT | NorthAmerica |

### Logic Used

- `LEFT()`
- `SUBSTRING()`
- `CHARINDEX()`
- `TRIM()`

### Defensive Programming

Additional validation ensures:
- rows without `-` delimiter do not fail the query
- invalid values return `NULL`

---

## 5. Employment Status Normalization

### Source Values

```text
Active
Inactive
Pending
```

### Transformed Values

| Original Status | Is_Active |
|---|---|
| Active | 1 |
| Inactive | 0 |
| Pending | 0 |

### Purpose

Standardize categorical values into binary indicators for:
- reporting
- analytics
- machine learning

---

## 6. Join Date Standardization

```sql
TRY_CAST(Join_Date AS DATE)
```

### Purpose

- Convert invalid date formats safely
- Prevent ETL pipeline failures
- Standardize datatype

### Why `TRY_CAST`?

Unlike `CAST`, `TRY_CAST`:
- returns `NULL` for invalid values
- prevents runtime exceptions

---

## 7. Salary Cleaning

### Issues Detected

- Non-numeric values such as:
  
```text
N/A
```

### Transformation

```sql
CASE
    WHEN Salary = 'N/A' THEN NULL
    ELSE TRY_CAST(Salary AS DECIMAL(18,2))
END
```

### Purpose

- Replace invalid salary values with `NULL`
- Convert valid salaries to numeric datatype
- Enable aggregation and analytics

---

## 8. Email Standardization

```sql
TRIM(Email)
```

### Data Quality Observation

Duplicate email addresses were identified in the source system.

### Recommendation

Requires validation with:
- business stakeholders
- system administrators
- HR data owners

---

## 9. Phone Number Cleaning

### Transformation Logic

```sql
CASE 
    WHEN CAST(Phone AS decimal) < 0 THEN ABS(Phone)
    ELSE Phone
END
```

### Purpose

- Remove invalid negative phone numbers
- Standardize identifier formatting

### Note

Phone numbers should ideally remain stored as strings (`VARCHAR/NVARCHAR`) because:
- they are identifiers
- not mathematical values

---

## 10. Remote Work Normalization

### Source Values

```text
true
false
TRUE
False
```

### Transformed Values

| Source | Remote_Work |
|---|---|
| true | 1 |
| false | 0 |

### Logic

```sql
LOWER(TRIM(Remote_Work))
```

### Purpose

Standardize boolean representation.

---

# Missing Value Imputation

## CTE: `cte_department_statistics`

The second CTE calculates grouped averages used for imputing missing values.

### Grouping Columns

- Department
- Region
- Remote_Work

---

## Average Calculations

```sql
AVG(Age)
AVG(Salary)
```

### Output Columns

| Column | Description |
|---|---|
| Avg_Age | Average employee age |
| Avg_Salary | Average employee salary |

---

# NULL Value Replacement

The final query uses:

```sql
COALESCE()
```

to replace missing values.

---

## Age Imputation

```sql
COALESCE(emp.Age, stats.Avg_Age)
```

If `Age` is NULL:
- use grouped average age

---

## Salary Imputation

```sql
COALESCE(emp.Salary, stats.Avg_Salary)
```

If `Salary` is NULL:
- use grouped average salary

---
