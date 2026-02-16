/*
    Stored Procedure: hr.SelectDepartments
    Purpose: Select departments; optionally filter by IsActive.
*/
CREATE PROCEDURE [hr].[SelectDepartments]
    @IsActive BIT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        [DepartmentId],
        [DepartmentCode],
        [DepartmentName],
        [CreatedDate],
        [ModifiedDate],
        [IsActive]
    FROM [hr].[Department]
    WHERE (@IsActive IS NULL OR [IsActive] = @IsActive)
    ORDER BY [DepartmentCode];
END;
GO
