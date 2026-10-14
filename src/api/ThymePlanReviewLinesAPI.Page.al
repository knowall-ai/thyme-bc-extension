/// <summary>
/// Custom API page for the findings of AI plan reviews. planningDate = 0001-01-01 (blank)
/// means the finding is about the whole week. check is the check that raised it: ROUNDING,
/// OVER_CAPACITY, BILLABLE_TARGET, CALENDAR, BUDGET_BURN, PLAN_SHAPE, OUTSIDE_PROJECT_DATES
/// or OTHER.
///
/// Findings for one review:
///   GET .../planReviewLines?$filter=reviewEntryNo eq 42
///
/// Who can do what (codeunit "Thyme Record Security"): every Thyme user reads them; only the
/// AI agent or a Thyme administrator creates, changes or deletes them.
///
/// Endpoint: /api/knowall/thyme/v1.0/companies({companyId})/planReviewLines
/// </summary>
page 50119 "Thyme Plan Review Lines API"
{
    APIGroup = 'thyme';
    APIPublisher = 'knowall';
    APIVersion = 'v1.0';
    EntityName = 'planReviewLine';
    EntitySetName = 'planReviewLines';
    EntityCaption = 'Plan Review Line';
    EntitySetCaption = 'Plan Review Lines';
    PageType = API;
    SourceTable = "Thyme Plan Review Line";
    DelayedInsert = true;
    ODataKeyFields = SystemId;
    Extensible = false;
    // THYME ADMIN writes findings only indirectly, through this page and its
    // CheckCanWritePlanReviews triggers; the AI agent has direct access.
    Permissions = tabledata "Thyme Plan Review Line" = rimd;

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
                field(reviewEntryNo; Rec."Review Entry No.")
                {
                    Caption = 'Review Entry No.';
                }
                field(lineNo; Rec."Line No.")
                {
                    Caption = 'Line No.';
                }
                field(severity; Rec.Severity)
                {
                    Caption = 'Severity';
                }
                field(check; Rec.Check)
                {
                    Caption = 'Check';
                }
                field(planningDate; Rec."Planning Date")
                {
                    Caption = 'Planning Date';
                }
                field(jobNo; Rec."Job No.")
                {
                    Caption = 'Job No.';
                }
                field(resourceNo; Rec."Resource No.")
                {
                    Caption = 'Resource No.';
                }
                field(note; Rec.Note)
                {
                    Caption = 'Note';
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
        RecordSecurity: Codeunit "Thyme Record Security";
    begin
        RecordSecurity.CheckCanWritePlanReviews();
        exit(true);
    end;

    trigger OnModifyRecord(): Boolean
    var
        RecordSecurity: Codeunit "Thyme Record Security";
    begin
        RecordSecurity.CheckCanWritePlanReviews();
        exit(true);
    end;

    trigger OnDeleteRecord(): Boolean
    var
        RecordSecurity: Codeunit "Thyme Record Security";
    begin
        RecordSecurity.CheckCanWritePlanReviews();
        exit(true);
    end;
}
