# 🏥 Hospital Database – Backup & Recovery Simulation

This project simulates a real-world SQL Server database environment for a hospital and demonstrates core database administration skills: database design, backup strategies, disaster recovery, data normalization, and ETL processing.

## 📁 Project Structure

```
HospitalProject/
├── Backups/
│   ├── Hospital_Full.bak
│   ├── Hospital_Differential.bak
│   └── Hospital_TransactionLog.trn
├── CSV_Files/
│   ├── DoctorData.csv
│   ├── PatientData.csv
│   ├── AppointmentData.csv
│   ├── BillingData.csv
│   ├── ServiceData.csv
│   ├── ServiceDepartmentData.csv
│   └── PatientRecordData.csv
├── SQL_Scripts/
│   ├── Create_Tables.sql
│   ├── Insert_Data.sql
│   ├── Backup_And_Recovery_Tasks.sql
│   └── FK_Additions.sql
├── Screenshots/
│   ├── FullBackup.png
│   ├── DifferentialBackup.png
│   ├── LogBackup.png
│   ├── Disaster_Simulation.png
│   ├── Restore_Steps.png
│   └── Recovery_Verification.png
├── Hospital_ER_Model.png
```

## 🛠️ What This Project Covers

✅ Created normalized tables across multiple schemas (`Patient`, `Hospital`)  
✅ Populated realistic mock data using the SQL Server Import Wizard  
✅ Established foreign key constraints to model relationships  
✅ Standardized services and linked them to departments with associative entities  
✅ Simulated real-world scenarios: walk-ins, emergency visits, appointment-based services  
✅ Performed **Full**, **Differential**, and **Transaction Log** backups  
✅ Simulated a **disaster** by dropping a critical table  
✅ Successfully **restored** the entire database using backup chain  
✅ Tracked patient activity in a centralized `Patient_Record` table  

## 🔁 Recovery Simulation Workflow

1. **Full Backup**  
2. Inserted additional records  
3. **Differential Backup**  
4. Inserted additional billing records  
5. **Transaction Log Backup**  
6. Dropped `Patient.Appointment` table to simulate disaster  
7. Restored:
   - `Hospital_Full.bak` → `WITH NORECOVERY`
   - `Hospital_Differential.bak` → `WITH NORECOVERY`
   - `Hospital_TransactionLog.trn` → `WITH RECOVERY`
8. Database fully restored and validated

## 🧠 Key Concepts Practiced

- Schema Design & Normalization  
- Importing data using SQL Server Import Wizard  
- Foreign Key Enforcement  
- Real-world billing and service modeling  
- Backup Strategy & Restore Planning  
- Handling NULLs and default values  
- SQL Server `WITH RECOVERY`, `WITH NORECOVERY`, and `WITH REPLACE` clauses  
- Managing file paths and SQL Server service permissions

## 🖼️ ER Diagram

> See `Hospital_ER_Model.png` in the root folder for the complete schema overview.
