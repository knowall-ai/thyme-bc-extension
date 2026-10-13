/// <summary>
/// A single finding within an AI plan review. "Check" says which check raised it (ROUNDING,
/// OVER_CAPACITY, BILLABLE_TARGET, CALENDAR, BUDGET_BURN, PLAN_SHAPE, OUTSIDE_PROJECT_DATES
/// or OTHER); "Planning Date" = 0D means the finding is about the whole week. A finding can
/// carry proposed changes to planning-line cells ("Thyme Plan Review Change"), applied together.
/// </summary>
table 50108 "Thyme Plan Review Line"
{
    Caption = 'Thyme Plan Review Line';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Review Entry No."; Integer)
        {
            Caption = 'Review Entry No.';
            TableRelation = "Thyme Plan Review"."Entry No.";
            NotBlank = true;
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(3; Severity; Enum "Thyme Review Severity")
        {
            Caption = 'Severity';
        }
        field(4; Check; Code[30])
        {
            Caption = 'Check';
        }
        // Optional: the day the finding is about (0D = the whole week).
        field(5; "Planning Date"; Date)
        {
            Caption = 'Planning Date';
        }
        field(6; "Job No."; Code[20])
        {
            Caption = 'Job No.';
            TableRelation = Job;
        }
        field(7; "Resource No."; Code[20])
        {
            Caption = 'Resource No.';
            TableRelation = Resource;
        }
        field(8; Note; Text[500])
        {
            Caption = 'Note';
        }
    }

    keys
    {
        key(PK; "Review Entry No.", "Line No.")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    var
        ReviewLine: Record "Thyme Plan Review Line";
    begin
        CheckAgainstReview();

        // Callers may omit lineNo; number findings in 10000 steps like BC's own lines.
        if "Line No." = 0 then begin
            ReviewLine.SetRange("Review Entry No.", "Review Entry No.");
            if ReviewLine.FindLast() then
                "Line No." := ReviewLine."Line No." + 10000
            else
                "Line No." := 10000;
        end;
    end;

    trigger OnModify()
    begin
        CheckAgainstReview();
    end;

    /// <summary>
    /// Deleting a finding removes its proposed changes too.
    /// </summary>
    trigger OnDelete()
    var
        ReviewChange: Record "Thyme Plan Review Change";
    begin
        ReviewChange.SetRange("Review Entry No.", "Review Entry No.");
        ReviewChange.SetRange("Review Line No.", "Line No.");
        if not ReviewChange.IsEmpty() then
            ReviewChange.DeleteAll();
    end;

    /// <summary>
    /// The review must exist, and a finding about a particular day must be about a day in the
    /// review's week.
    /// </summary>
    local procedure CheckAgainstReview()
    var
        Review: Record "Thyme Plan Review";
    begin
        TestField("Review Entry No.");
        if not Review.Get("Review Entry No.") then
            Error(ReviewNotFoundErr, "Review Entry No.");
        if "Planning Date" = 0D then
            exit;
        if ("Planning Date" < Review."Week Start") or ("Planning Date" > Review."Week Start" + 6) then
            Error(DateOutsideWeekErr, "Planning Date", Review."Week Start", "Review Entry No.");
    end;

    var
        ReviewNotFoundErr: Label 'Plan review %1 does not exist.', Comment = '%1 = review entry number';
        DateOutsideWeekErr: Label '%1 isn''t in the week starting %2 that plan review %3 covers.', Comment = '%1 = planning date, %2 = week start date, %3 = review entry number';
}
