/// <summary>
/// For Thyme web app users: run the Thyme API pages, read AI timesheet reviews, and
/// accept or dismiss AI time suggestions. Base-app data such as time sheets and
/// resources still comes from the standard D365 permission sets.
/// </summary>
permissionset 50101 "THYME USER"
{
    Assignable = true;
    Caption = 'Thyme User';

    Permissions =
        table "Thyme Timesheet Review" = X,
        table "Thyme Timesheet Review Line" = X,
        table "Thyme Time Suggestion" = X,
        tabledata "Thyme Timesheet Review" = R,
        tabledata "Thyme Timesheet Review Line" = R,
        tabledata "Thyme Time Suggestion" = RM,
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
        codeunit "Thyme Time Sheet Actions" = X;
}
