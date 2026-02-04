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
CREATE OR ALTER TRIGGER trg_ValidateDoctorDepartment
ON Appointment
INSTEAD OF INSERT
AS
BEGIN
 SET NOCOUNT ON;
    -- Validate
    IF EXISTS (
        SELECT 1
        FROM inserted i
        WHERE dbo.fn_ValidateDoctorDepartment(i.doctor_id, i.department_id) = 0
    )
    BEGIN
        RAISERROR('Doctor not assigned to this department!!', 16, 1);
        RETURN;
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
