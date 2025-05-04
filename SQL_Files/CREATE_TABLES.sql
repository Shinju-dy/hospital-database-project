CREATE DATABASE Hospital;
GO

USE Hospital;
GO

CREATE SCHEMA Hospital;
GO

CREATE SCHEMA Patient;
GO

CREATE TABLE Hospital.Address(
	Address_Id INT IDENTITY(1,1) PRIMARY KEY,
	Region NVARCHAR (50) NOT NULL, 
	Digital_Address NVARCHAR (50) NOT NULL,
	Town NVARCHAR (100) NOT NULL,
	Street NVARCHAR (100)
	);

CREATE TABLE Hospital.Department(
	Department_Id INT IDENTITY(1,1) PRIMARY KEY,
	Department_Name NVARCHAR (100) NOT NULL,
	Department_Description NVARCHAR (255) NOT NULL
	);

CREATE TABLE Hospital.Service(
	Service_Id INT IDENTITY(1,1) PRIMARY KEY,
	Service_Name NVARCHAR (50) NOT NULL UNIQUE,
	); 

CREATE TABLE Hospital.Service_Department (
    Service_Department_Id INT IDENTITY(1,1) PRIMARY KEY,
    Service_Id INT NOT NULL FOREIGN KEY REFERENCES Hospital.Service(Service_Id),
    Department_Id INT NOT NULL FOREIGN KEY REFERENCES Hospital.Department(Department_Id),
    Standard_Charge DECIMAL(10,2) NOT NULL
);


CREATE TABLE Hospital.Doctor(
	Doctor_Id INT IDENTITY(1,1) PRIMARY KEY,
	First_Name NVARCHAR(50) NOT NULL,
	Last_Name NVARCHAR(50) NOT NULL,
	Other_Names NVARCHAR(100) NULL,
	Speciality NVARCHAR(100) NOT NULL,
	DOB DATE NOT NULL,
	Gender NVARCHAR(20) NOT NULL,
	Phone_Number NVARCHAR(20) NOT NULL,
	Email NVARCHAR(100) NOT NULL,
	Date_Joined Date NOT NULL DEFAULT GETDATE(),
	Id_Name NVARCHAR(100) NOT NULL,
	Id_Number NVARCHAR(20) NOT NULL,
	Emergency_Contact_name NVARCHAR(100) NOT NULL,
	Emergency_Contact NVARCHAR(20) NOT NULL,
	Department_Id INT NOT NULL FOREIGN KEY REFERENCES Hospital.Department(Department_id),
	Address_Id INT NOT NULL FOREIGN KEY REFERENCES Hospital.Address(Address_id),

	CONSTRAINT CK_Doctor_Gender CHECK (Gender IN ('Male','Female', 'Other'))
	);


CREATE TABLE Patient.Patient(
	Patient_Id INT IDENTITY(1,1) PRIMARY KEY,
	First_Name NVARCHAR(50) NOT NULL,
	Last_Name NVARCHAR(50) NOT NULL,
	Other_Names NVARCHAR(100) NULL,
	DOB DATE NOT NULL,
	Gender NVARCHAR(20) NOT NULL,
	Phone_Number NVARCHAR(20) NOT NULL,
	Email NVARCHAR(100) NOT NULL,
	Date_Created Date NOT NULL DEFAULT GETDATE(),
	Id_Name NVARCHAR(100) NOT NULL,
	Id_Number NVARCHAR(20) NOT NULL,
	Emergency_Contact_Name NVARCHAR(100) NOT NULL,
	Emergency_Contact NVARCHAR(20) NOT NULL,
	Address_id INT NOT NULL FOREIGN KEY REFERENCES Hospital.Address(Address_id),

	CONSTRAINT CK_Patient_Gender CHECK (Gender IN ('Male','Female', 'Other'))
	);


CREATE TABLE Patient.Appointment(
	Appointment_Id INT IDENTITY(1,1) PRIMARY KEY,
	Patient_Id INT NOT NULL FOREIGN KEY REFERENCES Patient.Patient(Patient_id),
	Doctor_Id INT NOT NULL FOREIGN KEY REFERENCES Hospital.Doctor(Doctor_id),
	Appointment_Date DATE NOT NULL,
	Reason NVARCHAR(255) NULL,
	Appointment_Status NVARCHAR(20) NOT NULL,
	Cancellation_Reason NVARCHAR(100) NULL,
	Notes NVARCHAR(100) NOT NULL,
	CONSTRAINT CK_Apointment_Status CHECK(Appointment_status IN ('Scheduled', 'Completed', 'Cancelled'))
	);


CREATE TABLE Patient.Patient_Record (
    Record_Id INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
    Patient_Id INT NOT NULL FOREIGN KEY REFERENCES Patient.Patient(Patient_Id),
    Appointment_Id INT NULL FOREIGN KEY REFERENCES Patient.Appointment(Appointment_Id),
	Service_Department_Id INT NOT NULL FOREIGN KEY REFERENCES Hospital.Service_Department(Service_Department_Id),
    Visit_Type VARCHAR(20) NOT NULL CHECK (Visit_Type IN ('Appointment', 'Emergency', 'Walk-In')),
    Visit_Date DATE NOT NULL,
    Diagnosis NVARCHAR(100) NOT NULL,
    Treatment NVARCHAR(100) NOT NULL,
    Notes NVARCHAR(200) NULL
);


CREATE TABLE Hospital.Billing(
	Billing_Id INT IDENTITY(1,1) PRIMARY KEY,
	Patient_Id INT NOT NULL FOREIGN KEY REFERENCES Patient.Patient(Patient_id),
	Appointment_Id INT NULL FOREIGN KEY REFERENCES Patient.Appointment(Appointment_id),
	Vist_Type NVARCHAR(50) NOT NULL DEFAULT 'Walk-In',
	Created_Date Date NOT NULL DEFAULT GETDATE(),
	Payment_Status NVARCHAR(20) NOT NULL,
	Payment_Method NVARCHAR(20) NOT NULL,
	Payment_Date Date NOT NULL DEFAULT GETDATE(),
	Service_Department_Id INT NOT NULL FOREIGN KEY REFERENCES Service_Department.Service_Department(Service_Department_Id),
	CONSTRAINT CK_Visit_Type CHECK(Visit_Type IN('Walk-In', 'Appointment', 'Emergency')),
	CONSTRAINT CK_Billing_Status CHECK(Payment_Status IN ('Paid', 'Pending', 'Overdue')),
	CONSTRAINT CK_Billing_Payment_Method CHECK(Payment_Method IN ('Cash', 'Card', 'Insurance', 'Mobile Money'))
);





