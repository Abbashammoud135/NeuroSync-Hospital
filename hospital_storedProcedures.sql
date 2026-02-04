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

        -- UPDATE Bed
        -- SET status = 'Available'
        -- WHERE bed_id IN (SELECT bed_id FROM @bed_table);

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
CREATE OR ALTER PROCEDURE sp_GenerateBilling
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

