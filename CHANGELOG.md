# Changelog

Notable changes to the Thyme BC Extension. Versions match `app.json`.

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
