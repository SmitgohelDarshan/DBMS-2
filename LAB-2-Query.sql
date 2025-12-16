---------------------------------------Part – A---------------------------------------
--1.	INSERT Procedures: Create stored procedures to insert records into STUDENT tables (SP_INSERT_STUDENT)
--StuID	Name	Email	Phone	Department	DOB	EnrollmentYear
--10	Harsh Parmar	harsh@univ.edu	9876543219	CSE	2005-09-18	2023
--11	Om Patel	om@univ.edu	9876543220	IT	2002-08-22	2022
CREATE OR ALTER PROCEDURE PR_INSERT_STUDENT
@STUID INT, @NAME VARCHAR(100), @EMAIL VARCHAR(100), @PHONE VARCHAR(15), @DEP VARCHAR(50), @DOB DATE, @ENROLL INT
AS
BEGIN
	INSERT INTO STUDENT(StudentID, StuName, StuEmail, StuPhone, StuDepartment, StuDateOfBirth, StuEnrollmentYear) VALUES 
	(@STUID, @NAME, @EMAIL, @PHONE, @DEP, @DOB, @ENROLL)
END

EXEC PR_INSERT_STUDENT 10, 'Harsh Parmar', 'harsh@univ.edu', '9876543219', 'CSE', '2005-09-18', 2023
EXEC PR_INSERT_STUDENT 11, 'Om Patel', 'om@univ.edu', '9876543220', 'IT', '2002-08-22', 2022

--2.	INSERT Procedures: Create stored procedures to insert records into COURSE tables 
--(SP_INSERT_COURSE)
--CourseID	CourseName	Credits	Dept	Semester
--CS330	Computer Networks	4	CSE	5
--EC120	Electronic Circuits	3	ECE	2
CREATE OR ALTER PROC PR_INSERT_COURSE
@CID VARCHAR(10), @CNAME VARCHAR(100), @CREDITS INT, @DEPT VARCHAR(50), @SEM INT 
AS
BEGIN
	INSERT INTO COURSE1 (CourseID, CourseName, CourseCredits, CourseDepartment, CourseSemester)	VALUES
	(@CID, @CNAME, @CREDITS, @DEPT, @SEM)
END

EXEC PR_INSERT_COURSE 'CS330', 'Computer Networks', 4, 'CSE', 5
EXEC PR_INSERT_COURSE 'EC120', 'Electronic Circuits', 3, 'ECE', 2

--3.	UPDATE Procedures: Create stored procedure SP_UPDATE_STUDENT to update Email and Phone in STUDENT table. (Update using studentID)
CREATE OR ALTER PROC PR_UPDATE_STUDENT
@SID INT, @EMAIL VARCHAR(50), @PHONE VARCHAR(15)
AS
BEGIN
	UPDATE STUDENT
	SET StuEmail = @EMAIL, StuPhone = @PHONE
	WHERE StudentID = @SID
END

EXEC PR_UPDATE_STUDENT 1, 'ravi@univ.edu', '9876543210'

--4.	DELETE Procedures: Create stored procedure SP_DELETE_STUDENT to delete records from STUDENT where Student Name is Om Patel.
CREATE OR ALTER PROC PR_DELETE_STUDENT
@NAME VARCHAR(100)
AS
BEGIN
	DELETE STUDENT
	WHERE StuName = @NAME
END

EXEC PR_DELETE_STUDENT 'Pooja Rao'

--5.	SELECT BY PRIMARY KEY: Create stored procedures to select records by primary key (SP_SELECT_STUDENT_BY_ID) from Student table.
CREATE OR ALTER PROC PR_SELECT_STUDENT_BY_ID
@ID INT
AS
BEGIN
	SELECT * FROM STUDENT
	WHERE StudentID = @ID
END

EXEC PR_SELECT_STUDENT_BY_ID 1

--6.	Create a stored procedure that shows details of the first 5 students ordered by EnrollmentYear.
CREATE OR ALTER PROC PR_SELECT_5_STUDENT_BY_ENYEAR
AS
BEGIN
	SELECT TOP 5 * FROM STUDENT
	ORDER BY StuEnrollmentYear
END

EXEC PR_SELECT_5_STUDENT_BY_ENYEAR 


--------------------------------------------Part – B------------------------------------------  
--7.	Create a stored procedure which displays faculty designation-wise count.
CREATE OR ALTER PROC PR_SELECT_FACULTY_BY_DESIGNATION
AS
BEGIN
	SELECT COUNT(FacultyID), FacultyDesignation FROM FACULTY
	GROUP BY FacultyDesignation
END

EXEC PR_SELECT_FACULTY_BY_DESIGNATION

--8.	Create a stored procedure that takes department name as input and returns all students in that department.
CREATE OR ALTER PROC PR_SELECT_DEPT
@DEPTNAME VARCHAR(50)
AS
BEGIN
	SELECT * FROM STUDENT
	WHERE StuDepartment = @DEPTNAME
END

EXEC PR_SELECT_DEPT 'CSE'


--------------------------------------------Part-C------------------------------------------------------------
--9.	Create a stored procedure which displays department-wise maximum, minimum, and average credits of courses.
CREATE OR ALTER PROC PR_SELECT_DEPT_AGG
AS
BEGIN
	SELECT MAX(CourseDepartment) AS MAXIMUM,
			MIN(CourseDepartment) AS MINIMUM,
			AVG(CourseCredits) AS AVERAGE_CREDITS,
			CourseDepartment
			FROM COURSE1
			GROUP BY CourseDepartment
END

EXEC PR_SELECT_DEPT_AGG

--10.	Create a stored procedure that accepts StudentID as parameter and returns all courses the student is enrolled in with their grades.
CREATE OR ALTER PROC PR_SELECT_STUDENT_GRADE
@ID INT
AS
BEGIN
	SELECT C.CourseName, E.Grade
	FROM ENROLLMENT E
	JOIN STUDENT S
	ON E.StudentID = S.StudentID
	JOIN COURSE1 C
	ON E.CourseID = C.CourseID
	WHERE S.StudentID = @ID
END

EXEC PR_SELECT_STUDENT_GRADE 1