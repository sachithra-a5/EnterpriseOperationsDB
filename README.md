# EnterpriseOperationsDB

SQL Server 2022 database project for Enterprise Operations. Built with Visual Studio 2022+ (SSDT) and targets SQL Server 2022.

## Project structure

```
EnterpriseOperationsDB/
├── Schemas/              # Database schemas (hr, config)
├── Tables/               # Table definitions (dbo, hr, config)
├── Functions/            # User-defined functions
├── StoredProcedures/     # Stored procedures (Insert, Update, Select examples)
├── Views/                # SQL views (e.g. reporting views)
├── StaticData/           # Seed/reference data (one file per entity)
├── Jobs/                 # SQL Server Agent job scripts
├── Scripts/              # Non-database scripts (e.g. PowerShell for Agent jobs)
│   └── PowerShell/       # ExportEmployeeData.ps1 and README_ExportEmployeeData.md
├── PostDeployment/       # Single post-deploy script; :r includes StaticData and Jobs
└── PublishProfiles/      # Dev, UAT, Prod publish settings
```

- **Schemas:** `hr` (HR objects), `config` (reference/configuration). `dbo` is the default.
- **Views:** One `.sql` file per view (e.g. `dbo.vw_EmployeeDetail` for employee list with department/status names).
- **StaticData:** One file per entity (e.g. `DepartmentData.sql`, `RoleData.sql`, `StatusData.sql`). No subfolders. Each file has common data (all environments) and environment-specific blocks using the `$(Environment)` SQLCMD variable.
- **PostDeployment:** Runs after schema deploy. Uses `:r` to run static data and job scripts in a fixed order (Department → Role → Status → Jobs).

## Prerequisites

- Visual Studio 2022 or later with **SQL Server Data Tools** (SSDT) / database project workload
- SQL Server 2022 (or compatible instance) for deployment
- SQL Server Agent enabled on the target server (for the maintenance job)

## Build

1. Open `EnterpriseOperationsDB.slnx` or the `.sqlproj` in Visual Studio.
2. Build the project (e.g. **Build → Rebuild Solution** or **F6**).

The build produces a `.dacpac` in `bin\Debug\` (or `bin\Release\`). SQLCMD variables `Environment` and `DatabaseName` have default values in the project so the build can validate post-deploy scripts; they are overridden at publish time by the selected profile.

## Publish (deploy)

### From Visual Studio

1. Right-click the **EnterpriseOperationsDB** project → **Publish**.
2. Choose a publish profile: **Dev**, **UAT**, or **Prod**.
3. Confirm or edit the target connection and database name.
4. Click **Publish**.

The selected profile sets the target database and the SQLCMD variable **Environment** (Dev/UAT/Prod). Static data scripts use this to insert environment-specific rows (e.g. Dev-only departments).

### Using SqlPackage (CLI)

```bash
# Build first (e.g. from Visual Studio or MSBuild), then:
SqlPackage.exe /Action:Publish `
  /SourceFile:"bin\Debug\EnterpriseOperationsDB.dacpac" `
  /Profile:"PublishProfiles\Dev.publish.xml" `
  /TargetServerName:"(localdb)\MSSQLLocalDB" `
  /TargetDatabaseName:"EnterpriseOperationsDB_Dev"
```

Override connection or variables as needed; the profile supplies `Environment` and `DatabaseName` for post-deploy scripts.

## GitHub Actions CI/CD

The repository includes a two-job pipeline for building, generating a deployment preview, and deploying to SQL Server after manual approval.

- **Workflow file:** [.github/workflows/deploy-sql-database.yml](.github/workflows/deploy-sql-database.yml)
- **Runner:** Self-hosted Windows (e.g. `runs-on: [self-hosted, windows]`).
- **Triggers:** Push to `master` and manual `workflow_dispatch`.

### Pipeline jobs

| Job | Purpose |
|-----|---------|
| **Build & Generate Script** | Checkout → MSBuild (Release) → SqlPackage **Script** (writes `deployment_preview.sql`) → SqlPackage **DeployReport** (writes `deployment_report.xml`) → upload artifact `sql-deployment-package` (preview script, report, `.dacpac`, `Scripts/PowerShell/`). |
| **SQL Deployment** | Runs after Job 1. Downloads artifact → SqlPackage **Publish** → add deployment summary to job summary → copy PowerShell scripts to `SCRIPTS_DESTINATION_PATH` → cleanup. |

Both jobs use the same environment by default (`ENV_NAME`). To require approval **only for deployment**: use two environments—e.g. **ENV_NAME** (e.g. `Dev`) for Job 1 with no required reviewers, and **DEPLOY_ENVIRONMENT** (e.g. `Dev-Deploy`) for Job 2 with required reviewers—and set the deploy job in the workflow to `environment: ${{ vars.DEPLOY_ENVIRONMENT }}`.

### Variables and secrets

Configure in **Settings → Secrets and variables → Actions** (repository and/or environment).

| Type | Name | Purpose |
|------|------|---------|
| **Variable** | `ENV_NAME` | Environment name (e.g. `Dev`). Used by both jobs for variables and display. |
| **Variable** | `DEPLOY_ENVIRONMENT` | Optional. If set, use it for Job 2 only so required reviewers apply to deploy (e.g. `Dev-Deploy`). |
| **Variable** | `DB_SERVER_NAME` | Target SQL Server instance (e.g. `localhost`, `.\SQLEXPRESS`). Set in the environment(s). |
| **Variable** | `DB_NAME` | Target database name (e.g. `EnterpriseOperationsDB_Dev`). Set in the environment(s). |
| **Variable** | `SCRIPTS_DESTINATION_PATH` | Folder path on the runner where `.ps1` files from `Scripts/PowerShell/` are copied (Job 2). |
| **Secret** | `DB_CONNECTION_STRING` | Rest of the connection string (e.g. `Integrated Security=True;` or `User Id=...;Password=...;`). Combined with `Server=` and `Database=` in the workflow. Set in the environment(s). |

### Artifacts

- After Job 1, the run has an artifact **sql-deployment-package** containing `deployment_preview.sql`, `deployment_report.xml`, the built `.dacpac`, and `Scripts/PowerShell/`. Download it to review the script before approving deployment.

## Publish profiles

| Profile   | Typical use   | SQLCMD `Environment` | Example database name           |
|----------|----------------|------------------------|----------------------------------|
| **Dev**  | Local / dev    | `Dev`                  | `EnterpriseOperationsDB_Dev`   |
| **UAT**  | UAT / staging  | `UAT`                  | `EnterpriseOperationsDB_UAT`   |
| **Prod** | Production     | `Prod`                 | `EnterpriseOperationsDB`        |

- Edit each `.publish.xml` under **PublishProfiles** to set the real server and database (and auth) for your environments.
- To avoid accidental production deploys, use Dev (or UAT) as the default and only run Publish with the Prod profile when intended.

### Example publish profile for local deployments (versioned)

A versioned example profile is kept in the repo for reference and local setups:

- **File:** [PublishProfiles/Local.Example.publish.xml](PublishProfiles/Local.Example.publish.xml)
- **Purpose:** Template for local or dev deployments. Copy to a new profile (e.g. `Dev.publish.xml`) or use as reference. The file header includes a version comment (e.g. `Version: 1.0`) for change tracking.
- **What to set:** Update `TargetConnectionString` and `TargetServerName` to your instance: `(localdb)\MSSQLLocalDB`, `.\SQLEXPRESS`, or `localhost`. Keep `SqlCmdVariable` **Environment** (Dev/UAT/Prod) and **DatabaseName** in sync with your target and static data.

## Static data and environments

- **Common data:** Inserts that run in every environment (e.g. core departments, roles, statuses). Uses `IF NOT EXISTS (...)` so scripts are idempotent and safe to re-run.
- **Environment-specific data:** Wrapped in `IF '$(Environment)' = 'Dev'` (or `UAT` / `Prod`). Only the block for the current profile’s `Environment` runs.
- **Idempotency:** All inserts are guarded by `IF NOT EXISTS` on a natural key (e.g. `DepartmentCode`, `RoleCode`, `StatusCode`) so re-publishing does not create duplicate rows.

## SQL Server Agent jobs

Post-deployment runs the job scripts under **Jobs/** in order. Each script is idempotent (creates or updates the job).

| Job | Schedule | Description |
|-----|----------|-------------|
| **Maintenance_EnterpriseOperations** | Daily 2:00 AM | T-SQL maintenance step in `$(DatabaseName)`. |
| **EmployeeStatistics_Daily** | Daily 1:15 PM | Runs `dbo.usp_CollectEmployeeStatistics` to populate `dbo.EmployeeStatistics`. |
| **Job_ExportEmployeeData** | Daily 1:00 PM | Runs **PowerShell** script `D:\SQLJobs\Powershell\ExportEmployeeData.ps1`; writes static data to `D:\SQLJobs\Output\` and logs to `D:\SQLJobs\Logs\`. |

- **Job_ExportEmployeeData:** The PowerShell script is stored in the repo at **Scripts\PowerShell\ExportEmployeeData.ps1**. Deploy a copy to **D:\SQLJobs\Powershell\ExportEmployeeData.ps1** on each server where the job runs. See **Scripts\PowerShell\README_ExportEmployeeData.md** for deployment and testing steps.

## Database objects (overview)

- **Tables:** `hr.Department`, `hr.Role`, `config.Status`, `dbo.Employee` (with FKs across schemas and audit columns: CreatedDate, ModifiedDate, IsActive).
- **Views:** `dbo.vw_EmployeeDetail` — employee list with department and status names (joins `dbo.Employee`, `hr.Department`, `config.Status`).
- **Function:** `dbo.GetEmployeeDisplayName(EmployeeId)` — returns the employee’s full name.
- **Stored procedures:** `hr.InsertDepartment`, `hr.UpdateDepartment`, `hr.SelectDepartments`.

## Best practices

- **Schemas:** Use `hr` and `config` (and `dbo`) to group objects; keeps security and ownership clear.
- **Static data:** One file per entity under **StaticData**, no subfolders. Control execution order in **PostDeployment\Script.PostDeployment.sql**.
- **Environment variable:** Use the publish profile’s `Environment` so one set of scripts works for Dev, UAT, and Prod.
- **Idempotent scripts:** Always use `IF NOT EXISTS` (or equivalent) for static data inserts.
- **Re-publishing:** Deploying again when objects (tables, views, etc.) already exist is safe. SSDT compares the project to the target and only updates what changed (e.g. views are dropped and recreated if their definition changed). View-level permissions are lost on view updates; use schema-level grants or a post-deploy script if you need to preserve them.
- **Source control:** Commit `.sqlproj`, all `.sql` files, and publish profiles. Use placeholder or safe connection strings; avoid storing production passwords in the repo.

## License

Internal / use as per your organization’s policy.
