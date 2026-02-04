ALTER TABLE Patient
ADD CONSTRAINT chk_BloodType CHECK (blood_type IN ('A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'));

ALTER TABLE Billing
ADD CONSTRAINT chk_BillingStatus CHECK (status IN ('Pending','Paid','Cancelled'));

ALTER TABLE Department
ADD CONSTRAINT chk_FloorNumber CHECK(floor_number >= 0);

ALTER TABLE Appointment
DROP CONSTRAINT fk_appointment_patient;
GO
ALTER TABLE Appointment
ADD CONSTRAINT fk_appointment_patient
FOREIGN KEY (patient_id)
REFERENCES Patient(patient_id)
ON DELETE CASCADE;
GO

ALTER TABLE Appointment
ADD CONSTRAINT chk_appointment_status
CHECK (status IN ('Scheduled','Completed','Canceled'));

ALTER TABLE Admission
ADD CONSTRAINT chk_admission_status
CHECK (status IN ('Admitted','Discharged'));

ALTER TABLE Bed
ADD CONSTRAINT chk_bed_status
CHECK (status IN ('Available','Occupied'));
