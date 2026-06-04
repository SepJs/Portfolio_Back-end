PRAGMA foreign_keys = ON;

-- ====================================================================
-- 1. CORE SCHOOL STRUCTURE (Classes, Students, Teachers)
-- ====================================================================

-- Academic classes/sections
CREATE TABLE classes (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT UNIQUE NOT NULL CHECK(name IN('01','02','03','04','05','06','07','08','09','10','11','12')),
    category TEXT NOT NULL CHECK(category IN('Mathematics','Experimental')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Student profiles linked to their respective classes
CREATE TABLE students (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    national_code VARCHAR(10) UNIQUE NOT NULL,
    grade INTEGER NOT NULL CHECK(grade IN(10,11,12)),
    class_id INTEGER NOT NULL,
    status TEXT DEFAULT 'Active' CHECK(status IN('Active', 'Graduated', 'Suspended')),
    FOREIGN KEY (class_id) REFERENCES classes(id) ON DELETE RESTRICT
);

-- Teacher profiles and credentials
CREATE TABLE teachers (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    national_code VARCHAR(10) UNIQUE NOT NULL,
    main_subject TEXT NOT NULL CHECK(main_subject IN('Farsi','Math','Chemistry','Geography', 'Physics', 'Biology')),
    age INTEGER NOT NULL CHECK(age >= 20),
    phone VARCHAR(15) UNIQUE NOT NULL,
    hire_date DATE DEFAULT CURRENT_DATE
);

-- Junction table for Teacher-to-Class allocations (Many-to-Many)
CREATE TABLE teacher_classes (
    teacher_id INTEGER NOT NULL,
    class_id INTEGER NOT NULL,
    academic_year VARCHAR(9) NOT NULL, -- Example: '1404-1405'
    PRIMARY KEY (teacher_id, class_id, academic_year),
    FOREIGN KEY (teacher_id) REFERENCES teachers(id) ON DELETE CASCADE,
    FOREIGN KEY (class_id) REFERENCES classes(id) ON DELETE CASCADE
);

-- ====================================================================
-- 2. ACADEMICS & PERFORMANCE (Subjects, Exams, Grades)
-- ====================================================================

-- Specific school subjects/courses taught
CREATE TABLE subjects (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    title VARCHAR(100) UNIQUE NOT NULL,
    coefficient INTEGER NOT NULL CHECK(coefficient BETWEEN 1 AND 4) -- Unit coefficient (Zarib)
);

-- Scheduled examinations
CREATE TABLE exams (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    class_id INTEGER NOT NULL,
    subject_id INTEGER NOT NULL,
    exam_type TEXT NOT NULL CHECK(exam_type IN('Continuous', 'Final_First_Term', 'Final_Second_Term')),
    max_score REAL DEFAULT 20.0,
    exam_date DATE NOT NULL,
    FOREIGN KEY (class_id) REFERENCES classes(id) ON DELETE CASCADE,
    FOREIGN KEY (subject_id) REFERENCES subjects(id) ON DELETE CASCADE
);

-- Individual student exam results
CREATE TABLE student_grades (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    student_id INTEGER NOT NULL,
    exam_id INTEGER NOT NULL,
    score REAL NOT NULL CHECK(score BETWEEN 0.0 AND 20.0),
    recorded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(student_id, exam_id), -- Prevents duplicate grades for the same exam
    FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE,
    FOREIGN KEY (exam_id) REFERENCES exams(id) ON DELETE CASCADE
);

-- ====================================================================
-- 3. OPERATIONS & LOGISTICS (Attendance & Finance)
-- ====================================================================

-- Daily tracking of student attendance
CREATE TABLE attendance (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    student_id INTEGER NOT NULL,
    date DATE DEFAULT CURRENT_DATE,
    status TEXT NOT NULL CHECK(status IN('Present', 'Absent_Justified', 'Absent_Unjustified', 'Delayed')),
    remarks TEXT,
    UNIQUE(student_id, date),
    FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE
);

-- Student financial accounting and tuition tracking
CREATE TABLE student_payments (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    student_id INTEGER NOT NULL,
    amount_paid DECIMAL(12, 2) NOT NULL CHECK(amount_paid > 0),
    payment_type TEXT NOT NULL CHECK(payment_type IN('Tuition', 'Books', 'Uniform', 'Exam_Fees')),
    payment_method TEXT NOT NULL CHECK(payment_method IN('Card_Transfer', 'Cheque', 'Cash')),
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE RESTRICT
);

-- ====================================================================
-- 4. DATABASE OPTIMIZATION (Performance Indexes)
-- ====================================================================

-- Indexing foreign keys and fields heavily targeted by WHERE/JOIN queries
CREATE INDEX idx_students_class ON students(class_id);
CREATE INDEX idx_students_names ON students(last_name, first_name);
CREATE INDEX idx_grades_student ON student_grades(student_id);
CREATE INDEX idx_attendance_date ON attendance(date);
CREATE INDEX idx_exams_lookup ON exams(class_id, subject_id);
