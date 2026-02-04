/// <summary>
/// Custom API page exposing Resource Units of Measure conversion factors.
/// Used to convert quantities from units like DAY to base unit HOUR.
///
/// Example: resourceNo="EMP001", code="DAY", qtyPerUnitOfMeasure=8
/// means 1 DAY = 8 HOURs for that resource.
///
/// Endpoint: /api/knowall/thyme/v1.0/companies({companyId})/resourceUnitsOfMeasure
/// </summary>
page 50108 "Thyme Resource UoM API"
{
    APIGroup = 'thyme';
    APIPublisher = 'knowall';
    APIVersion = 'v1.0';
    EntityName = 'resourceUnitOfMeasure';
    EntitySetName = 'resourceUnitsOfMeasure';
    PageType = API;
    SourceTable = "Resource Unit of Measure";
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
                field(resourceNo; Rec."Resource No.")
                {
                    Caption = 'Resource No.';
                }
                field(code; Rec.Code)
                {
                    Caption = 'Code';
                }
                field(qtyPerUnitOfMeasure; Rec."Qty. per Unit of Measure")
                {
                    Caption = 'Qty. per Unit of Measure';
                }
                field(relatedToBaseUnitOfMeasure; Rec."Related to Base Unit of Meas.")
                {
                    Caption = 'Related to Base Unit of Measure';
                }
                field(lastModifiedDateTime; Rec.SystemModifiedAt)
                {
                    Caption = 'Last Modified DateTime';
                }
            }
        }
    }
}
