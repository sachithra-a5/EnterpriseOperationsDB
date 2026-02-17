/*
    Stored Procedure: dbo.usp_GetEmployeesByDepartment
    Purpose: Return employee details for a given department (for lists, reports, APIs).
    Uses vw_EmployeeDetail; filters by DepartmentId and optionally by IsActive.
*/
CREATE PROCEDURE [dbo].[usp_GetEmployeesByDepartment]
    @DepartmentId    INT,
    @IncludeInactive BIT = 0
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        [EmployeeId],
        [EmployeeCode],
        [FullName],
        [EmailAddress],
        [DepartmentId],
        [DepartmentCode],
        [DepartmentName],
        [StatusId],
        [StatusCode],
        [StatusName],
        [IsActive],
        [CreatedDate],
        [ModifiedDate]
    FROM [dbo].[vw_EmployeeDetail]
    WHERE [DepartmentId] = @DepartmentId
      AND ([IsActive] = 1 OR @IncludeInactive = 1)
    ORDER BY [EmployeeCode];
END;
GO
