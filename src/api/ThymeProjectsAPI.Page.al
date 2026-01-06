/// <summary>
/// Custom API page exposing Projects (Jobs) with additional fields
/// not available in the standard BC API v2.0.
///
/// Endpoint: /api/knowall/thyme/v1.0/companies({companyId})/projects
/// </summary>
page 50100 "Thyme Projects API"
{
    APIGroup = 'thyme';
    APIPublisher = 'knowall';
    APIVersion = 'v1.0';
    EntityName = 'project';
    EntitySetName = 'projects';
    PageType = API;
    SourceTable = Job;
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
                field(description; Rec.Description)
                {
                    Caption = 'Description';
                }
                field(billToCustomerNo; Rec."Bill-to Customer No.")
                {
                    Caption = 'Bill-to Customer No.';
                }
                field(billToCustomerName; Rec."Bill-to Name")
                {
                    Caption = 'Bill-to Customer Name';
                }
                field(personResponsible; Rec."Person Responsible")
                {
                    Caption = 'Person Responsible';
                }
                field(status; Rec.Status)
                {
                    Caption = 'Status';
                }
                field(startingDate; Rec."Starting Date")
                {
                    Caption = 'Starting Date';
                }
                field(endingDate; Rec."Ending Date")
                {
                    Caption = 'Ending Date';
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
