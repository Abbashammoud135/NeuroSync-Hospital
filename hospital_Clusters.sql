--
-- CREATE CLUSTERED INDEX idx_Appointment_Date
-- ON Appointment (appointment_datetime);

CREATE NONCLUSTERED INDEX idx_Patient_NationalID
ON Patient (national_id);

CREATE NONCLUSTERED INDEX idx_Doctor_Specialization
ON Doctor (specialization);

CREATE NONCLUSTERED INDEX idx_Billing_Patient

ON Billing (patient_id);
