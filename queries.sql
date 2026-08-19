-- EduTrack Data Audit
-- Each query is independent and can be run separately in Supabase.

-- 1. List every enrollment with the student's name, course, and completion.
SELECT
    s.name AS student_full_name,
    c.title AS course_title,
    e.completion_percentage
FROM enrollments AS e
INNER JOIN students AS s ON s.id = e.student_id
INNER JOIN courses AS c ON c.id = e.course_id
ORDER BY s.name, c.title;

-- 2. Show students who passed a course and the course they passed.
SELECT
    s.name AS student_name,
    s.email,
    c.title AS course_title
FROM enrollments AS e
INNER JOIN students AS s ON s.id = e.student_id
INNER JOIN courses AS c ON c.id = e.course_id
WHERE e.passed IS TRUE
ORDER BY s.name, c.title;

-- 3. Calculate average completion by instructor, highest first.
SELECT
    c.instructor_name,
    ROUND(AVG(e.completion_percentage), 2) AS average_completion_percentage
FROM courses AS c
INNER JOIN enrollments AS e ON e.course_id = c.id
GROUP BY c.instructor_name
ORDER BY average_completion_percentage DESC, c.instructor_name;

-- 4. Find students who have no enrollments.
SELECT
    s.id AS student_id,
    s.name AS student_name,
    s.email,
    s.signup_date
FROM students AS s
LEFT JOIN enrollments AS e ON e.student_id = s.id
WHERE e.id IS NULL
ORDER BY s.name;

-- 5. Find courses that have no enrollments.
SELECT
    c.id AS course_id,
    c.title AS course_title,
    c.category,
    c.instructor_name
FROM courses AS c
LEFT JOIN enrollments AS e ON e.course_id = c.id
WHERE e.id IS NULL
ORDER BY c.title;

-- 6. Count courses per student, showing only students in more than one.
SELECT
    s.id AS student_id,
    s.name AS student_name,
    COUNT(e.course_id) AS course_count
FROM students AS s
INNER JOIN enrollments AS e ON e.student_id = s.id
GROUP BY s.id, s.name
HAVING COUNT(e.course_id) > 1
ORDER BY course_count DESC, s.name;

-- 7. Calculate revenue per category from the current course monthly fees.
SELECT
    c.category,
    ROUND(SUM(c.monthly_fee), 2) AS total_monthly_revenue
FROM courses AS c
INNER JOIN enrollments AS e ON e.course_id = c.id
GROUP BY c.category
ORDER BY total_monthly_revenue DESC, c.category;

-- 8. Show each instructor and their number of enrolled students.
SELECT
    c.instructor_name,
    COUNT(DISTINCT e.student_id) AS enrolled_student_count
FROM courses AS c
LEFT JOIN enrollments AS e ON e.course_id = c.id
GROUP BY c.instructor_name
ORDER BY enrolled_student_count DESC, c.instructor_name;

-- 9. Check for enrollments whose student_id has no matching student.
SELECT e.*
FROM enrollments AS e
LEFT JOIN students AS s ON s.id = e.student_id
WHERE s.id IS NULL
ORDER BY e.id;

-- 10. Check for enrollments whose course_id has no matching course.
SELECT e.*
FROM enrollments AS e
LEFT JOIN courses AS c ON c.id = e.course_id
WHERE c.id IS NULL
ORDER BY e.id;
