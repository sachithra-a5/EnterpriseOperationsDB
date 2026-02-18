/*
    Post-Deployment Script
    Runs once after schema deploy. :r includes are resolved at BUILD time and inlined.
    Order: Static data (respect FK order), then Jobs.
    GO statements ensure each script runs in a separate batch.
*/
:r ..\StaticData\DepartmentData.sql
GO  
:r ..\StaticData\RoleData.sql
GO
:r ..\StaticData\StatusData.sql
GO
:r ..\StaticData\PaymentMethodData.sql
GO
:r ..\Jobs\Job_Maintenance_EnterpriseOperations.sql
GO
:r ..\Jobs\Job_EmployeeStatistics.sql
GO
:r ..\Jobs\Job_ExportEmployeeData.sql
GO
