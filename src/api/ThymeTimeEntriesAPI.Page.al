/// <summary>
/// Custom API page exposing Time Entries (Job Ledger Entries) for projects.
/// Filtered to Resource-type entries only to show actual time tracking data.
///
/// Endpoint: /api/knowall/thyme/v1.0/companies({companyId})/timeEntries
/// </summary>
page 50102 "Thyme Time Entries API"
{
    APIGroup = 'thyme';
    APIPublisher = 'knowall';
    APIVersion = 'v1.0';
    EntityName = 'timeEntry';
    EntitySetName = 'timeEntries';
    PageType = API;
    SourceTable = "Job Ledger Entry";
    SourceTableView = where(Type = const(Resource));
    DelayedInsert = true;
    ODataKeyFields = SystemId;
    Extensible = false;
    Editable = false;

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
                field(entryNo; Rec."Entry No.")
                {
                    Caption = 'Entry No.';
                    Editable = false;
                }
                field(jobNo; Rec."Job No.")
                {
                    Caption = 'Job No.';
                }
                field(jobTaskNo; Rec."Job Task No.")
                {
                    Caption = 'Job Task No.';
                }
                field(postingDate; Rec."Posting Date")
                {
                    Caption = 'Posting Date';
                }
                field(type; Rec.Type)
                {
                    Caption = 'Type';
                }
                field(number; Rec."No.")
                {
                    Caption = 'No.';
                }
                field(description; Rec.Description)
                {
                    Caption = 'Description';
                }
                field(quantity; Rec.Quantity)
                {
                    Caption = 'Quantity';
                }
                field(unitCost; Rec."Unit Cost (LCY)")
                {
                    Caption = 'Unit Cost';
                }
                field(totalCost; Rec."Total Cost (LCY)")
                {
                    Caption = 'Total Cost';
                }
                field(unitPrice; Rec."Unit Price (LCY)")
                {
                    Caption = 'Unit Price';
                }
                field(totalPrice; Rec."Total Price (LCY)")
                {
                    Caption = 'Total Price';
                }
                field(workTypeCode; Rec."Work Type Code")
                {
                    Caption = 'Work Type Code';
                }
                field(entryType; Rec."Entry Type")
                {
                    Caption = 'Entry Type';
                }
                field(documentNo; Rec."Document No.")
                {
                    Caption = 'Document No.';
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
