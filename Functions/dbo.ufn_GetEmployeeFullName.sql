/*
    Function: dbo.ufn_GetEmployeeFullName
    Purpose: Return the FullName for the given EmployeeId, or NULL if not found or @EmployeeId is NULL.
    Uses dbo.Employee.FullName (single column; no FirstName/LastName in this schema).
*/
CREATE FUNCTION [dbo].[ufn_GetEmployeeFullName] (@EmployeeId INT)
RETURNS NVARCHAR(500)
AS
BEGIN
    DECLARE @FullName NVARCHAR(500) = NULL;

    IF @EmployeeId IS NOT NULL
    BEGIN
        SELECT @FullName = [FullName]
        FROM [dbo].[Employee]
        WHERE [EmployeeId] = @EmployeeId;
    END;

    RETURN @FullName;
END;
GO
