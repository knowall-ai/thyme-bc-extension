# Changelog

Notable changes to the Thyme BC Extension. Versions match `app.json`.

## 1.12.0.0

### Added

- `timesheetReviews` and `timesheetReviewLines` endpoints for storing AI timesheet reviews
  (verdict, summary, and per-line findings). Deleting a review deletes its lines.
- `timeSuggestions` endpoint for AI time-entry suggestions (Pending, Accepted, Dismissed),
  with duplicate protection on resource, source, source reference and date.
- `THYME AI AGENT` and `THYME USER` permission sets for the extension's new tables.
