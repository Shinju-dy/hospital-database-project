--CREATING FULL BACKUP
BACKUP DATABASE HOSPITAL
TO DISK = 'C:\Users\User\Desktop\DB_Admin\HospitalProject\Backups\Hospital_Full.bak'
WITH FORMAT, INIT, NAME = 'HOSPITAL_FULL_BACKUP';

--INSERTING NEW RECORDS
INSERT INTO Patient.Appointment (
    Patient_Id, Doctor_Id, Appointment_Date, Reason, 
    Appointment_Status, Cancellation_Reason, Notes
)
VALUES
(3, 1, '2025-05-02', 'Headache', 'Scheduled', NULL, 'Auto-generated for backup sim'),
(1, 4, '2025-05-03', 'Fever', 'Completed', NULL, 'Auto-generated for backup sim'),
(4, 2, '2025-05-04', 'Abdominal Pain', 'Cancelled', 'Patient Request', 'Auto-generated for backup sim'),
(2, 3, '2025-05-05', 'Routine Checkup', 'Scheduled', NULL, 'Auto-generated for backup sim'),
(5, 5, '2025-05-06', 'Follow-up', 'Cancelled', 'Emergency Conflict', 'Auto-generated for backup sim');

-- Appointment-based billing records
INSERT INTO Hospital.Billing (
    Patient_Id, Appointment_Id, Department_Id, Service_Department_Id,
    Created_Date, Payment_Status, Payment_Method, Payment_Date, Visit_Type
)
VALUES 
(3, 31, 1, 12, '2025-05-02', 'Paid', 'Cash', '2025-05-03', 'Appointment'),
(1, 32, 2, 7, '2025-05-03', 'Pending', 'Card', '2025-05-04', 'Appointment'),
(4, 33, 3, 15, '2025-05-04', 'Paid', 'Insurance', '2025-05-05', 'Appointment'),
(2, 34, 4, 2, '2025-05-05', 'Pending', 'Mobile Money', '2025-05-06', 'Appointment'),
(5, 35, 5, 20, '2025-05-06', 'Paid', 'Card', '2025-05-07', 'Appointment');

-- Walk-in and Emergency billing records (no Appointment_Id)
INSERT INTO Hospital.Billing (
    Patient_Id, Appointment_Id, Department_Id, Service_Department_Id,
    Created_Date, Payment_Status, Payment_Method, Payment_Date, Visit_Type
)
VALUES 
(1, NULL, 6, 10, '2025-05-02', 'Paid', 'Cash', '2025-05-02', 'Walk-In'),
(2, NULL, 7, 19, '2025-05-02', 'Pending', 'Insurance', '2025-05-02', 'Emergency'),
(3, NULL, 8, 24, '2025-05-02', 'Paid', 'Card', '2025-05-02', 'Walk-In'),
(4, NULL, 9, 8, '2025-05-02', 'Pending', 'Cash', '2025-05-02', 'Emergency'),
(5, NULL, 10, 6, '2025-05-02', 'Paid', 'Mobile Money', '2025-05-02', 'Walk-In');

--CREATING A DIFFERENTIAL BACKUP
BACKUP DATABASE HOSPITAL
TO DISK = 'C:\Users\User\Desktop\DB_Admin\HospitalProject\Backups\Hospital_Differential.bak'
WITH DIFFERENTIAL,
STATS = 10,
INIT, NAME ='Hospital_Differential_Backup' ;


-- INSERTING ONE LAST RECORD 
-- Insert a new walk-in billing record
INSERT INTO Hospital.Billing (
    Patient_Id, Appointment_Id, Service_Department_Id,
    Created_Date, Payment_Status, Payment_Method, Payment_Date, Visit_Type
)
VALUES ( 3, NULL, 10, GETDATE(), 'Pending', 'Cash', GETDATE(), 'Walk-In');

--CHANGING MY RECOVERY MODEL TO A FULL MODEL SO I CAN CONDUT A LOG BACKUP
ALTER DATABASE Hospital SET RECOVERY FULL;
--CREATING TRANSACTIONAL LOG BACKUP
BACKUP LOG Hospital
TO DISK = 'C:\Users\User\Desktop\DB_Admin\HospitalProject\Backups\Hospital_TransactionLog.trn'
WITH INIT,
     NAME = 'Hospital Transaction Log Backup',
     SKIP,
     STATS = 10;

-- DROPING FK CONSTRAINTS
ALTER TABLE Hospital.Billing DROP CONSTRAINT FK__Billing__Appoint__4BAC3F29;
ALTER TABLE Patient.Appointment DROP CONSTRAINT FK__Appointme__Docto__46E78A0C;
ALTER TABLE Patient.Appointment DROP CONSTRAINT FK__Appointme__Patie__45F365D3;

-- DROPING THE APPOINTMENT TABLE
DROP TABLE Patient.Appointment;

SELECT * FROM Patient.Appointment;


--RESTORE
--FULL BACKUP
RESTORE DATABASE Hospital
FROM DISK = 'C:\Users\User\Desktop\DB_Admin\HospitalProject\Backups\Hospital_Full.bak'
WITH NORECOVERY, REPLACE;

--DIFFERENTIAL BACKUP
RESTORE DATABASE Hospital
FROM DISK = 'C:\Users\User\Desktop\DB_Admin\HospitalProject\Backups\Hospital_Differential.bak'
WITH NORECOVERY;

--LOG BACKUP
RESTORE LOG Hospital
FROM DISK = 'C:\Users\User\Desktop\DB_Admin\HospitalProject\Backups\Hospital_TransactionLog.trn'
WITH RECOVERY;


--CHECK HOSPITAL DB HAS FULLY RESTORED AND IS ONLINE
SELECT name, state_desc, recovery_model_desc
FROM sys.databases
WHERE name = 'Hospital';


--VERIFY IF RESTORE WORKED
SELECT  * FROM Patient.Appointment;
