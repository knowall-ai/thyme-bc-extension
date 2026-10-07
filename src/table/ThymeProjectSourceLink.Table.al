/// <summary>
/// A linked source on a project: "work in this GitHub repo / DevOps project, or a meeting with
/// this keyword / attendee domain, is time on this project" (optionally on a given task).
/// The AI agent reads these to map activity to projects when it suggests time entries.
///
/// Who can change them (codeunit "Thyme Record Security"): Thyme administrators and the
/// project's manager (Project Manager, or the time sheet owner of its Person Responsible).
/// The AI agent can add links it learned from approved time (Learned = true) and change or
/// remove only those. A person who edits a learned link adopts it (Learned becomes false).
///
/// Values are normalised on save: a GitHub URL becomes owner/repo (owner/* or owner/prefix-*
/// for a whole organisation or a name prefix), a DevOps URL becomes the project name, an
/// attendee e-mail address becomes its domain, and "Meeting: " is dropped from a keyword.
/// </summary>
table 50106 "Thyme Project Source Link"
{
    Caption = 'Thyme Project Source Link';
    DataClassification = CustomerContent;
    LookupPageId = "Thyme Project Source Links";
    DrillDownPageId = "Thyme Project Source Links";

    fields
    {
        field(1; "Job No."; Code[20])
        {
            Caption = 'Project No.';
            TableRelation = Job;
            NotBlank = true;
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
            Editable = false;
        }
        field(3; Type; Enum "Thyme Project Source Type")
        {
            Caption = 'Type';

            trigger OnValidate()
            begin
                if Value <> '' then
                    Value := NormaliseValue(Type, Value);
            end;
        }
        field(4; Value; Text[250])
        {
            Caption = 'Value';

            trigger OnValidate()
            begin
                Value := NormaliseValue(Type, Value);
            end;
        }
        field(5; "Job Task No."; Code[20])
        {
            Caption = 'Project Task No.';
            TableRelation = "Job Task"."Job Task No." where("Job No." = field("Job No."),
                                                            "Job Task Type" = const(Posting));
        }
        // With a task: tick to use the month's block when there is one (the task is the fallback).
        // Without a task: tick to always use the month's block; otherwise the agent detects it.
        field(6; "Use Monthly Block"; Boolean)
        {
            Caption = 'Use Monthly Block';
        }
        // Added by the AI agent from approved time rather than by a person.
        field(7; Learned; Boolean)
        {
            Caption = 'Learned';
            Editable = false;
        }
        field(8; "Created By"; Code[50])
        {
            Caption = 'Created By';
            Editable = false;
        }
        field(9; "Created At"; DateTime)
        {
            Caption = 'Created At';
            Editable = false;
        }
    }

    keys
    {
        key(PK; "Job No.", "Line No.")
        {
            Clustered = true;
        }
        // The agent: every link of a type across projects.
        key(TypeValue; Type, Value)
        {
        }
    }

    trigger OnInsert()
    var
        RecordSecurity: Codeunit "Thyme Record Security";
    begin
        TestField("Job No.");
        RecordSecurity.CheckCanInsertSourceLink(Rec);
        Value := NormaliseValue(Type, Value);
        CheckTask();
        CheckNoDuplicate();
        if "Line No." = 0 then
            "Line No." := NextLineNo();
        "Created By" := CopyStr(UpperCase(UserId()), 1, MaxStrLen("Created By"));
        "Created At" := CurrentDateTime();
    end;

    trigger OnModify()
    var
        RecordSecurity: Codeunit "Thyme Record Security";
    begin
        RecordSecurity.CheckCanModifySourceLink(Rec);
        Value := NormaliseValue(Type, Value);
        CheckTask();
        CheckNoDuplicate();
    end;

    trigger OnDelete()
    var
        RecordSecurity: Codeunit "Thyme Record Security";
    begin
        RecordSecurity.CheckCanDeleteSourceLink(Rec);
    end;

    trigger OnRename()
    begin
        Error(RenameErr);
    end;

    /// <summary>
    /// The value as stored: trimmed, and for GitHub and DevOps URLs or e-mail addresses reduced
    /// to what the agent matches on. Errors when the value can't be a valid link of that type.
    /// </summary>
    procedure NormaliseValue(LinkType: Enum "Thyme Project Source Type"; RawValue: Text): Text[250]
    var
        Result: Text;
    begin
        Result := RawValue.Trim();
        if Result = '' then
            Error(ValueRequiredErr);
        case LinkType of
            LinkType::GitHubRepo:
                Result := NormaliseGitHubRepo(Result);
            LinkType::DevOpsProject:
                Result := NormaliseDevOpsProject(Result);
            LinkType::MeetingKeyword:
                Result := NormaliseKeyword(Result);
            LinkType::AttendeeDomain:
                Result := NormaliseDomain(Result);
        end;
        if StrLen(Result) > 250 then
            Error(ValueTooLongErr);
        exit(CopyStr(Result, 1, 250));
    end;

    local procedure NormaliseGitHubRepo(RawValue: Text): Text
    var
        Parts: List of [Text];
        Owner: Text;
        Repo: Text;
        IsUrl: Boolean;
    begin
        RawValue := RawValue.ToLower();
        IsUrl := RawValue.StartsWith('https://') or RawValue.StartsWith('http://');
        RawValue := StripScheme(RawValue);
        if RawValue.StartsWith('www.') then
            RawValue := RawValue.Substring(5);
        if RawValue.StartsWith('github.com/') then begin
            RawValue := RawValue.Substring(12);
            IsUrl := true;
        end;
        RawValue := RawValue.TrimEnd('/');
        Parts := RawValue.Split('/');
        // A URL may go deeper (…/owner/repo/pull/12); owner/repo as typed may not.
        if (Parts.Count() < 2) or ((Parts.Count() > 2) and not IsUrl) then
            Error(GitHubFormatErr, RawValue);
        Owner := Parts.Get(1);
        Repo := Parts.Get(2);
        if Repo.EndsWith('.git') then
            Repo := Repo.Substring(1, StrLen(Repo) - 4);
        if not IsSlug(Owner, false) then
            Error(GitHubFormatErr, RawValue);
        if Repo.EndsWith('*') then begin
            if (Repo <> '*') and not IsSlug(Repo.Substring(1, StrLen(Repo) - 1), false) then
                Error(GitHubFormatErr, RawValue);
        end else
            if not IsSlug(Repo, false) then
                Error(GitHubFormatErr, RawValue);
        exit(Owner + '/' + Repo);
    end;

    local procedure NormaliseDevOpsProject(RawValue: Text): Text
    var
        Parts: List of [Text];
        Lower: Text;
    begin
        RawValue := RawValue.Replace('%20', ' ');
        Lower := StripScheme(RawValue.ToLower());
        if Lower.StartsWith('dev.azure.com/') then begin
            // dev.azure.com/{org}/{project}/...
            Parts := StripScheme(RawValue).Split('/');
            if (Parts.Count() < 3) or (Parts.Get(3) = '') then
                Error(DevOpsFormatErr, RawValue);
            exit(Parts.Get(3).Trim());
        end;
        if Lower.Contains('.visualstudio.com/') then begin
            // {org}.visualstudio.com/{project}/...
            Parts := StripScheme(RawValue).Split('/');
            if (Parts.Count() < 2) or (Parts.Get(2) = '') then
                Error(DevOpsFormatErr, RawValue);
            exit(Parts.Get(2).Trim());
        end;
        if RawValue.Contains('/') then
            Error(DevOpsFormatErr, RawValue);
        exit(RawValue);
    end;

    local procedure NormaliseKeyword(RawValue: Text): Text
    begin
        if RawValue.ToLower().StartsWith('meeting:') then
            RawValue := RawValue.Substring(9).Trim();
        if StrLen(RawValue) < 3 then
            Error(KeywordTooShortErr);
        exit(RawValue);
    end;

    local procedure NormaliseDomain(RawValue: Text): Text
    begin
        RawValue := StripScheme(RawValue.ToLower());
        if RawValue.Contains('@') then
            RawValue := RawValue.Substring(RawValue.LastIndexOf('@') + 1);
        RawValue := RawValue.TrimEnd('/');
        if RawValue.StartsWith('www.') then
            RawValue := RawValue.Substring(5);
        if (not RawValue.Contains('.')) or RawValue.StartsWith('.') or RawValue.EndsWith('.') or not IsSlug(RawValue, true) then
            Error(DomainFormatErr, RawValue);
        exit(RawValue);
    end;

    local procedure StripScheme(RawValue: Text): Text
    begin
        if RawValue.ToLower().StartsWith('https://') then
            exit(RawValue.Substring(9));
        if RawValue.ToLower().StartsWith('http://') then
            exit(RawValue.Substring(8));
        exit(RawValue);
    end;

    /// <summary>Lower-case letters, digits, '-', '_' and '.' only (no '_' in a domain).</summary>
    local procedure IsSlug(Candidate: Text; IsDomain: Boolean): Boolean
    var
        AllowedTok: Label 'abcdefghijklmnopqrstuvwxyz0123456789-.', Locked = true;
        i: Integer;
        c: Text;
    begin
        if Candidate = '' then
            exit(false);
        for i := 1 to StrLen(Candidate) do begin
            c := CopyStr(Candidate, i, 1);
            if (StrPos(AllowedTok, c) = 0) and not ((c = '_') and not IsDomain) then
                exit(false);
        end;
        exit(true);
    end;

    local procedure CheckTask()
    var
        JobTask: Record "Job Task";
    begin
        if "Job Task No." = '' then
            exit;
        if not JobTask.Get("Job No.", "Job Task No.") then
            Error(TaskNotFoundErr, "Job Task No.", "Job No.");
        if JobTask."Job Task Type" <> JobTask."Job Task Type"::Posting then
            Error(TaskNotPostingErr, "Job Task No.", "Job No.");
    end;

    local procedure CheckNoDuplicate()
    var
        Existing: Record "Thyme Project Source Link";
    begin
        Existing.SetRange("Job No.", "Job No.");
        Existing.SetRange(Type, Type);
        Existing.SetFilter("Line No.", '<>%1', "Line No.");
        if Existing.FindSet() then
            repeat
                if Existing.Value.ToLower() = Value.ToLower() then
                    Error(DuplicateErr, Format(Type), Value, "Job No.");
            until Existing.Next() = 0;
    end;

    local procedure NextLineNo(): Integer
    var
        Last: Record "Thyme Project Source Link";
    begin
        Last.SetRange("Job No.", "Job No.");
        if Last.FindLast() then
            exit(Last."Line No." + 10000);
        exit(10000);
    end;

    var
        ValueRequiredErr: Label 'Enter a value for the linked source.';
        ValueTooLongErr: Label 'The value can be at most 250 characters.';
        GitHubFormatErr: Label '"%1" is not a GitHub repository. Enter owner/repo, owner/* for every repo of an owner, owner/prefix-* for repos starting with a prefix, or the repository''s URL.', Comment = '%1 = the value entered';
        DevOpsFormatErr: Label '"%1" is not an Azure DevOps project. Enter the project name or its URL (https://dev.azure.com/organisation/project).', Comment = '%1 = the value entered';
        KeywordTooShortErr: Label 'A meeting keyword must be at least 3 characters.';
        DomainFormatErr: Label '"%1" is not a domain. Enter a domain such as contoso.com, or an attendee''s e-mail address.', Comment = '%1 = the value entered';
        TaskNotFoundErr: Label 'Task %1 does not exist on project %2.', Comment = '%1 = job task number, %2 = job number';
        TaskNotPostingErr: Label 'Task %1 on project %2 is not a posting task. Choose a task that time can be logged against.', Comment = '%1 = job task number, %2 = job number';
        DuplicateErr: Label 'The %1 "%2" is already linked to project %3.', Comment = '%1 = link type, %2 = value, %3 = job number';
        RenameErr: Label 'A linked source can''t be moved to another project. Delete it and add it to the other project.';
}
