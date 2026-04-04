--Part – A 
--1. Handle Divide by Zero Error and Print message like: Error occurs that is - Divide by zero error. 
BEGIN TRY
    DECLARE @a INT = 10, @b INT = 0;
    DECLARE @result INT;

    SET @result = @a / @b;

    PRINT 'Result = ' + CAST(@result AS VARCHAR);
END TRY
BEGIN CATCH
    PRINT 'Error occurs that is - Divide by zero error.';
END CATCH;


--2. Try to convert string to integer and handle the error using try…catch block. 
BEGIN TRY
    DECLARE @str VARCHAR(10) = 'ABC';
    DECLARE @num INT;

    SET @num = CAST(@str AS INT);

    PRINT 'Converted Number = ' + CAST(@num AS VARCHAR);
END TRY
BEGIN CATCH
    PRINT 'Error: Cannot convert string to integer.';
END CATCH;


--3. Create a procedure that prints the sum of two numbers: take both numbers as integer & handle 
--exception with all error functions if any one enters string value in numbers otherwise print result. 
CREATE PROCEDURE SumTwoNumbers
    @num1 VARCHAR(10),
    @num2 VARCHAR(10)
AS
BEGIN
    BEGIN TRY
        DECLARE @a INT, @b INT, @sum INT;

        SET @a = CAST(@num1 AS INT);
        SET @b = CAST(@num2 AS INT);

        SET @sum = @a + @b;

        PRINT 'Sum = ' + CAST(@sum AS VARCHAR);
    END TRY
    BEGIN CATCH
        PRINT 'Error Number: ' + CAST(ERROR_NUMBER() AS VARCHAR);
        PRINT 'Error Message: ' + ERROR_MESSAGE();
        PRINT 'Severity: ' + CAST(ERROR_SEVERITY() AS VARCHAR);
        PRINT 'State: ' + CAST(ERROR_STATE() AS VARCHAR);
    END CATCH
END;


--4. Handle a Primary Key Violation while inserting data into student table and print the error details such 
--as the error message, error number, severity, and state. 
BEGIN TRY
    INSERT INTO Student(StudentID, Name)
    VALUES (1, 'Smit'); -- Duplicate ID
END TRY
BEGIN CATCH
    PRINT 'Error Message: ' + ERROR_MESSAGE();
    PRINT 'Error Number: ' + CAST(ERROR_NUMBER() AS VARCHAR);
    PRINT 'Severity: ' + CAST(ERROR_SEVERITY() AS VARCHAR);
    PRINT 'State: ' + CAST(ERROR_STATE() AS VARCHAR);
END CATCH;


--5. Throw custom exception using stored procedure which accepts StudentID as input & that throws 
--Error like no StudentID is available in database. 
CREATE PROCEDURE CheckStudent
    @StudentID INT
AS
BEGIN
    IF NOT EXISTS (SELECT * FROM Student WHERE StudentID = @StudentID)
    BEGIN
        THROW 50001, 'No StudentID is available in database.', 1;
    END
    ELSE
    BEGIN
        PRINT 'Student exists.';
    END
END;


--6. Handle a Foreign Key Violation while inserting data into Enrollment table and print appropriate error 
--message. 
BEGIN TRY
    INSERT INTO Enrollment(StudentID, CourseID)
    VALUES (999, 101); -- Invalid StudentID
END TRY
BEGIN CATCH
    PRINT 'Foreign Key Violation Occurred!';
    PRINT 'Error Message: ' + ERROR_MESSAGE();
END CATCH;


--Part – B 
--7. Handle Invalid Date Format 
BEGIN TRY
    DECLARE @date DATE;

    SET @date = CAST('32-13-2024' AS DATE);

    PRINT 'Valid Date';
END TRY
BEGIN CATCH
    PRINT 'Invalid Date Format!';
END CATCH;


--8. Procedure to Update faculty’s Email with Error Handling. 
CREATE PROCEDURE UpdateFacultyEmail
    @FacultyID INT,
    @Email VARCHAR(100)
AS
BEGIN
    BEGIN TRY
        UPDATE Faculty
        SET Email = @Email
        WHERE FacultyID = @FacultyID;

        PRINT 'Email Updated Successfully';
    END TRY
    BEGIN CATCH
        PRINT 'Error updating email: ' + ERROR_MESSAGE();
    END CATCH
END;


--9. Throw custom exception that throws error if the data is invalid. 
CREATE PROCEDURE InsertStudent
    @StudentID INT,
    @Age INT
AS
BEGIN
    IF @Age <= 0
    BEGIN
        THROW 50002, 'Invalid Data: Age must be greater than 0.', 1;
    END

    INSERT INTO Student(StudentID, Age)
    VALUES (@StudentID, @Age);
END;


--Part – C 
--10. Write a script that checks if a faculty’s salary is NULL. If it is, use RAISERROR to show a message with a 
--severity of 16. (Note: Do not use any table)
DECLARE @Salary INT = NULL;

IF @Salary IS NULL
BEGIN
    RAISERROR('Salary is NULL. Please provide a valid salary.', 16, 1);
END
ELSE
BEGIN
    PRINT 'Salary is valid';
END;