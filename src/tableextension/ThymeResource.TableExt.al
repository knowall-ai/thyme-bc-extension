/// <summary>
/// Adds a per-person billable target to the Resource table.
///
/// "Thyme Billable Target Set" tells "not set" apart from a real 0% target:
/// - Set = false: the resource has no target of its own; Thyme uses the company default
///   from Thyme Setup ("Default Billable Target %"). The percentage is kept at 0.
/// - Set = true: "Thyme Billable Target %" is the resource's target, and 0 means 0%.
/// Entering a percentage marks the target as set; clearing the flag resets the percentage to 0.
/// </summary>
tableextension 50100 "Thyme Resource" extends Resource
{
    fields
    {
        field(50100; "Thyme Billable Target %"; Decimal)
        {
            Caption = 'Thyme Billable Target %';
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 2;
            MinValue = 0;
            MaxValue = 100;

            trigger OnValidate()
            begin
                Rec."Thyme Billable Target Set" := true;
            end;
        }
        field(50101; "Thyme Billable Target Set"; Boolean)
        {
            Caption = 'Thyme Billable Target Set';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if not Rec."Thyme Billable Target Set" then
                    Rec."Thyme Billable Target %" := 0;
            end;
        }
    }
}
