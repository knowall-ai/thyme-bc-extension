# Thyme BC API Extension

Custom Business Central API endpoints for the [Thyme](https://github.com/knowall-ai/thyme) time tracking app.

## Why This Extension?

The standard BC API v2.0 `/projects` endpoint only returns 4 fields:
- `id`, `number`, `displayName`, `lastModifiedDateTime`

This extension exposes additional fields needed by Thyme:
- Customer name and number
- Person responsible
- Project status and dates
- Job tasks

## API Endpoints

Once deployed, the APIs are available at:

```
https://api.businesscentral.dynamics.com/v2.0/{tenant}/{environment}/api/knowall/thyme/v1.0/companies({companyId})/projects
https://api.businesscentral.dynamics.com/v2.0/{tenant}/{environment}/api/knowall/thyme/v1.0/companies({companyId})/jobTasks
```

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

### Deploy to Sandbox

1. Configure `launch.json` with your sandbox environment name
2. Press `F5` to publish directly to sandbox

### Deploy to Production

1. Build the `.app` file
2. Go to BC Admin Center → Extensions → Upload Extension
3. Or use PowerShell: `Publish-NAVApp`

## Project Structure

```
thyme-bc-extension/
├── app.json                          # Extension manifest
├── src/
│   └── api/
│       ├── ThymeProjectsAPI.Page.al  # Projects endpoint (page 50100)
│       └── ThymeJobTasksAPI.Page.al  # Job Tasks endpoint (page 50101)
└── .vscode/
    ├── launch.json                   # Debug configuration
    └── settings.json                 # Editor settings
```

## Related

- [Thyme Time Tracking App](https://github.com/knowall-ai/thyme)
- [Issue #41 - BC API Limitation](https://github.com/knowall-ai/thyme/issues/41)
- [Microsoft BC Custom API Docs](https://learn.microsoft.com/en-us/dynamics365/business-central/dev-itpro/developer/devenv-develop-custom-api)
