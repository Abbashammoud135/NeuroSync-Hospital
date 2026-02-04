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
