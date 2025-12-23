# Elite College Management System (Cameroon Adaptation)

## Project Overview
A comprehensive web-based CRUD application for managing educational institutions in Cameroon, specifically designed for O-Level and A-Level programs following the Cameroon GCE system.

## Features
- **Student Management**: Complete CRUD operations for student records
- **Teacher Management**: Staff records, attendance, and salary management
- **Academic Management**: Courses, subjects, results tracking
- **Financial Management**: Student fees and teacher salaries in XAF (CFA)
- **Attendance System**: Track student and teacher attendance
- **Bilingual Support**: English/French interface switching
- **Print Functionality**: Generate receipts and salary slips
- **Role-based Access**: Admin and Teacher roles with appropriate permissions

## Technology Stack
- **Backend**: PHP 7.4+
- **Database**: MySQL/MariaDB
- **Frontend**: HTML5, CSS3, JavaScript
- **Style**: Custom CSS with responsive design

## Key Adaptations for Cameroon
- Currency changed from USD to XAF (CFA)
- Educational system follows Cameroon O-Level/A-Level GCE
- Course names adapted to Cameroonian curriculum
- Bilingual interface (English/French)
- Local naming conventions and formats

## Installation
1. Import the SQL database structure
2. Configure database connection in `config/database.php`
3. Access the application via web browser
4. Use default login: admin@imperial.cm / admin123

## Modules
- Dashboard with statistics
- Student CRUD operations
- Teacher management
- Course and subject management
- Fee management (XAF)
- Salary management (XAF)
- Attendance tracking
- Results management
- Reporting and printing