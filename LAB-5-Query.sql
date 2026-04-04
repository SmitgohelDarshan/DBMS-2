------------------------------------Part – A--------------------------------------------------------
--1. Create a cursor Course_Cursor to fetch all rows from COURSE table and display them.
DECLARE @CourseID VARCHAR(10), @CourseName VARCHAR(100), @CourseCredits INT, @CourseDepartment VARCHAR(50), @CourseSemester INT

DECLARE Course_Cursor CURSOR
FOR
	SELECT * FROM COURSE1

OPEN Course_Cursor

FETCH NEXT FROM Course_Cursor INTO @CourseID, @CourseName, @CourseCredits, @CourseDepartment, @CourseSemester

WHILE @@FETCH_STATUS = 0
	BEGIN
		SELECT @CourseID + ' ' + @CourseName + ' ' + CAST(@CourseCredits AS VARCHAR(50)) + ' ' + @CourseDepartment + ' ' + CAST(@CourseSemester AS VARCHAR(50))
	FETCH NEXT FROM Course_Cursor INTO @CourseID, @CourseName, @CourseCredits, @CourseDepartment, @CourseSemester
	END

CLOSE Course_Cursor

DEALLOCATE Course_Cursor


--2. Create a cursor Student_Cursor_Fetch to fetch records in form of StudentID_StudentName (Example:
--1_Raj Patel).
DECLARE @StuName VARCHAR(100), @StudentID INT

DECLARE Student_Cursor_Fetch CURSOR
FOR
	SELECT StuName, StudentID FROM STUDENT

OPEN Student_Cursor_Fetch

FETCH NEXT FROM Student_Cursor_Fetch INTO @StudentID, @StuName

WHILE @@FETCH_STATUS = 0
	BEGIN
		--PRINT CONCAT(@StudentID,'_',@StuName)
		PRINT StudentID + '_' + CAST(StuName AS VARCHAR(100))
		FETCH NEXT FROM Student_Cursor_Fetch INTO @StudentID, @StuName
	END

CLOSE Student_Cursor_Fetch

DEALLOCATE Student_Cursor_Fetch

--3. Create a cursor to find and display all courses with Credits greater than 3.
DECLARE @CourseName VARCHAR(100), @CourseCredits INT

DECLARE Course_Credits CURSOR
FOR
	SELECT CourseName, CourseCredits FROM COURSE1
	WHERE CourseCredits > 3

OPEN Course_Credits

FETCH NEXT FROM Course_Credits INTO @CourseName, @CourseCredits

WHILE @@FETCH_STATUS = 0
	BEGIN
		SELECT @CourseName + ' ' + CAST(@CourseCredits AS VARCHAR(50))
	FETCH NEXT FROM Course_Credits INTO @CourseName, @CourseCredits
	END

CLOSE Course_Credits

DEALLOCATE Course_Credits

--4. Create a cursor to display all students who enrolled in year 2021 or later.
DECLARE @StuName VARCHAR(100), @StuEnrollmentYear INT

DECLARE Course_Student_Name CURSOR
FOR
	SELECT StuName, StuEnrollmentYear FROM STUDENT
	WHERE StuEnrollmentYear >= '2021'

OPEN Course_Student_Name

FETCH NEXT FROM Course_Student_Name INTO @StuName, @StuEnrollmentYear

WHILE @@FETCH_STATUS = 0
	BEGIN
		SELECT @StuName, @StuEnrollmentYear
	FETCH NEXT FROM Course_Student_Name INTO @StuName, @StuEnrollmentYear
	END

CLOSE Course_Student_Name

DEALLOCATE Course_Student_Name

--5. Create a cursor Course_CursorUpdate that retrieves all courses and increases Credits by 1 for courses
--with Credits less than 4.
DECLARE @CourseName VARCHAR(100), @CourseCredits INT

DECLARE Course_CursorUpdate CURSOR
FOR
	SELECT CourseName, CourseCredits FROM COURSE1
	WHERE CourseCredits < 4

OPEN Course_CursorUpdate

FETCH NEXT FROM Course_CursorUpdate INTO @CourseName, @CourseCredits

WHILE @@FETCH_STATUS = 0
	BEGIN
		UPDATE COURSE1
		SET CourseCredits += 1
		--PRINT CONCAT(CourseName, ' ', CourseCredits)
		PRINT CourseName
	FETCH NEXT FROM Course_CursorUpdate INTO @CourseName, @CourseCredits
	END

CLOSE Course_CursorUpdate

DEALLOCATE Course_CursorUpdate

--6. Create a Cursor to fetch Student Name with Course Name (Example: Raj Patel is enrolled in Database
--Management System)
DECLARE @StuName VARCHAR(100), @CourseName VARCHAR(100)

DECLARE Course_Student_Name_With_Course_Name CURSOR
FOR
	SELECT StuName, CourseName
	FROM ENROLLMENT E JOIN STUDENT S
	ON E.StudentID = S.StudentID
	JOIN COURSE1 C
	ON E.CourseID = C.CourseID

OPEN Course_Student_Name_With_Course_Name

FETCH NEXT FROM Course_Student_Name_With_Course_Name INTO @StuName, @CourseName

WHILE @@FETCH_STATUS = 0
	BEGIN
		SELECT @StuName + ' is enrolled in ' + @CourseName
	FETCH NEXT FROM Course_Student_Name_With_Course_Name INTO @StuName, @CourseName
	END

CLOSE Course_Student_Name_With_Course_Name

DEALLOCATE Course_Student_Name_With_Course_Name

--7. Create a cursor to insert data into new table if student belong to ‘CSE’ department. (create new table
--CSEStudent with relevant columns)
CREATE TABLE CSEStudent
(	
	StudentID INT,
    StuName VARCHAR(100),
)

DECLARE @StudentID INT, @StuName VARCHAR(100)

DECLARE Course_New_Student_Table CURSOR
FOR
	SELECT StudentID, StuName FROM STUDENT
	WHERE StuDepartment = 'CSE'

OPEN Course_New_Student_Table

FETCH NEXT FROM Course_New_Student_Table INTO @StudentID, @StuName

WHILE @@FETCH_STATUS = 0
	BEGIN
		INSERT INTO CSEStudent VALUES (@StudentID, @StuName)
	FETCH NEXT FROM Course_New_Student_Table INTO @StudentID, @StuName
	END

CLOSE Course_New_Student_Table

DEALLOCATE Course_New_Student_Table


--------------------------------------Part – B-----------------------------------------------------
--8. Create a cursor to update all NULL grades to 'F' for enrollments with Status 'Completed'
DECLARE @StudentID INT, @StuName VARCHAR(100)

DECLARE Course_Update_Grade CURSOR
FOR
	SELECT StudentID, StuName FROM STUDENT
	WHERE StuDepartment = 'CSE'

OPEN Course_Update_Grade

FETCH NEXT FROM Course_Update_Grade INTO @StudentID, @StuName

WHILE @@FETCH_STATUS = 0
	BEGIN
		INSERT INTO CSEStudent VALUES (@StudentID, @StuName)
	FETCH NEXT FROM Course_Update_Grade INTO @StudentID, @StuName
	END

CLOSE Course_Update_Grade

DEALLOCATE Course_Update_Grade


--9. Cursor to show Faculty with Course they teach (EX: Dr. Sheth teaches Data structure)

--------------------------------------Part – C------------------------------------------------------
--10. Cursor to calculate total credits per student (Example: Raj Patel has total credits = 15)
