/// <summary>
/// Custom API page exposing Resources with capacity data.
/// Enables Thyme to fetch weekly hours targets and billable targets per employee.
///
/// canRequestSuggestions is true when the caller may ask the agent for time suggestions for
/// the resource (see the suggestionRequests endpoint).
///
/// billableTargetPercent (0..100) is only meaningful when billableTargetSet is true;
/// otherwise Thyme uses defaultBillableTargetPercent from the thymeSetup endpoint.
/// billableTargetPercent comes before billableTargetSet so that, when a PATCH sends both,
/// the flag is applied last (setting a percentage marks the target as set).
///
/// weeklyCapacityHours is only meaningful when weeklyCapacitySet is true; otherwise Thyme uses
/// hours per day x 5. An explicit 0 means the person is listed but not counted. The same
/// ordering rule applies: the flag comes after the hours. flexibleWorkingDays means the person
/// works their weekly capacity on any days, so Thyme judges the week rather than each day.
///
/// githubUsername and devopsUser are the person's connected accounts (blank devopsUser = their
/// time sheet owner's UPN). canEditConnectedAccounts is true when the caller may change them: a
/// Thyme administrator for anyone, a person for their own resource. Change them with the
/// setConnectedAccounts action, which works without permission to modify resources:
///   POST /resources({id})/Microsoft.NAV.setConnectedAccounts
///   { "githubUsername": "alex-contoso", "devopsUser": "" }
/// A PATCH of the fields works too, for callers who may modify resources; the same rule applies.
///
/// Endpoint: /api/knowall/thyme/v1.0/companies({companyId})/resources
/// </summary>
page 50104 "Thyme Resources API"
{
    APIGroup = 'thyme';
    APIPublisher = 'knowall';
    APIVersion = 'v1.0';
    EntityName = 'resource';
    EntitySetName = 'resources';
    PageType = API;
    SourceTable = Resource;
    DelayedInsert = true;
    ODataKeyFields = SystemId;
    Extensible = false;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(id; Rec.SystemId)
                {
                    Caption = 'Id';
                    Editable = false;
                }
                field(number; Rec."No.")
                {
                    Caption = 'Number';
                }
                field(name; Rec.Name)
                {
                    Caption = 'Name';
                }
                field(searchName; Rec."Search Name")
                {
                    Caption = 'Search Name';
                }
                field(type; Rec.Type)
                {
                    Caption = 'Type';
                }
                field(capacity; Rec.Capacity)
                {
                    Caption = 'Capacity';
                }
                field(unitCost; Rec."Unit Cost")
                {
                    Caption = 'Unit Cost';
                }
                field(unitPrice; Rec."Unit Price")
                {
                    Caption = 'Unit Price';
                }
                field(baseUnitOfMeasure; Rec."Base Unit of Measure")
                {
                    Caption = 'Base Unit of Measure';
                }
                field(resourceGroupNo; Rec."Resource Group No.")
                {
                    Caption = 'Resource Group No.';
                }
                field(blocked; Rec.Blocked)
                {
                    Caption = 'Blocked';
                }
                field(privacyBlocked; Rec."Privacy Blocked")
                {
                    Caption = 'Privacy Blocked';
                }
                field(useTimeSheet; Rec."Use Time Sheet")
                {
                    Caption = 'Use Time Sheet';
                }
                field(timeSheetOwnerUserId; Rec."Time Sheet Owner User ID")
                {
                    Caption = 'Time Sheet Owner User ID';
                }
                field(timeSheetApproverUserId; Rec."Time Sheet Approver User ID")
                {
                    Caption = 'Time Sheet Approver User ID';
                }
                // Whether the caller may ask the agent for time suggestions for this resource
                // (suggestionRequests). Worked out per caller; read-only.
                field(canRequestSuggestions; CanRequestSuggestions)
                {
                    Caption = 'Can Request Suggestions';
                    Editable = false;
                }
                field(billableTargetPercent; Rec."Thyme Billable Target %")
                {
                    Caption = 'Billable Target %';
                }
                field(billableTargetSet; Rec."Thyme Billable Target Set")
                {
                    Caption = 'Billable Target Set';
                }
                field(weeklyCapacityHours; Rec."Thyme Weekly Capacity (Hours)")
                {
                    Caption = 'Weekly Capacity (Hours)';
                }
                field(weeklyCapacitySet; Rec."Thyme Weekly Capacity Set")
                {
                    Caption = 'Weekly Capacity Set';
                }
                field(flexibleWorkingDays; Rec."Thyme Flexible Working Days")
                {
                    Caption = 'Flexible Working Days';
                }
                field(githubUsername; Rec."Thyme GitHub Username")
                {
                    Caption = 'GitHub Username';
                }
                field(devopsUser; Rec."Thyme DevOps User")
                {
                    Caption = 'DevOps User';
                }
                // Whether the caller may change githubUsername and devopsUser. Per caller; read-only.
                field(canEditConnectedAccounts; CanEditConnectedAccounts)
                {
                    Caption = 'Can Edit Connected Accounts';
                    Editable = false;
                }
                field(lastDateModified; Rec."Last Date Modified")
                {
                    Caption = 'Last Date Modified';
                }
                field(lastModifiedDateTime; Rec.SystemModifiedAt)
                {
                    Caption = 'Last Modified DateTime';
                    Editable = false;
                }
            }
        }
    }

    var
        CallerCanAccessAll: Boolean;
        CallerIsThymeAdmin: Boolean;
        CanRequestSuggestions: Boolean;
        CanEditConnectedAccounts: Boolean;

    trigger OnOpenPage()
    var
        RecordSecurity: Codeunit "Thyme Record Security";
    begin
        CallerCanAccessAll := RecordSecurity.CanAccessAll();
        CallerIsThymeAdmin := RecordSecurity.IsThymeAdmin();
    end;

    trigger OnAfterGetRecord()
    var
        RecordSecurity: Codeunit "Thyme Record Security";
    begin
        CanRequestSuggestions := RecordSecurity.CanRequestSuggestions(Rec, CallerCanAccessAll);
        CanEditConnectedAccounts := RecordSecurity.CanEditConnectedAccounts(Rec, CallerIsThymeAdmin);
    end;

    /// <summary>
    /// Sets the resource's GitHub username and DevOps user (blank clears one). For the person
    /// themselves or a Thyme administrator; doesn't need permission to modify resources.
    /// </summary>
    [ServiceEnabled]
    procedure setConnectedAccounts(var ActionContext: WebServiceActionContext; githubUsername: Text; devopsUser: Text)
    var
        ConnectedAccounts: Codeunit "Thyme Connected Accounts";
    begin
        ConnectedAccounts.SetConnectedAccounts(Rec."No.", githubUsername, devopsUser);
        ActionContext.SetObjectType(ObjectType::Page);
        ActionContext.SetObjectId(Page::"Thyme Resources API");
        ActionContext.AddEntityKey(Rec.FieldNo(SystemId), Rec.SystemId);
        ActionContext.SetResultCode(WebServiceActionResultCode::Updated);
    end;
}
