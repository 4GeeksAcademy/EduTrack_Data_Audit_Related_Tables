# EduTrack Data Audit — Analysis Report

## Database overview

The audit covers three related tables in the Supabase `public` schema:

- `students`: 8 records
- `courses`: 7 records
- `enrollments`: 9 records
- Relationship: each student can have many enrollments, and each course can have many enrollments. The `enrollments` table joins students and courses.

All results below were produced by the corresponding numbered statement in `queries.sql`.

## 1. Enrollment details

The INNER JOIN returned all 9 valid enrollment records:

- Emily Watson — Advanced Python — 40%
- Emily Watson — Intro to Python — 85%
- Emily Watson — Web Design Basics — 60%
- Klaus Weber — Data Analysis with SQL — 78%
- Klaus Weber — Intro to Python — 92%
- Marco Rossi — Advanced Python — 95%
- Marco Rossi — Intro to Python — 88%
- Priya Sharma — Digital Marketing 101 — 70%
- Priya Sharma — Intro to Python — 55%

Because this is an INNER JOIN across all three tables, only enrollments with a matching student and course appear.

## 2. Students who passed courses

Six passed enrollment records were found:

- Emily Watson (`emily.watson@student.edutrack.com`) — Intro to Python
- Klaus Weber (`klaus.weber@student.edutrack.com`) — Data Analysis with SQL
- Klaus Weber (`klaus.weber@student.edutrack.com`) — Intro to Python
- Marco Rossi (`marco.rossi@student.edutrack.com`) — Advanced Python
- Marco Rossi (`marco.rossi@student.edutrack.com`) — Intro to Python
- Priya Sharma (`priya.sharma@student.edutrack.com`) — Digital Marketing 101

Four distinct students have passed at least one course.

## 3. Average completion by instructor

Ordered from highest to lowest average completion:

- Marta López — 75.83%
- Lucia Prades — 70.00%
- Carlos Vega — 69.00%

Marta López has the highest average completion percentage among instructors with enrollments.

## 4. Students with no enrollments

The LEFT JOIN found 4 registered students who have never enrolled:

- Giulia Romano — `giulia.romano@student.edutrack.com` — signed up 2025-01-03
- Lucia Fernandes — `lucia.fernandes@test.com` — signed up 2024-03-12
- Pierre Dubois — `pierre.dubois@test.com` — signed up 2024-06-21
- Yuki Nakamura — `yuki.nakamura@test.com` — signed up 2024-05-16

Half of the 8 registered students currently have no enrollment record.

## 5. Courses with no enrollments

The LEFT JOIN found 2 catalog courses without enrollments:

- Email Campaigns — Marketing — instructor: Pending assignment
- UI/UX Fundamentals — Design — instructor: Pending assignment

These courses exist in the catalog but currently have no enrolled students.

## 6. Students enrolled in more than one course

The `GROUP BY` and `HAVING` query returned 4 students:

- Emily Watson — 3 courses
- Klaus Weber — 2 courses
- Marco Rossi — 2 courses
- Priya Sharma — 2 courses

Every student who has an enrollment is taking more than one course.

## 7. Monthly revenue by category

Revenue uses the current `courses.monthly_fee` for each enrollment, as required:

- Programming — $339.94
- Data — $59.99
- Design — $39.99
- Marketing — $29.99

Programming generates the highest current monthly revenue. These values intentionally do not use the historical `enrollments.monthly_fee_paid` field.

## 8. Students enrolled per instructor

The number of distinct enrolled students per instructor is:

- Marta López — 4 students
- Carlos Vega — 2 students
- Lucia Prades — 1 student
- Pending assignment — 0 students

The LEFT JOIN keeps instructors represented by catalog courses even when those courses have no enrollments.

## 9. Enrollments with an invalid student reference

No rows were returned. Every `enrollments.student_id` matches an existing `students.id`.

## 10. Enrollments with an invalid course reference

No rows were returned. Every `enrollments.course_id` matches an existing `courses.id`.

## Conclusion

The database relationships are internally consistent: all 9 enrollments reference valid students and courses. The main missing-data findings are 4 students without enrollments and 2 courses without enrollments.

## Security note

Row Level Security is currently disabled on all three public tables. This does not affect the assignment queries, but a production Supabase application should enable RLS together with appropriate access policies.
