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
