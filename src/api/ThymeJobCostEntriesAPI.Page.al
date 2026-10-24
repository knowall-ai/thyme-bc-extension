/// <summary>
/// Custom API page exposing every Job Ledger Entry on a project, of every type (Resource, Item
/// and G/L Account), for a project's real costs and prices. Read-only.
///
/// Unlike timeEntries (page 50105), which is filtered to Resource entries, this includes the
/// non-hour costs posted to a project: Item and G/L Account entries, and resourceType tells
/// people's time from Machine resources such as AI usage (e.g. resource AI-USAGE, unit cost 1). Hours must still come only from
/// Resource entries for people: filter by type and resourceType, or use timeEntries.
///
/// Endpoint: /api/knowall/thyme/v1.0/companies({companyId})/jobCostEntries
/// </summary>
page 50125 "Thyme Job Cost Entries API"
{
    APIGroup = 'thyme';
    APIPublisher = 'knowall';
    APIVersion = 'v1.0';
    EntityName = 'jobCostEntry';
    EntitySetName = 'jobCostEntries';
    PageType = API;
    SourceTable = "Job Ledger Entry";
    DelayedInsert = true;
    ODataKeyFields = SystemId;
    Extensible = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    DataAccessIntent = ReadOnly;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(id; Rec.SystemId)
                {
                    Caption = 'Id';
                }
                field(entryNo; Rec."Entry No.")
                {
                    Caption = 'Entry No.';
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
                // The resource's type (Person or Machine) for Resource entries, blank otherwise,
                // so Thyme can tell people's hours from machine costs such as AI usage
                field(resourceType; ResourceTypeName)
                {
                    Caption = 'Resource Type';
                }
                field(description; Rec.Description)
                {
                    Caption = 'Description';
                }
                field(quantity; Rec.Quantity)
                {
                    Caption = 'Quantity';
                }
                // Same field names and meaning as timeEntries: these are in the company's local
                // currency (LCY), and the *ProjectCurrency fields below in the project's currency.
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
                field(currencyCode; Rec."Currency Code")
                {
                    Caption = 'Currency Code';
                }
                field(unitCostProjectCurrency; Rec."Unit Cost")
                {
                    Caption = 'Unit Cost (Project Currency)';
                }
                field(totalCostProjectCurrency; Rec."Total Cost")
                {
                    Caption = 'Total Cost (Project Currency)';
                }
                field(unitPriceProjectCurrency; Rec."Unit Price")
                {
                    Caption = 'Unit Price (Project Currency)';
                }
                field(totalPriceProjectCurrency; Rec."Total Price")
                {
                    Caption = 'Total Price (Project Currency)';
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
                }
            }
        }
    }

    var
        ResourceTypeName: Text[30];

    trigger OnAfterGetRecord()
    begin
        ResourceTypeName := GetResourceTypeName();
    end;

    // The enum value's name rather than its caption, so it doesn't change with the user's language
    local procedure GetResourceTypeName(): Text[30]
    var
        Resource: Record Resource;
    begin
        if Rec.Type <> Rec.Type::Resource then
            exit('');
        if not Resource.ReadPermission() then
            exit('');
        if not Resource.Get(Rec."No.") then
            exit('');
        exit(CopyStr(Resource.Type.Names().Get(Resource.Type.Ordinals().IndexOf(Resource.Type.AsInteger())), 1, 30));
    end;
}
