-- Combined Hospital SQL - All scripts concatenated
-- Source files: hospital_DDL.sql, hospital_BusinessRules.sql, hospital_Functions.sql,
-- hospital_Triggers.sql, hospital_Views.sql, hospital_storedProcedures.sql,
-- hospital_seeds.sql, hospital_security.sql, hospital_Transaction.sql, Query.sql

/* ==========================
   hospital_DDL.sql
   ========================== */
-- Hospital
CREATE TABLE Hospital (
    hospital_id INT IDENTITY(1,1) PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    address VARCHAR(250) NOT NULL,
    phone VARCHAR(20) NOT NULL
);

-- Department
CREATE TABLE Department (
    department_id INT IDENTITY(1,1) PRIMARY KEY,
    hospital_id INT NOT NULL,
    name VARCHAR(100) NOT NULL,
    type VARCHAR(50),
    floor_number INT,
    CONSTRAINT fk_department_hospital FOREIGN KEY (hospital_id) REFERENCES Hospital(hospital_id)
);

-- Role
CREATE TABLE Role (
    role_id INT IDENTITY(1,1) PRIMARY KEY,
    role_name VARCHAR(50) NOT NULL,
    description VARCHAR(200)
);

-- Person (Base)
CREATE TABLE Person (
    person_id INT IDENTITY(1,1) PRIMARY KEY,
    full_name VARCHAR(120) NOT NULL,
    date_of_birth DATE,
    gender CHAR(1),
    email VARCHAR(120) UNIQUE,
    phone VARCHAR(30) UNIQUE,
    role_id INT NOT NULL,
    department_id INT,
    windows_login VARCHAR(100) UNIQUE,
    CONSTRAINT fk_person_role FOREIGN KEY (role_id) REFERENCES Role(role_id),
    CONSTRAINT fk_person_department FOREIGN KEY (department_id) REFERENCES Department(department_id)
);

-- Patient
CREATE TABLE Patient (
    patient_id INT PRIMARY KEY,
    national_id VARCHAR(20) UNIQUE,
    blood_type CHAR(3),
    allergies NVARCHAR(MAX),
    emergency_contact_name VARCHAR(100),
    emergency_contact_phone VARCHAR(30),
    CONSTRAINT fk_patient_person FOREIGN KEY (patient_id) REFERENCES Person(person_id)
);

-- Doctor
CREATE TABLE Doctor (
    doctor_id INT PRIMARY KEY,
    license_number VARCHAR(50) UNIQUE,
    specialization VARCHAR(100),
    working_hours VARCHAR(100),
    active_status BIT DEFAULT 1,
    CONSTRAINT fk_doctor_person FOREIGN KEY (doctor_id) REFERENCES Person(person_id)
);

-- Nurse
CREATE TABLE Nurse (
    nurse_id INT PRIMARY KEY,
    certification_level VARCHAR(50),
    shift_schedule VARCHAR(100),
    active_status BIT DEFAULT 1,
    CONSTRAINT fk_nurse_person FOREIGN KEY (nurse_id) REFERENCES Person(person_id)
);

-- Appointment
CREATE TABLE Appointment (
    appointment_id INT IDENTITY(1,1) PRIMARY KEY,
    patient_id INT NOT NULL,
    doctor_id INT NOT NULL,
    department_id INT NOT NULL,
    appointment_datetime DATETIME NOT NULL,
    status VARCHAR(50) NOT NULL,
    notes NVARCHAR(MAX),
    CONSTRAINT fk_appointment_patient FOREIGN KEY (patient_id) REFERENCES Patient(patient_id),
    CONSTRAINT fk_appointment_doctor FOREIGN KEY (doctor_id) REFERENCES Doctor(doctor_id),
    CONSTRAINT fk_appointment_department FOREIGN KEY (department_id) REFERENCES Department(department_id)
);

-- Admission
CREATE TABLE Admission (
    admission_id INT IDENTITY(1,1) PRIMARY KEY,
    patient_id INT NOT NULL,
    department_id INT NOT NULL,
    admission_date DATETIME NOT NULL,
    discharge_date DATETIME NULL,
    room_number VARCHAR(10),
    bed_number VARCHAR(10),
    status VARCHAR(50),
    CONSTRAINT fk_admission_patient FOREIGN KEY (patient_id) REFERENCES Patient(patient_id),
    CONSTRAINT fk_admission_department FOREIGN KEY (department_id) REFERENCES Department(department_id)
);

-- Encounter
CREATE TABLE Encounter (
    encounter_id INT IDENTITY(1,1) PRIMARY KEY,
    patient_id INT NOT NULL,
    doctor_id INT NOT NULL,
    department_id INT NOT NULL,
    encounter_datetime DATETIME NOT NULL,
    encounter_type VARCHAR(50),
    notes NVARCHAR(MAX),
    CONSTRAINT fk_encounter_patient FOREIGN KEY (patient_id) REFERENCES Patient(patient_id),
    CONSTRAINT fk_encounter_doctor FOREIGN KEY (doctor_id) REFERENCES Doctor(doctor_id),
    CONSTRAINT fk_encounter_department FOREIGN KEY (department_id) REFERENCES Department(department_id)
);

-- Diagnosis
CREATE TABLE Diagnosis (
    diagnosis_id INT IDENTITY(1,1) PRIMARY KEY,
    encounter_id INT NOT NULL,
    diagnosis_code VARCHAR(20),
    description VARCHAR(250),
    severity VARCHAR(50),
    CONSTRAINT fk_diagnosis_encounter FOREIGN KEY (encounter_id) REFERENCES Encounter(encounter_id)
);

-- Prescription
CREATE TABLE Prescription (
    prescription_id INT IDENTITY(1,1) PRIMARY KEY,
    diagnosis_id INT NOT NULL,
    medication_name VARCHAR(100),
    dosage VARCHAR(50),
    frequency VARCHAR(50),
    duration VARCHAR(50),
    instructions NVARCHAR(MAX),
    CONSTRAINT fk_prescription_diagnosis FOREIGN KEY (diagnosis_id) REFERENCES Diagnosis(diagnosis_id)
);

-- Laboratory_Test
CREATE TABLE Laboratory_Test (
    lab_test_id INT IDENTITY(1,1) PRIMARY KEY,
    encounter_id INT NOT NULL,
    test_type VARCHAR(100),
    ordered_by INT NOT NULL,
    status VARCHAR(50),
    results_reference NVARCHAR(MAX),
    CONSTRAINT fk_lab_encounter FOREIGN KEY (encounter_id) REFERENCES Encounter(encounter_id),
    CONSTRAINT fk_lab_doctor FOREIGN KEY (ordered_by) REFERENCES Doctor(doctor_id)
);

-- Billing
CREATE TABLE Billing (
    billing_id INT IDENTITY(1,1) PRIMARY KEY,
    patient_id INT NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL CHECK(total_amount >=0),
    billing_date DATETIME NOT NULL,
    status VARCHAR(50),
    breakdown NVARCHAR(MAX),
    CONSTRAINT fk_billing_patient FOREIGN KEY (patient_id) REFERENCES Patient(patient_id)
);

-- Payment
CREATE TABLE Payment (
    payment_id INT IDENTITY(1,1) PRIMARY KEY,
    billing_id INT NOT NULL,
    amount DECIMAL(10,2) NOT NULL CHECK(amount > 0),
    payment_method VARCHAR(50),
    payment_date DATETIME NOT NULL,
    CONSTRAINT fk_payment_billing FOREIGN KEY (billing_id) REFERENCES Billing(billing_id)
);

-- Audit_Log
CREATE TABLE Audit_Log (
    audit_id INT IDENTITY(1,1) PRIMARY KEY,
    entity_name VARCHAR(100),
    entity_id INT,
    action_type VARCHAR(50),
    /* Lines 174-176 omitted */
    CONSTRAINT fk_audit_person FOREIGN KEY (performed_by) REFERENCES Person(person_id)
);

-- Room Table
CREATE TABLE Room (
    room_id INT IDENTITY(1,1) PRIMARY KEY,
    /* Lines 182-187 omitted */
    CONSTRAINT fk_room_department FOREIGN KEY (department_id) REFERENCES Department(department_id)
);

-- Bed Table
CREATE TABLE Bed (
    bed_id INT IDENTITY(1,1) PRIMARY KEY,
    /* Lines 193-196 omitted */
    CONSTRAINT fk_bed_room FOREIGN KEY (room_id) REFERENCES Room(room_id)
);

-- Update Admission to use Bed
ALTER TABLE Admission
DROP COLUMN room_number, bed_number;


ALTER TABLE Admission
ADD bed_id INT NULL,
CONSTRAINT fk_admission_bed FOREIGN KEY (bed_id) REFERENCES Bed(bed_id);

-- Insurance Table
CREATE TABLE Insurance (
    insurance_id INT IDENTITY(1,1) PRIMARY KEY,
    /* Lines 211-215 omitted */
    CONSTRAINT fk_insurance_patient FOREIGN KEY (patient_id) REFERENCES Patient(patient_id)
);

-- Department Staff Table
CREATE TABLE Department_Staff (
    staff_id INT IDENTITY(1,1) PRIMARY KEY,
    /* Lines 221-228 omitted */
    CONSTRAINT fk_staff_role FOREIGN KEY (role_id) REFERENCES Role(role_id)
);

CREATE TABLE Emergency_Triage (
    triage_id INT IDENTITY PRIMARY KEY,
);


/* ==========================
   hospital_BusinessRules.sql
   ========================== */
ALTER TABLE Patient
ADD CONSTRAINT chk_BloodType CHECK (blood_type IN ('A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'));

ALTER TABLE Billing
ADD CONSTRAINT chk_BillingStatus CHECK (status IN ('Pending','Paid','Cancelled'));

ALTER TABLE Department
ADD CONSTRAINT chk_FloorNumber CHECK(floor_number >= 0);

ALTER TABLE Appointment
DROP CONSTRAINT fk_appointment_patient;
GO
ALTER TABLE Appointment
ADD CONSTRAINT fk_appointment_patient
FOREIGN KEY (patient_id)
REFERENCES Patient(patient_id)
ON DELETE CASCADE;
GO

ALTER TABLE Appointment
ADD CONSTRAINT chk_appointment_status
CHECK (status IN ('Scheduled','Completed','Canceled'));

ALTER TABLE Admission
ADD CONSTRAINT chk_admission_status
CHECK (status IN ('Admitted','Discharged'));

ALTER TABLE Bed
ADD CONSTRAINT chk_bed_status
CHECK (status IN ('Available','Occupied'));


/* ==========================
   hospital_Functions.sql
   ========================== */
CREATE FUNCTION fn_CalculateAge (@dob DATE)
RETURNS INT
AS
BEGIN
    RETURN DATEDIFF(YEAR, @dob, GETDATE())
           - CASE
               WHEN MONTH(@dob) > MONTH(GETDATE())
                 OR (MONTH(@dob) = MONTH(GETDATE()) AND DAY(@dob) > DAY(GETDATE()))
               THEN 1 ELSE 0
             END
END;
Go
CREATE FUNCTION fn_IsBedAvailable (@bed_id INT)
RETURNS BIT
AS
BEGIN
    DECLARE @status VARCHAR(50)

    SELECT @status = status FROM Bed WHERE bed_id = @bed_id

    RETURN CASE WHEN @status = 'Available' THEN 1 ELSE 0 END
END;
Go

CREATE FUNCTION fn_CalculateTotalBillingAmount(@base_amount DECIMAL(10,2), @insurance_coverage DECIMAL(5,2))
RETURNS DECIMAL(10,2)
AS
BEGIN
    RETURN @base_amount - (@base_amount * (@insurance_coverage / 100))
END;
Go

CREATE FUNCTION fn_ValidateDoctorDepartment(@doctor_id INT, @department_id INT)
RETURNS BIT
AS
BEGIN
    IF EXISTS (
        SELECT 1 FROM Department_Staff
        WHERE person_id = @doctor_id AND department_id = @department_id
    )
        RETURN 1
    RETURN 0
END;
Go

CREATE FUNCTION fn_PreparePatientAIProfile (@patient_id INT)
RETURNS NVARCHAR(MAX)
AS
BEGIN
    DECLARE @profile NVARCHAR(MAX)
    SELECT @profile = CONCAT(
        'Age:', dbo.fn_CalculateAge(per.date_of_birth), '; ',
        'Gender:', per.gender, '; ',
        'BloodType:', p.blood_type, '; ',
        'Allergies:', p.allergies
    )
    FROM Patient p
    JOIN Person per ON p.patient_id = per.person_id
    WHERE p.patient_id = @patient_id
    RETURN @profile
END;
CREATE FUNCTION fn_PreparePatientAIProfile_JSON (@patient_id INT)
RETURNS NVARCHAR(MAX)
AS
BEGIN
    RETURN (
        SELECT
            dbo.fn_CalculateAge(per.date_of_birth) AS age,
            per.gender,
            p.blood_type,
            p.allergies
        FROM Patient p
        JOIN Person per ON p.patient_id = per.person_id
        WHERE p.patient_id = @patient_id
        FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
    );
END;

CREATE FUNCTION dbo.fn_GetTriageLevel
(
    @EncounterID INT
)
RETURNS VARCHAR(20)
AS
BEGIN
    DECLARE @TriageLevel VARCHAR(20);

    SELECT @TriageLevel = triage_level
    FROM Emergency_Triage
    WHERE encounter_id = @EncounterID;

    RETURN @TriageLevel;
END;


/* ==========================
   hospital_Triggers.sql
   ========================== */
CREATE TRIGGER trg_BedOccupied
ON Admission
AFTER INSERT
AS
BEGIN
    UPDATE Bed
    SET status = 'Occupied'
    WHERE bed_id IN (SELECT bed_id FROM inserted)
END;

Go
CREATE TRIGGER trg_BedReleased
ON Admission
AFTER UPDATE
AS
BEGIN
    IF UPDATE(discharge_date)
    BEGIN
        UPDATE Bed
        SET status = 'Available'
        WHERE bed_id IN (
            SELECT bed_id
            FROM inserted
            WHERE discharge_date IS NOT NULL
        )
    END
END;
Go

CREATE TRIGGER trg_AuditPatient
ON Patient
AFTER UPDATE
AS
BEGIN
    INSERT INTO Audit_Log (entity_name, entity_id, action_type, performed_by, performed_at)
    SELECT
        'Patient',
        i.patient_id,
        'UPDATE',
        ISNULL(p.person_id, 1),  -- map SYSTEM_USER to person_id
        GETDATE()
    FROM inserted i
    LEFT JOIN Person p ON p.windows_login = SYSTEM_USER
END;
Go
-- It prevents appointments from being created if the doctor does not belong to the selected department.
CREATE TRIGGER trg_ValidateDoctorDepartment
ON Appointment
INSTEAD OF INSERT
AS
BEGIN
    -- Validate
    IF EXISTS (
        SELECT 1
        FROM inserted i
        WHERE dbo.fn_ValidateDoctorDepartment(i.doctor_id, i.department_id) = 0
    )
    BEGIN
        THROW 50010, 'Doctor not assigned to this department', 1;
    END

    -- Insert explicitly (safe column list)
    INSERT INTO Appointment
    (
        patient_id,
        doctor_id,
        department_id,
        appointment_datetime,
        status,
        notes
    )
    SELECT
        patient_id,
        doctor_id,
        department_id,
        appointment_datetime,
        status,
        notes
    FROM inserted;
END;
Go
-- If a patient is triaged as Red, automatically admit them to the hospital (if not already admitted).
CREATE TRIGGER trg_RedTriageAutoAdmission
ON Emergency_Triage
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO Admission (patient_id, department_id, admission_date, status)
    SELECT 
        e.patient_id,
        e.department_id,
        GETDATE(),
        'Admitted'
    FROM inserted t
    JOIN Encounter e ON t.encounter_id = e.encounter_id
    WHERE t.triage_level = 'Red'
      AND NOT EXISTS (
          SELECT 1 FROM Admission a
          WHERE a.patient_id = e.patient_id
          AND a.status = 'Admitted'
      );
END;
GO
--Keeps triage notes in sync with encounter updates
CREATE TRIGGER trg_UpdateTriageNotes
ON Encounter
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE t
    SET t.notes = e.notes
    FROM Emergency_Triage t
    JOIN inserted i ON t.encounter_id = i.encounter_id
    JOIN Encounter e ON e.encounter_id = i.encounter_id
    WHERE t.triage_level IS NOT NULL;
END;
GO


/* ==========================
   hospital_Views.sql
   ========================== */
CREATE VIEW vw_PatientOverview AS
SELECT
    p.patient_id,
    per.full_name,
    per.gender,
    dbo.fn_CalculateAge(per.date_of_birth) AS age,
    p.blood_type,
    p.allergies,
    per.phone
FROM Patient p
JOIN Person per ON p.patient_id = per.person_id;
Go

CREATE VIEW vw_DoctorSchedule AS
SELECT
    d.doctor_id,
    per.full_name,
    a.appointment_datetime,
    a.status,
    dep.name AS department
FROM Appointment a
JOIN Doctor d ON a.doctor_id = d.doctor_id
JOIN Person per ON d.doctor_id = per.person_id
JOIN Department dep ON a.department_id = dep.department_id;

GO
CREATE VIEW vw_BillingSummary AS
SELECT
    b.billing_id,
    per.full_name AS patient_name,
    b.total_amount,
    b.status,
    b.billing_date
FROM Billing b
JOIN Patient p ON b.patient_id = p.patient_id
JOIN Person per ON p.patient_id = per.person_id;
GO

CREATE VIEW vw_AI_PatientDataset AS
SELECT
    p.patient_id,
    dbo.fn_PreparePatientAIProfile_JSON(p.patient_id) AS ai_profile,
    b.total_amount,
    COUNT(e.encounter_id) AS encounter_count
FROM Patient p
LEFT JOIN Billing b ON p.patient_id = b.patient_id
LEFT JOIN Encounter e ON p.patient_id = e.patient_id
GROUP BY p.patient_id, b.total_amount;
GO

--List all Emergency patients with triage
CREATE OR ALTER VIEW vw_EmergencyTriage AS
SELECT 
    per.full_name AS PatientName,
    p.patient_id,
    e.encounter_id,
    e.encounter_datetime,
    t.triage_level,
    t.notes AS TriageNotes,
    d.name AS Department
FROM Emergency_Triage t
JOIN Encounter e ON t.encounter_id = e.encounter_id
JOIN Patient p ON e.patient_id = p.patient_id
JOIN Person per ON p.patient_id = per.person_id
JOIN Department d ON e.department_id = d.department_id;

GO


/* ==========================
   hospital_storedProcedures.sql
   ========================== */
-- 1️⃣ Admit Patient
CREATE OR ALTER PROCEDURE sp_AdmitPatient
    @patient_id INT,
    @department_id INT,
    @bed_id INT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRANSACTION;
    BEGIN TRY
        -- 1️⃣ Validate bed availability
        IF NOT EXISTS (
            SELECT 1
            FROM Bed
            WHERE bed_id = @bed_id
              AND status = 'Available'
        )
        BEGIN
            THROW 50001, 'Selected bed is not available.', 1;
        END

        -- 2️⃣ Insert admission
        INSERT INTO Admission (patient_id, department_id, admission_date, bed_id, status)
        VALUES (@patient_id, @department_id, GETDATE(), @bed_id, 'Admitted');

        -- 3️⃣ Update bed status
        UPDATE Bed
        SET status = 'Occupied'
        WHERE bed_id = @bed_id;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW; -- rethrow exact error
    END CATCH
END;
GO


-- 2️⃣ Discharge Patient
CREATE PROCEDURE sp_DischargePatient
    @admission_id INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;
    BEGIN TRY
        DECLARE @bed_table TABLE (bed_id INT);

        UPDATE Admission
        SET status = 'Discharged', discharge_date = GETDATE()
        OUTPUT inserted.bed_id INTO @bed_table
        WHERE admission_id = @admission_id;

        UPDATE Bed
        SET status = 'Available'
        WHERE bed_id IN (SELECT bed_id FROM @bed_table);

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;
GO

-- 3️⃣ Schedule Appointment
CREATE PROCEDURE sp_ScheduleAppointment
    @patient_id INT,
    @doctor_id INT,
    @department_id INT,
    @appointment_datetime DATETIME
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO Appointment (patient_id, doctor_id, department_id, appointment_datetime, status)
    VALUES (@patient_id, @doctor_id, @department_id, @appointment_datetime, 'Scheduled');
END;
GO

-- 4️⃣ Generate Billing
CREATE PROCEDURE sp_GenerateBilling
    @patient_id INT,
    @total_amount DECIMAL(10,2),
    @breakdown NVARCHAR(MAX) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO Billing (patient_id, total_amount, billing_date, status, breakdown)
    VALUES (@patient_id, @total_amount, GETDATE(), 'Pending', @breakdown);
END;
GO

-- 5️⃣ Record Payment
CREATE PROCEDURE sp_RecordPayment
    @billing_id INT
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE Billing
    SET status = 'Paid', billing_date = GETDATE()
    WHERE billing_id = @billing_id;
END;
GO



/* ==========================
   hospital_seeds.sql
   ========================== */
-- 1️⃣ Hospital
INSERT INTO Hospital (name, address, phone) VALUES
('City General Hospital', '123 Main St, Metropolis', '555-0100');

-- 2️⃣ Department
INSERT INTO Department (hospital_id, name, type, floor_number) VALUES
(1, 'Cardiology', 'Medical', 2),
(1, 'Neurology', 'Medical', 3),
(1, 'Pediatrics', 'Medical', 1),
(1, 'Radiology', 'Diagnostic', 1),
(1, 'Emergency', 'Emergency', 0);

-- 3️⃣ Role
INSERT INTO Role (role_name, description) VALUES
('Patient', 'Hospital patient'),
('Doctor', 'Medical doctor'),
('Nurse', 'Registered nurse'),
('Receptionist', 'Front desk staff'),
('Admin', 'System administrator');

-- 4️⃣ Person
INSERT INTO Person (full_name, date_of_birth, gender, email, phone, role_id, department_id) VALUES
('Alice Smith', '1980-04-15', 'F', 'alice@example.com', '555-1001', 2, 1), -- Doctor
('Bob Jones', '1975-07-20', 'M', 'bob@example.com', '555-1002', 2, 2), -- Doctor
('Carol White', '1990-05-12', 'F', 'carol@example.com', '555-1003', 3, 1), -- Nurse
('Daniel Green', '1982-11-08', 'M', 'daniel@example.com', '555-1004', 3, 2), -- Nurse
('Emily Brown', '1995-09-01', 'F', 'emily@example.com', '555-1005', 4, NULL), -- Receptionist
('Frank Black', '2000-01-10', 'M', 'frank@example.com', '555-1006', 1, NULL), -- Patient
('Grace Lee', '1998-06-23', 'F', 'grace@example.com', '555-1007', 1, NULL), -- Patient
('Hannah Kim', '2001-02-14', 'F', 'hannah@example.com', '555-1008', 1, NULL), -- Patient
('Ian Scott', '1988-12-12', 'M', 'ian@example.com', '555-1009', 1, NULL); -- Patient

-- 5️⃣ Patient
INSERT INTO Patient (patient_id, national_id, blood_type, allergies, emergency_contact_name, emergency_contact_phone) VALUES
(6, 'NID1001', 'O+', 'Peanuts', 'Alice Smith', '555-1001'),
(7, 'NID1002', 'A-', 'None', 'Bob Jones', '555-1002'),
(8, 'NID1003', 'B+', 'Penicillin', 'Carol White', '555-1003'),
(9, 'NID1004', 'AB-', 'None', 'Daniel Green', '555-1004');

-- 6️⃣ Doctor
INSERT INTO Doctor (doctor_id, license_number, specialization, working_hours, active_status) VALUES
(1, 'LIC1001', 'Cardiologist', 'Mon-Fri 9:00-17:00', 1),
(2, 'LIC1002', 'Neurologist', 'Mon-Fri 10:00-18:00', 1);

-- 7️⃣ Nurse
INSERT INTO Nurse (nurse_id, certification_level, shift_schedule, active_status) VALUES
(3, 'RN', 'Day', 1),
(4, 'RN', 'Night', 1);

-- 8️⃣ Room
INSERT INTO Room (department_id, room_number, room_type, capacity, status) VALUES
(1, '201', 'ICU', 2, 'Available'),
(1, '202', 'General', 2, 'Available'),
(2, '301', 'General', 3, 'Available'),
(3, '101', 'Pediatrics', 2, 'Available'),
(5, 'ER1', 'Emergency', 1, 'Available');

-- 9️⃣ Bed
INSERT INTO Bed (room_id, bed_number, status) VALUES
(1, 'B1', 'Available'),
(1, 'B2', 'Available'),
(2, 'B1', 'Available'),
(2, 'B2', 'Available'),
(3, 'B1', 'Available'),
(3, 'B2', 'Available'),
(3, 'B3', 'Available'),
(4, 'B1', 'Available'),
(4, 'B2', 'Available'),
(5, 'B1', 'Available');

-- 10️⃣ Department Staff
INSERT INTO Department_Staff (person_id, department_id, role_id, start_date) VALUES
(1, 1, 2, '2020-01-01'),
(2, 2, 2, '2020-01-01'),
(3, 1, 3, '2021-01-01'),
(4, 2, 3, '2021-01-01');

-- 11️⃣ Admission
INSERT INTO Admission (patient_id, department_id, admission_date, bed_id, status) VALUES
(6, 1, GETDATE(), 1, 'Admitted'),
(7, 2, GETDATE(), 3, 'Admitted'),
(8, 3, GETDATE(), 7, 'Admitted');

-- 12️⃣ Appointment
INSERT INTO Appointment (patient_id, doctor_id, department_id, appointment_datetime, status, notes) VALUES
(6, 1, 1, DATEADD(DAY,1,GETDATE()), 'Scheduled', 'Initial checkup'),
(7, 2, 2, DATEADD(DAY,2,GETDATE()), 'Scheduled', 'Neurology consultation'),
(8, 1, 1, DATEADD(DAY,3,GETDATE()), 'Scheduled', 'Follow-up visit');

-- 13️⃣ Encounter
INSERT INTO Encounter (patient_id, doctor_id, department_id, encounter_datetime, encounter_type, notes) VALUES
(6, 1, 1, GETDATE(), 'Consultation', 'Chest pain'),
(7, 2, 2, GETDATE(), 'Consultation', 'Headache'),
(8, 1, 1, GETDATE(), 'Follow-up', 'Routine check');

-- 14️⃣ Diagnosis
INSERT INTO Diagnosis (encounter_id, diagnosis_code, description, severity) VALUES
(1, 'I20', 'Angina Pectoris', 'Moderate'),
(2, 'G44', 'Migraine', 'Mild'),
(3, 'Z00', 'Routine check', 'None');

-- 15️⃣ Prescription
INSERT INTO Prescription (diagnosis_id, medication_name, dosage, frequency, duration, instructions) VALUES
(1, 'Aspirin', '75mg', 'Once daily', '30 days', 'Take after meals'),
(2, 'Ibuprofen', '200mg', 'Twice daily', '7 days', 'After meals'),
(3, 'Vitamin D', '1000 IU', 'Once daily', '30 days', 'Any time');

-- 16️⃣ Laboratory Test
INSERT INTO Laboratory_Test (encounter_id, test_type, ordered_by, status, results_reference) VALUES
(1, 'Blood Test', 1, 'Pending', NULL),
(2, 'MRI', 2, 'Scheduled', NULL),
(3, 'Routine Blood', 1, 'Completed', 'LAB-REF-003');

-- 17️⃣ Billing
INSERT INTO Billing (patient_id, total_amount, billing_date, status, breakdown) VALUES
(6, 1200.00, GETDATE(), 'Pending', 'Consultation: 200, Lab: 1000'),
(7, 1500.00, GETDATE(), 'Pending', 'Consultation: 300, MRI: 1200'),
(8, 200.00, GETDATE(), 'Pending', 'Routine check');

-- 18️⃣ Payment
INSERT INTO Payment (billing_id, amount, payment_method, payment_date) VALUES
(1, 1200.00, 'Credit Card', GETDATE()),
(2, 500.00, 'Cash', GETDATE());

-- 19️⃣ Insurance
INSERT INTO Insurance (patient_id, provider_name, policy_number, coverage_details) VALUES
(6, 'HealthPlus', 'POL1001', 'Covers 80% of hospitalization costs'),
(7, 'MediCare', 'POL1002', 'Covers 70% of neurology services'),
(8, 'HealthSecure', 'POL1003', 'Covers routine checkups');

INSERT INTO Emergency_Triage (encounter_id, triage_level, notes)
VALUES
(1, 'Red', 'Severe chest pain, low blood pressure, suspected heart attack'),
(2, 'Yellow', 'High fever, dehydration, patient conscious and stable'),
(3, 'Green', 'Small laceration on hand, no active bleeding');


/* ==========================
   hospital_security.sql
   ========================== */
CREATE ROLE DoctorRole;
CREATE ROLE NurseRole;
CREATE ROLE AdminRole;
CREATE ROLE AIServiceRole;

GRANT SELECT ON vw_PatientOverview TO DoctorRole;
GRANT EXECUTE ON sp_AdmitPatient TO AdminRole;
GRANT SELECT ON vw_AI_PatientDataset TO AIServiceRole;


/* ==========================
   hospital_Transaction.sql
   ========================== */
DECLARE @patient_id INT = 6; -- example patient
DECLARE @department_id INT = 1; -- Cardiology
DECLARE @bed_id INT = 1; -- ICU Bed B1

BEGIN TRANSACTION;

BEGIN TRY
    -- 1️⃣ Check if bed is available
    IF NOT EXISTS (SELECT 1 FROM Bed WHERE bed_id = @bed_id AND status = 'Available')
    BEGIN
        THROW 50001, 'Selected bed is not available.', 1;
    END

    -- 2️⃣ Insert Admission
    INSERT INTO Admission (patient_id, department_id, admission_date, bed_id, status)
    VALUES (@patient_id, @department_id, GETDATE(), @bed_id, 'Admitted');

    -- 3️⃣ Update Bed status by trigger 


    COMMIT TRANSACTION;
    PRINT 'Patient admitted successfully.';

END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    PRINT 'Admission failed: ' + ERROR_MESSAGE();
END CATCH;


DECLARE @patient_id INT = 6;
DECLARE @amount DECIMAL(10,2) = 1200.00;
DECLARE @payment_method VARCHAR(50) = 'Credit Card';
DECLARE @billing_id INT;

BEGIN TRANSACTION;

BEGIN TRY
    -- 1️⃣ Insert Billing
    INSERT INTO Billing (patient_id, total_amount, billing_date, status, breakdown)
    VALUES (@patient_id, @amount, GETDATE(), 'Pending', 'Consultation + Lab');

    SET @billing_id = SCOPE_IDENTITY();

    -- 2️⃣ Insert Payment
    INSERT INTO Payment (billing_id, amount, payment_method, payment_date)
    VALUES (@billing_id, @amount, @payment_method, GETDATE());

    -- 3️⃣ Update Billing status
    UPDATE Billing
    SET status = 'Paid'
    WHERE billing_id = @billing_id;

    COMMIT TRANSACTION;
    PRINT 'Billing and payment completed successfully.';

END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    PRINT 'Billing/Payment failed: ' + ERROR_MESSAGE();
END CATCH;


/* ==========================
   Query.sql (placeholder)
   ========================== */
-- Add any ad-hoc queries here

-- End of combined file
