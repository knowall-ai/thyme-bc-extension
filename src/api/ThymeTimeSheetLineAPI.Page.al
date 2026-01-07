/// <summary>
/// Custom API page exposing Time Sheet Lines with job/task references and status.
/// This enables Thyme to display time entries in all approval states,
/// not just posted entries available via standard BC API v2.0.
///
/// Endpoint: /api/knowall/thyme/v1.0/companies({companyId})/timeSheetLines
/// </summary>
page 50103 "Thyme Time Sheet Line API"
{
    APIGroup = 'thyme';
    APIPublisher = 'knowall';
    APIVersion = 'v1.0';
    EntityName = 'timeSheetLine';
    EntitySetName = 'timeSheetLines';
    PageType = API;
    SourceTable = "Time Sheet Line";
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
                field(timeSheetNo; Rec."Time Sheet No.")
                {
                    Caption = 'Time Sheet No.';
                }
                field(lineNo; Rec."Line No.")
                {
                    Caption = 'Line No.';
                }
                field(timeSheetStartingDate; Rec."Time Sheet Starting Date")
                {
                    Caption = 'Time Sheet Starting Date';
                }
                field(lineType; Rec.Type)
                {
                    Caption = 'Type';
                }
                field(jobNo; Rec."Job No.")
                {
                    Caption = 'Job No.';
                }
                field(jobTaskNo; Rec."Job Task No.")
                {
                    Caption = 'Job Task No.';
                }
                field(description; Rec.Description)
                {
                    Caption = 'Description';
                }
                field(causeOfAbsenceCode; Rec."Cause of Absence Code")
                {
                    Caption = 'Cause of Absence Code';
                }
                field(workTypeCode; Rec."Work Type Code")
                {
                    Caption = 'Work Type Code';
                }
                field(chargeable; Rec.Chargeable)
                {
                    Caption = 'Chargeable';
                }
                field(totalQuantity; Rec."Total Quantity")
                {
                    Caption = 'Total Quantity';
                }
                field(status; Rec.Status)
                {
                    Caption = 'Status';
                }
                field(approvedBy; Rec."Approved By")
                {
                    Caption = 'Approved By';
                }
                field(approvalDate; Rec."Approval Date")
                {
                    Caption = 'Approval Date';
                }
                field(posted; Rec.Posted)
                {
                    Caption = 'Posted';
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
