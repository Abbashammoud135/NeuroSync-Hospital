# NeuroSync-Hospital

## 📌 Overview

**NeuroSync Hospital Database System** is a fully integrated, enterprise-grade SQL Server hospital management designed to model real-world hospital operations while enforcing business rules, automation, data integrity, security, and AI readiness.

This system transforms hospital workflows into a structured, intelligent data platform that supports:

- Clinical operations  
- Emergency response  
- Billing and insurance  
- Staff management  
- AI-driven analytics and decision support  

It is built using relational architecture, triggers, stored procedures, views, transactions, and role-based security to simulate a production-ready hospital environment.

---

## 🧠 System Architecture

The system is designed using a layered relational model:

### Core Entities

| Layer | Purpose |
|------|---------|
| Hospital / Department | Physical and organizational structure |
| Person / Role | Unified identity system for patients, doctors, nurses, and staff |
| Patient / Doctor / Nurse | Specialized role extensions |
| Encounter / Diagnosis / Prescription | Clinical workflow pipeline |
| Admission / Bed / Room | Resource and capacity management |
| Billing / Payment / Insurance | Financial workflow |
| Emergency Triage | Critical care prioritization |
| Audit Log | Security and compliance tracking |

This design ensures **data normalization**, **referential integrity**, and **scalability** across multiple hospitals and departments.

---



## ⚡ Emergency Intelligence System

### Automated Red-Triage Response

If a patient is classified as **Red (Critical)**:

- The system automatically admits the patient  
- Assigns hospital resources  
- Tracks the encounter in real time  

This logic is enforced using:

- `AFTER INSERT` triggers  
- Referential validation  
- Admission status checks  

This simulates real emergency department automation systems.

---

## 🔐 Security Model

### Role-Based Access Control (RBAC)

| Role | Permissions |
|------|------------|
| DoctorRole | Read patient overview |
| NurseRole | Clinical workflow access |
| AdminRole | Admissions and system control |
| AIServiceRole | AI dataset access |

Security is enforced using:

- SQL Server roles  
- View-based data exposure  
- Procedure-level execution control  

This ensures **data privacy**, **clinical compliance**, and **controlled AI access**.

---

## 🤖 AI Integration Layer

The system includes a built-in **AI-ready data pipeline**:

### AI Patient Profile Generator

Structured patient profiles are automatically generated in JSON format using:

- `fn_PreparePatientAIProfile_JSON()`

### AI Dataset View

- `vw_AI_PatientDataset`

Provides:
- Patient profile  
- Billing data  
- Encounter frequency  

This allows direct integration with **ML pipelines, analytics platforms, and predictive models**.

---

## 🔄 Automation & Business Rules

### Smart Triggers

| Trigger | Function |
|---------|----------|
| trg_BedOccupied | Marks beds as occupied on admission |
| trg_BedReleased | Frees beds on discharge |
| trg_RedTriageAutoAdmission | Auto-admits critical patients |
| trg_ValidateDoctorDepartment | Prevents invalid appointments |
| trg_AuditPatient | Tracks data changes |
| trg_UpdateTriageNotes | Syncs clinical notes |

---

## 🧾 Financial System

### Billing Pipeline

- Charges generated via stored procedures  
- Insurance coverage supported  
- Payment tracking  
- Status enforcement (`Pending`, `Paid`, `Cancelled`)  

### Transaction Safety

All financial operations use:

- `BEGIN TRANSACTION`  
- `TRY / CATCH`  
- Automatic rollback  

This ensures **ACID compliance and financial integrity**.

---

## 🏗️ Stored Procedures

| Procedure | Purpose |
|-----------|----------|
| sp_AdmitPatient | Safe admission with bed validation |
| sp_DischargePatient | Automated discharge & bed release |
| sp_ScheduleAppointment | Department-validated scheduling |
| sp_GenerateBilling | Secure billing generation |
| sp_RecordPayment | Payment processing |

All procedures are **atomic, validated, and production-safe**.

---

## 📊 Views for Analytics

| View | Purpose |
|------|---------|
| vw_PatientOverview | Clinical dashboard |
| vw_DoctorSchedule | Staff scheduling |
| vw_BillingSummary | Financial monitoring |
| vw_EmergencyTriage | Emergency tracking |
| vw_AI_PatientDataset | Machine learning dataset |

---

## 🛠️ Technologies Used

- Microsoft SQL Server  
- T-SQL  
- Relational Design (3NF)  
- Triggers & Transactions  
- Role-Based Security  
- JSON & AI-Ready Views  

---

## 🚀 Scalability & Reliability

Designed for:

- Multi-hospital expansion  
- Department scaling  
- High-volume emergency operations  
- AI system integration  
- Secure cloud deployment  

The architecture supports **horizontal scaling and service-based integration**.

---

## 📁 Repository Structure
hospital_DDL.sql → Schema & tables


hospital_BusinessRules.sql → Constraints & validation


hospital_Functions.sql → AI & logic functions


hospital_Triggers.sql → Automation layer


hospital_Views.sql → Analytics & dashboards


hospital_StoredProcedures.sql → Safe operations


hospital_Security.sql → Roles & permissions


hospital_Transaction.sql → ACID workflow examples


hospital_Seeds.sql → Demo data


Query.sql → Testing & analysis


---

## 🎯 Academic & Professional Value

This project demonstrates:

- Enterprise database engineering  
- Healthcare system modeling  
- AI-data readiness  
- Security & compliance design  
- Transactional system architecture  
- Automation through database intelligence  

---

## ✨ Vision

> In healthcare, every second matters.  
> **NeuroSync** transforms hospital data into real-time intelligence — connecting patients, doctors, systems, and AI into a single, secure, and scalable platform.
