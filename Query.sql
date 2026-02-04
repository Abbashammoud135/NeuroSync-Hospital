-- SELECT * FROM vw_PatientOverview;
-- --2️⃣ Doctors – Schedule & Department Validation
-- -- View doctor schedule
-- SELECT * FROM vw_DoctorSchedule;

-- -- Test function: is Doctor 1 assigned to Department 1?
-- SELECT dbo.fn_ValidateDoctorDepartment(1, 1) AS IsAssigned;  -- Expect 1
-- SELECT dbo.fn_ValidateDoctorDepartment(2, 1) AS IsAssigned;  -- Expect 0

-- DECLARE @apptDateTime DATETIME = DATEADD(DAY, 5, GETDATE());
-- EXEC sp_ScheduleAppointment 
--     @patient_id = 9, 
--     @doctor_id = 1, 
--     @department_id = 1, 
--     @appointment_datetime = @apptDateTime;

-- -- Try invalid appointment (doctor not in department) → triggers error
-- EXEC sp_ScheduleAppointment 
--     @patient_id = 9, 
--     @doctor_id = 2, 
--     @department_id = 1, 
--     @appointment_datetime = @apptDateTime;

-- select * from Patient where patient_id=6;
-- UPDATE Patient SET allergies='Peanuts, Shellfish' WHERE patient_id=6;
-- SELECT * FROM Audit_Log WHERE entity_name='Patient' ORDER BY performed_at DESC;

SELECT d.diagnosis_id, d.description, d.severity, p.medication_name
FROM Diagnosis d
JOIN Prescription p ON d.diagnosis_id = p.diagnosis_id;