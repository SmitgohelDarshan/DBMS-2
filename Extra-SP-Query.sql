--1. Write a stored procedure to return course-wise student count for a specific semester.
CREATE OR ALTER PROC PR_CourseWiseStudentCount
@Semester INT
AS
BEGIN
    SELECT 
        C.CourseID,
        C.CourseName,
        COUNT(E.StudentID) AS StudentCount
    FROM COURSE1 C
    JOIN ENROLLMENT E ON C.CourseID = E.CourseID
    WHERE C.CourseSemester = @Semester
    GROUP BY C.CourseID, C.CourseName;
END;

EXEC PR_CourseWiseStudentCount 5

--2. Create a stored procedure that returns all students who have completed 2 or more than 2 courses.
CREATE OR ALTER PROC PR_StudentsCompletedMin2Courses
AS
BEGIN
    SELECT 
        S.StudentID,
        S.StuName,
        COUNT(E.CourseID) AS CompletedCourses
    FROM STUDENT S
    JOIN ENROLLMENT E ON S.StudentID = E.StudentID
    WHERE E.EnrollmentStatus = 'Completed'
    GROUP BY S.StudentID, S.StuName
    HAVING COUNT(E.CourseID) >= 2;
END;

EXEC PR_StudentsCompletedMin2Courses

--3. Create a stored procedure to list students without any active enrollment.
CREATE PROCEDURE PR_StudentsWithoutActiveEnrollment
AS
BEGIN
    SELECT *
    FROM STUDENT
    WHERE StudentID NOT IN (
        SELECT StudentID
        FROM ENROLLMENT
        WHERE EnrollmentStatus = 'Active'
    );
END;

EXEC PR_StudentsWithoutActiveEnrollment

--4. Write a stored procedure to list faculty who teach more than one course in the same year.
CREATE OR ALTER PROC PR_FacultyMultipleCoursesSameYear
AS
BEGIN
    SELECT 
        F.FacultyID,
        F.FacultyName,
        CA.Year,
        COUNT(CA.CourseID) AS CourseCount
    FROM FACULTY F
    JOIN COURSE_ASSIGNMENT CA ON F.FacultyID = CA.FacultyID
    GROUP BY F.FacultyID, F.FacultyName, CA.Year
    HAVING COUNT(CA.CourseID) > 1;
END;

EXEC PR_FacultyMultipleCoursesSameYear

--5. Create a stored procedure to find faculty who are not assigned any course in a given year.
CREATE OR ALTER PROC PR_FacultyWithoutCourseInYear
@Year INT
AS
BEGIN
    SELECT *
    FROM FACULTY
    WHERE FacultyID NOT IN (
        SELECT FacultyID
        FROM COURSE_ASSIGNMENT
        WHERE Year = @Year
    );
END;

EXEC PR_FacultyWithoutCourseInYear 2012

--6. Write a stored procedure to fetch top N students based on number of completed courses.
CREATE PROCEDURE PR_TopNStudentsByCompletedCourses
@N INT
AS
BEGIN
    SELECT TOP (@N)
        S.StudentID,
        S.StuName,
        COUNT(E.CourseID) AS CompletedCourses
    FROM STUDENT S
    JOIN ENROLLMENT E ON S.StudentID = E.StudentID
    WHERE E.EnrollmentStatus = 'Completed'
    GROUP BY S.StudentID, S.StuName
    ORDER BY COUNT(E.CourseID) DESC;
END;

EXEC PR_TopNStudentsByCompletedCourses 4

--7. Write a stored procedure that returns students with at least one Active and one Completed course.
CREATE PROCEDURE PR_StudentsActiveAndCompleted
AS
BEGIN
    SELECT DISTINCT S.StudentID, S.StuName
    FROM STUDENT S
    WHERE EXISTS (
        SELECT 1 FROM ENROLLMENT
        WHERE StudentID = S.StudentID
        AND EnrollmentStatus = 'Active'
    )
    AND EXISTS (
        SELECT 1 FROM ENROLLMENT
        WHERE StudentID = S.StudentID
        AND EnrollmentStatus = 'Completed'
    );
END;

EXEC PR_StudentsActiveAndCompleted

--8. Write a stored procedure to return students whose age is below a given value.
CREATE OR ALTER PROC PR_StudentsBelowAge
@Age INT
AS
BEGIN
    SELECT *, DATEDIFF(YEAR, StuDateOfBirth, GETDATE()) AS Age
    FROM STUDENT
    WHERE DATEDIFF(YEAR, StuDateOfBirth, GETDATE()) < @Age;
END;

EXEC PR_StudentsBelowAge 18

--9. Create a stored procedure that returns courses never enrolled by any student.
CREATE OR ALTER PROC PR_CoursesNeverEnrolled
AS
BEGIN
    SELECT *
    FROM COURSE1
    WHERE CourseID NOT IN (
        SELECT CourseID FROM ENROLLMENT
    );
END;

EXEC PR_CoursesNeverEnrolled

--10. Write a stored procedure to display students enrolled in the latest semester of their department.
CREATE OR ALTER PROC PR_StudentsLatestSemesterByDepartment
AS
BEGIN
    SELECT DISTINCT 
        S.StudentID,
        S.StuName,
        C.CourseSemester
    FROM STUDENT S
    JOIN ENROLLMENT E ON S.StudentID = E.StudentID
    JOIN COURSE1 C ON E.CourseID = C.CourseID
    WHERE C.CourseSemester = (
        SELECT MAX(C2.CourseSemester)
        FROM COURSE1 C2
        WHERE C2.CourseDepartment = S.StuDepartment
    );
END;

EXEC PR_StudentsLatestSemesterByDepartment

--11. Create a stored procedure to fetch department-wise highest enrollment course.
