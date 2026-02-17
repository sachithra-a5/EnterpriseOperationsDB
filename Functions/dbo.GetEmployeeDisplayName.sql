/*
    Function: dbo.GetEmployeeDisplayName
    Purpose: Return a display name for the given EmployeeId: "FullName (EmployeeCode)", or NULL if not found or @EmployeeId is NULL.
    Only active employees (IsActive = 1). Trims spaces from FullName.
*/
CREATE FUNCTION [dbo].[GetEmployeeDisplayName] (@EmployeeId INT)
RETURNS NVARCHAR(550)
AS
BEGIN
    DECLARE @DisplayName NVARCHAR(550) = NULL;

    IF @EmployeeId IS NOT NULL
    BEGIN
        SELECT @DisplayName = LTRIM(RTRIM([FullName])) + N' (' + [EmployeeCode] + N')'
        FROM [dbo].[Employee]
        WHERE [EmployeeId] = @EmployeeId
          AND [IsActive] = 1;
    END;

    RETURN @DisplayName;
END;
GO
