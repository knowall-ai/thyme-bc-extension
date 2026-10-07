/// <summary>
/// An AI review of a time sheet, written by the reviewing agent through the
/// timesheetReviews API and read by the Thyme web app.
///
/// "Version Stamp" records the latest lastModifiedDateTime across the time sheet's
/// lines and details at the moment it was reviewed, so a reader can tell whether
/// the time sheet has changed since (and the review is therefore stale).
/// </summary>
table 50100 "Thyme Timesheet Review"
{
    Caption = 'Thyme Timesheet Review';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            AutoIncrement = true;
            Editable = false;
        }
        field(2; "Time Sheet No."; Code[20])
        {
            Caption = 'Time Sheet No.';
            TableRelation = "Time Sheet Header";
            NotBlank = true;
        }
        field(3; "Version Stamp"; DateTime)
        {
            Caption = 'Version Stamp';
        }
        field(4; Verdict; Enum "Thyme Review Verdict")
        {
            Caption = 'Verdict';
            // Default to the cautious outcome so a review posted without a verdict
            // never reads as an approval.
            InitValue = Check;
        }
        field(5; Summary; Text[2048])
        {
            Caption = 'Summary';
        }
        field(6; Reviewer; Text[100])
        {
            Caption = 'Reviewer';
        }
        field(7; "Reviewed At"; DateTime)
        {
            Caption = 'Reviewed At';
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
        // Supports "latest review for a time sheet" queries:
        // $filter=timeSheetNo eq '...'&$orderby=reviewedAt desc&$top=1
        key(TimeSheetReviewedAt; "Time Sheet No.", "Reviewed At")
        {
        }
    }

    trigger OnInsert()
    begin
        TestField("Time Sheet No.");
        TestField("Version Stamp");
        if "Reviewed At" = 0DT then
            "Reviewed At" := CurrentDateTime();
    end;

    trigger OnModify()
    begin
        TestField("Time Sheet No.");
        TestField("Version Stamp");
    end;

    /// <summary>
    /// Deleting a review removes its findings too, so no orphaned lines are left behind.
    /// </summary>
    trigger OnDelete()
    var
        ReviewLine: Record "Thyme Timesheet Review Line";
    begin
        ReviewLine.SetRange("Review Entry No.", "Entry No.");
        if not ReviewLine.IsEmpty() then
            ReviewLine.DeleteAll(true);
    end;
}
