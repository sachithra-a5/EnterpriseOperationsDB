/*
    Function: dbo.GetEmployeeDisplayName
    Purpose: Returns the FullName for the given EmployeeId, or NULL if not found.
*/
CREATE FUNCTION [dbo].[GetEmployeeDisplayName] (@EmployeeId INT)
RETURNS NVARCHAR(200)
AS
BEGIN
    DECLARE @FullName NVARCHAR(200);

    SELECT @FullName = [FullName]
    FROM [dbo].[Employee]
    WHERE [EmployeeId] = @EmployeeId
      AND [IsActive] = 1;

    RETURN @FullName;
END;
GO
