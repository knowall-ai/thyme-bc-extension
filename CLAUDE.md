# Thyme BC Extension - Claude Code Instructions

## Project Overview

This is a Business Central (BC) AL extension that provides custom API endpoints for the Thyme time tracking app. The standard BC API v2.0 has limited fields, so this extension exposes additional data.

## Key Files

- `app.json` - Extension manifest (ID ranges 50100-50199)
- `src/api/ThymeProjectsAPI.Page.al` - Projects API (page 50100)
- `src/api/ThymeJobTasksAPI.Page.al` - Job Tasks API (page 50101)
- `src/api/ThymeTimeSheetAPI.Page.al` - Time Sheets API (page 50102)
- `src/api/ThymeTimeSheetLineAPI.Page.al` - Time Sheet Line API (page 50103)
- `src/api/ThymeTimeSheetDetailAPI.Page.al` - Time Sheet Detail API (page 50106)
- `src/api/ThymeResourcesAPI.Page.al` - Resources API (page 50104)
- `src/api/ThymeTimeEntriesAPI.Page.al` - Time Entries API (page 50105)
- `src/api/ThymeJobPlanningLinesAPI.Page.al` - Job Planning Lines API (page 50107)
- `src/api/ThymeResourceUnitsOfMeasureAPI.Page.al` - Resource Units of Measure API (page 50108)
- `src/api/ThymeTimesheetReviewsAPI.Page.al` - Timesheet Reviews API (page 50109, table 50100)
- `src/api/ThymeTimesheetReviewLinesAPI.Page.al` - Timesheet Review Lines API (page 50110, table 50101)
- `src/api/ThymeTimeSuggestionsAPI.Page.al` - Time Suggestions API (page 50111, table 50102)
- `src/enum/` - Review verdict/severity and suggestion source/confidence/status enums (50100-50104)
- `src/permissionset/` - `THYME AI AGENT` (50100) and `THYME USER` (50101); add new tables/pages to these
- `src/codeunit/ThymeTimeSheetActions.Codeunit.al` - Time Sheet approval workflow actions (codeunit 50100)

## API Configuration

```
APIGroup = 'thyme'
APIPublisher = 'knowall'
APIVersion = 'v1.0'
```

Endpoints available at:
```
/api/knowall/thyme/v1.0/companies({id})/projects
/api/knowall/thyme/v1.0/companies({id})/jobTasks
/api/knowall/thyme/v1.0/companies({id})/timeSheets
/api/knowall/thyme/v1.0/companies({id})/timeSheetLines
/api/knowall/thyme/v1.0/companies({id})/timeSheetDetails
/api/knowall/thyme/v1.0/companies({id})/resources
/api/knowall/thyme/v1.0/companies({id})/timeEntries
/api/knowall/thyme/v1.0/companies({id})/jobPlanningLines
/api/knowall/thyme/v1.0/companies({id})/resourceUnitsOfMeasure
/api/knowall/thyme/v1.0/companies({id})/timesheetReviews
/api/knowall/thyme/v1.0/companies({id})/timesheetReviewLines
/api/knowall/thyme/v1.0/companies({id})/timeSuggestions
```

For user information, use BC's standard Automation API:
```
/api/microsoft/automation/v2.0/companies({id})/users
```

## Development Commands

- **Download symbols**: `Ctrl+Shift+P` → "AL: Download Symbols"
- **Build**: `Ctrl+Shift+B`
- **Deploy to sandbox**: `F5`

## CI/CD Deployment

GitHub Actions workflows deploy to BC Online (SaaS):

- `.github/workflows/deploy-sandbox.yml` - Triggered on push to `main`
- `.github/workflows/deploy-production.yml` - Triggered on release

**Important**: BC Online requires different functions than BC on-premises containers:
- Use `Publish-PerTenantExtensionApps` (not `Publish-BcContainerApp`)
- Use `Download-Artifacts` to get `alc.exe` for compilation
- Download symbols via BC Online dev API, not `Compile-AppInBcContainer`
- **Always bump the version in `app.json`** when making changes - BC won't update if version is unchanged

Secrets needed per environment:
- `BC_TENANT_ID` - Azure AD tenant ID
- `BC_CLIENT_ID` - App registration client ID
- `BC_CLIENT_SECRET` - App registration client secret

## Related Repositories

- [Thyme App](https://github.com/knowall-ai/thyme) - The main time tracking app
- Issue: https://github.com/knowall-ai/thyme/issues/41

## Testing

Use the `business-central-sandbox` MCP server to test custom endpoints after deployment.
