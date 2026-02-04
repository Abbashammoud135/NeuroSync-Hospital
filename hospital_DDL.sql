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
    performed_by INT NOT NULL,
    performed_at DATETIME NOT NULL,
    CONSTRAINT fk_audit_person FOREIGN KEY (performed_by) REFERENCES Person(person_id)
);

-- Room Table
CREATE TABLE Room (
    room_id INT IDENTITY(1,1) PRIMARY KEY,
    department_id INT NOT NULL,
    room_number VARCHAR(10) NOT NULL,
    room_type VARCHAR(50), -- ICU, General, Private
    capacity INT DEFAULT 1,
    status VARCHAR(50) DEFAULT 'Available',
    CONSTRAINT fk_room_department FOREIGN KEY (department_id) REFERENCES Department(department_id)
);

-- Bed Table
CREATE TABLE Bed (
    bed_id INT IDENTITY(1,1) PRIMARY KEY,
    room_id INT NOT NULL,
    bed_number VARCHAR(10) NOT NULL,
    status VARCHAR(50) DEFAULT 'Available',
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
    patient_id INT NOT NULL,
    provider_name VARCHAR(100),
    policy_number VARCHAR(50) UNIQUE,
    coverage_details NVARCHAR(MAX),
    CONSTRAINT fk_insurance_patient FOREIGN KEY (patient_id) REFERENCES Patient(patient_id)
);

-- Department Staff Table
CREATE TABLE Department_Staff (
    staff_id INT IDENTITY(1,1) PRIMARY KEY,
    person_id INT NOT NULL,
    department_id INT NOT NULL,
    role_id INT NOT NULL,
    start_date DATE,
    end_date DATE NULL,
    CONSTRAINT fk_staff_person FOREIGN KEY (person_id) REFERENCES Person(person_id),
    CONSTRAINT fk_staff_department FOREIGN KEY (department_id) REFERENCES Department(department_id),
    CONSTRAINT fk_staff_role FOREIGN KEY (role_id) REFERENCES Role(role_id)
);

CREATE TABLE Emergency_Triage (
    triage_id INT IDENTITY PRIMARY KEY,
    encounter_id INT NOT NULL,
    triage_level VARCHAR(20), -- Red, Yellow, Green
    notes NVARCHAR(MAX),
    CONSTRAINT fk_triage_encounter
        FOREIGN KEY (encounter_id) REFERENCES Encounter(encounter_id)
);
