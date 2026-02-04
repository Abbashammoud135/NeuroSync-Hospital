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

