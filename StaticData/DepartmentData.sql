/*
    StaticData\DepartmentData.sql
    Seed data for hr.Department.
    Common data runs in all environments; environment-specific blocks run only when $(Environment) matches.
    SQLCMD variable $(Environment) is set in the Publish Profile (Dev, UAT, Prod).
*/
PRINT 'DepartmentData: Environment = $(Environment)';

-- ========== COMMON DATA (all environments) ==========
IF NOT EXISTS (SELECT 1 FROM hr.Department WHERE DepartmentCode = 'HR')
BEGIN
    INSERT INTO hr.Department (DepartmentCode, DepartmentName, CreatedDate, ModifiedDate, IsActive)
    VALUES ('HR', 'Human Resources', GETDATE(), GETDATE(), 1);
END

IF NOT EXISTS (SELECT 1 FROM hr.Department WHERE DepartmentCode = 'IT')
BEGIN
    INSERT INTO hr.Department (DepartmentCode, DepartmentName, CreatedDate, ModifiedDate, IsActive)
    VALUES ('IT', 'Information Technology', GETDATE(), GETDATE(), 1);
END

-- ========== ENVIRONMENT-SPECIFIC DATA ==========
IF '$(Environment)' = 'Dev'
BEGIN
    IF NOT EXISTS (SELECT 1 FROM hr.Department WHERE DepartmentCode = 'DEVTEST')
        INSERT INTO hr.Department (DepartmentCode, DepartmentName, CreatedDate, ModifiedDate, IsActive)
        VALUES ('DEVTEST', 'Dev Test Department', GETDATE(), GETDATE(), 1);
END
ELSE IF '$(Environment)' = 'UAT'
BEGIN
    IF NOT EXISTS (SELECT 1 FROM hr.Department WHERE DepartmentCode = 'UATONLY')
        INSERT INTO hr.Department (DepartmentCode, DepartmentName, CreatedDate, ModifiedDate, IsActive)
        VALUES ('UATONLY', 'UAT Only Department', GETDATE(), GETDATE(), 1);
END
ELSE IF '$(Environment)' = 'Prod'
BEGIN
    -- Production-only departments if needed.
    SET NOCOUNT ON;
END
