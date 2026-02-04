--1️⃣ Patients – Overview & AI Profile
-- View all patients
SELECT * FROM vw_PatientOverview;

-- Get AI profile JSON for patient 8
SELECT dbo.fn_PreparePatientAIProfile_JSON(8) AS AI_Profile_JSON;

-- Get AI profile as text
SELECT dbo.fn_PreparePatientAIProfile(8) AS AI_Profile_Text;

--2️⃣ Doctors – Schedule & Department Validation
-- View doctor schedule
SELECT * FROM vw_DoctorSchedule;

-- Test function: is Doctor 1 assigned to Department 1?
SELECT dbo.fn_ValidateDoctorDepartment(1, 1) AS IsAssigned;  -- Expect 1
SELECT dbo.fn_ValidateDoctorDepartment(2, 1) AS IsAssigned;  -- Expect 0


--3️⃣ Appointments – Create / Validate Triggers
-- Try scheduling appointment (valid doctor-department)
DECLARE @apptDateTime DATETIME = DATEADD(DAY, 5, GETDATE());
EXEC sp_ScheduleAppointment 
    @patient_id = 9, 
    @doctor_id = 1, 
    @department_id = 1, 
    @appointment_datetime = @apptDateTime;

-- Try invalid appointment (doctor not in department) → triggers error
EXEC sp_ScheduleAppointment 
    @patient_id = 9, 
    @doctor_id = 2, 
    @department_id = 1, 
    @appointment_datetime = @apptDateTime;
-- View all appointments


SELECT * FROM Appointment;
--4️⃣ Admissions – Bed Availability & Trigger
-- Admit patient 9 to Department 1, Bed 10
EXEC sp_AdmitPatient @patient_id=9, @department_id=1, @bed_id=10;

-- Check Admission and Bed status
SELECT * FROM Admission WHERE patient_id=9;
SELECT * FROM Bed WHERE bed_id=10;
-- Discharge patient 9
DECLARE @admission_id INT;
SELECT TOP 1 @admission_id = admission_id FROM Admission WHERE patient_id=9 AND status='Admitted' ;

EXEC sp_DischargePatient @admission_id=@admission_id;
select * from Admission where admission_id=@admission_id;
-- Verify Bed becomes Available
SELECT * FROM Bed WHERE bed_id=10;


--5️⃣ Billing & Payment
-- Generate a new billing for patient 9
EXEC sp_GenerateBilling @patient_id=9, @total_amount=500.00, @breakdown='Consultation + Labs';
SELECT * FROM vw_BillingSummary WHERE patient_name IN ('Ian Scott');--billing date is the date the billing was created/Generated

-- Pay the billing
DECLARE @bill_id INT = (SELECT TOP 1 billing_id FROM Billing WHERE patient_id=9 ORDER BY billing_date DESC);
EXEC sp_RecordPayment @billing_id=@bill_id;

-- View Billing summary
SELECT * FROM vw_BillingSummary WHERE patient_name IN ('Ian Scott');


--6️⃣ Emergency Triage & Auto Admission
-- Insert a Red triage (should auto-admit patient 9)
DECLARE @admission_id INT;
SELECT TOP 1 @admission_id = admission_id FROM Admission WHERE patient_id=8 AND status='Admitted' ;

EXEC sp_DischargePatient @admission_id=@admission_id;
INSERT INTO Emergency_Triage (encounter_id, triage_level, notes)
VALUES (3, 'Red', 'Critical condition');
select TOP 1 * from Emergency_Triage where encounter_id=3;
SELECT * from Patient;
SELECT * from Encounter;
-- Check automatic admission triggered
SELECT * FROM Admission ; -- patient_id=8 had encounter 3


--7️⃣ AI Patient Dataset
-- View AI-ready dataset for analytics
SELECT * FROM vw_AI_PatientDataset;

--8️⃣ Audit Log – Track Changes
-- Update patient to trigger audit
UPDATE Patient SET allergies='Peanuts, Shellfish' WHERE patient_id=6;

-- Check audit log
SELECT * FROM Audit_Log WHERE entity_name='Patient' ORDER BY performed_at DESC;

--9️⃣ Laboratory Tests & Diagnosis
-- View lab tests
SELECT * FROM Laboratory_Test;

-- View diagnosis with prescriptions
SELECT d.diagnosis_id, d.description, d.severity, p.medication_name
FROM Diagnosis d
JOIN Prescription p ON d.diagnosis_id = p.diagnosis_id;

