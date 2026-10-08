/// <summary>
/// A person's connected accounts on their resource: their GitHub username and the Azure DevOps
/// user they sign in with (when it differs from their Microsoft 365 sign-in). The AI agent uses
/// them to find whose GitHub and DevOps activity is whose.
///
/// Values are normalised before they're stored: a GitHub profile URL or an @mention becomes the
/// login, and the DevOps user is lower-cased. Who may change them is checked by
/// "Thyme Record Security" (a Thyme administrator for anyone, a person for their own resource).
///
/// SetConnectedAccounts is what the resources API's setConnectedAccounts action calls. People
/// often have no permission to modify resources at all (the standard D365 permission sets give
/// that to few), so it writes the two fields with inherent permissions, after the row-level check.
/// It modifies without running the Resource's OnModify trigger, so nothing else on the resource
/// (or in other tables) is touched.
/// </summary>
codeunit 50106 "Thyme Connected Accounts"
{
    var
        InvalidGitHubUsernameErr: Label '"%1" is not a valid GitHub username. Use the login from the person''s GitHub profile: letters, digits and single hyphens, not starting or ending with a hyphen, at most 39 characters.', Comment = '%1 = the value entered';
        InvalidDevOpsUserErr: Label '"%1" is not a valid Azure DevOps user. Enter the e-mail address the person signs in to Azure DevOps with, or leave it blank to use their Microsoft 365 sign-in.', Comment = '%1 = the value entered';
        GitHubUsernameCharsTok: Label 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-', Locked = true;
        GitHubHostTok: Label 'github.com/', Locked = true;

    /// <summary>
    /// Sets both connected accounts of a resource (blank clears one). Errors if the caller may
    /// not change them or a value isn't valid; then nothing is changed.
    /// </summary>
    [InherentPermissions(PermissionObjectType::TableData, Database::Resource, 'RM')]
    procedure SetConnectedAccounts(ResourceNo: Code[20]; GitHubUsername: Text; DevOpsUser: Text)
    var
        Resource: Record Resource;
        RecordSecurity: Codeunit "Thyme Record Security";
        NewGitHubUsername: Text;
        NewDevOpsUser: Text;
    begin
        RecordSecurity.CheckCanEditConnectedAccounts(ResourceNo);
        // Normalise first, so a profile URL longer than the field still fits
        NewGitHubUsername := NormaliseGitHubUsername(GitHubUsername);
        NewDevOpsUser := NormaliseDevOpsUser(DevOpsUser);
        Resource.Get(ResourceNo);
        Resource.Validate("Thyme GitHub Username", CopyStr(NewGitHubUsername, 1, MaxStrLen(Resource."Thyme GitHub Username")));
        Resource.Validate("Thyme DevOps User", CopyStr(NewDevOpsUser, 1, MaxStrLen(Resource."Thyme DevOps User")));
        Resource.Modify(false);
    end;

    /// <summary>
    /// A GitHub login from what was entered: trimmed, without a leading @ or a github.com profile
    /// URL around it. Blank stays blank. Errors unless it is a valid login (letters, digits and
    /// single hyphens, no leading or trailing hyphen, 1 to 39 characters).
    /// </summary>
    procedure NormaliseGitHubUsername(Value: Text): Text
    var
        HostPos: Integer;
        Entered: Text;
    begin
        Entered := Value;
        Value := Value.Trim();
        if Value = '' then
            exit('');
        HostPos := StrPos(LowerCase(Value), GitHubHostTok);
        if HostPos > 0 then
            Value := CopyStr(Value, HostPos + StrLen(GitHubHostTok));
        Value := Value.TrimEnd('/').TrimStart('@');
        if (Value = '') or (StrLen(Value) > 39) or (DelChr(Value, '=', GitHubUsernameCharsTok) <> '') or
           Value.StartsWith('-') or Value.EndsWith('-') or Value.Contains('--')
        then
            Error(InvalidGitHubUsernameErr, Entered.Trim());
        exit(Value);
    end;

    /// <summary>
    /// An Azure DevOps user (an e-mail address or UPN) from what was entered: trimmed and
    /// lower-cased. Blank stays blank (the agent then uses the time sheet owner's UPN).
    /// </summary>
    procedure NormaliseDevOpsUser(Value: Text): Text
    var
        AtPos: Integer;
        Domain: Text;
        Entered: Text;
    begin
        Entered := Value;
        Value := LowerCase(Value.Trim());
        if Value = '' then
            exit('');
        AtPos := StrPos(Value, '@');
        if (AtPos <= 1) or (StrLen(Value) > 250) or Value.Contains(' ') then
            Error(InvalidDevOpsUserErr, Entered.Trim());
        Domain := CopyStr(Value, AtPos + 1);
        if (Domain = '') or Domain.Contains('@') or not Domain.Contains('.') or Domain.StartsWith('.') or Domain.EndsWith('.') then
            Error(InvalidDevOpsUserErr, Entered.Trim());
        exit(Value);
    end;
}
