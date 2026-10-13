/// <summary>
/// For Thyme web app users: run the Thyme API pages, read AI timesheet reviews,
/// accept or dismiss AI time suggestions, ask the agent for suggestions now (suggestion
/// requests; who for is checked per resource), see whether the agent is online, read the company's default billable target,
/// and read projects' linked sources (changing them is checked per project: Thyme administrators and the project's manager),
/// and set their own GitHub username through the resources API's setGitHubUsername action.
/// Every Thyme user reads day notes; changing them is checked in code (people who may change the plan:
/// permission to write Job Planning Lines).
/// Base-app data such as time sheets and resources still comes from the standard D365
/// permission sets. To change the default billable target, use THYME ADMIN.
/// Every Thyme user reads AI plan reviews (with their findings and proposed changes) and plan review
/// requests, and can create a request (checked in code: people who may change the plan).
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
        table "Thyme Agent Heartbeat" = X,
        table "Thyme Plan Review" = X,
        table "Thyme Plan Review Line" = X,
        table "Thyme Plan Review Change" = X,
        table "Thyme Plan Review Request" = X,
        table "Thyme Project Source Link" = X,
        table "Thyme Day Note" = X,
        tabledata "Thyme Timesheet Review" = R,
        tabledata "Thyme Timesheet Review Line" = R,
        tabledata "Thyme Time Suggestion" = RM,
        tabledata "Thyme Setup" = R,
        tabledata "Thyme Suggestion Request" = RI,
        tabledata "Thyme Agent Heartbeat" = R,
        tabledata "Thyme Plan Review" = R,
        tabledata "Thyme Plan Review Line" = R,
        tabledata "Thyme Plan Review Change" = R,
        tabledata "Thyme Plan Review Request" = RI,
        tabledata "Thyme Project Source Link" = RIMD,
        // Direct read only; insert, modify and delete are indirect, so day notes can only be written
        // through the dayNotes API page, whose triggers check CanEditPlan (not, say, a config package).
        tabledata "Thyme Day Note" = Rimd,
        // Indirect only: lets codeunit "Thyme Connected Accounts" save a person's own GitHub
        // username after its row-level check; it gives no direct right to change resources.
        tabledata Resource = m,
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
        page "Thyme Agent Heartbeats API" = X,
        page "Thyme Plan Reviews API" = X,
        page "Thyme Plan Review Lines API" = X,
        page "Thyme Plan Review Changes API" = X,
        page "Thyme Plan Review Requests API" = X,
        page "Thyme Project Source Links API" = X,
        page "Thyme Project Source Links" = X,
        page "Thyme Day Notes API" = X,
        codeunit "Thyme Time Sheet Actions" = X,
        codeunit "Thyme Record Security" = X,
        codeunit "Thyme Connected Accounts" = X,
        codeunit "Thyme Source Link Events" = X;
}
