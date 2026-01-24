/// <summary>
/// Custom API page exposing Job Planning Lines for budget data.
/// Enables Thyme to show budget vs actual comparisons in project views.
///
/// Endpoint: /api/knowall/thyme/v1.0/companies({companyId})/jobPlanningLines
/// </summary>
page 50107 "Thyme Job Planning Lines API"
{
    APIGroup = 'thyme';
    APIPublisher = 'knowall';
    APIVersion = 'v1.0';
    EntityName = 'jobPlanningLine';
    EntitySetName = 'jobPlanningLines';
    PageType = API;
    SourceTable = "Job Planning Line";
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
                }
                field(jobNo; Rec."Job No.")
                {
                    Caption = 'Job No.';
                }
                field(jobTaskNo; Rec."Job Task No.")
                {
                    Caption = 'Job Task No.';
                }
                field(lineNo; Rec."Line No.")
                {
                    Caption = 'Line No.';
                }
                field(planningDate; Rec."Planning Date")
                {
                    Caption = 'Planning Date';
                }
                field(lineType; Rec."Line Type")
                {
                    Caption = 'Line Type';
                }
                field(type; Rec.Type)
                {
                    Caption = 'Type';
                }
                field(resourceNo; Rec."No.")
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
                field(unitCost; Rec."Unit Cost")
                {
                    Caption = 'Unit Cost';
                }
                field(unitPrice; Rec."Unit Price")
                {
                    Caption = 'Unit Price';
                }
                field(totalCost; Rec."Total Cost")
                {
                    Caption = 'Total Cost';
                }
                field(totalPrice; Rec."Total Price")
                {
                    Caption = 'Total Price';
                }
                field(lastModifiedDateTime; Rec.SystemModifiedAt)
                {
                    Caption = 'Last Modified DateTime';
                }
            }
        }
    }
}
