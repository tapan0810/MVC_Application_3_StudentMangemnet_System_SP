--CREATE TABLE CLASS(

	--ClassId INT IDENTITY(1,1) PRIMARY KEY,
	--ClassName VARCHAR(20) NOT NULL,
	--MentorName VARCHAR(200) NOT NULL,
	--IsActive BIT NOT NULL
--);


-- CREATE TABLE Student(

	--StudentId INT IDENTITY(1,1) PRIMARY KEY,
	--StudentName VARCHAR(200) NOT NULL,
	--Adress VARCHAR(200) NOT NULL,
	--Email VARCHAR(200) UNIQUE,
	----PhoneNumber VARCHAR(15),
	--ClassId INT,

	--CONSTRAINT FK_Class_Students
		--FOREIGN KEY(ClassId)
		--REFERENCES Class(ClassId)

--);

-- **************************************************************************************

-- CLASS Related SPs:

--***************************************************************************************

--Stored Procedure for Get Class Deatails
	CREATE OR ALTER PROCEDURE
	dbo.usp_GetAll_Class_Details
	AS
	BEGIN
		SET NOCOUNT ON;
		SET XACT_ABORT ON;

		BEGIN TRY
			select * 
			from dbo.CLASS
			order by ClassId;
		END TRY

		BEGIN CATCH
			;THROW;
		END CATCH
	END;
	GO
--Stored Procedure for Get Class By ID
	CREATE OR ALTER PROCEDURE
	dbo.usp_Get_Class_By_Id
		@ClassId INT
	AS
	BEGIN

		SET NOCOUNT ON;

		BEGIN TRY
			--validate input
			IF @ClassId <= 0
			BEGIN
				;THROW 50001,'ClassId must be greater than 0.',1;
			END;

			--Fetch Class Details
			select * from
			dbo.CLASS
			where ClassId = @ClassId;
		END TRY

		BEGIN CATCH
			;THROW;
		END CATCH


	END;
	GO

--Stored Procedure to Add New Class 
	CREATE OR ALTER PROCEDURE
	dbo.usp_Create_Class
		@ClassName VARCHAR(20),
		@Mentor VARCHAR(200),
		@IsActive BIT = 1	
	AS
	BEGIN
		SET NOCOUNT ON;
		SET XACT_ABORT ON;

		BEGIN TRY

		--validate input
		IF NULLIF(LTRIM(RTRIM(@ClassName)),'')
		IS NULL
			BEGIN
				;THROW 50001,'ClassName is required.',1;
			END;

		IF NULLIF(LTRIM(RTRIM(@Mentor)),'')
		IS NULL
			BEGIN
				;THROW 50002,'Mentor Name is required.',1;
			END;

		--start transaction
		BEGIN TRANSACTION;

		-- check duplicate class
		IF EXISTS
		(
			select 1 
			from dbo.CLASS
			where ClassName = @ClassName
		)
		BEGIN
			;THROW 50003, 'Class already exists.',1;
		END;

		-- insert class
		INSERT INTO dbo.CLASS
		(
			ClassName,
			MentorName,
			IsActive
		)
		values
		(
			LTRIM(RTRIM(@ClassName)),
			LTRIM(RTRIM(@Mentor)),
			@IsActive
		);

		-- commit transaction
		COMMIT TRANSACTION;

		--return newly created ClassId
		SELECT
			CAST(SCOPE_IDENTITY() AS INT)AS ClassId;

		END TRY

		BEGIN CATCH

		--rrollback if transaction is active
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION;

			-- send original error back to application
			;THROW;
		END CATCH
	END;
	GO

--Stored Procedure to Delete A Class

--Stored Procedure to Edit Class Deatils

--***************************************************************************************
-- Student Related SPs:
--***************************************************************************************

--Stored Procedure for Get All Students Deatails
--Stored Procedure for Get Student By ID
--Stored Procedure to Add New Student 
--Stored Procedure to Search for a Student
--Stored Procedure to Delete A Student
--Stored Procedure to Edit Student Deatils
