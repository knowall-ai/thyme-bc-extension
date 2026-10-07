/// <summary>
/// For Thyme web app users: run the Thyme API pages, read AI timesheet reviews,
/// accept or dismiss AI time suggestions, ask the agent for suggestions now (suggestion
/// requests; who for is checked per resource), and read the company's default billable target.
/// Base-app data such as time sheets and resources still comes from the standard D365
/// permission sets. To change the default billable target, use THYME ADMIN.
/// </summary>
permissionset 50101 "THYME USER"
{
    Assignable = true;
    Caption = 'Thyme User';

    Permissions =
        table "Thyme Timesheet Review" = X,
        table "Thyme Timesheet Review Line" = X,
        table "Thyme Time Suggestion" = X,
        table "Thyme Setup" = X,
        table "Thyme Suggestion Request" = X,
        tabledata "Thyme Timesheet Review" = R,
        tabledata "Thyme Timesheet Review Line" = R,
        tabledata "Thyme Time Suggestion" = RM,
        tabledata "Thyme Setup" = R,
        tabledata "Thyme Suggestion Request" = RI,
        page "Thyme Projects API" = X,
        page "Thyme Job Tasks API" = X,
        page "Thyme Time Sheet API" = X,
        page "Thyme Time Sheet Line API" = X,
        page "Thyme Time Sheet Detail API" = X,
        page "Thyme Resources API" = X,
        page "Thyme Time Entries API" = X,
        page "Thyme Job Planning Lines API" = X,
        page "Thyme Resource UoM API" = X,
        page "Thyme Timesheet Reviews API" = X,
        page "Thyme TS Review Lines API" = X,
        page "Thyme Time Suggestions API" = X,
        page "Thyme Setup API" = X,
        page "Thyme Suggestion Requests API" = X,
        codeunit "Thyme Time Sheet Actions" = X,
        codeunit "Thyme Record Security" = X;
}
