/*
    Stored Procedure: hr.InsertDepartment
    Purpose: Insert a new department into hr.Department.
*/
CREATE PROCEDURE [hr].[InsertDepartment]
    @DepartmentCode NVARCHAR(20),
    @DepartmentName NVARCHAR(100),
    @IsActive BIT = 1,
    @DepartmentId INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO [hr].[Department] ([DepartmentCode], [DepartmentName], [CreatedDate], [ModifiedDate], [IsActive])
    VALUES (@DepartmentCode, @DepartmentName, GETDATE(), GETDATE(), @IsActive);

    SET @DepartmentId = SCOPE_IDENTITY();
END;
GO
