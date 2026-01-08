/// <summary>
/// Custom API page exposing Time Sheet Details (daily hour entries).
/// Each detail record represents hours worked on a specific date for a time sheet line.
///
/// Endpoint: /api/knowall/thyme/v1.0/companies({companyId})/timeSheetDetails
/// </summary>
page 50106 "Thyme Time Sheet Detail API"
{
    APIGroup = 'thyme';
    APIPublisher = 'knowall';
    APIVersion = 'v1.0';
    EntityName = 'timeSheetDetail';
    EntitySetName = 'timeSheetDetails';
    PageType = API;
    SourceTable = "Time Sheet Detail";
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
                field(timeSheetLineNo; Rec."Time Sheet Line No.")
                {
                    Caption = 'Time Sheet Line No.';
                }
                field(date; Rec.Date)
                {
                    Caption = 'Date';
                }
                field(type; Rec.Type)
                {
                    Caption = 'Type';
                }
                field(resourceNo; Rec."Resource No.")
                {
                    Caption = 'Resource No.';
                }
                field(jobNo; Rec."Job No.")
                {
                    Caption = 'Job No.';
                }
                field(jobTaskNo; Rec."Job Task No.")
                {
                    Caption = 'Job Task No.';
                }
                field(causeOfAbsenceCode; Rec."Cause of Absence Code")
                {
                    Caption = 'Cause of Absence Code';
                }
                field(quantity; Rec.Quantity)
                {
                    Caption = 'Quantity';
                }
                field(postedQuantity; Rec."Posted Quantity")
                {
                    Caption = 'Posted Quantity';
                }
                field(status; Rec.Status)
                {
                    Caption = 'Status';
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
