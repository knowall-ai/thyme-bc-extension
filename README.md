<p align="center">
  <img src="images/hero.svg" alt="Thyme BC Extension" width="100%">
</p>

<p align="center">
  <a href="https://github.com/knowall-ai/thyme">Thyme App</a> •
  <a href="https://thyme.knowall.ai">Website</a> •
  <a href="https://learn.microsoft.com/en-us/dynamics365/business-central/dev-itpro/developer/devenv-develop-custom-api">BC API Docs</a>
</p>

---

Custom Business Central API endpoints for the [Thyme](https://github.com/knowall-ai/thyme) time tracking app.

## Why This Extension?

The standard BC API v2.0 `/projects` endpoint only returns 4 fields:
- `id`, `number`, `displayName`, `lastModifiedDateTime`

This extension exposes additional fields needed by Thyme:
- Customer name and number
- Person responsible
- Project status and dates
- Job tasks
- Time sheets with approval status (Open, Submitted, Approved, Rejected)
- Resources with capacity information
- Posted time entries from Job Ledger

## API Endpoints

Once deployed, the APIs are available at:

```
.../api/knowall/thyme/v1.0/companies({companyId})/projects
.../api/knowall/thyme/v1.0/companies({companyId})/jobTasks
.../api/knowall/thyme/v1.0/companies({companyId})/timeSheets
.../api/knowall/thyme/v1.0/companies({companyId})/timeSheetLines
.../api/knowall/thyme/v1.0/companies({companyId})/resources
.../api/knowall/thyme/v1.0/companies({companyId})/timeEntries
```

Base URL: `https://api.businesscentral.dynamics.com/v2.0/{tenant}/{environment}`

### Projects API

| Field | Description |
|-------|-------------|
| `id` | System GUID |
| `number` | Job No. |
| `description` | Project description |
| `billToCustomerNo` | Customer number |
| `billToCustomerName` | Customer name |
| `personResponsible` | Project manager |
| `status` | Planning, Quote, Open, Completed |
| `startingDate` | Project start date |
| `endingDate` | Project end date |
| `lastModifiedDateTime` | Last modified timestamp |

### Job Tasks API

| Field | Description |
|-------|-------------|
| `id` | System GUID |
| `jobNo` | Parent job number |
| `jobTaskNo` | Task number |
| `description` | Task description |
| `jobTaskType` | Posting, Heading, Total, Begin-Total, End-Total |
| `lastModifiedDateTime` | Last modified timestamp |

### Time Sheets API

| Field | Description |
|-------|-------------|
| `id` | System GUID |
| `number` | Time sheet number |
| `startingDate` | Week starting date |
| `endingDate` | Week ending date |
| `resourceNo` | Resource number |
| `ownerUserId` | Owner user ID |
| `approverUserId` | Approver user ID |
| `lastModifiedDateTime` | Last modified timestamp |

**Bound Actions:**
- `POST /timeSheets({id})/Microsoft.NAV.submit` - Submit for approval
- `POST /timeSheets({id})/Microsoft.NAV.approve` - Approve time sheet
- `POST /timeSheets({id})/Microsoft.NAV.reject` - Reject time sheet
- `POST /timeSheets({id})/Microsoft.NAV.reopen` - Reopen for editing

### Time Sheet Lines API

| Field | Description |
|-------|-------------|
| `id` | System GUID |
| `timeSheetNo` | Parent time sheet number |
| `lineNo` | Line number |
| `timeSheetStartingDate` | Time sheet starting date |
| `type` | Resource, Job, Absence, Assembly Order, Service |
| `jobNo` | Job number (if type=Job) |
| `jobTaskNo` | Job task number (if type=Job) |
| `description` | Line description |
| `totalQuantity` | Total hours |
| `status` | Open, Submitted, Rejected, Approved |
| `approvedBy` | User who approved |
| `approvalDate` | Date approved |
| `posted` | Whether posted to ledger |
| `lastModifiedDateTime` | Last modified timestamp |

**Bound Actions:**
- `POST /timeSheetLines({id})/Microsoft.NAV.approve` - Approve line
- `POST /timeSheetLines({id})/Microsoft.NAV.reject` - Reject line
- `POST /timeSheetLines({id})/Microsoft.NAV.reopen` - Reopen for editing

### Resources API

| Field | Description |
|-------|-------------|
| `id` | System GUID |
| `number` | Resource No. |
| `name` | Resource name |
| `type` | Person or Machine |
| `capacity` | Weekly hours capacity |
| `baseUnitOfMeasure` | Hour/Day units |
| `lastModifiedDateTime` | Last modified timestamp |

### Time Entries API

| Field | Description |
|-------|-------------|
| `id` | System GUID |
| `entryNo` | Ledger entry number |
| `jobNo` | Parent job number |
| `jobTaskNo` | Task number |
| `postingDate` | Entry posting date |
| `type` | Entry type (Resource) |
| `number` | Resource/item number |
| `description` | Entry description |
| `quantity` | Hours/units |
| `unitCost` | Cost per unit (LCY) |
| `totalCost` | Total cost (LCY) |
| `unitPrice` | Price per unit (LCY) |
| `totalPrice` | Total price (LCY) |
| `workTypeCode` | Work type classification |
| `entryType` | Usage or Sale |
| `documentNo` | Source document number |
| `lastModifiedDateTime` | Last modified timestamp |

**Note:** Time Entries are filtered to Resource-type entries only (employee time tracking).

## Development Setup

### Prerequisites

1. [VS Code](https://code.visualstudio.com/)
2. [AL Language extension](https://marketplace.visualstudio.com/items?itemName=ms-dynamics-smb.al)
3. Access to a Business Central sandbox environment

### Download Symbols

1. Open the project in VS Code
2. Press `Ctrl+Shift+P` → "AL: Download Symbols"
3. Enter your BC sandbox credentials

### Build

Press `Ctrl+Shift+B` to build the `.app` file.

### Deploy via GitHub Actions (Recommended)

The repo includes CI/CD workflows for both environments:

| Workflow | Trigger | Target |
|----------|---------|--------|
| `deploy-sandbox.yml` | Push to `main` | Sandbox (Contoso Ltd) |
| `deploy-production.yml` | Release published | Production (KnowAll Ltd) |

**GitHub Environments Required:**

Create two environments in Settings → Environments:

1. **Sandbox** - No protection rules
2. **Production** - Add required reviewers for safety

**Secrets (per environment):**

| Secret | Description |
|--------|-------------|
| `BC_TENANT_ID` | Your Azure AD tenant ID |
| `BC_CLIENT_ID` | Azure AD app registration client ID |
| `BC_CLIENT_SECRET` | Azure AD app registration client secret |

**Azure AD App Setup:**

1. Register an app in Azure AD
2. Grant API permissions: `Dynamics 365 Business Central` → `API.ReadWrite.All` and `Automation.ReadWrite.All`
3. Add redirect URI: `https://businesscentral.dynamics.com/OAuthLanding.htm`
4. Create a client secret
5. In BC Admin Center → Microsoft Entra Apps → Authorize the app
6. **Critical**: In Business Central → search "Microsoft Entra applications" → add the app with permission sets `D365 AUTOMATION` and `EXTEN. MGT. - ADMIN`

See [docs/INSTALLATION.adoc](docs/INSTALLATION.adoc) for detailed setup instructions.

### Deploy via VS Code

1. Configure `launch.json` with your sandbox environment name
2. Press `F5` to publish directly to sandbox

### Deploy to Production

1. Build the `.app` file
2. Go to BC Admin Center → Extensions → Upload Extension
3. Or use PowerShell: `Publish-NAVApp`

## Project Structure

```
thyme-bc-extension/
├── app.json                                    # Extension manifest
├── src/
│   ├── api/
│   │   ├── ThymeProjectsAPI.Page.al            # Projects endpoint (page 50100)
│   │   ├── ThymeJobTasksAPI.Page.al            # Job Tasks endpoint (page 50101)
│   │   ├── ThymeTimeSheetAPI.Page.al           # Time Sheets (page 50102)
│   │   ├── ThymeTimeSheetLineAPI.Page.al       # Time Sheet Lines (page 50103)
│   │   ├── ThymeResourcesAPI.Page.al           # Resources endpoint (page 50104)
│   │   └── ThymeTimeEntriesAPI.Page.al         # Time Entries endpoint (page 50105)
│   └── codeunit/
│       └── ThymeTimeSheetActions.Codeunit.al   # Approval workflow actions (codeunit 50100)
└── .vscode/
    ├── launch.json                             # Debug configuration
    └── settings.json                           # Editor settings
```

## Documentation

- [Installation Guide](docs/INSTALLATION.adoc) - Complete setup instructions
- [Solution Design](docs/SOLUTION_DESIGN.adoc) - Architecture and API design
- [Troubleshooting](docs/TROUBLESHOOTING.adoc) - Common issues and solutions
- [Testing](docs/TESTING.adoc) - How to test the API

## Related

- [Thyme Time Tracking App](https://github.com/knowall-ai/thyme)
- [Issue #41 - BC API Limitation](https://github.com/knowall-ai/thyme/issues/41)
- [Microsoft BC Custom API Docs](https://learn.microsoft.com/en-us/dynamics365/business-central/dev-itpro/developer/devenv-develop-custom-api)
