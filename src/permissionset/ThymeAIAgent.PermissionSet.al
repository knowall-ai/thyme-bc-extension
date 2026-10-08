/// <summary>
/// For the AI agent's app registration (Microsoft Entra application in BC): full access
/// to the timesheet review and time suggestion tables it writes through the API, and to
/// the suggestion requests it works through and its heartbeat. It reads every project's linked
/// sources and adds the ones it learns (changing or removing only learned links is checked in code).
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
        tabledata "Thyme Suggestion Request" = RIMD,
        tabledata "Thyme Agent Heartbeat" = RIMD,
        tabledata "Thyme Project Source Link" = RIMD;
}
