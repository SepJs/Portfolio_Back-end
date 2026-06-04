-- Insert Classes (High School Sectors)
INSERT INTO classes (name, category) VALUES 
('01', 'Mathematics'),
('02', 'Experimental'),
('03', 'Mathematics'),
('04', 'Experimental');

-- Insert Students (Grades 10 to 12)
INSERT INTO students (first_name, last_name, national_code, grade, class_id) VALUES 
('Ali', 'Rezaei', '1234567890', 10, 1),
('Mohammad', 'Ahmadi', '0987654321', 11, 2),
('Sina', 'Khademi', '1122334455', 12, 3),
('Zahra', 'Kamali', '5544332211', 12, 2),
('Amir', 'Hosseini', '6677889900', 11, 4),
('Sara', 'Mani', '9988776655', 10, 1);

-- Insert Teachers
INSERT INTO teachers (first_name, last_name, national_code, main_subject, age, phone) VALUES 
('Hassan', 'Mousavi', '1111111111', 'Math', 42, '+989123456789'),
('Reza', 'Karimi', '2222222222', 'Chemistry', 38, '+989129876543'),
('Maryarm', 'Zarei', '3333333333', 'Physics', 35, '+989121112233');

-- Link Teachers to Classes
INSERT INTO teacher_classes (teacher_id, class_id, academic_year) VALUES 
(1, 1, '1404-1405'),
(1, 3, '1404-1405'),
(2, 2, '1404-1405'),
(2, 4, '1404-1405'),
(3, 1, '1404-1405'),
(3, 2, '1404-1405');

-- Insert School Subjects with Units/Coefficients (Zarib)
INSERT INTO subjects (title, coefficient) VALUES 
('Calculus', 4),
('Organic Chemistry', 3),
('Physics 1', 3),
('General Geography', 2);

-- Insert Scheduled Exams
INSERT INTO exams (class_id, subject_id, exam_type, max_score, exam_date) VALUES 
(1, 1, 'Final_First_Term', 20.0, '2026-01-15'),
(1, 3, 'Continuous', 20.0, '2026-02-10'),
(2, 2, 'Final_First_Term', 20.0, '2026-01-18'),
(3, 1, 'Final_First_Term', 20.0, '2026-01-15'),
(4, 2, 'Continuous', 20.0, '2026-02-12');

-- Insert Student Grades (Performance Results)
INSERT INTO student_grades (student_id, exam_id, score) VALUES 
(1, 1, 18.5), -- Ali in Calculus
(1, 2, 16.0), -- Ali in Physics 1
(6, 1, 19.75),-- Sara in Calculus
(6, 2, 14.5), -- Sara in Physics 1
(2, 3, 12.0), -- Mohammad in Chemistry
(4, 3, 19.5), -- Zahra in Chemistry
(3, 4, 15.0); -- Sina in Calculus

-- Insert Attendance Logs
INSERT INTO attendance (student_id, date, status, remarks) VALUES 
(1, '2026-05-10', 'Present', 'On time'),
(2, '2026-05-10', 'Absent_Unjustified', 'No medical note'),
(3, '2026-05-10', 'Delayed', '15 mins late due to traffic'),
(4, '2026-05-10', 'Present', 'On time'),
(1, '2026-05-11', 'Absent_Justified', 'Sick leave');

-- Insert Financial Payments
INSERT INTO student_payments (student_id, amount_paid, payment_type, payment_method) VALUES 
(1, 5000000.00, 'Tuition', 'Card_Transfer'),
(2, 1200000.00, 'Books', 'Cash'),
(3, 6500000.00, 'Tuition', 'Cheque'),
(4, 5000000.00, 'Tuition', 'Card_Transfer'),
(5, 450000.00, 'Uniform', 'Cash');