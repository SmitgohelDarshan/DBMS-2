----------------------------------------Part-A---------------------------------
--1. Write a scalar function to print "Welcome to DBMS Lab". 
CREATE OR ALTER FUNCTION FN_WELCOME()
RETURNS VARCHAR(50)
AS
BEGIN
	RETURN 'Welcome to DBMS Lab'
END

SELECT DBO.FN_WELCOME()

--2. Write a scalar function to calculate simple interest.  
CREATE OR ALTER FUNCTION FN_SIMPLE_INTEREST(@P FLOAT, @R FLOAT, @N FLOAT)
RETURNS FLOAT
AS
BEGIN
	RETURN (@P * @R * @N) / 100
END

SELECT DBO.FN_SIMPLE_INTEREST(5,5,2)

--3. Function to Get Difference in Days Between Two Given Dates 
CREATE OR ALTER FUNCTION FN_DATE_DIFF_IN_DAY(@DATE1 DATE, @DATE2 DATE)
RETURNS INT
AS
BEGIN
	RETURN DATEDIFF(DAY,@DATE1, @DATE2)
END

SELECT DBO.FN_DATE_DIFF_IN_DAY('2025-05-01','2025-06-01')

--4. Write a scalar function which returns the sum of Credits for two given CourseIDs. 
CREATE OR ALTER FUNCTION FN_SUM_CREDITS(@ID1 VARCHAR(50), @ID2 VARCHAR(50))
RETURNS INT
AS
BEGIN
	DECLARE @SUM INT
	SELECT @SUM = SUM(CourseCredits) FROM COURSE1
	WHERE CourseID IN (@ID1, @ID2)

	RETURN @SUM
END

SELECT DBO.FN_SUM_CREDITS('CS101', 'CS102')

--5. Write a function to check whether the given number is ODD or EVEN. 
CREATE OR ALTER FUNCTION FN_CHECK_ODD_EVEN_NUMBER(@NUM INT)
RETURNS VARCHAR(20)
AS
BEGIN
	IF @NUM % 2 = 0
		RETURN CAST(@NUM AS VARCHAR(20)) + ' ' + 'IS EVEN NUMBER'
	RETURN @NUM + ' ' + 'IS ODD NUMBER'

END

SELECT DBO.FN_CHECK_ODD_EVEN_NUMBER(20)

--6. Write a function to print number from 1 to N. (Using while loop) 
CREATE OR ALTER FUNCTION FN_PRINT_N_NUMBERS(@N INT)
RETURNS VARCHAR(100)
AS
BEGIN
	DECLARE @I INT, @RESULT VARCHAR(100)
	SET @I = 1
	SET @RESULT = ''
	WHILE(@I <= @N)
	BEGIN
		SET @RESULT = @RESULT + CAST(@I AS VARCHAR(100)) + ' '
		SET @I = @I + 1
	END

	RETURN @RESULT
END

SELECT DBO.FN_PRINT_N_NUMBERS(5)

--7. Write a scalar function to calculate factorial of total credits for a given CourseID. 
CREATE OR ALTER FUNCTION FN_FACTORIAL_OF_TOTALCREDITS(@ID VARCHAR(50))
RETURNS INT
AS
BEGIN
	DECLARE @SUM INT, @RESULT INT
	SET @RESULT = 1
	SELECT @SUM = SUM(CourseCredits) FROM COURSE1
	WHERE CourseID = @ID

	WHILE(@SUM != 0)
	BEGIN
		SET @RESULT = @RESULT * @SUM
		SET @SUM = @SUM - 1
	END

	RETURN @RESULT
END

SELECT DBO.FN_FACTORIAL_OF_TOTALCREDITS('CS101')

--8. Write a scalar function to check whether a given EnrollmentYear is in the past, current or future (Case 
--statement)  
CREATE OR ALTER FUNCTION FN_CHECK_ENROLLMENT_YEAR(@ENYEAR INT)
RETURNS VARCHAR(50)
AS
BEGIN
	RETURN CASE
		WHEN @ENYEAR < YEAR(GETDATE()) THEN 'PAST'
		WHEN @ENYEAR = YEAR(GETDATE()) THEN 'CURRENT'
		ELSE 'FUTURE'
		END
END

SELECT DBO.FN_CHECK_ENROLLMENT_YEAR(2025)

--9. Write a table-valued function that returns details of students whose names start with a given letter. 
CREATE OR ALTER FUNCTION FN_STUDENT_DETAILS(@LETTER VARCHAR(1))
RETURNS TABLE
AS
	RETURN (SELECT * FROM STUDENT
	WHERE StuName LIKE @LETTER + '%')

SELECT * FROM DBO.FN_STUDENT_DETAILS('A')

--10. Write a table-valued function that returns unique department names from the STUDENT table. 
CREATE OR ALTER FUNCTION FN_UNIQUE_DEP_DISPLAY()
RETURNS TABLE
AS
	RETURN (SELECT StuDepartment FROM STUDENT
	GROUP BY StuDepartment)

SELECT * FROM DBO.FN_UNIQUE_DEP_DISPLAY()


----------------------------------------------Part-B------------------------------
--11. Write a scalar function that calculates age in years given a DateOfBirth. 
CREATE OR ALTER FUNCTION FN_CALCULATE_AGE_DATEBIRTH(@DATE DATE)
RETURNS INT
AS
BEGIN
	DECLARE @AGE INT
	SET @AGE = DATEDIFF(YEAR, @DATE, GETDATE())
	RETURN @AGE
END

SELECT DBO.FN_CALCULATE_AGE_DATEBIRTH('2007-01-07')

--12. Write a scalar function to check whether given number is palindrome or not. 
CREATE OR ALTER FUNCTION FN_CHECK_PALINDROME_NUM(@NUM INT)
RETURNS VARCHAR(50)
AS
BEGIN
	DECLARE @TEMP INT, @DIGIT INT, @RESULT INT
	SET @TEMP = @NUM
	SET @RESULT = 0
	
	WHILE(@TEMP != 0)
	BEGIN
		SET @DIGIT = @TEMP % 10
		SET @RESULT = (@RESULT * 10) + @DIGIT
		SET @TEMP = @TEMP / 10
	END
	
	IF @RESULT = @NUM
		RETURN CAST(@NUM AS VARCHAR(50)) + ' ' + 'IS PALINDROME NUMBER'

	RETURN CAST(@NUM AS VARCHAR(50)) + ' ' + 'IS NOT PALINDROME NUMBER'
END

SELECT DBO.FN_CHECK_PALINDROME_NUM(121)

--13. Write a scalar function to calculate the sum of Credits for all courses in the 'CSE' department. 
CREATE OR ALTER FUNCTION FN_SUM_CREDITS_DEPARTMENT()
RETURNS INT
AS
BEGIN
	DECLARE @SUM INT
	SELECT @SUM = SUM(CourseCredits) FROM COURSE1
	WHERE CourseDepartment = 'CSE'
	RETURN @SUM
END

SELECT DBO.FN_SUM_CREDITS_DEPARTMENT()

--14. Write a table-valued function that returns all courses taught by faculty with a specific designation.
CREATE FUNCTION FN_Courses_By_Faculty_Designation(@Designation VARCHAR(50))
RETURNS TABLE
AS
RETURN
(
    SELECT DISTINCT
        C.CourseID,
        C.CourseName,
        C.CourseCredits,
        C.CourseDepartment,
        C.CourseSemester
    FROM FACULTY F JOIN COURSE_ASSIGNMENT CA 
	ON F.FacultyID = CA.FacultyID
    JOIN COURSE1 C ON CA.CourseID = C.CourseID
    WHERE F.FacultyDesignation = @Designation
);

SELECT * FROM DBO.FN_Courses_By_Faculty_Designation('Professor')

---------------------------------------Part - C-------------------------------------------------------- 
--15. Write a scalar function that accepts StudentID and returns their total enrolled credits (sum of credits 
--from all active enrollments).
CREATE FUNCTION FN_Total_Active_Credits(@StudentID INT)
RETURNS INT
AS
BEGIN
    DECLARE @TotalCredits INT;

    SELECT @TotalCredits = SUM(C.CourseCredits)
    FROM ENROLLMENT E
    JOIN COURSE1 C ON E.CourseID = C.CourseID
    WHERE E.StudentID = @StudentID AND E.EnrollmentStatus = 'Active';

    RETURN ISNULL(@TotalCredits, 0);  
	--Converts NULL into 0
END;

SELECT DBO.FN_Total_Active_Credits(1)

--16. Write a scalar function that accepts two dates (joining date range) and returns the count of faculty who 
--joined in that period. 
CREATE FUNCTION FN_COUNT_FACULTY_GIVEN_DATES(@STARTDATE DATE,@ENDDATE DATE)
RETURNS INT
AS
BEGIN
    DECLARE @FACULTYCOUNT INT;

    SELECT @FACULTYCOUNT = COUNT(FacultyID)
    FROM FACULTY
    WHERE FacultyJoiningDate 
          BETWEEN @STARTDATE AND @ENDDATE;

    RETURN ISNULL(@FACULTYCOUNT, 0);  --Converts NULL into 0
END;

SELECT DBO.FN_COUNT_FACULTY_GIVEN_DATES('2010-07-15 ', '2012-08-20')

