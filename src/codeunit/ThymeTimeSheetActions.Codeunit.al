/// <summary>
/// Codeunit providing time sheet approval workflow actions for the Thyme API.
/// Wraps BC's built-in Time Sheet Approval Management functionality.
/// </summary>
codeunit 50100 "Thyme Time Sheet Actions"
{
    /// <summary>
    /// Submits a time sheet for approval.
    /// </summary>
    procedure SubmitTimeSheet(var TimeSheetHeader: Record "Time Sheet Header")
    var
        TimeSheetApprovalMgt: Codeunit "Time Sheet Approval Management";
    begin
        TimeSheetApprovalMgt.Submit(TimeSheetHeader);
    end;

    /// <summary>
    /// Approves a submitted time sheet.
    /// </summary>
    procedure ApproveTimeSheet(var TimeSheetHeader: Record "Time Sheet Header")
    var
        TimeSheetApprovalMgt: Codeunit "Time Sheet Approval Management";
    begin
        TimeSheetApprovalMgt.Approve(TimeSheetHeader);
    end;

    /// <summary>
    /// Rejects a submitted time sheet.
    /// </summary>
    procedure RejectTimeSheet(var TimeSheetHeader: Record "Time Sheet Header")
    var
        TimeSheetApprovalMgt: Codeunit "Time Sheet Approval Management";
    begin
        TimeSheetApprovalMgt.Reject(TimeSheetHeader);
    end;

    /// <summary>
    /// Reopens a rejected or approved time sheet for editing.
    /// </summary>
    procedure ReopenTimeSheet(var TimeSheetHeader: Record "Time Sheet Header")
    var
        TimeSheetApprovalMgt: Codeunit "Time Sheet Approval Management";
    begin
        TimeSheetApprovalMgt.ReopenSubmitted(TimeSheetHeader);
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
