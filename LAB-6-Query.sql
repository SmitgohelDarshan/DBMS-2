--Table : Log(LogMessage varchar(100), logDate Datetime) 
CREATE TABLE Log(LogMessage varchar(100), logDate Datetime)

--Part – A 
--1. Create trigger for printing appropriate message after student registration.
CREATE OR ALTER TRIGGER TR_STUDENT_MSG
ON STUDENT
AFTER INSERT
AS
BEGIN
	PRINT 'Student Register successfully.'
END

INSERT INTO STUDENT VALUES (40, 'SMIT', 'SMIT@GMAIL.COM', '1234567890', 'CSE', '2002-02-04', 2026, 8.90)
DROP TRIGGER TR_STUDENT_MSG

--2. Create trigger for printing appropriate message after faculty deletion. 
CREATE OR ALTER TRIGGER TR_FACULTY_DELETE
ON FACULTY
AFTER DELETE
AS
BEGIN
	PRINT 'Faculty Delete successfully.'
END

DELETE FROM FACULTY
WHERE FacultyID = 107

DROP TRIGGER TR_FACULTY_DELETE

--3. Create trigger for monitoring all events on course table. (print only appropriate message) 
CREATE OR ALTER TRIGGER TR_COURSE_EVENTS
ON COURSE1
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    IF EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted)
        PRINT 'Course updated successfully';
    ELSE IF EXISTS (SELECT * FROM inserted)
        PRINT 'Course inserted successfully';
    ELSE IF EXISTS (SELECT * FROM deleted)
        PRINT 'Course deleted successfully';
END

DELETE FROM COURSE1
WHERE CourseID = 'CS101'

DROP TRIGGER TR_COURSE_EVENTS

--4. Create trigger for logging data on new student registration in Log table. 
CREATE OR ALTER TRIGGER TR_STUDENT_REG
ON STUDENT
AFTER INSERT
AS
BEGIN
	INSERT INTO Log VALUES ('DATA INSERTED', GETDATE())
END

INSERT INTO STUDENT VALUES (30, 'SMIT', 'SMIT@GMAIL.COM', '1234567890', 'CSE', '2002-02-04', 2026, 8.90)

SELECT * FROM Log

DROP TRIGGER TR_STUDENT_REG

--5. Create trigger for auto-uppercasing faculty names. 
CREATE OR ALTER TRIGGER TR_FACULTY_NAME
ON FACULTY
AFTER INSERT
AS
BEGIN
	DECLARE @FID INT, @FNAME VARCHAR(50)
	SELECT @FID = FacultyID, @FNAME = FacultyName FROM inserted
	UPDATE FACULTY
	SET FacultyName = UPPER(@FNAME)
	WHERE FacultyID = @FID
END


INSERT INTO FACULTY VALUES (131, 'drpatel', 'PATEL@GMAIL.COM', 'CSE', 'PRO', '2026-01-27')
SELECT * FROM FACULTY

DROP TRIGGER TR_FACULTY_NAME

--6. Create trigger for calculating faculty experience (Note: Add required column in faculty table) 
CREATE OR ALTER TRIGGER TR_FACULTY_EXP
ON FACULTY
AFTER INSERT
AS
BEGIN
	DECLARE @FID INT, @FJDATE VARCHAR(50)
	SELECT @FID = FacultyID, @FJDATE = FacultyJoiningDate FROM inserted
	UPDATE FACULTY
	SET EXPERIENCE = DATEDIFF(YEAR, @FJDATE, GETDATE())
	WHERE FacultyID = @FID
END

ALTER TABLE FACULTY ADD EXPERIENCE INT
INSERT INTO FACULTY VALUES (135, 'drpatel', 'PATEL@GMAIL.COM', 'CSE', 'PRO', '2026-01-27', NULL)
SELECT * FROM FACULTY

DROP TRIGGER TR_FACULTY_EXP

--Part – B 
--7. Create trigger for auto-stamping enrollment dates. 
CREATE OR ALTER TRIGGER TR_ENROLLMENT_EXP
ON ENROLLMENT
AFTER INSERT
AS
BEGIN
	DECLARE @EID INT, @EDATE VARCHAR(50)
	SELECT @EID = EnrollmentID, @EDATE = EnrollmentDate FROM inserted
	UPDATE ENROLLMENT
	SET EnrollmentDate = GETDATE()
	WHERE EnrollmentID = @EID
END

DROP TRIGGER TR_ENROLLMENT_EXP

--8. Create trigger for logging data After course assignment - log course and faculty detail. 
CREATE OR ALTER TRIGGER TR_COURSE_LOG
ON COURSE1
AFTER INSERT
AS
BEGIN
    INSERT INTO Log
    SELECT 
        'Course ' + CourseID + ' assigned to faculty ' + CAST(FacultyID AS VARCHAR),
        GETDATE()
    FROM inserted;
END

--Part - C 
--9. Create trigger for updating student phone and print the old and new phone number. 
CREATE OR ALTER TRIGGER TR_STUDENT_PHONE
ON STUDENT
AFTER UPDATE
AS
BEGIN
    IF UPDATE(Phone)
    BEGIN
        SELECT 
            'Old Phone: ' + D.Phone + 
            ' New Phone: ' + I.Phone AS PhoneChange
        FROM deleted D
        JOIN inserted I ON D.StudentID = I.StudentID;
    END
END

--10. Create trigger for updating course credit log old and new credits in log table. 
CREATE OR ALTER TRIGGER TR_COURSE_CREDIT_LOG
ON COURSE1
AFTER UPDATE
AS
BEGIN
    IF UPDATE(Credits)
    BEGIN
        INSERT INTO Log
        SELECT 
            'Credits changed from ' + 
            CAST(D.Credits AS VARCHAR) + 
            ' to ' + 
            CAST(I.Credits AS VARCHAR),
            GETDATE()
        FROM deleted D
        JOIN inserted I ON D.CourseID = I.CourseID;
    END
END
