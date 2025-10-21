-- genius_geeks_FIXED.sql
-- COMPLETE DATABASE WITH FIXED INSERT STATEMENTS

DROP DATABASE IF EXISTS genius_geeks;
CREATE DATABASE genius_geeks CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE genius_geeks;

-- Users table
CREATE TABLE users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    role ENUM('admin', 'teacher', 'student', 'parent') NOT NULL,
    phone VARCHAR(20),
    address TEXT,
    profile_photo VARCHAR(255) DEFAULT 'default.png',
    status ENUM('active', 'inactive') DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- Students table
CREATE TABLE students (
    student_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    roll_number VARCHAR(50) UNIQUE NOT NULL,
    admission_date DATE NOT NULL,
    date_of_birth DATE,
    gender ENUM('male', 'female', 'other'),
    guardian_name VARCHAR(100),
    guardian_phone VARCHAR(20),
    status ENUM('active', 'inactive') DEFAULT 'active',
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- Teachers table
CREATE TABLE teachers (
    teacher_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    employee_id VARCHAR(50) UNIQUE NOT NULL,
    joining_date DATE NOT NULL,
    qualification VARCHAR(255),
    specialization VARCHAR(255),
    experience_years INT DEFAULT 0,
    salary DECIMAL(10, 2) DEFAULT 0,
    status ENUM('active', 'inactive') DEFAULT 'active',
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- Parents table
CREATE TABLE parents (
    parent_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    occupation VARCHAR(100),
    relation VARCHAR(50),
    status ENUM('active', 'inactive') DEFAULT 'active',
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- Admins table
CREATE TABLE admins (
    admin_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    admin_level ENUM('super', 'normal') DEFAULT 'normal',
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- Courses table
CREATE TABLE courses (
    course_id INT PRIMARY KEY AUTO_INCREMENT,
    course_name VARCHAR(100) NOT NULL,
    course_code VARCHAR(20) UNIQUE NOT NULL,
    description TEXT,
    duration VARCHAR(50),
    fee DECIMAL(10, 2) DEFAULT 0,
    teacher_id INT,
    status ENUM('active', 'inactive') DEFAULT 'active',
    FOREIGN KEY (teacher_id) REFERENCES teachers(teacher_id)
) ENGINE=InnoDB;

-- Additional tables (23 total)
CREATE TABLE subjects (subject_id INT PRIMARY KEY AUTO_INCREMENT, subject_name VARCHAR(100) NOT NULL, course_id INT NOT NULL, FOREIGN KEY (course_id) REFERENCES courses(course_id) ON DELETE CASCADE) ENGINE=InnoDB;
CREATE TABLE classes (class_id INT PRIMARY KEY AUTO_INCREMENT, class_name VARCHAR(100) NOT NULL, course_id INT NOT NULL, teacher_id INT, room_number VARCHAR(20), capacity INT DEFAULT 30, FOREIGN KEY (course_id) REFERENCES courses(course_id), FOREIGN KEY (teacher_id) REFERENCES teachers(teacher_id)) ENGINE=InnoDB;
CREATE TABLE attendance (attendance_id INT PRIMARY KEY AUTO_INCREMENT, student_id INT NOT NULL, class_id INT NOT NULL, attendance_date DATE NOT NULL, status ENUM('present', 'absent', 'late') DEFAULT 'present', FOREIGN KEY (student_id) REFERENCES students(student_id), FOREIGN KEY (class_id) REFERENCES classes(class_id)) ENGINE=InnoDB;
CREATE TABLE quizzes (quiz_id INT PRIMARY KEY AUTO_INCREMENT, quiz_title VARCHAR(200) NOT NULL, subject_id INT NOT NULL, teacher_id INT NOT NULL, duration INT DEFAULT 60, total_marks INT DEFAULT 100, created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, FOREIGN KEY (subject_id) REFERENCES subjects(subject_id), FOREIGN KEY (teacher_id) REFERENCES teachers(teacher_id)) ENGINE=InnoDB;
CREATE TABLE quiz_questions (question_id INT PRIMARY KEY AUTO_INCREMENT, quiz_id INT NOT NULL, question_text TEXT NOT NULL, option_a VARCHAR(255), option_b VARCHAR(255), option_c VARCHAR(255), option_d VARCHAR(255), correct_answer CHAR(1), marks INT DEFAULT 1, FOREIGN KEY (quiz_id) REFERENCES quizzes(quiz_id) ON DELETE CASCADE) ENGINE=InnoDB;
CREATE TABLE quiz_attempts (attempt_id INT PRIMARY KEY AUTO_INCREMENT, quiz_id INT NOT NULL, student_id INT NOT NULL, score INT DEFAULT 0, attempted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, FOREIGN KEY (quiz_id) REFERENCES quizzes(quiz_id), FOREIGN KEY (student_id) REFERENCES students(student_id)) ENGINE=InnoDB;
CREATE TABLE badges (badge_id INT PRIMARY KEY AUTO_INCREMENT, badge_name VARCHAR(100) NOT NULL, badge_description TEXT, points INT DEFAULT 0) ENGINE=InnoDB;
CREATE TABLE student_badges (id INT PRIMARY KEY AUTO_INCREMENT, student_id INT NOT NULL, badge_id INT NOT NULL, earned_date DATE NOT NULL, FOREIGN KEY (student_id) REFERENCES students(student_id), FOREIGN KEY (badge_id) REFERENCES badges(badge_id)) ENGINE=InnoDB;
CREATE TABLE meetings (meeting_id INT PRIMARY KEY AUTO_INCREMENT, parent_id INT NOT NULL, teacher_id INT NOT NULL, student_id INT NOT NULL, meeting_date DATE NOT NULL, meeting_time TIME NOT NULL, status ENUM('pending', 'confirmed', 'cancelled') DEFAULT 'pending', notes TEXT, FOREIGN KEY (parent_id) REFERENCES parents(parent_id), FOREIGN KEY (teacher_id) REFERENCES teachers(teacher_id), FOREIGN KEY (student_id) REFERENCES students(student_id)) ENGINE=InnoDB;
CREATE TABLE notifications (notification_id INT PRIMARY KEY AUTO_INCREMENT, user_id INT NOT NULL, title VARCHAR(200) NOT NULL, message TEXT NOT NULL, is_read BOOLEAN DEFAULT FALSE, created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, FOREIGN KEY (user_id) REFERENCES users(user_id)) ENGINE=InnoDB;
CREATE TABLE resources (resource_id INT PRIMARY KEY AUTO_INCREMENT, title VARCHAR(200) NOT NULL, file_path VARCHAR(255) NOT NULL, subject_id INT NOT NULL, uploaded_by INT NOT NULL, created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, FOREIGN KEY (subject_id) REFERENCES subjects(subject_id), FOREIGN KEY (uploaded_by) REFERENCES users(user_id)) ENGINE=InnoDB;
CREATE TABLE surveys (survey_id INT PRIMARY KEY AUTO_INCREMENT, survey_title VARCHAR(200) NOT NULL, survey_question TEXT NOT NULL, options JSON NOT NULL, created_by INT NOT NULL, created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, FOREIGN KEY (created_by) REFERENCES users(user_id)) ENGINE=InnoDB;
CREATE TABLE survey_responses (response_id INT PRIMARY KEY AUTO_INCREMENT, survey_id INT NOT NULL, user_id INT NOT NULL, answer TEXT NOT NULL, responded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, FOREIGN KEY (survey_id) REFERENCES surveys(survey_id), FOREIGN KEY (user_id) REFERENCES users(user_id)) ENGINE=InnoDB;
CREATE TABLE payments (payment_id INT PRIMARY KEY AUTO_INCREMENT, student_id INT NOT NULL, amount DECIMAL(10, 2) NOT NULL, payment_date DATE NOT NULL, payment_method ENUM('cash', 'card', 'online', 'bkash', 'nagad') DEFAULT 'cash', status ENUM('pending', 'completed') DEFAULT 'completed', FOREIGN KEY (student_id) REFERENCES students(student_id)) ENGINE=InnoDB;
CREATE TABLE appointments (appointment_id INT PRIMARY KEY AUTO_INCREMENT, student_id INT NOT NULL, counselor_id INT NOT NULL, appointment_date DATE NOT NULL, appointment_time TIME NOT NULL, purpose TEXT, status ENUM('pending', 'confirmed', 'completed', 'cancelled') DEFAULT 'pending', FOREIGN KEY (student_id) REFERENCES students(student_id), FOREIGN KEY (counselor_id) REFERENCES teachers(teacher_id)) ENGINE=InnoDB;
CREATE TABLE progress_reports (report_id INT PRIMARY KEY AUTO_INCREMENT, student_id INT NOT NULL, term VARCHAR(50) NOT NULL, overall_grade VARCHAR(10), teacher_comments TEXT, parent_acknowledged BOOLEAN DEFAULT FALSE, created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, FOREIGN KEY (student_id) REFERENCES students(student_id)) ENGINE=InnoDB;
CREATE TABLE lecture_slides (slide_id INT PRIMARY KEY AUTO_INCREMENT, title VARCHAR(200) NOT NULL, file_path VARCHAR(255) NOT NULL, subject_id INT NOT NULL, uploaded_by INT NOT NULL, views INT DEFAULT 0, created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, FOREIGN KEY (subject_id) REFERENCES subjects(subject_id), FOREIGN KEY (uploaded_by) REFERENCES teachers(teacher_id)) ENGINE=InnoDB;

-- INSERT DEMO DATA
INSERT INTO users (username, email, password, full_name, role, phone, status) VALUES
('admin', 'admin@genius.com', 'admin123', 'Administrator', 'admin', '01700000001', 'active'),
('teacher1', 'teacher@genius.com', 'teacher123', 'John Teacher', 'teacher', '01700000002', 'active'),
('student1', 'student@genius.com', 'student123', 'Jane Student', 'student', '01700000003', 'active'),
('parent1', 'parent@genius.com', 'parent123', 'Mr. Parent', 'parent', '01700000004', 'active');

INSERT INTO admins (user_id, admin_level) VALUES (1, 'super');
INSERT INTO teachers (user_id, employee_id, joining_date, qualification, specialization, experience_years, salary, status) VALUES (2, 'EMP001', '2024-01-01', 'M.Sc', 'Mathematics', 5, 25000, 'active');
INSERT INTO students (user_id, roll_number, admission_date, date_of_birth, gender, guardian_name, guardian_phone, status) VALUES (3, 'STU001', '2024-01-15', '2005-05-10', 'female', 'Mr. Smith', '01712345678', 'active');
INSERT INTO parents (user_id, occupation, relation, status) VALUES (4, 'Business Owner', 'Father', 'active');
INSERT INTO badges (badge_name, badge_description, points) VALUES ('Perfect Attendance', '25+ days present', 100), ('Quiz Master', '90%+ score', 150), ('Top Performer', 'Top 3 rank', 200);
INSERT INTO courses (course_name, course_code, description, duration, fee, teacher_id, status) VALUES ('Advanced Mathematics', 'MATH101', 'Advanced math', '6 months', 15000, 1, 'active'), ('Physics Fundamentals', 'PHY101', 'Basic physics', '5 months', 12000, 1, 'active');
INSERT INTO subjects (subject_name, course_id) VALUES ('Algebra', 1), ('Geometry', 1), ('Mechanics', 2);
INSERT INTO classes (class_name, course_id, teacher_id, room_number, capacity) VALUES ('Math Class A', 1, 1, 'R101', 30), ('Physics Class B', 2, 1, 'R102', 25);
