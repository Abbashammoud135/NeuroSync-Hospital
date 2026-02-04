-- Full backup
BACKUP DATABASE HMS
TO DISK = 'C:\Users\User\OneDrive\Desktop\4th year\Database\Project\Backup\HospitalDB_Full.bak'
WITH FORMAT,
NAME = 'Full Backup of HospitalDB';
GO