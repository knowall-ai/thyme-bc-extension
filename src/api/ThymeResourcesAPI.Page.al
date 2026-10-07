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
        CanRequestSuggestions: Boolean;

    trigger OnOpenPage()
    var
        RecordSecurity: Codeunit "Thyme Record Security";
    begin
        CallerCanAccessAll := RecordSecurity.CanAccessAll();
    end;

    trigger OnAfterGetRecord()
    var
        RecordSecurity: Codeunit "Thyme Record Security";
    begin
        CanRequestSuggestions := RecordSecurity.CanRequestSuggestions(Rec, CallerCanAccessAll);
    end;
}
