-- phpMyAdmin SQL Dump
-- version 5.0.2
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Feb 25, 2024 at 10:00 AM
-- Server version: 10.4.14-MariaDB
-- PHP Version: 7.2.33

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Create database if not exists and use it
--
CREATE DATABASE IF NOT EXISTS `elite_school_college_staff` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `elite_school_college_staff`;

-- --------------------------------------------------------

--
-- Table structure for table `staff_info`
--

DROP TABLE IF EXISTS `staff_info`;
CREATE TABLE `staff_info` (
  `staff_id` varchar(20) NOT NULL,
  `national_id` varchar(30) NOT NULL,
  `first_name` varchar(50) NOT NULL,
  `last_name` varchar(50) NOT NULL,
  `gender` varchar(10) NOT NULL,
  `date_of_birth` date NOT NULL,
  `place_of_birth` varchar(100) NOT NULL,
  `nationality` varchar(30) NOT NULL DEFAULT 'Cameroonian',
  `marital_status` varchar(20) DEFAULT NULL,
  `email` varchar(100) NOT NULL,
  `phone_number` varchar(20) NOT NULL,
  `emergency_contact` varchar(100) NOT NULL,
  `emergency_phone` varchar(20) NOT NULL,
  `address` varchar(200) NOT NULL,
  `region` varchar(50) NOT NULL,
  `division` varchar(50) NOT NULL,
  `subdivision` varchar(50) DEFAULT NULL,
  `blood_group` varchar(5) DEFAULT NULL,
  `medical_conditions` text DEFAULT NULL,
  `profile_image` varchar(255) DEFAULT NULL,
  `joined_date` date NOT NULL,
  `employment_type` enum('Permanent','Contract','Probation','Temporary') NOT NULL,
  `status` enum('Active','Suspended','Retired','Resigned','Terminated','On Leave') NOT NULL DEFAULT 'Active',
  `retirement_date` date DEFAULT NULL,
  PRIMARY KEY (`staff_id`),
  UNIQUE KEY `national_id` (`national_id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `staff_info`
--

INSERT INTO `staff_info` (`staff_id`, `national_id`, `first_name`, `last_name`, `gender`, `date_of_birth`, `place_of_birth`, `nationality`, `marital_status`, `email`, `phone_number`, `emergency_contact`, `emergency_phone`, `address`, `region`, `division`, `subdivision`, `blood_group`, `medical_conditions`, `profile_image`, `joined_date`, `employment_type`, `status`, `retirement_date`) VALUES
('ESC-FDR-001', '1000112233445', 'John', 'Mbeng', 'Male', '1960-03-15', 'Yaoundé', 'Cameroonian', 'Married', 'john.mbeng@elitecollege.cm', '+237 677 111 000', 'Sarah Mbeng (Wife)', '+237 677 111 001', 'Bastos, Yaoundé', 'Centre', 'Mfoundi', 'Yaoundé I', 'O+', 'Hypertension', 'images/staff/founder.jpg', '2000-01-10', 'Permanent', 'Active', '2025-03-15'),
('ESC-PRI-001', '1000223344556', 'Dr. Emmanuel', 'Nkeng', 'Male', '1970-08-22', 'Douala', 'Cameroonian', 'Married', 'emmanuel.nkeng@elitecollege.cm', '+237 677 222 000', 'Grace Nkeng (Wife)', '+237 677 222 001', 'Bonapriso, Douala', 'Littoral', 'Wouri', 'Douala I', 'A+', 'None', 'images/staff/principal.jpg', '2010-09-01', 'Permanent', 'Active', '2030-08-22'),
('ESC-VP-001', '1000334455667', 'Mrs. Pauline', 'Acha', 'Female', '1975-11-30', 'Bafoussam', 'Cameroonian', 'Married', 'pauline.acha@elitecollege.cm', '+237 677 333 000', 'Peter Acha (Husband)', '+237 677 333 001', 'Commercial Ave, Bafoussam', 'Ouest', 'Mifi', 'Bafoussam', 'B+', 'None', 'images/staff/vice_principal.jpg', '2012-09-01', 'Permanent', 'Active', '2035-11-30'),
('ESC-TCH-001', '1000445566778', 'Mr. Samuel', 'Tabi', 'Male', '1985-04-12', 'Buea', 'Cameroonian', 'Single', 'samuel.tabi@elitecollege.cm', '+237 677 444 000', 'Mary Tabi (Sister)', '+237 677 444 001', 'Molyko, Buea', 'Southwest', 'Fako', 'Buea', 'AB+', 'None', 'images/staff/tch001.jpg', '2015-09-01', 'Permanent', 'Active', '2045-04-12'),
('ESC-ACC-001', '1000556677889', 'Mrs. Beatrice', 'Fomen', 'Female', '1982-07-25', 'Yaoundé', 'Cameroonian', 'Married', 'beatrice.fomen@elitecollege.cm', '+237 677 555 000', 'John Fomen (Husband)', '+237 677 555 001', 'Nkolbisson, Yaoundé', 'Centre', 'Mfoundi', 'Yaoundé II', 'O-', 'None', 'images/staff/accountant.jpg', '2018-09-01', 'Permanent', 'Active', '2042-07-25');

-- --------------------------------------------------------

--
-- Table structure for table `staff_roles`
--

DROP TABLE IF EXISTS `staff_roles`;
CREATE TABLE `staff_roles` (
  `role_id` int(11) NOT NULL AUTO_INCREMENT,
  `staff_id` varchar(20) NOT NULL,
  `primary_role` enum('Founder','Principal','Vice Principal','Teacher','HOD','Accountant','Gate Keeper','Discipline Master','Canteen Manager','Librarian','Lab Technician','Secretary','Cleaner') NOT NULL,
  `department` varchar(50) DEFAULT NULL,
  `secondary_role` varchar(50) DEFAULT NULL,
  `effective_date` date NOT NULL,
  `end_date` date DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`role_id`),
  KEY `staff_id` (`staff_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `staff_roles`
--

INSERT INTO `staff_roles` (`role_id`, `staff_id`, `primary_role`, `department`, `secondary_role`, `effective_date`, `end_date`, `is_active`) VALUES
(1, 'ESC-FDR-001', 'Founder', 'Administration', NULL, '2000-01-10', NULL, 1),
(2, 'ESC-PRI-001', 'Principal', 'Administration', NULL, '2010-09-01', NULL, 1),
(3, 'ESC-VP-001', 'Vice Principal', 'Administration', 'Discipline Master', '2012-09-01', NULL, 1),
(4, 'ESC-TCH-001', 'Teacher', 'Science', 'HOD - Mathematics', '2015-09-01', NULL, 1),
(5, 'ESC-ACC-001', 'Accountant', 'Finance', NULL, '2018-09-01', NULL, 1);

-- --------------------------------------------------------

--
-- Table structure for table `staff_contracts`
--

DROP TABLE IF EXISTS `staff_contracts`;
CREATE TABLE `staff_contracts` (
  `contract_id` int(11) NOT NULL AUTO_INCREMENT,
  `staff_id` varchar(20) NOT NULL,
  `contract_type` enum('Permanent','Fixed-Term','Probation','Part-Time') NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date DEFAULT NULL,
  `duration_months` int(11) DEFAULT NULL,
  `salary_scale` varchar(30) NOT NULL,
  `basic_salary_xaf` int(11) NOT NULL,
  `signed_by_founder` tinyint(1) NOT NULL DEFAULT 0,
  `signature_date` date DEFAULT NULL,
  `contract_document` varchar(255) DEFAULT NULL,
  `renewal_date` date DEFAULT NULL,
  `termination_reason` text DEFAULT NULL,
  `status` enum('Active','Expired','Terminated','Renewed') NOT NULL DEFAULT 'Active',
  PRIMARY KEY (`contract_id`),
  KEY `staff_id` (`staff_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `staff_contracts`
--

INSERT INTO `staff_contracts` (`contract_id`, `staff_id`, `contract_type`, `start_date`, `end_date`, `duration_months`, `salary_scale`, `basic_salary_xaf`, `signed_by_founder`, `signature_date`, `contract_document`, `renewal_date`, `termination_reason`, `status`) VALUES
(1, 'ESC-PRI-001', 'Permanent', '2010-09-01', NULL, NULL, 'Principal Scale', 1200000, 1, '2010-08-15', 'contracts/principal_001.pdf', NULL, NULL, 'Active'),
(2, 'ESC-VP-001', 'Permanent', '2012-09-01', NULL, NULL, 'Vice Principal Scale', 900000, 1, '2012-08-20', 'contracts/vp_001.pdf', NULL, NULL, 'Active'),
(3, 'ESC-TCH-001', 'Fixed-Term', '2015-09-01', '2025-08-31', 120, 'Grade A', 550000, 1, '2015-08-10', 'contracts/tch_001.pdf', '2025-07-01', NULL, 'Active'),
(4, 'ESC-ACC-001', 'Permanent', '2018-09-01', NULL, NULL, 'Grade B', 600000, 1, '2018-08-15', 'contracts/acc_001.pdf', NULL, NULL, 'Active');

-- --------------------------------------------------------

--
-- Table structure for table `staff_salary_structure`
--

DROP TABLE IF EXISTS `staff_salary_structure`;
CREATE TABLE `staff_salary_structure` (
  `salary_id` int(11) NOT NULL AUTO_INCREMENT,
  `staff_id` varchar(20) NOT NULL,
  `basic_salary_xaf` int(11) NOT NULL,
  `housing_allowance_xaf` int(11) NOT NULL DEFAULT 0,
  `transport_allowance_xaf` int(11) NOT NULL DEFAULT 0,
  `medical_allowance_xaf` int(11) NOT NULL DEFAULT 0,
  `responsibility_allowance_xaf` int(11) NOT NULL DEFAULT 0,
  `overtime_rate_xaf` int(11) DEFAULT 0,
  `other_allowances_xaf` int(11) DEFAULT 0,
  `tax_rate` decimal(5,2) NOT NULL,
  `pension_rate` decimal(5,2) NOT NULL,
  `insurance_rate` decimal(5,2) NOT NULL,
  `total_gross_xaf` int(11) NOT NULL,
  `effective_date` date NOT NULL,
  `last_review_date` date DEFAULT NULL,
  PRIMARY KEY (`salary_id`),
  KEY `staff_id` (`staff_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `staff_salary_structure`
--

INSERT INTO `staff_salary_structure` (`salary_id`, `staff_id`, `basic_salary_xaf`, `housing_allowance_xaf`, `transport_allowance_xaf`, `medical_allowance_xaf`, `responsibility_allowance_xaf`, `overtime_rate_xaf`, `other_allowances_xaf`, `tax_rate`, `pension_rate`, `insurance_rate`, `total_gross_xaf`, `effective_date`, `last_review_date`) VALUES
(1, 'ESC-PRI-001', 1200000, 300000, 150000, 100000, 200000, 20000, 50000, 12.50, 7.50, 2.50, 2000000, '2023-09-01', '2024-01-15'),
(2, 'ESC-VP-001', 900000, 200000, 100000, 80000, 150000, 15000, 30000, 12.00, 7.50, 2.50, 1465000, '2023-09-01', '2024-01-15'),
(3, 'ESC-TCH-001', 550000, 120000, 60000, 40000, 80000, 10000, 20000, 10.00, 7.00, 2.00, 870000, '2023-09-01', '2024-01-15'),
(4, 'ESC-ACC-001', 600000, 150000, 70000, 50000, 60000, 12000, 25000, 11.00, 7.00, 2.00, 962000, '2023-09-01', '2024-01-15');

-- --------------------------------------------------------

--
-- Table structure for table `salary_payments`
--

DROP TABLE IF EXISTS `salary_payments`;
CREATE TABLE `salary_payments` (
  `payment_id` int(11) NOT NULL AUTO_INCREMENT,
  `staff_id` varchar(20) NOT NULL,
  `month` varchar(20) NOT NULL,
  `year` year(4) NOT NULL,
  `basic_salary_xaf` int(11) NOT NULL,
  `total_allowances_xaf` int(11) NOT NULL,
  `overtime_hours` int(11) DEFAULT 0,
  `overtime_pay_xaf` int(11) DEFAULT 0,
  `bonus_xaf` int(11) DEFAULT 0,
  `total_gross_xaf` int(11) NOT NULL,
  `tax_deduction_xaf` int(11) NOT NULL,
  `pension_deduction_xaf` int(11) NOT NULL,
  `insurance_deduction_xaf` int(11) NOT NULL,
  `other_deductions_xaf` int(11) DEFAULT 0,
  `loan_deductions_xaf` int(11) DEFAULT 0,
  `total_deductions_xaf` int(11) NOT NULL,
  `net_salary_xaf` int(11) NOT NULL,
  `payment_method` varchar(30) NOT NULL,
  `payment_date` date NOT NULL,
  `bank_name` varchar(100) DEFAULT NULL,
  `account_number` varchar(30) DEFAULT NULL,
  `transaction_reference` varchar(50) DEFAULT NULL,
  `status` enum('Paid','Pending','Failed','On Hold') NOT NULL DEFAULT 'Pending',
  `paid_by` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`payment_id`),
  KEY `staff_id` (`staff_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `salary_payments`
--

INSERT INTO `salary_payments` (`payment_id`, `staff_id`, `month`, `year`, `basic_salary_xaf`, `total_allowances_xaf`, `overtime_hours`, `overtime_pay_xaf`, `bonus_xaf`, `total_gross_xaf`, `tax_deduction_xaf`, `pension_deduction_xaf`, `insurance_deduction_xaf`, `other_deductions_xaf`, `loan_deductions_xaf`, `total_deductions_xaf`, `net_salary_xaf`, `payment_method`, `payment_date`, `bank_name`, `account_number`, `transaction_reference`, `status`, `paid_by`) VALUES
(1, 'ESC-PRI-001', 'January', 2024, 1200000, 800000, 5, 100000, 50000, 2150000, 268750, 161250, 53750, 0, 0, 483750, 1666250, 'Bank Transfer', '2024-02-01', 'BICEC', '12001234567', 'BICEC202401001', 'Paid', 'ESC-ACC-001'),
(2, 'ESC-VP-001', 'January', 2024, 900000, 565000, 3, 45000, 30000, 1540000, 184800, 115500, 38500, 0, 20000, 358800, 1181200, 'Bank Transfer', '2024-02-01', 'Ecobank', '45678901234', 'ECO202401001', 'Paid', 'ESC-ACC-001'),
(3, 'ESC-TCH-001', 'January', 2024, 550000, 300000, 8, 80000, 20000, 950000, 95000, 66500, 19000, 0, 0, 180500, 769500, 'Bank Transfer', '2024-02-01', 'UBA', '34567890123', 'UBA202401001', 'Paid', 'ESC-ACC-001');

-- --------------------------------------------------------

--
-- Table structure for table `staff_attendance`
--

DROP TABLE IF EXISTS `staff_attendance`;
CREATE TABLE `staff_attendance` (
  `attendance_id` int(11) NOT NULL AUTO_INCREMENT,
  `staff_id` varchar(20) NOT NULL,
  `attendance_date` date NOT NULL,
  `check_in_time` time DEFAULT NULL,
  `check_out_time` time DEFAULT NULL,
  `attendance_status` enum('Present','Absent','Late','Half-Day','Leave','Sick Leave','Maternity Leave','Official Duty') NOT NULL,
  `hours_worked` decimal(4,2) DEFAULT NULL,
  `overtime_hours` decimal(4,2) DEFAULT 0,
  `remarks` text DEFAULT NULL,
  `recorded_by` varchar(50) NOT NULL,
  `academic_year` varchar(9) NOT NULL,
  PRIMARY KEY (`attendance_id`),
  KEY `staff_id` (`staff_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `staff_attendance`
--

INSERT INTO `staff_attendance` (`attendance_id`, `staff_id`, `attendance_date`, `check_in_time`, `check_out_time`, `attendance_status`, `hours_worked`, `overtime_hours`, `remarks`, `recorded_by`, `academic_year`) VALUES
(1, 'ESC-PRI-001', '2024-01-15', '07:45:00', '17:30:00', 'Present', 9.75, 1.50, 'Board meeting', 'ESC-VP-001', '2023/2024'),
(2, 'ESC-VP-001', '2024-01-15', '07:50:00', '17:00:00', 'Present', 9.17, 0.50, 'Discipline committee', 'ESC-PRI-001', '2023/2024'),
(3, 'ESC-TCH-001', '2024-01-15', '07:30:00', '16:00:00', 'Present', 8.50, 0.00, 'Regular classes', 'ESC-PRI-001', '2023/2024'),
(4, 'ESC-ACC-001', '2024-01-15', '08:00:00', '16:30:00', 'Present', 8.50, 0.00, 'Monthly accounts', 'ESC-PRI-001', '2023/2024');

-- --------------------------------------------------------

--
-- Table structure for table `staff_leave`
--

DROP TABLE IF EXISTS `staff_leave`;
CREATE TABLE `staff_leave` (
  `leave_id` int(11) NOT NULL AUTO_INCREMENT,
  `staff_id` varchar(20) NOT NULL,
  `leave_type` enum('Annual','Sick','Maternity','Paternity','Study','Casual','Unpaid','Emergency') NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  `total_days` int(11) NOT NULL,
  `reason` text NOT NULL,
  `medical_certificate` varchar(255) DEFAULT NULL,
  `approved_by` varchar(50) DEFAULT NULL,
  `approval_date` date DEFAULT NULL,
  `status` enum('Pending','Approved','Rejected','Cancelled','Completed') NOT NULL DEFAULT 'Pending',
  `remarks` text DEFAULT NULL,
  PRIMARY KEY (`leave_id`),
  KEY `staff_id` (`staff_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `staff_leave`
--

INSERT INTO `staff_leave` (`leave_id`, `staff_id`, `leave_type`, `start_date`, `end_date`, `total_days`, `reason`, `medical_certificate`, `approved_by`, `approval_date`, `status`, `remarks`) VALUES
(1, 'ESC-TCH-001', 'Annual', '2024-03-01', '2024-03-15', 15, 'Annual vacation', NULL, 'ESC-PRI-001', '2024-02-10', 'Approved', 'Enjoy your leave'),
(2, 'ESC-ACC-001', 'Sick', '2024-01-20', '2024-01-25', 6, 'Malaria treatment', 'medical/cert_001.pdf', 'ESC-PRI-001', '2024-01-19', 'Completed', 'Get well soon');

-- --------------------------------------------------------

--
-- Table structure for table `performance_reports`
--

DROP TABLE IF EXISTS `performance_reports`;
CREATE TABLE `performance_reports` (
  `report_id` int(11) NOT NULL AUTO_INCREMENT,
  `staff_id` varchar(20) NOT NULL,
  `report_type` enum('Annual','Quarterly','Probation','Incident','Commendation') NOT NULL,
  `report_date` date NOT NULL,
  `evaluated_by` varchar(50) NOT NULL,
  `performance_score` decimal(5,2) NOT NULL,
  `strengths` text NOT NULL,
  `areas_for_improvement` text NOT NULL,
  `recommendations` text DEFAULT NULL,
  `promotion_recommended` tinyint(1) DEFAULT 0,
  `salary_increase_recommended` int(11) DEFAULT 0,
  `report_file` varchar(255) DEFAULT NULL,
  `status` enum('Draft','Submitted','Reviewed','Archived') NOT NULL DEFAULT 'Draft',
  PRIMARY KEY (`report_id`),
  KEY `staff_id` (`staff_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `performance_reports`
--

INSERT INTO `performance_reports` (`report_id`, `staff_id`, `report_type`, `report_date`, `evaluated_by`, `performance_score`, `strengths`, `areas_for_improvement`, `recommendations`, `promotion_recommended`, `salary_increase_recommended`, `report_file`, `status`) VALUES
(1, 'ESC-TCH-001', 'Annual', '2023-12-15', 'ESC-PRI-001', 88.50, 'Excellent subject knowledge, good student engagement, punctual', 'Could improve use of technology in teaching', 'Recommend for HOD position', 1, 50000, 'reports/tch001_2023.pdf', 'Reviewed'),
(2, 'ESC-ACC-001', 'Quarterly', '2024-01-20', 'ESC-PRI-001', 92.00, 'Accurate financial records, timely salary payments, good communication', 'Could streamline payment processes', 'Consider for senior accountant role', 0, 30000, 'reports/acc001_q4_2023.pdf', 'Submitted');

-- --------------------------------------------------------

--
-- Table structure for table `staff_qualifications`
--

DROP TABLE IF EXISTS `staff_qualifications`;
CREATE TABLE `staff_qualifications` (
  `qualification_id` int(11) NOT NULL AUTO_INCREMENT,
  `staff_id` varchar(20) NOT NULL,
  `qualification_type` enum('Academic','Professional','Certification','Training') NOT NULL,
  `institution` varchar(150) NOT NULL,
  `field_of_study` varchar(100) NOT NULL,
  `year_obtained` year(4) NOT NULL,
  `grade` varchar(20) DEFAULT NULL,
  `certificate_file` varchar(255) DEFAULT NULL,
  `verified` tinyint(1) NOT NULL DEFAULT 0,
  `verified_by` varchar(50) DEFAULT NULL,
  `verification_date` date DEFAULT NULL,
  PRIMARY KEY (`qualification_id`),
  KEY `staff_id` (`staff_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `staff_qualifications`
--

INSERT INTO `staff_qualifications` (`qualification_id`, `staff_id`, `qualification_type`, `institution`, `field_of_study`, `year_obtained`, `grade`, `certificate_file`, `verified`, `verified_by`, `verification_date`) VALUES
(1, 'ESC-PRI-001', 'Academic', 'University of Yaoundé I', 'PhD in Educational Administration', 2005, 'Excellent', 'qualifications/pri_phd.pdf', 1, 'ESC-FDR-001', '2010-08-10'),
(2, 'ESC-TCH-001', 'Academic', 'University of Buea', 'MSc in Mathematics', 2014, 'Distinction', 'qualifications/tch_msc.pdf', 1, 'ESC-PRI-001', '2015-08-15'),
(3, 'ESC-ACC-001', 'Professional', 'Institute of Chartered Accountants', 'CPA Certification', 2017, 'Pass', 'qualifications/acc_cpa.pdf', 1, 'ESC-PRI-001', '2018-08-20');

-- --------------------------------------------------------

--
-- Table structure for table `retirement_finance`
--

DROP TABLE IF EXISTS `retirement_finance`;
CREATE TABLE `retirement_finance` (
  `retirement_id` int(11) NOT NULL AUTO_INCREMENT,
  `staff_id` varchar(20) NOT NULL,
  `expected_retirement_date` date NOT NULL,
  `pension_provider` varchar(100) NOT NULL,
  `pension_account` varchar(50) NOT NULL,
  `total_pension_contribution_xaf` int(11) NOT NULL DEFAULT 0,
  `employer_contribution_xaf` int(11) NOT NULL DEFAULT 0,
  `employee_contribution_xaf` int(11) NOT NULL DEFAULT 0,
  `gratuity_amount_xaf` int(11) DEFAULT 0,
  `last_contribution_date` date DEFAULT NULL,
  `retirement_status` enum('Active','Eligible','Retired','Deferred') NOT NULL DEFAULT 'Active',
  `retirement_notes` text DEFAULT NULL,
  PRIMARY KEY (`retirement_id`),
  KEY `staff_id` (`staff_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `retirement_finance`
--

INSERT INTO `retirement_finance` (`retirement_id`, `staff_id`, `expected_retirement_date`, `pension_provider`, `pension_account`, `total_pension_contribution_xaf`, `employer_contribution_xaf`, `employee_contribution_xaf`, `gratuity_amount_xaf`, `last_contribution_date`, `retirement_status`, `retirement_notes`) VALUES
(1, 'ESC-PRI-001', '2030-08-22', 'CNPS Cameroon', 'CNPS12345678', 85000000, 51000000, 34000000, 15000000, '2024-01-31', 'Active', 'Regular contributions'),
(2, 'ESC-FDR-001', '2025-03-15', 'Private Pension Fund', 'PPF87654321', 120000000, 72000000, 48000000, 25000000, '2024-01-31', 'Active', 'Founder retirement package'),
(3, 'ESC-TCH-001', '2045-04-12', 'CNPS Cameroon', 'CNPS87654321', 12000000, 7200000, 4800000, 0, '2024-01-31', 'Active', 'Early career stage');

-- --------------------------------------------------------

--
-- Table structure for table `staff_documents`
--

DROP TABLE IF EXISTS `staff_documents`;
CREATE TABLE `staff_documents` (
  `document_id` int(11) NOT NULL AUTO_INCREMENT,
  `staff_id` varchar(20) NOT NULL,
  `document_type` enum('ID Copy','Certificates','Contract','Appointment Letter','Tax Forms','Medical Reports','Disciplinary Records','Other') NOT NULL,
  `document_name` varchar(150) NOT NULL,
  `document_path` varchar(255) NOT NULL,
  `upload_date` date NOT NULL,
  `expiry_date` date DEFAULT NULL,
  `uploaded_by` varchar(50) NOT NULL,
  `verified` tinyint(1) NOT NULL DEFAULT 0,
  `remarks` text DEFAULT NULL,
  PRIMARY KEY (`document_id`),
  KEY `staff_id` (`staff_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `departments`
--

DROP TABLE IF EXISTS `departments`;
CREATE TABLE `departments` (
  `department_id` int(11) NOT NULL AUTO_INCREMENT,
  `department_name` varchar(100) NOT NULL,
  `hod_staff_id` varchar(20) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `created_date` date NOT NULL,
  `status` enum('Active','Inactive','Merged') NOT NULL DEFAULT 'Active',
  PRIMARY KEY (`department_id`),
  KEY `hod_staff_id` (`hod_staff_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `departments`
--

INSERT INTO `departments` (`department_id`, `department_name`, `hod_staff_id`, `description`, `created_date`, `status`) VALUES
(1, 'Administration', 'ESC-PRI-001', 'College administration and management', '2000-01-10', 'Active'),
(2, 'Science', 'ESC-TCH-001', 'Science department for all science subjects', '2005-09-01', 'Active'),
(3, 'Finance', 'ESC-ACC-001', 'Financial management and accounting', '2010-09-01', 'Active'),
(4, 'Discipline', 'ESC-VP-001', 'Student discipline and conduct', '2012-09-01', 'Active');

-- --------------------------------------------------------

--
-- Table structure for table `login`
--

DROP TABLE IF EXISTS `login`;
CREATE TABLE `login` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` varchar(50) NOT NULL,
  `Password` varchar(255) NOT NULL,
  `staff_id` varchar(20) NOT NULL,
  `Role` varchar(30) NOT NULL,
  `account_status` varchar(20) NOT NULL DEFAULT 'Active',
  `last_login` datetime DEFAULT NULL,
  `password_changed_date` date DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `user_id` (`user_id`),
  KEY `staff_id` (`staff_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `login`
--

INSERT INTO `login` (`ID`, `user_id`, `Password`, `staff_id`, `Role`, `account_status`, `last_login`, `password_changed_date`) VALUES
(1, 'founder@elitecollege.cm', '$2y$10$hashedpassword1', 'ESC-FDR-001', 'Founder', 'Active', '2024-02-25 09:30:00', '2024-01-15'),
(2, 'principal@elitecollege.cm', '$2y$10$hashedpassword2', 'ESC-PRI-001', 'Principal', 'Active', '2024-02-25 08:15:00', '2024-01-20'),
(3, 'vice.principal@elitecollege.cm', '$2y$10$hashedpassword3', 'ESC-VP-001', 'Vice Principal', 'Active', '2024-02-25 08:30:00', '2024-01-18'),
(4, 'teacher.tabi@elitecollege.cm', '$2y$10$hashedpassword4', 'ESC-TCH-001', 'Teacher/HOD', 'Active', '2024-02-25 07:45:00', '2024-01-10'),
(5, 'accountant@elitecollege.cm', '$2y$10$hashedpassword5', 'ESC-ACC-001', 'Accountant', 'Active', '2024-02-25 08:00:00', '2024-01-12');

-- --------------------------------------------------------

--
-- Table structure for table `disciplinary_records`
--

DROP TABLE IF EXISTS `disciplinary_records`;
CREATE TABLE `disciplinary_records` (
  `record_id` int(11) NOT NULL AUTO_INCREMENT,
  `staff_id` varchar(20) NOT NULL,
  `incident_date` date NOT NULL,
  `incident_type` enum('Misconduct','Absenteeism','Poor Performance','Violation of Rules','Harassment','Financial Mismanagement','Other') NOT NULL,
  `description` text NOT NULL,
  `action_taken` text NOT NULL,
  `severity_level` enum('Minor','Major','Critical') NOT NULL,
  `reported_by` varchar(50) NOT NULL,
  `investigation_date` date DEFAULT NULL,
  `resolution_date` date DEFAULT NULL,
  `status` enum('Open','Investigating','Resolved','Closed','Appealed') NOT NULL DEFAULT 'Open',
  `remarks` text DEFAULT NULL,
  PRIMARY KEY (`record_id`),
  KEY `staff_id` (`staff_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `staff_advances_loans`
--

DROP TABLE IF EXISTS `staff_advances_loans`;
CREATE TABLE `staff_advances_loans` (
  `loan_id` int(11) NOT NULL AUTO_INCREMENT,
  `staff_id` varchar(20) NOT NULL,
  `loan_type` enum('Salary Advance','Housing Loan','Vehicle Loan','Emergency Loan','Other') NOT NULL,
  `amount_xaf` int(11) NOT NULL,
  `purpose` text NOT NULL,
  `approval_date` date NOT NULL,
  `approved_by` varchar(50) NOT NULL,
  `repayment_months` int(11) NOT NULL,
  `monthly_deduction_xaf` int(11) NOT NULL,
  `total_paid_xaf` int(11) NOT NULL DEFAULT 0,
  `remaining_balance_xaf` int(11) NOT NULL,
  `status` enum('Active','Paid','Defaulted','Written Off') NOT NULL DEFAULT 'Active',
  PRIMARY KEY (`loan_id`),
  KEY `staff_id` (`staff_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `staff_advances_loans`
--

INSERT INTO `staff_advances_loans` (`loan_id`, `staff_id`, `loan_type`, `amount_xaf`, `purpose`, `approval_date`, `approved_by`, `repayment_months`, `monthly_deduction_xaf`, `total_paid_xaf`, `remaining_balance_xaf`, `status`) VALUES
(1, 'ESC-VP-001', 'Vehicle Loan', 2000000, 'Purchase of car for official duties', '2023-06-15', 'ESC-PRI-001', 24, 100000, 600000, 1400000, 'Active');

-- --------------------------------------------------------

--
-- Table structure for table `training_development`
--

DROP TABLE IF EXISTS `training_development`;
CREATE TABLE `training_development` (
  `training_id` int(11) NOT NULL AUTO_INCREMENT,
  `staff_id` varchar(20) NOT NULL,
  `training_title` varchar(200) NOT NULL,
  `training_type` enum('Workshop','Seminar','Conference','Online Course','Certification','On-the-Job') NOT NULL,
  `provider` varchar(150) NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  `cost_xaf` int(11) NOT NULL,
  `funded_by` enum('College','Self','Government','Other') NOT NULL,
  `certificate_obtained` tinyint(1) DEFAULT 0,
  `certificate_file` varchar(255) DEFAULT NULL,
  `skills_acquired` text NOT NULL,
  `status` enum('Planned','Ongoing','Completed','Cancelled') NOT NULL DEFAULT 'Planned',
  PRIMARY KEY (`training_id`),
  KEY `staff_id` (`staff_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `staff_roles`
--
ALTER TABLE `staff_roles`
  ADD CONSTRAINT `staff_roles_ibfk_1` FOREIGN KEY (`staff_id`) REFERENCES `staff_info` (`staff_id`);

--
-- Constraints for table `staff_contracts`
--
ALTER TABLE `staff_contracts`
  ADD CONSTRAINT `staff_contracts_ibfk_1` FOREIGN KEY (`staff_id`) REFERENCES `staff_info` (`staff_id`);

--
-- Constraints for table `staff_salary_structure`
--
ALTER TABLE `staff_salary_structure`
  ADD CONSTRAINT `staff_salary_structure_ibfk_1` FOREIGN KEY (`staff_id`) REFERENCES `staff_info` (`staff_id`);

--
-- Constraints for table `salary_payments`
--
ALTER TABLE `salary_payments`
  ADD CONSTRAINT `salary_payments_ibfk_1` FOREIGN KEY (`staff_id`) REFERENCES `staff_info` (`staff_id`);

--
-- Constraints for table `staff_attendance`
--
ALTER TABLE `staff_attendance`
  ADD CONSTRAINT `staff_attendance_ibfk_1` FOREIGN KEY (`staff_id`) REFERENCES `staff_info` (`staff_id`);

--
-- Constraints for table `staff_leave`
--
ALTER TABLE `staff_leave`
  ADD CONSTRAINT `staff_leave_ibfk_1` FOREIGN KEY (`staff_id`) REFERENCES `staff_info` (`staff_id`);

--
-- Constraints for table `performance_reports`
--
ALTER TABLE `performance_reports`
  ADD CONSTRAINT `performance_reports_ibfk_1` FOREIGN KEY (`staff_id`) REFERENCES `staff_info` (`staff_id`);

--
-- Constraints for table `staff_qualifications`
--
ALTER TABLE `staff_qualifications`
  ADD CONSTRAINT `staff_qualifications_ibfk_1` FOREIGN KEY (`staff_id`) REFERENCES `staff_info` (`staff_id`);

--
-- Constraints for table `retirement_finance`
--
ALTER TABLE `retirement_finance`
  ADD CONSTRAINT `retirement_finance_ibfk_1` FOREIGN KEY (`staff_id`) REFERENCES `staff_info` (`staff_id`);

--
-- Constraints for table `staff_documents`
--
ALTER TABLE `staff_documents`
  ADD CONSTRAINT `staff_documents_ibfk_1` FOREIGN KEY (`staff_id`) REFERENCES `staff_info` (`staff_id`);

--
-- Constraints for table `departments`
--
ALTER TABLE `departments`
  ADD CONSTRAINT `departments_ibfk_1` FOREIGN KEY (`hod_staff_id`) REFERENCES `staff_info` (`staff_id`);

--
-- Constraints for table `login`
--
ALTER TABLE `login`
  ADD CONSTRAINT `login_ibfk_1` FOREIGN KEY (`staff_id`) REFERENCES `staff_info` (`staff_id`);

--
-- Constraints for table `disciplinary_records`
--
ALTER TABLE `disciplinary_records`
  ADD CONSTRAINT `disciplinary_records_ibfk_1` FOREIGN KEY (`staff_id`) REFERENCES `staff_info` (`staff_id`);

--
-- Constraints for table `staff_advances_loans`
--
ALTER TABLE `staff_advances_loans`
  ADD CONSTRAINT `staff_advances_loans_ibfk_1` FOREIGN KEY (`staff_id`) REFERENCES `staff_info` (`staff_id`);

--
-- Constraints for table `training_development`
--
ALTER TABLE `training_development`
  ADD CONSTRAINT `training_development_ibfk_1` FOREIGN KEY (`staff_id`) REFERENCES `staff_info` (`staff_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `staff_roles`
--
ALTER TABLE `staff_roles`
  MODIFY `role_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `staff_contracts`
--
ALTER TABLE `staff_contracts`
  MODIFY `contract_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `staff_salary_structure`
--
ALTER TABLE `staff_salary_structure`
  MODIFY `salary_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `salary_payments`
--
ALTER TABLE `salary_payments`
  MODIFY `payment_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `staff_attendance`
--
ALTER TABLE `staff_attendance`
  MODIFY `attendance_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `staff_leave`
--
ALTER TABLE `staff_leave`
  MODIFY `leave_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `performance_reports`
--
ALTER TABLE `performance_reports`
  MODIFY `report_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `staff_qualifications`
--
ALTER TABLE `staff_qualifications`
  MODIFY `qualification_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `retirement_finance`
--
ALTER TABLE `retirement_finance`
  MODIFY `retirement_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `staff_documents`
--
ALTER TABLE `staff_documents`
  MODIFY `document_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `departments`
--
ALTER TABLE `departments`
  MODIFY `department_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `login`
--
ALTER TABLE `login`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `disciplinary_records`
--
ALTER TABLE `disciplinary_records`
  MODIFY `record_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `staff_advances_loans`
--
ALTER TABLE `staff_advances_loans`
  MODIFY `loan_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `training_development`
--
ALTER TABLE `training_development`
  MODIFY `training_id` int(11) NOT NULL AUTO_INCREMENT;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;