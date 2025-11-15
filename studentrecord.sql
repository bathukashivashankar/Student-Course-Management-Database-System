-- Show tables
SELECT * FROM students;
SELECT * FROM courses;
SELECT * FROM enrollments;

-- Row counts
SELECT COUNT(*) AS student_count FROM students;
SELECT COUNT(*) AS course_count FROM courses;
SELECT COUNT(*) AS enrollment_count FROM enrollments;

-- Preview data
SELECT * FROM students LIMIT 5;
SELECT * FROM courses LIMIT 5;
SELECT * FROM enrollments LIMIT 5;

-- # Data Preprocessing & Missing Values
-- Missing values in Students table
SELECT 
    SUM(CASE WHEN gender IS NULL THEN 1 ELSE 0 END) AS missing_gender,
    SUM(CASE WHEN gpa IS NULL THEN 1 ELSE 0 END) AS missing_gpa,
    SUM(CASE WHEN date_of_birth IS NULL THEN 1 ELSE 0 END) AS missing_dob
FROM students;

-- Missing values in Enrollments table
SELECT 
    SUM(CASE WHEN grade IS NULL THEN 1 ELSE 0 END) AS missing_grade,
    SUM(CASE WHEN attendance_rate IS NULL THEN 1 ELSE 0 END) AS missing_attendance
FROM enrollments;

-- Show rows with missing data before treatment
SELECT * FROM students WHERE gender IS NULL OR gpa IS NULL OR date_of_birth IS NULL;
SELECT * FROM enrollments WHERE grade IS NULL OR attendance_rate IS NULL;

-- Replace NULL with 0 (numeric) or 'unknown' (text)
UPDATE students SET gpa = 0 WHERE gpa IS NULL;
UPDATE students SET gender = 'unknown' WHERE gender IS NULL;
UPDATE students SET date_of_birth = 'unknown' WHERE date_of_birth IS NULL;
UPDATE enrollments SET grade = 'unknown' WHERE grade IS NULL;
UPDATE enrollments SET attendance_rate = 0 WHERE attendance_rate IS NULL;

-- Check replacements
SELECT * FROM students WHERE gender = 'unknown' OR gpa = 0 OR date_of_birth = 'unknown';
SELECT * FROM enrollments WHERE grade = 'unknown' OR attendance_rate = 0;

--# Data Understanding
-- Join: What courses is each student taking? (first 10 enrollments)
SELECT enrollments.student_id, students.first_name, students.last_name, students.gender,
       enrollments.course_id, courses.course_name, enrollments.semester,
       enrollments.grade, enrollments.attendance_rate
FROM enrollments
JOIN students ON enrollments.student_id = students.student_id
JOIN courses ON enrollments.course_id = courses.course_id
LIMIT 10;


-- Aggregate: Average GPA per year of study
SELECT year_of_study, AVG(gpa) AS avg_gpa
FROM students
GROUP BY year_of_study
ORDER BY year_of_study;

-- Aggregate: Average grade and attendance by course
SELECT courses.course_name,
       AVG(CASE WHEN grade='A' THEN 4 WHEN grade='B' THEN 3 WHEN grade='C' THEN 2 WHEN grade='D' THEN 1 WHEN grade='F' THEN 0 ELSE NULL END) AS avg_grade_numeric,
       AVG(attendance_rate) AS avg_attendance
FROM enrollments
JOIN courses ON enrollments.course_id = courses.course_id
GROUP BY courses.course_id
ORDER BY avg_grade_numeric DESC;

-- Enrollment breakdown by semester
SELECT semester, COUNT(*) AS enrollments
FROM enrollments
GROUP BY semester
ORDER BY enrollments DESC;

-- Most popular courses (by enrollments)
SELECT courses.course_name, COUNT(*) AS enrollment_count
FROM enrollments
JOIN courses ON enrollments.course_id = courses.course_id
GROUP BY enrollments.course_id
ORDER BY enrollment_count DESC
LIMIT 5;


-- Data Association Example: Which year of study has highest average attendance?
SELECT students.year_of_study, AVG(enrollments.attendance_rate) AS avg_attendance
FROM enrollments
JOIN students ON enrollments.student_id = students.student_id
GROUP BY students.year_of_study
ORDER BY avg_attendance DESC;