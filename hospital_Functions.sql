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
