/// <summary>
/// Applies a plan review finding's proposed changes to the plan (Resource Job Planning Lines) in
/// one transaction: Thyme's "Apply change", through the planReviewLines API's applyChanges action.
///
/// Only a user who may change the plan (Thyme Record Security's CanEditPlan: permission to write
/// Job Planning Lines) can apply. Every cell is checked before anything is written: it must be
/// empty or hold exactly one Budget line, and its hours must still be the change's Current Hours.
/// Then each cell gets its Proposed Hours (0 deletes the line; an empty cell gets a new Budget
/// line), and the finding is stamped Applied At / Applied By. Any error rolls all of it back.
///
/// Hours follow Thyme's rule: if the resource has an HOUR unit of measure whose factor isn't 1,
/// the base unit is a day of (factor, or 1 / factor when below 1) hours; otherwise it's an hour.
///
/// The Permissions property gives the indirect rights this needs (writing planning lines, stamping
/// the finding); THYME USER grants the matching indirect modify on findings, and CanEditPlan gates
/// the planning-line writes, so only people who may change the plan succeed.
/// </summary>
codeunit 50107 "Thyme Plan Review Apply"
{
    Permissions = tabledata "Job Planning Line" = rimd,
                  tabledata "Thyme Plan Review" = r,
                  tabledata "Thyme Plan Review Line" = rm,
                  tabledata "Thyme Plan Review Change" = r,
                  tabledata "Resource Unit of Measure" = r,
                  tabledata Job = r;

    var
        NotAllowedToChangePlanErr: Label 'You don''t have permission to change the plan.';
        NoChangesErr: Label 'Finding %2 of plan review %1 has no changes to apply.', Comment = '%1 = review entry number, %2 = finding line number';
        SeveralLinesErr: Label 'Edit this cell by hand: %1 has %2 planning lines on %3 for project %4, task %5.', Comment = '%1 = resource number, %2 = number of lines, %3 = planning date, %4 = job number, %5 = job task number';
        NotBudgetLineErr: Label 'Edit this cell by hand: the planning line for %1 on %2 for project %3, task %4 is a %5 line, not a Budget line.', Comment = '%1 = resource number, %2 = planning date, %3 = job number, %4 = job task number, %5 = line type';
        PlanChangedErr: Label 'The plan changed since Poppie looked. Ask her to re-review.';
        HourUoMTok: Label 'HOUR', Locked = true;

    /// <summary>
    /// Applies all of the finding's changes, or none of them (an error rolls back the lot).
    /// </summary>
    procedure ApplyChanges(var ReviewLine: Record "Thyme Plan Review Line")
    var
        ReviewChange: Record "Thyme Plan Review Change";
        JobPlanningLine: Record "Job Planning Line";
        RecordSecurity: Codeunit "Thyme Record Security";
    begin
        RecordSecurity.CheckCanEditPlan(NotAllowedToChangePlanErr);

        ReviewChange.SetRange("Review Entry No.", ReviewLine."Review Entry No.");
        ReviewChange.SetRange("Review Line No.", ReviewLine."Line No.");
        if ReviewChange.IsEmpty() then
            Error(NoChangesErr, ReviewLine."Review Entry No.", ReviewLine."Line No.");

        // Hold the planning lines until commit, so the cells can't change between check and write.
        JobPlanningLine.LockTable();

        // Check every cell first; write only once they all pass.
        ReviewChange.FindSet();
        repeat
            CheckCell(ReviewChange);
        until ReviewChange.Next() = 0;

        ReviewChange.FindSet();
        repeat
            ApplyCell(ReviewChange);
        until ReviewChange.Next() = 0;

        ReviewLine.Get(ReviewLine."Review Entry No.", ReviewLine."Line No.");
        ReviewLine."Applied At" := CurrentDateTime();
        ReviewLine."Applied By" := CopyStr(UpperCase(UserId()), 1, MaxStrLen(ReviewLine."Applied By"));
        ReviewLine.Modify(true);
    end;

    local procedure CheckCell(ReviewChange: Record "Thyme Plan Review Change")
    var
        CellLine: Record "Job Planning Line";
        CellHours: Decimal;
        LineCount: Integer;
    begin
        FilterCell(CellLine, ReviewChange);
        LineCount := CellLine.Count();
        if LineCount > 1 then
            Error(SeveralLinesErr, ReviewChange."Resource No.", LineCount, ReviewChange."Planning Date", ReviewChange."Job No.", ReviewChange."Job Task No.");
        if LineCount = 1 then begin
            CellLine.FindFirst();
            if CellLine."Line Type" <> CellLine."Line Type"::Budget then
                Error(NotBudgetLineErr, ReviewChange."Resource No.", ReviewChange."Planning Date", ReviewChange."Job No.", ReviewChange."Job Task No.", CellLine."Line Type");
            CellHours := CellLine.Quantity * HoursPerUnit(ReviewChange."Resource No.");
        end;
        if Abs(CellHours - ReviewChange."Current Hours") >= 0.005 then
            Error(PlanChangedErr);
    end;

    local procedure ApplyCell(ReviewChange: Record "Thyme Plan Review Change")
    var
        CellLine: Record "Job Planning Line";
        NewQuantity: Decimal;
    begin
        NewQuantity := ReviewChange."Proposed Hours" / HoursPerUnit(ReviewChange."Resource No.");
        FilterCell(CellLine, ReviewChange);
        if CellLine.FindFirst() then begin
            if ReviewChange."Proposed Hours" = 0 then
                CellLine.Delete(true)
            else begin
                CellLine.Validate(Quantity, NewQuantity);
                CellLine.Modify(true);
            end;
            exit;
        end;
        if ReviewChange."Proposed Hours" = 0 then
            exit;
        InsertCellLine(ReviewChange, NewQuantity);
    end;

    local procedure InsertCellLine(ReviewChange: Record "Thyme Plan Review Change"; NewQuantity: Decimal)
    var
        NewLine: Record "Job Planning Line";
        LastLine: Record "Job Planning Line";
        Job: Record Job;
    begin
        LastLine.SetRange("Job No.", ReviewChange."Job No.");
        LastLine.SetRange("Job Task No.", ReviewChange."Job Task No.");
        NewLine.Init();
        NewLine."Job No." := ReviewChange."Job No.";
        NewLine."Job Task No." := ReviewChange."Job Task No.";
        if LastLine.FindLast() then
            NewLine."Line No." := LastLine."Line No." + 10000
        else
            NewLine."Line No." := 10000;
        // As the jobPlanningLines API does: BC only copies the project's currency onto a planning
        // line in OnInsert, after it is priced, so set it first to price the line in that currency.
        if Job.Get(ReviewChange."Job No.") then
            if NewLine."Currency Code" <> Job."Currency Code" then begin
                NewLine."Currency Code" := Job."Currency Code";
                NewLine.UpdateCurrencyFactor();
            end;
        NewLine.Validate("Line Type", NewLine."Line Type"::Budget);
        NewLine.Validate("Planning Date", ReviewChange."Planning Date");
        NewLine.Validate(Type, NewLine.Type::Resource);
        NewLine.Validate("No.", ReviewChange."Resource No.");
        NewLine.Validate(Quantity, NewQuantity);
        NewLine.Insert(true);
    end;

    /// <summary>The cell's lines: this project task, resource and day, with a quantity.</summary>
    local procedure FilterCell(var CellLine: Record "Job Planning Line"; ReviewChange: Record "Thyme Plan Review Change")
    begin
        CellLine.SetRange("Job No.", ReviewChange."Job No.");
        CellLine.SetRange("Job Task No.", ReviewChange."Job Task No.");
        CellLine.SetRange(Type, CellLine.Type::Resource);
        CellLine.SetRange("No.", ReviewChange."Resource No.");
        CellLine.SetRange("Planning Date", ReviewChange."Planning Date");
        CellLine.SetFilter(Quantity, '<>0');
    end;

    /// <summary>
    /// Hours in one base unit of the resource: the HOUR unit's factor (or its inverse when below 1)
    /// when it exists and isn't 1, i.e. the base unit is a day; otherwise 1 (the base unit is an hour).
    /// </summary>
    local procedure HoursPerUnit(ResourceNo: Code[20]): Decimal
    var
        ResourceUoM: Record "Resource Unit of Measure";
        Factor: Decimal;
    begin
        if not ResourceUoM.Get(ResourceNo, HourUoMTok) then
            exit(1);
        Factor := ResourceUoM."Qty. per Unit of Measure";
        if (Factor = 0) or (Factor = 1) then
            exit(1);
        if Factor > 1 then
            exit(Factor);
        exit(1 / Factor);
    end;
}
