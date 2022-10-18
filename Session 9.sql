--No 1
-- Create a store procedure with named ‘sp1’ to display CustomerId, CustomerName, CustomerGender, and CustomerAddress for every Customer with Id based on user’s input
CREATE PROCEDURE sp1 @id CHAR(5) AS
BEGIN
SELECT CustomerId,
	   CustomerName,
	   CustomerGender,
	   CustomerAddress
FROM MsCustomer
WHERE CustomerId = @id
END;

EXECUTE sp1 'CU001'

--No 2
--If the length of CustomerName is odd then procedure will give output ‘Character Length of Mentor Name is an Odd Number’
--If the length of CustomerName is even then procedure will display CustomerId, CustomerName, CustomerGender, TransactionId, and TransactionDate 
--for every transaction with customer whose name contains the name that was inputted by user
CREATE PROCEDURE sp2 @name VARCHAR(50) AS
BEGIN
IF LEN(@name) % 2 = 1
	BEGIN
	PRINT 'Character Length of Mentor Name is an Odd Number'
	END
ELSE
	BEGIN
	SELECT MsCustomer.CustomerId,
		   MsCustomer.CustomerName,
		   MsCustomer.CustomerGender,
		   TransactionId,
		   TransactionDate
	FROM MsCustomer
		 JOIN HeaderSalonServices ON HeaderSalonServices.CustomerId = MsCustomer.CustomerId
	WHERE CustomerName LIKE '%' + @name + '%'
	END
END;

EXECUTE sp2 'Elysia Chen'
EXECUTE sp2 'Fran'

--No 3
--Create a store procedure named ‘sp3’ to update StaffId, StaffName, StaffGender, and StaffPhone on MsStaff table based on StaffId, StaffName, StaffGender, and StaffPhone that was inputted by user
--Then display the updated data if the StaffId exists in MsStaff table. Otherwise show message ‘Staff does not exists’
CREATE PROCEDURE sp3 @id CHAR(5), @name VARCHAR(50), @gender VARCHAR(10), @phone VARCHAR(13) AS
BEGIN
IF EXISTS(
	SELECT StaffId
	FROM  MsStaff 
	WHERE StaffId = @id AND
		  StaffName = @name AND
		  StaffGender = @gender AND
		  StaffPhone = @phone
   )
	BEGIN
	UPDATE MsStaff
	SET StaffId = @id,
		StaffName = @name,
		StaffGender = @gender,
		StaffPhone = @phone
	WHERE StaffId = @id
	SELECT *
	FROM MsStaff
	WHERE StaffId = @id
	END
ELSE
	BEGIN
    PRINT 'Staff does not exists'
    END
    SELECT  *
    FROM    MsStaff
    END;

EXEC sp3 'SF005', 'Ryan Nixon', 'M', '08567756123'
EXEC sp3 'SF008', 'Ryan Nixon', 'M', '08567756123'

--No 4
--Create trigger named ‘trig1’ for MsCustomer table to validate if there are any data which had been updated, it will display before and after updated data on MsCustomer table
CREATE TRIGGER trig1
ON MsCustomer
FOR UPDATE AS
BEGIN
SELECT * FROM INSERTED
UNION
SELECT * FROM DELETED
END

SELECT *
FROM MsCustomer

BEGIN TRANSACTION
UPDATE MsCustomer
SET CustomerName = 'Franky Quo'
WHERE CustomerId = 'CU001'
SELECT * FROM MsCustomer
ROLLBACK

--No 5
--Create trigger with name ‘trig2’ for MsCustomer table to validate if there are any new inserted data, then the first data on MsCustomer will be deleted
CREATE TRIGGER trig2
ON MsCustomer
AFTER UPDATE AS
BEGIN
DELETE TOP(1)
FROM MsCustomer
END

BEGIN TRANSACTION
INSERT INTO MsCustomer(
	CustomerId, 
    CustomerName, 
	CustomerGender, 
	CustomerPhone,
	CustomerAddress
)
VALUES(
	'CU006',
	'Yogie Soesanto',
    'Male',
	'085562133000',
	'Pelsakih Street no 52'
)
SELECT *
FROM MsCustomer
ROLLBACK

SELECT *
FROM MsCustomer

--No 6
--Create trigger with name ‘trig3’ on MsCustomer table to validate if the data on MsCustomer table is deleted, then the deleted data will be insert into Removed table
--If Removed table hasn’t been created, then create the Removed table and insert the deleted data to Removed table
CREATE TRIGGER trig3
ON MsCustomer
FOR DELETE AS
BEGIN
IF OBJECT_ID('REMOVED') IS NOT NULL
	BEGIN
	INSERT INTO [REMOVED]
	SELECT *
	FROM MsCustomer
	END
ELSE
	BEGIN
	SELECT * 
	INTO [REMOVED] 
	FROM MsCustomer
	END
END

BEGIN TRANSACTION
DELETE FROM MsCustomer
WHERE CustomerId = 'CU002'
SELECT * FROM MsCustomer
SELECT * FROM [REMOVED]
ROLLBACK

--No 7
--Create cursor with name ‘cur1’ to validate whether the length of StaffName is odd or even then show the message about result
DECLARE @name VARCHAR(50)

DECLARE cur1 CURSOR
FOR 
SELECT StaffName 
FROM MsStaff

OPEN cur1
FETCH NEXT FROM cur1 INTO @name

IF @@FETCH_STATUS <> 0
	PRINT 'Cursor Fetch Failed!'

WHILE @@FETCH_STATUS = 0
BEGIN
IF LEN(@name) % 2 = 0
	BEGIN
	PRINT 'The length from StaffName ' + @name + ' is an odd number'
	END
ELSE
	BEGIN
	PRINT 'The length from StaffName ' + @name + ' is an even number'
	END
FETCH NEXT FROM cur1 INTO @name
END

CLOSE cur1
DEALLOCATE cur1

--No 8
--Create procedure named ‘sp4’ that receive StaffName from user’s input to display StaffName and StaffPosition for every staff which name contains the word that has been inputted by user
CREATE PROCEDURE sp4 @search VARCHAR(50) AS
BEGIN
DECLARE cur2 CURSOR
FOR
SELECT StaffName, 
	   StaffPosition
FROM    MsStaff
WHERE   StaffName LIKE '%' + @search + '%'
            
DECLARE @name VARCHAR(50),
        @position VARCHAR(20)
           
OPEN cur2
            
FETCH NEXT FROM cur2 INTO @name, @position

IF @@FETCH_STATUS <> 0
	PRINT 'Cursor Fetch Failed!'
    WHILE @@FETCH_STATUS = 0
	BEGIN
	PRINT 'StaffName : ' + @name + ' : ' + @position
	FETCH NEXT FROM [cur2] INTO @name, @position
	END
	CLOSE cur2
    DEALLOCATE cur2
END

EXEC sp4 'a'

DROP PROCEDURE sp4

--No 9
--Create procedure with name ‘sp5’ that receive CustomerId from user’s input to display CustomerName, and TransactionDate for every customer 
--which Id has been inputted by user and did treatment which ID is an even number
CREATE PROCEDURE sp5 @id CHAR(5) AS
BEGIN
DECLARE cur3 CURSOR
FOR
SELECT MsCustomer.CustomerName,
	   HeaderSalonServices.TransactionDate
FROM MsCustomer
	 JOIN HeaderSalonServices ON MsCustomer.CustomerId = HeaderSalonServices.CustomerId
WHERE   MsCustomer.CustomerId IN (@id)
                
DECLARE @nama VARCHAR(50),
        @date DATE
            
OPEN cur3

FETCH NEXT FROM cur3 INTO @nama, @date

IF @@FETCH_STATUS <> 0
	PRINT 'Cursor Fetch Failed!'
    WHILE @@FETCH_STATUS = 0
	BEGIN
	PRINT 'Customer Name : ' + @nama + ' Transaction Date is ' + CAST(@date AS VARCHAR)
	FETCH NEXT FROM cur3 INTO @nama, @date
	END
	CLOSE cur3
	DEALLOCATE cur3
END

EXEC sp5 'CU001'

--No 10
--Delete all procedure and trigger that has been made
DROP PROCEDURE sp1, sp2, sp3, sp4, sp5
DROP TRIGGER trig1, trig2, trig3

