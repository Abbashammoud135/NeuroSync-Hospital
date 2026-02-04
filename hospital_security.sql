CREATE ROLE DoctorRole;
CREATE ROLE NurseRole;
CREATE ROLE AdminRole;
CREATE ROLE AIServiceRole;

GRANT SELECT ON vw_PatientOverview TO DoctorRole;
GRANT EXECUTE ON sp_AdmitPatient TO AdminRole;
GRANT SELECT ON vw_AI_PatientDataset TO AIServiceRole;
