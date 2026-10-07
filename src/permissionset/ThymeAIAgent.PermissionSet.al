/// <summary>
/// For the AI agent's app registration (Microsoft Entra application in BC): full access
/// to the timesheet review and time suggestion tables it writes through the API, and to
/// the suggestion requests it works through.
/// Base-app data such as time sheets and resources still comes from the standard
/// D365 permission sets.
/// </summary>
permissionset 50100 "THYME AI AGENT"
{
    Assignable = true;
    Caption = 'Thyme AI Agent';
    IncludedPermissionSets = "THYME USER";

    Permissions =
        tabledata "Thyme Timesheet Review" = RIMD,
        tabledata "Thyme Timesheet Review Line" = RIMD,
        tabledata "Thyme Time Suggestion" = RIMD,
        tabledata "Thyme Suggestion Request" = RIMD;
}
