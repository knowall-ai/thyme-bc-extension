/// <summary>
/// Shows the Thyme billable target on the Resource Card.
/// </summary>
pageextension 50100 "Thyme Resource Card" extends "Resource Card"
{
    layout
    {
        addlast(Content)
        {
            group(Thyme)
            {
                Caption = 'Thyme';

                field("Thyme Billable Target %"; Rec."Thyme Billable Target %")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the percentage of this person''s logged time that should be billable, from 0 to 100. Entering a value, including 0, sets a target for this person and turns on Billable Target Set.';
                }
                field("Thyme Billable Target Set"; Rec."Thyme Billable Target Set")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether this person has their own billable target. When this is off, Thyme uses the Default Billable Target % from Thyme Setup. Turning it off clears the person''s target.';
                }
            }
        }
    }
}
