# Thyme BC Extension - Claude Code Instructions

## Project Overview

This is a Business Central (BC) AL extension that provides custom API endpoints for the Thyme time tracking app. The standard BC API v2.0 has limited fields, so this extension exposes additional data.

## Key Files

- `app.json` - Extension manifest (ID ranges 50100-50199)
- `src/api/ThymeProjectsAPI.Page.al` - Projects API (page 50100)
- `src/api/ThymeJobTasksAPI.Page.al` - Job Tasks API (page 50101)

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
```

## Development Commands

- **Download symbols**: `Ctrl+Shift+P` → "AL: Download Symbols"
- **Build**: `Ctrl+Shift+B`
- **Deploy to sandbox**: `F5`

## Related Repositories

- [Thyme App](https://github.com/knowall-ai/thyme) - The main time tracking app
- Issue: https://github.com/knowall-ai/thyme/issues/41

## Testing

Use the `business-central-sandbox` MCP server to test custom endpoints after deployment.
