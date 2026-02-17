/*
    View: dbo.vw_EmployeeSummary
    Purpose: Active employees only, with key columns for lists and reporting (code, name, email, department, status).
    Filter: IsActive = 1 so only current employees are returned.
*/
CREATE VIEW [dbo].[vw_EmployeeSummary]
AS
    SELECT
        e.[EmployeeId],
        e.[EmployeeCode],
        e.[FullName],
        e.[EmailAddress],
        d.[DepartmentCode],
        d.[DepartmentName],
        s.[StatusCode],
        s.[StatusName]
    FROM [dbo].[Employee] e
    INNER JOIN [hr].[Department] d
        ON e.[DepartmentId] = d.[DepartmentId]
    INNER JOIN [config].[Status] s
        ON e.[StatusId] = s.[StatusId]
    WHERE e.[IsActive] = 1;
