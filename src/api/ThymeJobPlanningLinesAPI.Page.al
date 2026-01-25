/// <summary>
/// Custom API page exposing Job Planning Lines for budget data.
/// Now supports creating planning lines in addition to reading.
/// Enables Thyme to show budget vs actual comparisons and create resource allocations.
///
/// Endpoint: /api/knowall/thyme/v1.0/companies({companyId})/jobPlanningLines
///
/// POST to create new planning lines. Required fields: jobNo, jobTaskNo, planningDate, number, quantity
/// Optional: type (defaults to Resource), lineType (defaults to Budget)
/// lineNo is auto-generated in increments of 10000.
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
                    Editable = false;
                }
            }
        }
    }

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    var
        JobPlanningLine: Record "Job Planning Line";
        NextLineNo: Integer;
    begin
        // Auto-assign Line No. if not provided or is 0
        if Rec."Line No." = 0 then begin
            JobPlanningLine.SetRange("Job No.", Rec."Job No.");
            JobPlanningLine.SetRange("Job Task No.", Rec."Job Task No.");
            if JobPlanningLine.FindLast() then
                NextLineNo := JobPlanningLine."Line No." + 10000
            else
                NextLineNo := 10000;
            Rec."Line No." := NextLineNo;
        end;

        // Default Type to Resource if not specified (for time/resource planning)
        if Rec.Type = Rec.Type::" " then
            Rec.Type := Rec.Type::Resource;

        // Default Line Type to Budget if not specified
        if Rec."Line Type" = Rec."Line Type"::" " then
            Rec."Line Type" := Rec."Line Type"::Budget;

        exit(true); // Continue with default insert
    end;
}
