-- PostgreSQL database dump
-- Converted from MySQL

-- Create database
CREATE DATABASE elite_school_college_staff
    WITH 
    ENCODING = 'UTF8'
    LC_COLLATE = 'en_US.UTF-8'
    LC_CTYPE = 'en_US.UTF-8'
    CONNECTION LIMIT = -1;

-- Connect to the database
\c elite_school_college_staff;

-- Create ENUM types first
CREATE TYPE employment_type_enum AS ENUM ('Permanent', 'Contract', 'Probation', 'Temporary');
CREATE TYPE staff_status_enum AS ENUM ('Active', 'Suspended', 'Retired', 'Resigned', 'Terminated', 'On Leave');
CREATE TYPE primary_role_enum AS ENUM ('Founder', 'Principal', 'Vice Principal', 'Teacher', 'HOD', 'Accountant', 'Gate Keeper', 'Discipline Master', 'Canteen Manager', 'Librarian', 'Lab Technician', 'Secretary', 'Cleaner');
CREATE TYPE contract_type_enum AS ENUM ('Permanent', 'Fixed-Term', 'Probation', 'Part-Time');
CREATE TYPE contract_status_enum AS ENUM ('Active', 'Expired', 'Terminated', 'Renewed');
CREATE TYPE attendance_status_enum AS ENUM ('Present', 'Absent', 'Late', 'Half-Day', 'Leave', 'Sick Leave', 'Maternity Leave', 'Official Duty');
CREATE TYPE leave_type_enum AS ENUM ('Annual', 'Sick', 'Maternity', 'Paternity', 'Study', 'Casual', 'Unpaid', 'Emergency');
CREATE TYPE leave_status_enum AS ENUM ('Pending', 'Approved', 'Rejected', 'Cancelled', 'Completed');
CREATE TYPE report_type_enum AS ENUM ('Annual', 'Quarterly', 'Probation', 'Incident', 'Commendation');
CREATE TYPE report_status_enum AS ENUM ('Draft', 'Submitted', 'Reviewed', 'Archived');
CREATE TYPE qualification_type_enum AS ENUM ('Academic', 'Professional', 'Certification', 'Training');
CREATE TYPE retirement_status_enum AS ENUM ('Active', 'Eligible', 'Retired', 'Deferred');
CREATE TYPE document_type_enum AS ENUM ('ID Copy', 'Certificates', 'Contract', 'Appointment Letter', 'Tax Forms', 'Medical Reports', 'Disciplinary Records', 'Other');
CREATE TYPE dept_status_enum AS ENUM ('Active', 'Inactive', 'Merged');
CREATE TYPE payment_status_enum AS ENUM ('Paid', 'Pending', 'Failed', 'On Hold');
CREATE TYPE incident_type_enum AS ENUM ('Misconduct', 'Absenteeism', 'Poor Performance', 'Violation of Rules', 'Harassment', 'Financial Mismanagement', 'Other');
CREATE TYPE severity_level_enum AS ENUM ('Minor', 'Major', 'Critical');
CREATE TYPE incident_status_enum AS ENUM ('Open', 'Investigating', 'Resolved', 'Closed', 'Appealed');
CREATE TYPE loan_type_enum AS ENUM ('Salary Advance', 'Housing Loan', 'Vehicle Loan', 'Emergency Loan', 'Other');
CREATE TYPE loan_status_enum AS ENUM ('Active', 'Paid', 'Defaulted', 'Written Off');
CREATE TYPE training_type_enum AS ENUM ('Workshop', 'Seminar', 'Conference', 'Online Course', 'Certification', 'On-the-Job');
CREATE TYPE funded_by_enum AS ENUM ('College', 'Self', 'Government', 'Other');
CREATE TYPE training_status_enum AS ENUM ('Planned', 'Ongoing', 'Completed', 'Cancelled');

-- --------------------------------------------------------

--
-- Table structure for table `staff_info`
--

DROP TABLE IF EXISTS staff_info CASCADE;
CREATE TABLE staff_info (
  staff_id VARCHAR(20) PRIMARY KEY,
  national_id VARCHAR(30) UNIQUE NOT NULL,
  first_name VARCHAR(50) NOT NULL,
  last_name VARCHAR(50) NOT NULL,
  gender VARCHAR(10) NOT NULL,
  date_of_birth DATE NOT NULL,
  place_of_birth VARCHAR(100) NOT NULL,
  nationality VARCHAR(30) NOT NULL DEFAULT 'Cameroonian',
  marital_status VARCHAR(20),
  email VARCHAR(100) UNIQUE NOT NULL,
  phone_number VARCHAR(20) NOT NULL,
  emergency_contact VARCHAR(100) NOT NULL,
  emergency_phone VARCHAR(20) NOT NULL,
  address VARCHAR(200) NOT NULL,
  region VARCHAR(50) NOT NULL,
  division VARCHAR(50) NOT NULL,
  subdivision VARCHAR(50),
  blood_group VARCHAR(5),
  medical_conditions TEXT,
  profile_image VARCHAR(255),
  joined_date DATE NOT NULL,
  employment_type employment_type_enum NOT NULL,
  status staff_status_enum NOT NULL DEFAULT 'Active',
  retirement_date DATE
);

-- --------------------------------------------------------

--
-- Table structure for table `staff_roles`
--

DROP TABLE IF EXISTS staff_roles CASCADE;
CREATE TABLE staff_roles (
  role_id SERIAL PRIMARY KEY,
  staff_id VARCHAR(20) NOT NULL,
  primary_role primary_role_enum NOT NULL,
  department VARCHAR(50),
  secondary_role VARCHAR(50),
  effective_date DATE NOT NULL,
  end_date DATE,
  is_active BOOLEAN NOT NULL DEFAULT TRUE
);

-- --------------------------------------------------------

--
-- Table structure for table `staff_contracts`
--

DROP TABLE IF EXISTS staff_contracts CASCADE;
CREATE TABLE staff_contracts (
  contract_id SERIAL PRIMARY KEY,
  staff_id VARCHAR(20) NOT NULL,
  contract_type contract_type_enum NOT NULL,
  start_date DATE NOT NULL,
  end_date DATE,
  duration_months INTEGER,
  salary_scale VARCHAR(30) NOT NULL,
  basic_salary_xaf INTEGER NOT NULL,
  signed_by_founder BOOLEAN NOT NULL DEFAULT FALSE,
  signature_date DATE,
  contract_document VARCHAR(255),
  renewal_date DATE,
  termination_reason TEXT,
  status contract_status_enum NOT NULL DEFAULT 'Active'
);

-- --------------------------------------------------------

--
-- Table structure for table `staff_salary_structure`
--

DROP TABLE IF EXISTS staff_salary_structure CASCADE;
CREATE TABLE staff_salary_structure (
  salary_id SERIAL PRIMARY KEY,
  staff_id VARCHAR(20) NOT NULL,
  basic_salary_xaf INTEGER NOT NULL,
  housing_allowance_xaf INTEGER NOT NULL DEFAULT 0,
  transport_allowance_xaf INTEGER NOT NULL DEFAULT 0,
  medical_allowance_xaf INTEGER NOT NULL DEFAULT 0,
  responsibility_allowance_xaf INTEGER NOT NULL DEFAULT 0,
  overtime_rate_xaf INTEGER DEFAULT 0,
  other_allowances_xaf INTEGER DEFAULT 0,
  tax_rate DECIMAL(5,2) NOT NULL,
  pension_rate DECIMAL(5,2) NOT NULL,
  insurance_rate DECIMAL(5,2) NOT NULL,
  total_gross_xaf INTEGER NOT NULL,
  effective_date DATE NOT NULL,
  last_review_date DATE
);

-- --------------------------------------------------------

--
-- Table structure for table `salary_payments`
--

DROP TABLE IF EXISTS salary_payments CASCADE;
CREATE TABLE salary_payments (
  payment_id SERIAL PRIMARY KEY,
  staff_id VARCHAR(20) NOT NULL,
  month VARCHAR(20) NOT NULL,
  year INTEGER NOT NULL,
  basic_salary_xaf INTEGER NOT NULL,
  total_allowances_xaf INTEGER NOT NULL,
  overtime_hours INTEGER DEFAULT 0,
  overtime_pay_xaf INTEGER DEFAULT 0,
  bonus_xaf INTEGER DEFAULT 0,
  total_gross_xaf INTEGER NOT NULL,
  tax_deduction_xaf INTEGER NOT NULL,
  pension_deduction_xaf INTEGER NOT NULL,
  insurance_deduction_xaf INTEGER NOT NULL,
  other_deductions_xaf INTEGER DEFAULT 0,
  loan_deductions_xaf INTEGER DEFAULT 0,
  total_deductions_xaf INTEGER NOT NULL,
  net_salary_xaf INTEGER NOT NULL,
  payment_method VARCHAR(30) NOT NULL,
  payment_date DATE NOT NULL,
  bank_name VARCHAR(100),
  account_number VARCHAR(30),
  transaction_reference VARCHAR(50),
  status payment_status_enum NOT NULL DEFAULT 'Pending',
  paid_by VARCHAR(50)
);

-- --------------------------------------------------------

--
-- Table structure for table `staff_attendance`
--

DROP TABLE IF EXISTS staff_attendance CASCADE;
CREATE TABLE staff_attendance (
  attendance_id SERIAL PRIMARY KEY,
  staff_id VARCHAR(20) NOT NULL,
  attendance_date DATE NOT NULL,
  check_in_time TIME,
  check_out_time TIME,
  attendance_status attendance_status_enum NOT NULL,
  hours_worked DECIMAL(4,2),
  overtime_hours DECIMAL(4,2) DEFAULT 0,
  remarks TEXT,
  recorded_by VARCHAR(50) NOT NULL,
  academic_year VARCHAR(9) NOT NULL
);

-- --------------------------------------------------------

--
-- Table structure for table `staff_leave`
--

DROP TABLE IF EXISTS staff_leave CASCADE;
CREATE TABLE staff_leave (
  leave_id SERIAL PRIMARY KEY,
  staff_id VARCHAR(20) NOT NULL,
  leave_type leave_type_enum NOT NULL,
  start_date DATE NOT NULL,
  end_date DATE NOT NULL,
  total_days INTEGER NOT NULL,
  reason TEXT NOT NULL,
  medical_certificate VARCHAR(255),
  approved_by VARCHAR(50),
  approval_date DATE,
  status leave_status_enum NOT NULL DEFAULT 'Pending',
  remarks TEXT
);

-- --------------------------------------------------------

--
-- Table structure for table `performance_reports`
--

DROP TABLE IF EXISTS performance_reports CASCADE;
CREATE TABLE performance_reports (
  report_id SERIAL PRIMARY KEY,
  staff_id VARCHAR(20) NOT NULL,
  report_type report_type_enum NOT NULL,
  report_date DATE NOT NULL,
  evaluated_by VARCHAR(50) NOT NULL,
  performance_score DECIMAL(5,2) NOT NULL,
  strengths TEXT NOT NULL,
  areas_for_improvement TEXT NOT NULL,
  recommendations TEXT,
  promotion_recommended BOOLEAN DEFAULT FALSE,
  salary_increase_recommended INTEGER DEFAULT 0,
  report_file VARCHAR(255),
  status report_status_enum NOT NULL DEFAULT 'Draft'
);

-- --------------------------------------------------------

--
-- Table structure for table `staff_qualifications`
--

DROP TABLE IF EXISTS staff_qualifications CASCADE;
CREATE TABLE staff_qualifications (
  qualification_id SERIAL PRIMARY KEY,
  staff_id VARCHAR(20) NOT NULL,
  qualification_type qualification_type_enum NOT NULL,
  institution VARCHAR(150) NOT NULL,
  field_of_study VARCHAR(100) NOT NULL,
  year_obtained INTEGER NOT NULL,
  grade VARCHAR(20),
  certificate_file VARCHAR(255),
  verified BOOLEAN NOT NULL DEFAULT FALSE,
  verified_by VARCHAR(50),
  verification_date DATE
);

-- --------------------------------------------------------

--
-- Table structure for table `retirement_finance`
--

DROP TABLE IF EXISTS retirement_finance CASCADE;
CREATE TABLE retirement_finance (
  retirement_id SERIAL PRIMARY KEY,
  staff_id VARCHAR(20) NOT NULL,
  expected_retirement_date DATE NOT NULL,
  pension_provider VARCHAR(100) NOT NULL,
  pension_account VARCHAR(50) NOT NULL,
  total_pension_contribution_xaf INTEGER NOT NULL DEFAULT 0,
  employer_contribution_xaf INTEGER NOT NULL DEFAULT 0,
  employee_contribution_xaf INTEGER NOT NULL DEFAULT 0,
  gratuity_amount_xaf INTEGER DEFAULT 0,
  last_contribution_date DATE,
  retirement_status retirement_status_enum NOT NULL DEFAULT 'Active',
  retirement_notes TEXT
);

-- --------------------------------------------------------

--
-- Table structure for table `staff_documents`
--

DROP TABLE IF EXISTS staff_documents CASCADE;
CREATE TABLE staff_documents (
  document_id SERIAL PRIMARY KEY,
  staff_id VARCHAR(20) NOT NULL,
  document_type document_type_enum NOT NULL,
  document_name VARCHAR(150) NOT NULL,
  document_path VARCHAR(255) NOT NULL,
  upload_date DATE NOT NULL,
  expiry_date DATE,
  uploaded_by VARCHAR(50) NOT NULL,
  verified BOOLEAN NOT NULL DEFAULT FALSE,
  remarks TEXT
);

-- --------------------------------------------------------

--
-- Table structure for table `departments`
--

DROP TABLE IF EXISTS departments CASCADE;
CREATE TABLE departments (
  department_id SERIAL PRIMARY KEY,
  department_name VARCHAR(100) NOT NULL,
  hod_staff_id VARCHAR(20),
  description TEXT,
  created_date DATE NOT NULL,
  status dept_status_enum NOT NULL DEFAULT 'Active'
);

-- --------------------------------------------------------

--
-- Table structure for table `login`
--

DROP TABLE IF EXISTS login CASCADE;
CREATE TABLE login (
  ID SERIAL PRIMARY KEY,
  user_id VARCHAR(50) UNIQUE NOT NULL,
  Password VARCHAR(255) NOT NULL,
  staff_id VARCHAR(20) NOT NULL,
  Role VARCHAR(30) NOT NULL,
  account_status VARCHAR(20) NOT NULL DEFAULT 'Active',
  last_login TIMESTAMP,
  password_changed_date DATE
);

-- --------------------------------------------------------

--
-- Table structure for table `disciplinary_records`
--

DROP TABLE IF EXISTS disciplinary_records CASCADE;
CREATE TABLE disciplinary_records (
  record_id SERIAL PRIMARY KEY,
  staff_id VARCHAR(20) NOT NULL,
  incident_date DATE NOT NULL,
  incident_type incident_type_enum NOT NULL,
  description TEXT NOT NULL,
  action_taken TEXT NOT NULL,
  severity_level severity_level_enum NOT NULL,
  reported_by VARCHAR(50) NOT NULL,
  investigation_date DATE,
  resolution_date DATE,
  status incident_status_enum NOT NULL DEFAULT 'Open',
  remarks TEXT
);

-- --------------------------------------------------------

--
-- Table structure for table `staff_advances_loans`
--

DROP TABLE IF EXISTS staff_advances_loans CASCADE;
CREATE TABLE staff_advances_loans (
  loan_id SERIAL PRIMARY KEY,
  staff_id VARCHAR(20) NOT NULL,
  loan_type loan_type_enum NOT NULL,
  amount_xaf INTEGER NOT NULL,
  purpose TEXT NOT NULL,
  approval_date DATE NOT NULL,
  approved_by VARCHAR(50) NOT NULL,
  repayment_months INTEGER NOT NULL,
  monthly_deduction_xaf INTEGER NOT NULL,
  total_paid_xaf INTEGER NOT NULL DEFAULT 0,
  remaining_balance_xaf INTEGER NOT NULL,
  status loan_status_enum NOT NULL DEFAULT 'Active'
);

-- --------------------------------------------------------

--
-- Table structure for table `training_development`
--

DROP TABLE IF EXISTS training_development CASCADE;
CREATE TABLE training_development (
  training_id SERIAL PRIMARY KEY,
  staff_id VARCHAR(20) NOT NULL,
  training_title VARCHAR(200) NOT NULL,
  training_type training_type_enum NOT NULL,
  provider VARCHAR(150) NOT NULL,
  start_date DATE NOT NULL,
  end_date DATE NOT NULL,
  cost_xaf INTEGER NOT NULL,
  funded_by funded_by_enum NOT NULL,
  certificate_obtained BOOLEAN DEFAULT FALSE,
  certificate_file VARCHAR(255),
  skills_acquired TEXT NOT NULL,
  status training_status_enum NOT NULL DEFAULT 'Planned'
);

-- --------------------------------------------------------

--
-- Insert data
--

-- Insert into staff_info
INSERT INTO staff_info (staff_id, national_id, first_name, last_name, gender, date_of_birth, place_of_birth, nationality, marital_status, email, phone_number, emergency_contact, emergency_phone, address, region, division, subdivision, blood_group, medical_conditions, profile_image, joined_date, employment_type, status, retirement_date) VALUES
('ESC-FDR-001', '1000112233445', 'John', 'Mbeng', 'Male', '1960-03-15', 'Yaoundé', 'Cameroonian', 'Married', 'john.mbeng@elitecollege.cm', '+237 677 111 000', 'Sarah Mbeng (Wife)', '+237 677 111 001', 'Bastos, Yaoundé', 'Centre', 'Mfoundi', 'Yaoundé I', 'O+', 'Hypertension', 'images/staff/founder.jpg', '2000-01-10', 'Permanent', 'Active', '2025-03-15'),
('ESC-PRI-001', '1000223344556', 'Dr. Emmanuel', 'Nkeng', 'Male', '1970-08-22', 'Douala', 'Cameroonian', 'Married', 'emmanuel.nkeng@elitecollege.cm', '+237 677 222 000', 'Grace Nkeng (Wife)', '+237 677 222 001', 'Bonapriso, Douala', 'Littoral', 'Wouri', 'Douala I', 'A+', 'None', 'images/staff/principal.jpg', '2010-09-01', 'Permanent', 'Active', '2030-08-22'),
('ESC-VP-001', '1000334455667', 'Mrs. Pauline', 'Acha', 'Female', '1975-11-30', 'Bafoussam', 'Cameroonian', 'Married', 'pauline.acha@elitecollege.cm', '+237 677 333 000', 'Peter Acha (Husband)', '+237 677 333 001', 'Commercial Ave, Bafoussam', 'Ouest', 'Mifi', 'Bafoussam', 'B+', 'None', 'images/staff/vice_principal.jpg', '2012-09-01', 'Permanent', 'Active', '2035-11-30'),
('ESC-TCH-001', '1000445566778', 'Mr. Samuel', 'Tabi', 'Male', '1985-04-12', 'Buea', 'Cameroonian', 'Single', 'samuel.tabi@elitecollege.cm', '+237 677 444 000', 'Mary Tabi (Sister)', '+237 677 444 001', 'Molyko, Buea', 'Southwest', 'Fako', 'Buea', 'AB+', 'None', 'images/staff/tch001.jpg', '2015-09-01', 'Permanent', 'Active', '2045-04-12'),
('ESC-ACC-001', '1000556677889', 'Mrs. Beatrice', 'Fomen', 'Female', '1982-07-25', 'Yaoundé', 'Cameroonian', 'Married', 'beatrice.fomen@elitecollege.cm', '+237 677 555 000', 'John Fomen (Husband)', '+237 677 555 001', 'Nkolbisson, Yaoundé', 'Centre', 'Mfoundi', 'Yaoundé II', 'O-', 'None', 'images/staff/accountant.jpg', '2018-09-01', 'Permanent', 'Active', '2042-07-25');

-- Insert into staff_roles
INSERT INTO staff_roles (staff_id, primary_role, department, secondary_role, effective_date, end_date, is_active) VALUES
('ESC-FDR-001', 'Founder', 'Administration', NULL, '2000-01-10', NULL, TRUE),
('ESC-PRI-001', 'Principal', 'Administration', NULL, '2010-09-01', NULL, TRUE),
('ESC-VP-001', 'Vice Principal', 'Administration', 'Discipline Master', '2012-09-01', NULL, TRUE),
('ESC-TCH-001', 'Teacher', 'Science', 'HOD - Mathematics', '2015-09-01', NULL, TRUE),
('ESC-ACC-001', 'Accountant', 'Finance', NULL, '2018-09-01', NULL, TRUE);

-- Insert into staff_contracts
INSERT INTO staff_contracts (staff_id, contract_type, start_date, end_date, duration_months, salary_scale, basic_salary_xaf, signed_by_founder, signature_date, contract_document, renewal_date, termination_reason, status) VALUES
('ESC-PRI-001', 'Permanent', '2010-09-01', NULL, NULL, 'Principal Scale', 1200000, TRUE, '2010-08-15', 'contracts/principal_001.pdf', NULL, NULL, 'Active'),
('ESC-VP-001', 'Permanent', '2012-09-01', NULL, NULL, 'Vice Principal Scale', 900000, TRUE, '2012-08-20', 'contracts/vp_001.pdf', NULL, NULL, 'Active'),
('ESC-TCH-001', 'Fixed-Term', '2015-09-01', '2025-08-31', 120, 'Grade A', 550000, TRUE, '2015-08-10', 'contracts/tch_001.pdf', '2025-07-01', NULL, 'Active'),
('ESC-ACC-001', 'Permanent', '2018-09-01', NULL, NULL, 'Grade B', 600000, TRUE, '2018-08-15', 'contracts/acc_001.pdf', NULL, NULL, 'Active');

-- Insert into staff_salary_structure
INSERT INTO staff_salary_structure (staff_id, basic_salary_xaf, housing_allowance_xaf, transport_allowance_xaf, medical_allowance_xaf, responsibility_allowance_xaf, overtime_rate_xaf, other_allowances_xaf, tax_rate, pension_rate, insurance_rate, total_gross_xaf, effective_date, last_review_date) VALUES
('ESC-PRI-001', 1200000, 300000, 150000, 100000, 200000, 20000, 50000, 12.50, 7.50, 2.50, 2000000, '2023-09-01', '2024-01-15'),
('ESC-VP-001', 900000, 200000, 100000, 80000, 150000, 15000, 30000, 12.00, 7.50, 2.50, 1465000, '2023-09-01', '2024-01-15'),
('ESC-TCH-001', 550000, 120000, 60000, 40000, 80000, 10000, 20000, 10.00, 7.00, 2.00, 870000, '2023-09-01', '2024-01-15'),
('ESC-ACC-001', 600000, 150000, 70000, 50000, 60000, 12000, 25000, 11.00, 7.00, 2.00, 962000, '2023-09-01', '2024-01-15');

-- Insert into salary_payments
INSERT INTO salary_payments (staff_id, month, year, basic_salary_xaf, total_allowances_xaf, overtime_hours, overtime_pay_xaf, bonus_xaf, total_gross_xaf, tax_deduction_xaf, pension_deduction_xaf, insurance_deduction_xaf, other_deductions_xaf, loan_deductions_xaf, total_deductions_xaf, net_salary_xaf, payment_method, payment_date, bank_name, account_number, transaction_reference, status, paid_by) VALUES
('ESC-PRI-001', 'January', 2024, 1200000, 800000, 5, 100000, 50000, 2150000, 268750, 161250, 53750, 0, 0, 483750, 1666250, 'Bank Transfer', '2024-02-01', 'BICEC', '12001234567', 'BICEC202401001', 'Paid', 'ESC-ACC-001'),
('ESC-VP-001', 'January', 2024, 900000, 565000, 3, 45000, 30000, 1540000, 184800, 115500, 38500, 0, 20000, 358800, 1181200, 'Bank Transfer', '2024-02-01', 'Ecobank', '45678901234', 'ECO202401001', 'Paid', 'ESC-ACC-001'),
('ESC-TCH-001', 'January', 2024, 550000, 300000, 8, 80000, 20000, 950000, 95000, 66500, 19000, 0, 0, 180500, 769500, 'Bank Transfer', '2024-02-01', 'UBA', '34567890123', 'UBA202401001', 'Paid', 'ESC-ACC-001');

-- Insert into staff_attendance
INSERT INTO staff_attendance (staff_id, attendance_date, check_in_time, check_out_time, attendance_status, hours_worked, overtime_hours, remarks, recorded_by, academic_year) VALUES
('ESC-PRI-001', '2024-01-15', '07:45:00', '17:30:00', 'Present', 9.75, 1.50, 'Board meeting', 'ESC-VP-001', '2023/2024'),
('ESC-VP-001', '2024-01-15', '07:50:00', '17:00:00', 'Present', 9.17, 0.50, 'Discipline committee', 'ESC-PRI-001', '2023/2024'),
('ESC-TCH-001', '2024-01-15', '07:30:00', '16:00:00', 'Present', 8.50, 0.00, 'Regular classes', 'ESC-PRI-001', '2023/2024'),
('ESC-ACC-001', '2024-01-15', '08:00:00', '16:30:00', 'Present', 8.50, 0.00, 'Monthly accounts', 'ESC-PRI-001', '2023/2024');

-- Insert into staff_leave
INSERT INTO staff_leave (staff_id, leave_type, start_date, end_date, total_days, reason, medical_certificate, approved_by, approval_date, status, remarks) VALUES
('ESC-TCH-001', 'Annual', '2024-03-01', '2024-03-15', 15, 'Annual vacation', NULL, 'ESC-PRI-001', '2024-02-10', 'Approved', 'Enjoy your leave'),
('ESC-ACC-001', 'Sick', '2024-01-20', '2024-01-25', 6, 'Malaria treatment', 'medical/cert_001.pdf', 'ESC-PRI-001', '2024-01-19', 'Completed', 'Get well soon');

-- Insert into performance_reports
INSERT INTO performance_reports (staff_id, report_type, report_date, evaluated_by, performance_score, strengths, areas_for_improvement, recommendations, promotion_recommended, salary_increase_recommended, report_file, status) VALUES
('ESC-TCH-001', 'Annual', '2023-12-15', 'ESC-PRI-001', 88.50, 'Excellent subject knowledge, good student engagement, punctual', 'Could improve use of technology in teaching', 'Recommend for HOD position', TRUE, 50000, 'reports/tch001_2023.pdf', 'Reviewed'),
('ESC-ACC-001', 'Quarterly', '2024-01-20', 'ESC-PRI-001', 92.00, 'Accurate financial records, timely salary payments, good communication', 'Could streamline payment processes', 'Consider for senior accountant role', FALSE, 30000, 'reports/acc001_q4_2023.pdf', 'Submitted');

-- Insert into staff_qualifications
INSERT INTO staff_qualifications (staff_id, qualification_type, institution, field_of_study, year_obtained, grade, certificate_file, verified, verified_by, verification_date) VALUES
('ESC-PRI-001', 'Academic', 'University of Yaoundé I', 'PhD in Educational Administration', 2005, 'Excellent', 'qualifications/pri_phd.pdf', TRUE, 'ESC-FDR-001', '2010-08-10'),
('ESC-TCH-001', 'Academic', 'University of Buea', 'MSc in Mathematics', 2014, 'Distinction', 'qualifications/tch_msc.pdf', TRUE, 'ESC-PRI-001', '2015-08-15'),
('ESC-ACC-001', 'Professional', 'Institute of Chartered Accountants', 'CPA Certification', 2017, 'Pass', 'qualifications/acc_cpa.pdf', TRUE, 'ESC-PRI-001', '2018-08-20');

-- Insert into retirement_finance
INSERT INTO retirement_finance (staff_id, expected_retirement_date, pension_provider, pension_account, total_pension_contribution_xaf, employer_contribution_xaf, employee_contribution_xaf, gratuity_amount_xaf, last_contribution_date, retirement_status, retirement_notes) VALUES
('ESC-PRI-001', '2030-08-22', 'CNPS Cameroon', 'CNPS12345678', 85000000, 51000000, 34000000, 15000000, '2024-01-31', 'Active', 'Regular contributions'),
('ESC-FDR-001', '2025-03-15', 'Private Pension Fund', 'PPF87654321', 120000000, 72000000, 48000000, 25000000, '2024-01-31', 'Active', 'Founder retirement package'),
('ESC-TCH-001', '2045-04-12', 'CNPS Cameroon', 'CNPS87654321', 12000000, 7200000, 4800000, 0, '2024-01-31', 'Active', 'Early career stage');

-- Insert into departments
INSERT INTO departments (department_name, hod_staff_id, description, created_date, status) VALUES
('Administration', 'ESC-PRI-001', 'College administration and management', '2000-01-10', 'Active'),
('Science', 'ESC-TCH-001', 'Science department for all science subjects', '2005-09-01', 'Active'),
('Finance', 'ESC-ACC-001', 'Financial management and accounting', '2010-09-01', 'Active'),
('Discipline', 'ESC-VP-001', 'Student discipline and conduct', '2012-09-01', 'Active');

-- Insert into login
INSERT INTO login (user_id, password, staff_id, role, account_status, last_login, password_changed_date) VALUES
('founder@elitecollege.cm', '$2y$10$hashedpassword1', 'ESC-FDR-001', 'Founder', 'Active', '2024-02-25 09:30:00', '2024-01-15'),
('principal@elitecollege.cm', '$2y$10$hashedpassword2', 'ESC-PRI-001', 'Principal', 'Active', '2024-02-25 08:15:00', '2024-01-20'),
('vice.principal@elitecollege.cm', '$2y$10$hashedpassword3', 'ESC-VP-001', 'Vice Principal', 'Active', '2024-02-25 08:30:00', '2024-01-18'),
('teacher.tabi@elitecollege.cm', '$2y$10$hashedpassword4', 'ESC-TCH-001', 'Teacher/HOD', 'Active', '2024-02-25 07:45:00', '2024-01-10'),
('accountant@elitecollege.cm', '$2y$10$hashedpassword5', 'ESC-ACC-001', 'Accountant', 'Active', '2024-02-25 08:00:00', '2024-01-12');

-- Insert into staff_advances_loans
INSERT INTO staff_advances_loans (staff_id, loan_type, amount_xaf, purpose, approval_date, approved_by, repayment_months, monthly_deduction_xaf, total_paid_xaf, remaining_balance_xaf, status) VALUES
('ESC-VP-001', 'Vehicle Loan', 2000000, 'Purchase of car for official duties', '2023-06-15', 'ESC-PRI-001', 24, 100000, 600000, 1400000, 'Active');

-- --------------------------------------------------------

--
-- Add foreign key constraints
--

ALTER TABLE staff_roles
ADD CONSTRAINT fk_staff_roles_staff_info FOREIGN KEY (staff_id) REFERENCES staff_info(staff_id);

ALTER TABLE staff_contracts
ADD CONSTRAINT fk_staff_contracts_staff_info FOREIGN KEY (staff_id) REFERENCES staff_info(staff_id);

ALTER TABLE staff_salary_structure
ADD CONSTRAINT fk_staff_salary_structure_staff_info FOREIGN KEY (staff_id) REFERENCES staff_info(staff_id);

ALTER TABLE salary_payments
ADD CONSTRAINT fk_salary_payments_staff_info FOREIGN KEY (staff_id) REFERENCES staff_info(staff_id);

ALTER TABLE staff_attendance
ADD CONSTRAINT fk_staff_attendance_staff_info FOREIGN KEY (staff_id) REFERENCES staff_info(staff_id);

ALTER TABLE staff_leave
ADD CONSTRAINT fk_staff_leave_staff_info FOREIGN KEY (staff_id) REFERENCES staff_info(staff_id);

ALTER TABLE performance_reports
ADD CONSTRAINT fk_performance_reports_staff_info FOREIGN KEY (staff_id) REFERENCES staff_info(staff_id);

ALTER TABLE staff_qualifications
ADD CONSTRAINT fk_staff_qualifications_staff_info FOREIGN KEY (staff_id) REFERENCES staff_info(staff_id);

ALTER TABLE retirement_finance
ADD CONSTRAINT fk_retirement_finance_staff_info FOREIGN KEY (staff_id) REFERENCES staff_info(staff_id);

ALTER TABLE staff_documents
ADD CONSTRAINT fk_staff_documents_staff_info FOREIGN KEY (staff_id) REFERENCES staff_info(staff_id);

ALTER TABLE departments
ADD CONSTRAINT fk_departments_staff_info FOREIGN KEY (hod_staff_id) REFERENCES staff_info(staff_id);

ALTER TABLE login
ADD CONSTRAINT fk_login_staff_info FOREIGN KEY (staff_id) REFERENCES staff_info(staff_id);

ALTER TABLE disciplinary_records
ADD CONSTRAINT fk_disciplinary_records_staff_info FOREIGN KEY (staff_id) REFERENCES staff_info(staff_id);

ALTER TABLE staff_advances_loans
ADD CONSTRAINT fk_staff_advances_loans_staff_info FOREIGN KEY (staff_id) REFERENCES staff_info(staff_id);

ALTER TABLE training_development
ADD CONSTRAINT fk_training_development_staff_info FOREIGN KEY (staff_id) REFERENCES staff_info(staff_id);

-- Create indexes
CREATE INDEX idx_staff_roles_staff_id ON staff_roles(staff_id);
CREATE INDEX idx_staff_contracts_staff_id ON staff_contracts(staff_id);
CREATE INDEX idx_staff_salary_structure_staff_id ON staff_salary_structure(staff_id);
CREATE INDEX idx_salary_payments_staff_id ON salary_payments(staff_id);
CREATE INDEX idx_staff_attendance_staff_id ON staff_attendance(staff_id);
CREATE INDEX idx_staff_leave_staff_id ON staff_leave(staff_id);
CREATE INDEX idx_performance_reports_staff_id ON performance_reports(staff_id);
CREATE INDEX idx_staff_qualifications_staff_id ON staff_qualifications(staff_id);
CREATE INDEX idx_retirement_finance_staff_id ON retirement_finance(staff_id);
CREATE INDEX idx_staff_documents_staff_id ON staff_documents(staff_id);
CREATE INDEX idx_departments_hod_staff_id ON departments(hod_staff_id);
CREATE INDEX idx_login_staff_id ON login(staff_id);
CREATE INDEX idx_disciplinary_records_staff_id ON disciplinary_records(staff_id);
CREATE INDEX idx_staff_advances_loans_staff_id ON staff_advances_loans(staff_id);
CREATE INDEX idx_training_development_staff_id ON training_development(staff_id);
