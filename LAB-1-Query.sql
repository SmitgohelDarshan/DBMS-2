SELECT * FROM STUDENT

INSERT INTO COURSE1 (CourseID,CourseName,CourseCredits,CourseDepartment,CourseSemester)
VALUES
('CS101','Programming Fundamentals',4,'CSE',1),
('CS201','Data Structures',4,'CSE',3),
('CS301','Database Management Systems',4,'CSE',5),
('IT101','Web Technologies',3,'IT',1),
('IT201','Software Engineering',4,'IT',3),
('EC101','Digital Electronics',3,'ECE',1),
('EC201','Microprocessors',4,'ECE',3),
('ME101','Engineering Mechanics',4,'MECH',1),
('CS202','Operating Systems',4,'CSE',4),
('CS302','Artificial Intelligence',3,'CSE',6);

SELECT * FROM COURSE1

INSERT INTO FACULTY (FacultyID,FacultyName,FacultyEmail,FacultyDepartment,FacultyDesignation,FacultyJoiningDate)
VALUES
(101,'Dr. Sheth','Sheth@univ.edu','CSE','Professor','2010-07-15'),
(102,'Prof. Gupta','gupta@univ.edu','IT','Associate Prof','2012-08-20'),
(103,'Dr. Patel','patel@univ.edu','CSE','Assistant Prof','2015-06-10'),
(104,'Dr. Singh','singh@univ.edu','ECE','Professor','2008-03-25'),
(105,'Prof. Reddy','reddy@univ.edu','IT','Assistant Prof','2018-01-15'),
(106,'Dr. Iyer','iyer@univ.edu','MECH','Associate Prof','2013-09-05'),
(107,'Prof. Nair','nair@univ.edu','CSE','Assistant Prof','2019-07-20');

SELECT * FROM FACULTY


INSERT INTO ENROLLMENT (StudentID,CourseID,EnrollmentDate,Grade,EnrollmentStatus)
VALUES
(1,'CS101','2021-07-01','A','Completed'),
(1,'CS201','2022-01-05','B+','Completed'),
(1,'CS301','2023-07-01',NULL,'Active'),
(2,'IT101','2020-07-01','A','Completed'),
(2,'IT201','2021-07-01','A-','Completed'),
(3,'CS101','2021-07-01','B','Completed'),
(3,'CS201','2022-01-05','A','Completed'),
(4,'EC101','2022-07-01','B+','Completed'),
(5,'IT101','2021-07-01','A','Completed'),
(6,'CS201','2021-01-05','A','Completed'),
(1,'CS302','2023-07-01',NULL,'Active'),
(2,'IT201','2022-01-05',NULL,'Dropped');

SELECT * FROM ENROLLMENT

INSERT INTO COURSE_ASSIGNMENT (CourseID,FacultyID,Semester,Year,ClassRoom)
VALUES
('CS101',103,1,2024,'A-301'),
('CS201',101,3,2024,'B-205'),
('CS301',101,5,2024,'A-401'),
('IT101',102,1,2024,'C-102'),
('IT201',105,3,2024,'C-205'),
('EC101',104,1,2024,'D-101'),
('EC201',104,3,2024,'D-203'),
('ME101',106,1,2024,'E-101'),
('CS202',107,4,2024,'A-305'),
('CS302',101,6,2024,'B-401');

SELECT * FROM COURSE_ASSIGNMENT


----------------------------------Part – A------------------------------------- 
--1.	Retrieve all unique departments from the STUDENT table.
SELECT DISTINCT StuDepartment FROM STUDENT

--2.	Insert a new student record into the STUDENT table.
--(9, 'Neha Singh', 'neha.singh@univ.edu', '9876543218', 'IT', '2003-09-20', 2021)
INSERT INTO STUDENT VALUES
(9, 'Neha Singh', 'neha.singh@univ.edu', '9876543218', 'IT', '2003-09-20', 2021)

--3.	Change the Email of student 'Raj Patel' to 'raj.p@univ.edu'. (STUDENT table)
UPDATE STUDENT
SET StuEmail = 'raj@univ.edu'
WHERE StuName = 'Raj Patel'

--4.	Add a new column 'CGPA' with datatype DECIMAL(3,2) to the STUDENT table.
ALTER TABLE STUDENT
ADD CGPA DECIMAL(3,2)

--5.	Retrieve all courses whose CourseName starts with 'Data'. (COURSE table)
SELECT CourseName FROM COURSE1
WHERE CourseName LIKE 'Data%'

--6.	Retrieve all students whose Name contains 'Shah'. (STUDENT table)
SELECT * FROM STUDENT
WHERE StuName LIKE '%Shah%'

--7.	Display all Faculty Names in UPPERCASE. (FACULTY table)
SELECT UPPER(FacultyName) FROM FACULTY

--8.	Find all faculty who joined after 2015. (FACULTY table)
SELECT * FROM FACULTY
WHERE YEAR(FacultyJoiningDate) > '2015'

--9.	Find the SQUARE ROOT of Credits for the course 'Database Management Systems'. (COURSE table)
SELECT SQRT(COURSECREDITS) FROM COURSE1
WHERE COURSENAME = 'Database Management Systems'

--10.	Find the Current Date using SQL Server in-built function.
SELECT GETDATE()

--11.	Find the top 3 students who enrolled earliest (by EnrollmentYear). (STUDENT table)
SELECT TOP 3 * FROM STUDENT
ORDER BY StuEnrollmentYear

--12.	Find all enrollments that were made in the year 2022. (ENROLLMENT table)
SELECT * FROM ENROLLMENT
WHERE YEAR(EnrollmentDate) = '2022'

--13.	Find the number of courses offered by each department. (COURSE table)
SELECT COUNT(CourseID), CourseDepartment
FROM COURSE1
GROUP BY CourseDepartment

--14.	Retrieve the CourseID which has more than 2 enrollments. (ENROLLMENT table)
SELECT CourseID
FROM ENROLLMENT
GROUP BY CourseID
HAVING COUNT(CourseID) > 2

--15.	Retrieve all the student name with their enrollment status. (STUDENT & ENROLLMENT table)
SELECT S.StuName, E.EnrollmentStatus
FROM STUDENT S JOIN ENROLLMENT E
ON S.StudentID = E.StudentID

--16.	Select all student names with their enrolled course names. (STUDENT, COURSE, ENROLLMENT table)
SELECT S.StuName, C.CourseName
FROM STUDENT S 
JOIN ENROLLMENT E
ON S.StudentID = E.StudentID
JOIN COURSE1 C
ON C.CourseID = E.CourseID

--17.	Create a view called 'ActiveEnrollments' showing only active enrollments with student name and  course name. (STUDENT, COURSE, ENROLLMENT,  table)
CREATE VIEW ActiveEnrollments
AS SELECT S.StuName, C.CourseName
FROM STUDENT S 
JOIN ENROLLMENT E
ON S.StudentID = E.StudentID
JOIN COURSE1 C
ON C.CourseID = E.CourseID
WHERE EnrollmentStatus = 'Active'

SELECT * FROM ActiveEnrollments

--18.	Retrieve the student’s name who is not enrol in any course using subquery. (STUDENT, ENROLLMENT TABLE)
SELECT StuName, StudentID FROM STUDENT
WHERE StudentID NOT IN (
	SELECT StudentID 
	FROM ENROLLMENT
)

--19.	Display course name having second highest credit. (COURSE table)
SELECT CourseName, CourseCredits
FROM COURSE1
WHERE CourseCredits IN (
	SELECT TOP 1 CourseCredits
	FROM (
				SELECT DISTINCT TOP 2 CourseCredits
				FROM COURSE1
				ORDER BY CourseCredits DESC
	) AS RESULT
	ORDER BY CourseCredits
)

--------------------------------------Part – B------------------------------------------------------------ 
--20.	Retrieve all courses along with the total number of students enrolled. (COURSE, ENROLLMENT table)
SELECT C.CourseName, COUNT(StudentID)
FROM ENROLLMENT E JOIN COURSE1 C
ON C.CourseID = E.CourseID
GROUP BY C.CourseName

--21.	Retrieve the total number of enrollments for each status, showing only statuses that have more than 2 enrollments. (ENROLLMENT table)
SELECT COUNT(EnrollmentID), EnrollmentStatus
FROM ENROLLMENT
GROUP BY EnrollmentStatus
HAVING COUNT(EnrollmentID) > 2

--22.	Retrieve all courses taught by 'Dr. Sheth' and order them by Credits. (FACULTY, COURSE, COURSE_ASSIGNMENT table)
SELECT CourseName
FROM COURSE_ASSIGNMENT
JOIN FACULTY
ON FACULTY.FacultyID = COURSE_ASSIGNMENT.FacultyID
JOIN COURSE1
ON COURSE1.CourseID = COURSE_ASSIGNMENT.CourseID
WHERE FacultyName = 'Dr. Sheth'
ORDER BY CourseCredits


---------------------------------------------Part – C--------------------------------------------- 
--23.	List all students who are enrolled in more than 3 courses. (STUDENT, ENROLLMENT table)
SELECT StuName, COUNT(CourseID)
FROM STUDENT JOIN ENROLLMENT
ON STUDENT.StudentID = ENROLLMENT.StudentID
GROUP BY StuName
HAVING COUNT(CourseID) > 3

--24.	Find students who have enrolled in both 'CS101' and 'CS201' Using Sub Query. (STUDENT, ENROLLMENT table)
SELECT StuName
FROM STUDENT
WHERE StudentID IN (
	SELECT StudentID FROM ENROLLMENT WHERE CourseID = 'CS101'
    INTERSECT
    SELECT StudentID FROM ENROLLMENT WHERE CourseID = 'CS201'
)

--25.	Retrieve department-wise count of faculty members along with their average years of experience (calculate experience from JoiningDate). (Faculty table)
SELECT FacultyDepartment, AVG(DATEDIFF(YEAR,FacultyJoiningDate, GETDATE())) AS AVG_YEAR, COUNT(FacultyID) AS department_wise_faculty
FROM FACULTY
GROUP BY FacultyDepartment