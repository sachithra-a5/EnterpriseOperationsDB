/*
    StaticData\RoleData.sql
    Seed data for hr.Role. Depends on hr.Department (DepartmentData.sql should run first in PostDeployment).
*/
PRINT 'RoleData: Environment = $(Environment)';

-- ========== COMMON DATA (all environments) ==========
IF NOT EXISTS (SELECT 1 FROM hr.Role WHERE RoleCode = 'ADMIN')
BEGIN
    INSERT INTO hr.Role (RoleCode, RoleName, DepartmentId, CreatedDate, ModifiedDate, IsActive)
    SELECT 'ADMIN', 'Administrator', DepartmentId, GETDATE(), GETDATE(), 1
    FROM hr.Department WHERE DepartmentCode = 'HR';
END

IF NOT EXISTS (SELECT 1 FROM hr.Role WHERE RoleCode = 'USER')
BEGIN
    INSERT INTO hr.Role (RoleCode, RoleName, DepartmentId, CreatedDate, ModifiedDate, IsActive)
    SELECT 'USER', 'Standard User', DepartmentId, GETDATE(), GETDATE(), 1
    FROM hr.Department WHERE DepartmentCode = 'HR';
END

-- ========== ENVIRONMENT-SPECIFIC DATA ==========
IF '$(Environment)' = 'Dev'
BEGIN
    IF NOT EXISTS (SELECT 1 FROM hr.Role WHERE RoleCode = 'DEVROLE')
        INSERT INTO hr.Role (RoleCode, RoleName, DepartmentId, CreatedDate, ModifiedDate, IsActive)
        SELECT 'DEVROLE', 'Dev Only Role', DepartmentId, GETDATE(), GETDATE(), 1
        FROM hr.Department WHERE DepartmentCode = 'HR';
END
ELSE IF '$(Environment)' = 'UAT'
BEGIN
    IF NOT EXISTS (SELECT 1 FROM hr.Role WHERE RoleCode = 'UATROLE')
        INSERT INTO hr.Role (RoleCode, RoleName, DepartmentId, CreatedDate, ModifiedDate, IsActive)
        SELECT 'UATROLE', 'UAT Only Role', DepartmentId, GETDATE(), GETDATE(), 1
        FROM hr.Department WHERE DepartmentCode = 'HR';
END
ELSE IF '$(Environment)' = 'Prod'
BEGIN
    -- Production-only roles if needed.
    SET NOCOUNT ON;
END
