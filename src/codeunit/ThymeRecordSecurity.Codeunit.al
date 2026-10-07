/// <summary>
/// Row-level security for the AI timesheet review and time suggestion APIs.
///
/// Who sees what:
/// - A timesheet review and its findings: the time sheet's owner, its approver, a Thyme
///   administrator and the AI agent.
/// - A time suggestion: the user it is for (the time sheet owner of its resource), a
///   Thyme administrator and the AI agent.
///
/// A Thyme administrator is a time sheet administrator (User Setup, the same rule that
/// governs creating time sheets through the API) or a user with the THYME ADMIN
/// permission set. The AI agent is identified by the THYME AI AGENT permission set. Both
/// permission sets count whether assigned directly or through a security group. SUPER
/// on its own does not bypass these rules.
///
/// The API pages apply the filters below in OnOpenPage, so collection reads, $filter
/// queries and GET/PATCH/DELETE by id all only reach records the caller may see. The
/// filters run in SQL (FlowFields), not as per-record checks.
/// </summary>
codeunit 50104 "Thyme Record Security"
{
    Permissions = tabledata "User Setup" = r,
                  tabledata Resource = r;

    var
        ThymeAdminRoleTok: Label 'THYME ADMIN', Locked = true;
        ThymeAIAgentRoleTok: Label 'THYME AI AGENT', Locked = true;
        NotAllowedToWriteReviewsErr: Label 'You are not allowed to change timesheet reviews. Only the AI agent or a Thyme administrator can.';
        NotAllowedToWriteSuggestionErr: Label 'You are not allowed to change time suggestions for resource %1. You can only change suggestions for a resource whose time sheets you own.', Comment = '%1 = resource number';

    /// <summary>
    /// True for a time sheet administrator (the "Time Sheet Admin." flag in User Setup).
    /// </summary>
    procedure IsTimeSheetAdmin(): Boolean
    var
        UserSetup: Record "User Setup";
    begin
        if UserSetup.Get(UserId()) then
            exit(UserSetup."Time Sheet Admin.");
        exit(false);
    end;

    /// <summary>
    /// True for a time sheet administrator or a user with the THYME ADMIN permission set.
    /// </summary>
    procedure IsThymeAdmin(): Boolean
    begin
        if IsTimeSheetAdmin() then
            exit(true);
        exit(HasThymePermissionSet(ThymeAdminRoleTok));
    end;

    /// <summary>
    /// True for the AI agent's app identity, recognised by the THYME AI AGENT permission set.
    /// </summary>
    procedure IsAIAgent(): Boolean
    begin
        exit(HasThymePermissionSet(ThymeAIAgentRoleTok));
    end;

    /// <summary>
    /// True if the caller sees every review and suggestion: the AI agent or a Thyme administrator.
    /// </summary>
    procedure CanAccessAll(): Boolean
    begin
        if IsAIAgent() then
            exit(true);
        exit(IsThymeAdmin());
    end;

    /// <summary>
    /// Limits reviews to time sheets the caller owns or approves, unless they can access all.
    /// </summary>
    procedure ApplyReviewFilter(var Review: Record "Thyme Timesheet Review")
    begin
        if CanAccessAll() then
            exit;

        // Owner = me OR approver = me, written as: the time sheet exists AND it is not the
        // case that both its owner and its approver are someone else (see the table fields).
        Review.FilterGroup(2);
        Review.SetFilter("User ID Filter", '<>%1', CurrentUserCode());
        Review.SetRange("Hidden From User Filter", false);
        Review.SetRange("Time Sheet Exists", true);
        Review.FilterGroup(0);
    end;

    /// <summary>
    /// Limits review findings to time sheets the caller owns or approves, unless they can access all.
    /// </summary>
    procedure ApplyReviewLineFilter(var ReviewLine: Record "Thyme Timesheet Review Line")
    begin
        if CanAccessAll() then
            exit;

        ReviewLine.FilterGroup(2);
        ReviewLine.SetFilter("User ID Filter", '<>%1', CurrentUserCode());
        ReviewLine.SetRange("Hidden From User Filter", false);
        ReviewLine.SetRange("Time Sheet Exists", true);
        ReviewLine.FilterGroup(0);
    end;

    /// <summary>
    /// Limits suggestions to resources whose time sheets the caller owns, unless they can access all.
    /// </summary>
    procedure ApplySuggestionFilter(var Suggestion: Record "Thyme Time Suggestion")
    begin
        if CanAccessAll() then
            exit;

        Suggestion.FilterGroup(2);
        Suggestion.SetRange("Resource Owner User ID", CurrentUserCode());
        Suggestion.FilterGroup(0);
    end;

    /// <summary>
    /// Only the AI agent or a Thyme administrator may create, change or delete reviews
    /// and their findings.
    /// </summary>
    procedure CheckCanWriteReviews()
    begin
        if not CanAccessAll() then
            Error(NotAllowedToWriteReviewsErr);
    end;

    /// <summary>
    /// A suggestion being created or changed must be for a resource whose time sheets the
    /// caller owns, unless they can access all. Checked on the new values, so a user can't
    /// move their suggestion to someone else.
    /// </summary>
    procedure CheckCanWriteSuggestion(Suggestion: Record "Thyme Time Suggestion")
    begin
        if CanAccessAll() then
            exit;
        if not IsOwnResource(Suggestion."Resource No.") then
            Error(NotAllowedToWriteSuggestionErr, Suggestion."Resource No.");
    end;

    local procedure IsOwnResource(ResourceNo: Code[20]): Boolean
    var
        Resource: Record Resource;
    begin
        if ResourceNo = '' then
            exit(false);
        if not Resource.Get(ResourceNo) then
            exit(false);
        exit((Resource."Time Sheet Owner User ID" <> '') and (Resource."Time Sheet Owner User ID" = CurrentUserCode()));
    end;

    local procedure HasThymePermissionSet(RoleId: Code[20]): Boolean
    var
        UserPermissions: Codeunit "User Permissions";
        CurrentModule: ModuleInfo;
        SystemScope: Option System,Tenant;
    begin
        NavApp.GetCurrentModuleInfo(CurrentModule);
        exit(UserPermissions.HasUserPermissionSetAssigned(UserSecurityId(), CompanyName(), RoleId, SystemScope::System, CurrentModule.Id()));
    end;

    /// <summary>
    /// The caller's user name as stored in the Code[50] user ID fields. Never blank, so a
    /// filter on it can't match a time sheet or resource that has no owner or approver.
    /// </summary>
    local procedure CurrentUserCode(): Code[50]
    var
        NoUserTok: Label '<NO USER>', Locked = true;
    begin
        if UserId() = '' then
            exit(NoUserTok);
        exit(CopyStr(UpperCase(UserId()), 1, 50));
    end;
}
