/*
    View: dbo.vw_EmployeeDetail
    Purpose: Employee list with department and status names for reporting/display.
*/
CREATE VIEW [dbo].[vw_EmployeeDetail]
AS
    SELECT
        e.[EmployeeId],
        e.[EmployeeCode],
        e.[FullName],
        e.[DepartmentId],
        d.[DepartmentCode],
        d.[DepartmentName],
        e.[StatusId],
        s.[StatusCode],
        s.[StatusName],
        e.[IsActive],
        e.[CreatedDate],
        e.[ModifiedDate]
    FROM [dbo].[Employee] e
    INNER JOIN [hr].[Department] d ON e.[DepartmentId] = d.[DepartmentId]
    INNER JOIN [config].[Status] s ON e.[StatusId] = s.[StatusId];
