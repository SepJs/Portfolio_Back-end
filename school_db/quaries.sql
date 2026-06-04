-- ====================================================================
-- QUERY 1: THE REVENUE LEADERBOARD (Financial Analytics)
-- Description: Calculates total financial contributions per student, 
-- ranking them from highest payer to lowest, including their class details.
-- ====================================================================
SELECT 
    s.id AS student_id,
    s.first_name || ' ' || s.last_name AS student_full_name,
    c.name AS class_name,
    c.category AS stream,
    SUM(p.amount_paid) AS total_financial_contribution
FROM students s
JOIN classes c ON s.class_id = c.id
JOIN student_payments p ON s.id = p.student_id
GROUP BY s.id, s.first_name, s.last_name, c.name, c.category
ORDER BY total_financial_contribution DESC;


-- ====================================================================
-- QUERY 2: CLASS PERFORMANCE MATRIX (Educational Insights)
-- Description: Computes the average score, highest score, and lowest score 
-- for each exam, grouped by class and subject. Essential for school boards.
-- ====================================================================
SELECT 
    c.name AS class_name,
    c.category AS class_stream,
    sub.title AS subject_title,
    e.exam_type,
    ROUND(AVG(g.score), 2) AS average_score,
    MAX(g.score) AS highest_score,
    MIN(g.score) AS lowest_score,
    COUNT(g.id) AS total_graded_students
FROM exams e
JOIN classes c ON e.class_id = c.id
JOIN subjects sub ON e.subject_id = sub.id
JOIN student_grades g ON e.id = g.exam_id
GROUP BY c.name, c.category, sub.title, e.exam_type
ORDER BY average_score DESC;


-- ====================================================================
-- QUERY 3: TEACHER WORKLOAD AND IMPACT REPORT (HR & Operations)
-- Description: Tracks how many distinct classes and unique students 
-- each teacher is responsible for in the current academic year.
-- ====================================================================
SELECT 
    t.id AS teacher_id,
    t.first_name || ' ' || t.last_name AS teacher_name,
    t.main_subject,
    COUNT(DISTINCT tc.class_id) AS total_classes_taught,
    COUNT(DISTINCT s.id) AS total_students_under_management
FROM teachers t
JOIN teacher_classes tc ON t.id = tc.teacher_id
JOIN students s ON tc.class_id = s.class_id
WHERE tc.academic_year = '1404-1405'
GROUP BY t.id, t.first_name, t.last_name, t.main_subject
ORDER BY total_students_under_management DESC;


-- ====================================================================
-- QUERY 4: ABSENTEEISM RED FLAG REPORT (Disciplinary Monitoring)
-- Description: Flags students who have been marked 'Absent_Unjustified' 
-- or 'Delayed' to closely monitor bad attendance patterns.
-- ====================================================================
SELECT 
    s.id AS student_id,
    s.first_name || ' ' || s.last_name AS student_name,
    c.name AS class_name,
    COUNT(a.id) AS total_infractions,
    GROUP_CONCAT(a.date || ' (' || a.status || ')') AS infraction_dates_and_types
FROM students s
JOIN classes c ON s.class_id = c.id
JOIN attendance a ON s.id = a.student_id
WHERE a.status IN ('Absent_Unjustified', 'Delayed')
GROUP BY s.id, s.first_name, s.last_name, c.name
HAVING total_infractions > 0
ORDER BY total_infractions DESC;


-- ====================================================================
-- QUERY 5: WEIGHTED GPA CALCULATOR (Advanced Data Aggregation)
-- Description: A complex mathematical query that multiplies scores by 
-- subject coefficients (Zarib) to find the real weighted academic average for each student.
-- ====================================================================
SELECT 
    s.id AS student_id,
    s.first_name || ' ' || s.last_name AS student_name,
    c.name AS class_name,
    ROUND(SUM(g.score * sub.coefficient) / SUM(sub.coefficient), 2) AS weighted_gpa
FROM students s
JOIN classes c ON s.class_id = c.id
JOIN student_grades g ON s.id = g.student_id
JOIN exams e ON g.exam_id = e.id
JOIN subjects sub ON e.subject_id = sub.id
GROUP BY s.id, s.first_name, s.last_name, c.name
ORDER BY weighted_gpa DESC;