# 🧹 Employee Data Cleaning & Transformation ETL

## 📝 Overview

This project demonstrates an ETL (Extract, Transform, Load) pipeline implemented in SQL Server for cleaning, standardizing, and enriching employee data from the `bronze.employees` source table.

The pipeline applies multiple data quality operations including:

- ✨ Data standardization
- 🧼 String cleaning
- 🔄 Type conversion
- 🚫 Missing value imputation
- 🧬 Feature engineering
- 📊 Data normalization
- ✅ Data validation

The final dataset is prepared for:
- 📈 Analytics
- 📄 Reporting
- 📊 Dashboarding
- 🏬 Data warehousing
- 🤖 Machine learning preprocessing

---

# 🏗️ Architecture

```text
🥉 Bronze Layer (Raw Data)
        ↓
🧹 Data Cleaning & Standardization
        ↓
🧬 Feature Engineering
        ↓
🚫 Missing Value Imputation
        ↓
🥈 Silver Layer (Cleaned Data)
```

---

# 📂 Source Table

```csv file
Messy_Employee_dataset.csv
```

The source table contains raw employee records with inconsistent formatting, missing values, and non-standardized attributes.

---

# 🗃️ Final Output Columns (Data Catalog)

| Column |  Description |
|---|---|
| Employee_ID |  Employee identifier (exe. EMP1000) |
| First_Name |  Employee first name |
| Last_Name |  employee last name |
| Age |  Employee age  |
| Department |  Department where the employee works |
| Region |  Region where the employee works |
| Is_Active |  If the employee currently work or not (exe 1, 0) |
| Join_Date |  Date when the employee joins the company |
| Salary |  The salary amount staff will receive |
| Email |  Work email |
| Phone |  Employee phone number |
| Performance_Score | The performance score of employee (exe Excellent, Good, Poor, Average) |
| Remote_Work |  (Remote) / (In-Person) work modality (exe. 1, 0) |

---

# 🛠️ SQL Techniques Used

| 🧩 Technique | 🎯 Purpose |
|---|---|
| CTEs | 🏗️ Modular ETL structure |
| TRIM | 🧹 String cleaning |
| CASE | 🔄 Conditional transformation |
| TRY_CAST | 🦺 Safe datatype conversion |
| CHARINDEX | 🔍 String parsing |
| SUBSTRING | ✂️ Feature extraction |
| LEFT | ⬅️ String extraction |
| AVG | 🧮 Imputation statistics |
| COALESCE | 💡 NULL replacement |
| LEFT JOIN | 🖇️ Preserve unmatched rows |

---

# 🏆 Data Quality Improvements Achieved

✅ Standardized text values  
✅ Removed extra spaces  
✅ Converted invalid values safely  
✅ Handled missing values  
✅ Normalized categorical fields  
✅ Created analytical dimensions  
✅ Prevented ETL runtime failures  
✅ Improved reporting readiness  

---

# 🚀 Recommended Future Improvements

## 1. 📊 Use Median Instead of Average

Salary distributions often contain outliers.

Median imputation is more statistically robust than AVG.

---

## 2. 🏷️ Add Data Quality Flags

Example:

```sql
Age_Imputed
Salary_Imputed
```

This improves:
- 🕵️ Auditability
- 📜 Lineage
- 🔍 Analytics transparency

---

## 3. 💾 Persist Cleaned Data

Create a dedicated cleaned table:

```sql
silver.employees
```

instead of recalculating transformations repeatedly.

---

## 4. ✅ Add Validation Rules

Recommended constraints:

- 📧 Valid email format
- 🎂 Positive age values
- 💰 Salary ranges
- 📞 Phone format validation

---

# 🧰 Technologies Used

- 🗄️ SQL Server
- 💻 T-SQL
- 🏗️ Common Table Expressions (CTEs)

---

# 📊 Use Cases

This ETL pipeline is suitable for:

- 👥 HR analytics
- 📈 Power BI dashboards
- 📓 Workforce reporting
- 🏬 Data warehouse staging
- 🤖 Machine learning preprocessing
- 🕵️ Data quality assessment

---

## 👤 Author

**Sameh Abdullah**  
**LinkedIn**: [My Profile](https://linkedin.com/in/sameh-abdullah-961554176)
