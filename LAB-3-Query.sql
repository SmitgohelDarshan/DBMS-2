----------------------------------Part – A------------------------------------------------- 
--1.	Create a stored procedure that accepts a date and returns all faculty members who joined on that date.
CREATE OR ALTER PROC PR_FAULTY_DATE
@DATE DATE
AS
BEGIN
	SELECT FacultyName FROM FACULTY
	WHERE FacultyJoiningDate = @DATE
END

EXEC PR_FAULTY_DATE '2010-07-15'

--2.	Create a stored procedure for ENROLLMENT table where user enters either StudentID and returns EnrollmentID, EnrollmentDate, Grade, and Status.
CREATE OR ALTER PROC PR_STUDENT_DETAILS
@STUDENTID INT
AS
BEGIN
	SELECT EnrollmentID, EnrollmentDate, Grade, EnrollmentStatus
	FROM ENROLLMENT
	WHERE StudentID = @STUDENTID
END

EXEC PR_STUDENT_DETAILS 1

--3.	Create a stored procedure that accepts two integers (min and max credits) and returns all courses whose credits fall between these values.
CREATE OR ALTER PROC PR_CREDIT_VALUES
@MIN INT, @MAX INT
AS
BEGIN
	SELECT CourseName FROM COURSE1
	WHERE CourseCredits BETWEEN @MIN AND @MAX
END	

EXEC PR_CREDIT_VALUES 1, 5

--4.	Create a stored procedure that accepts Course Name and returns the list of students enrolled in that course.
CREATE OR ALTER PROC PR_STUDENT_IN_COURSE
@NAME VARCHAR(50)
AS
BEGIN
	SELECT S.StuName, C.CourseName
	FROM ENROLLMENT E 
	JOIN STUDENT S
	ON E.StudentID = S.StudentID
	JOIN COURSE1 C
	ON E.CourseID = C.CourseID
	WHERE CourseName = @NAME
END

EXEC PR_STUDENT_IN_COURSE 'Data Structures'

--5.	Create a stored procedure that accepts Faculty Name and returns all course assignments.
CREATE OR ALTER PROC PR_COURSE_ASSIGN
@NAME VARCHAR(50)
AS
BEGIN
	SELECT CourseName 
	FROM COURSE_ASSIGNMENT CA 
	JOIN FACULTY F
	ON CA.FacultyID = F.FacultyID
	JOIN COURSE1 C
	ON CA.CourseID = C.CourseID
	WHERE FacultyName = @NAME
END

EXEC PR_COURSE_ASSIGN 'Dr. Sheth'

--6.	Create a stored procedure that accepts Semester number and Year, and returns all course assignments with faculty and classroom details.
CREATE OR ALTER PROC PR_COURSE_ASSIGNMENT_DETAILS
@SEM INT, @YEAR INT
AS
BEGIN
	SELECT C.CourseName, F.FacultyName, CA.ClassRoom
	FROM COURSE_ASSIGNMENT CA 
	JOIN FACULTY F
	ON CA.FacultyID = F.FacultyID
	JOIN COURSE1 C
	ON CA.CourseID = C.CourseID
	WHERE CA.Semester = @SEM AND CA.Year = @YEAR
END

EXEC PR_COURSE_ASSIGNMENT_DETAILS 6, 2024


-----------------------------------------Part – B--------------------------------------------------------- 
--7.	Create a stored procedure that accepts the first letter of Status ('A', 'C', 'D') and returns enrollment details.
CREATE OR ALTER PROC PR_ENROLLMENT_DETAILS
@LETTER VARCHAR(1)
AS
BEGIN
	SELECT C.CourseName, S.StuName, E.EnrollmentStatus, E.Grade
	FROM ENROLLMENT E 
	JOIN STUDENT S
	ON E.StudentID = S.StudentID
	JOIN COURSE1 C
	ON E.CourseID = C.CourseID
	WHERE E.EnrollmentStatus LIKE @LETTER+'%'
END

EXEC PR_ENROLLMENT_DETAILS 'C'

--8.	Create a stored procedure that accepts either Student Name OR Department Name and returns student data accordingly.
CREATE OR ALTER PROC PR_STUDENT_DATA
@NAME VARCHAR(50)
AS
BEGIN
	SELECT StuName, StuEmail, StuPhone, StuDepartment, StuDateOfBirth, StuEnrollmentYear
	FROM STUDENT
	WHERE StuName = @NAME OR StuDepartment = @NAME
END

EXEC PR_STUDENT_DATA 'Raj Patel'

--9.	Create a stored procedure that accepts CourseID and returns all students enrolled grouped by enrollment status with counts.
CREATE OR ALTER PROC PR_ENROLLMENT_COUNTS
@ID VARCHAR(30), @COUNT INT OUT
AS
BEGIN
	SELECT @COUNT = COUNT(*) FROM ENROLLMENT
	WHERE CourseID = @ID
END

DECLARE @CNT INT

EXEC PR_ENROLLMENT_COUNTS 'CS101', @CNT OUTPUT

SELECT @CNT


------------------------------------Part – C-------------------------------------------------------- 
--10.	Create a stored procedure that accepts a year as input and returns all courses assigned to faculty in that year with classroom details.
CREATE OR ALTER PROC PR_COURSE_ASSIGN_CLASS
@YEAR INT
AS
BEGIN
	SELECT C.CourseName, F.FacultyName, CA.ClassRoom
	FROM COURSE_ASSIGNMENT CA 
	JOIN FACULTY F
	ON CA.FacultyID = F.FacultyID
	JOIN COURSE1 C
	ON CA.CourseID = C.CourseID
	WHERE CA.Year = @YEAR
END

EXEC PR_COURSE_ASSIGN_CLASS	2024

--11.	Create a stored procedure that accepts From Date and To Date and returns all enrollments within that range with student and course details.
CREATE OR ALTER PROC PR_STUDENT_ENROLL_IN_COURSE_DATE
@DATE1 DATE, @DATE2 DATE
AS
BEGIN
	SELECT C.CourseName, S.StuName, E.EnrollmentStatus, E.Grade
	FROM ENROLLMENT E 
	JOIN STUDENT S
	ON E.StudentID = S.StudentID
	JOIN COURSE1 C
	ON E.CourseID = C.CourseID
	WHERE EnrollmentDate >= @DATE1 AND EnrollmentDate <= @DATE2
END

EXEC PR_STUDENT_ENROLL_IN_COURSE_DATE '2021-07-01', '2022-01-05'

--12.	Create a stored procedure that accepts FacultyID and calculates their total teaching load (sum of credits of all courses assigned).
CREATE OR ALTER PROC PR_SUM_CREADITS
@ID INT, @ANS INT OUT
AS
BEGIN
	SELECT @ANS = SUM(CourseCredits)
	FROM COURSE_ASSIGNMENT CA 
	JOIN FACULTY F
	ON CA.FacultyID = F.FacultyID
	JOIN COURSE1 C
	ON CA.CourseID = C.CourseID 
	WHERE F.FacultyID = @ID
END

DECLARE @SUM INT

EXEC PR_SUM_CREADITS '101', @SUM OUTPUT

SELECT @SUM