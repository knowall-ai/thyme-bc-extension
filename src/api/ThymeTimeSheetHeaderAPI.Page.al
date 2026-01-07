/// <summary>
/// Custom API page exposing Time Sheet Headers with status information
/// not available in the standard BC API v2.0 timeRegistrationEntries endpoint.
///
/// Endpoint: /api/knowall/thyme/v1.0/companies({companyId})/timeSheetHeaders
/// </summary>
page 50102 "Thyme Time Sheet Header API"
{
    APIGroup = 'thyme';
    APIPublisher = 'knowall';
    APIVersion = 'v1.0';
    EntityName = 'timeSheetHeader';
    EntitySetName = 'timeSheetHeaders';
    PageType = API;
    SourceTable = "Time Sheet Header";
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
                field(startingDate; Rec."Starting Date")
                {
                    Caption = 'Starting Date';
                }
                field(endingDate; Rec."Ending Date")
                {
                    Caption = 'Ending Date';
                }
                field(resourceNo; Rec."Resource No.")
                {
                    Caption = 'Resource No.';
                }
                field(ownerUserId; Rec."Owner User ID")
                {
                    Caption = 'Owner User ID';
                }
                field(approverUserId; Rec."Approver User ID")
                {
                    Caption = 'Approver User ID';
                }
                field(status; Rec.Status)
                {
                    Caption = 'Status';
                }
                field(lastModifiedDateTime; Rec.SystemModifiedAt)
                {
                    Caption = 'Last Modified DateTime';
                    Editable = false;
                }
            }
        }
    }
}
