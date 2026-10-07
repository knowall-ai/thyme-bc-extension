# Changelog

Notable changes to the Thyme BC Extension. Versions match `app.json`.

## 1.18.0.0

### Added

- `suggestionRequests` endpoint (page 50114, table 50104 `Thyme Suggestion Request`, enum 50105):
  ask the AI agent to generate time suggestions for a resource and period (at most 7 days, not
  in the future) now, instead of waiting for its scheduled runs. Thyme creates the request and
  polls it; the agent claims it (`Running`), reports `progress`, and finishes it as `Done` with
  `createdCount`/`updatedCount` or `Failed` with an `errorMessage`. One open request per
  resource and period.
- Who can request: the resource's time sheet owner and approver, Thyme administrators and the AI
  agent. They can also read those requests. Only the AI agent can change or delete one.
- `canRequestSuggestions` on `resources` (read-only, per caller), so Thyme can show the
  *Request suggestions* button only to people who may use it.
- `agentHeartbeats` endpoint (page 50115, table 50105 `Thyme Agent Heartbeat`): when each AI
  agent was last seen (stamped by BC), its status text and version. Every Thyme user can read it,
  so Thyme can show whether the agent is online and disable requests while it isn't. Only the AI
  agent writes it.

### Unchanged on purpose

- Suggestions themselves stay visible only to the person they're for, administrators and the
  AI agent. An approver who requests them for someone sees the request's progress and counts,
  not the suggestions.

## 1.15.0.1

### Security

- Row-level security on `timesheetReviews`, `timesheetReviewLines` and `timeSuggestions`. A review
  and its lines are visible only to the time sheet's owner and approver, Thyme administrators
  (*Time Sheet Admin.* in User Setup, or the `THYME ADMIN` permission set) and the AI agent
  (`THYME AI AGENT`). A suggestion is visible to, and changeable by, only its resource's time
  sheet owner, administrators and the AI agent. Records outside the caller's scope are left out
  of lists and `$filter` results, and return 404 by `id`.
- Only the AI agent or a Thyme administrator can create, change or delete reviews and review
  lines. A user can't create a suggestion for, or move one to, a resource they don't own.
- New `Thyme Record Security` codeunit (50104) holds these rules. The time sheet admin check
  used when creating time sheets through the API now comes from it too, so both stay in step.
- `SUPER` on its own no longer sees other users' reviews and suggestions through the API.
  Assign `THYME ADMIN` or *Time Sheet Admin.* to anyone who should.

## 1.14.0.1

### Added

- `currencyCode` on `projects` (the Job's Currency Code; blank = local currency), read-only.
- Project-currency amounts on `timeEntries`: `unitCostProjectCurrency`, `totalCostProjectCurrency`,
  `unitPriceProjectCurrency` and `totalPriceProjectCurrency`, plus `currencyCode`. The existing
  `unitCost`, `totalCost`, `unitPrice` and `totalPrice` stay in local currency (LCY).
- Local-currency amounts on `jobPlanningLines`: `unitCostLCY`, `totalCostLCY`, `unitPriceLCY` and
  `totalPriceLCY` (read-only), plus `currencyCode`. The existing cost and price fields stay in the
  project currency.

### Fixed

- Planning lines created through `jobPlanningLines` on a project in another currency were priced
  in local currency but labelled with the project currency (BC only copies the project's currency
  onto a line when it's inserted, after the API has priced it). The currency is now set as soon as
  `jobNo` is applied, so the line is priced in the project currency.

This lets Thyme show a project priced in another currency (for example EUR in a GBP company) in
that currency, instead of labelling its prices with the company currency.

## 1.13.0.0

### Added

- Per-person billable target on Resource (`Thyme Billable Target %` with a `Thyme Billable Target Set`
  flag so "not set" is distinct from 0%), shown in a Thyme group on the Resource Card and exposed on
  the `resources` endpoint as `billableTargetPercent` and `billableTargetSet` (editable, 0-100).
- `Thyme Setup` single-record table and page with the company `Default Billable Target %` (75 by default),
  exposed on the new `thymeSetup` endpoint (read and update).
- `THYME ADMIN` permission set for changing Thyme Setup; `THYME USER` can read it.

## 1.12.0.0

### Added

- `timesheetReviews` and `timesheetReviewLines` endpoints for storing AI timesheet reviews
  (verdict, summary, and per-line findings). Deleting a review deletes its lines.
- `timeSuggestions` endpoint for AI time-entry suggestions (Pending, Accepted, Dismissed),
  with duplicate protection on resource, source, source reference and date.
- `THYME AI AGENT` and `THYME USER` permission sets for the extension's new tables.
