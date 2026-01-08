/// <summary>
/// Codeunit providing time sheet approval workflow actions for the Thyme API.
/// Wraps BC's built-in Time Sheet Approval Management functionality.
/// </summary>
codeunit 50100 "Thyme Time Sheet Actions"
{
    /// <summary>
    /// Submits a time sheet for approval by submitting all open lines.
    /// </summary>
    procedure SubmitTimeSheet(var TimeSheetHeader: Record "Time Sheet Header")
    var
        TimeSheetLine: Record "Time Sheet Line";
        TimeSheetApprovalMgt: Codeunit "Time Sheet Approval Management";
    begin
        TimeSheetLine.SetRange("Time Sheet No.", TimeSheetHeader."No.");
        TimeSheetLine.SetRange(Status, TimeSheetLine.Status::Open);
        if TimeSheetLine.FindSet() then
            repeat
                TimeSheetApprovalMgt.Submit(TimeSheetLine);
            until TimeSheetLine.Next() = 0;
    end;

    /// <summary>
    /// Approves a submitted time sheet by approving all submitted lines.
    /// </summary>
    procedure ApproveTimeSheet(var TimeSheetHeader: Record "Time Sheet Header")
    var
        TimeSheetLine: Record "Time Sheet Line";
        TimeSheetApprovalMgt: Codeunit "Time Sheet Approval Management";
    begin
        TimeSheetLine.SetRange("Time Sheet No.", TimeSheetHeader."No.");
        TimeSheetLine.SetRange(Status, TimeSheetLine.Status::Submitted);
        if TimeSheetLine.FindSet() then
            repeat
                TimeSheetApprovalMgt.Approve(TimeSheetLine);
            until TimeSheetLine.Next() = 0;
    end;

    /// <summary>
    /// Rejects a submitted time sheet by rejecting all submitted lines.
    /// </summary>
    procedure RejectTimeSheet(var TimeSheetHeader: Record "Time Sheet Header")
    var
        TimeSheetLine: Record "Time Sheet Line";
        TimeSheetApprovalMgt: Codeunit "Time Sheet Approval Management";
    begin
        TimeSheetLine.SetRange("Time Sheet No.", TimeSheetHeader."No.");
        TimeSheetLine.SetRange(Status, TimeSheetLine.Status::Submitted);
        if TimeSheetLine.FindSet() then
            repeat
                TimeSheetApprovalMgt.Reject(TimeSheetLine);
            until TimeSheetLine.Next() = 0;
    end;

    /// <summary>
    /// Reopens a rejected or approved time sheet by reopening all non-open lines.
    /// </summary>
    procedure ReopenTimeSheet(var TimeSheetHeader: Record "Time Sheet Header")
    var
        TimeSheetLine: Record "Time Sheet Line";
        TimeSheetApprovalMgt: Codeunit "Time Sheet Approval Management";
    begin
        TimeSheetLine.SetRange("Time Sheet No.", TimeSheetHeader."No.");
        TimeSheetLine.SetFilter(Status, '%1|%2|%3',
            TimeSheetLine.Status::Submitted,
            TimeSheetLine.Status::Rejected,
            TimeSheetLine.Status::Approved);
        if TimeSheetLine.FindSet() then
            repeat
                TimeSheetApprovalMgt.ReopenSubmitted(TimeSheetLine);
            until TimeSheetLine.Next() = 0;
    end;

    /// <summary>
    /// Approves a specific time sheet line.
    /// </summary>
    procedure ApproveTimeSheetLine(var TimeSheetLine: Record "Time Sheet Line")
    var
        TimeSheetApprovalMgt: Codeunit "Time Sheet Approval Management";
    begin
        TimeSheetApprovalMgt.Approve(TimeSheetLine);
    end;

    /// <summary>
    /// Rejects a specific time sheet line.
    /// </summary>
    procedure RejectTimeSheetLine(var TimeSheetLine: Record "Time Sheet Line")
    var
        TimeSheetApprovalMgt: Codeunit "Time Sheet Approval Management";
    begin
        TimeSheetApprovalMgt.Reject(TimeSheetLine);
    end;

    /// <summary>
    /// Reopens a specific time sheet line for editing.
    /// </summary>
    procedure ReopenTimeSheetLine(var TimeSheetLine: Record "Time Sheet Line")
    var
        TimeSheetApprovalMgt: Codeunit "Time Sheet Approval Management";
    begin
        TimeSheetApprovalMgt.ReopenSubmitted(TimeSheetLine);
    end;
}
