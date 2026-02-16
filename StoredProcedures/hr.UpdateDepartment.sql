/*
    Stored Procedure: hr.UpdateDepartment
    Purpose: Update an existing department by DepartmentId.
*/
CREATE PROCEDURE [hr].[UpdateDepartment]
    @DepartmentId INT,
    @DepartmentCode NVARCHAR(20) = NULL,
    @DepartmentName NVARCHAR(100) = NULL,
    @IsActive BIT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE [hr].[Department]
    SET
        [DepartmentCode] = ISNULL(@DepartmentCode, [DepartmentCode]),
        [DepartmentName] = ISNULL(@DepartmentName, [DepartmentName]),
        [IsActive] = ISNULL(@IsActive, [IsActive]),
        [ModifiedDate] = GETDATE()
    WHERE [DepartmentId] = @DepartmentId;
END;
GO
