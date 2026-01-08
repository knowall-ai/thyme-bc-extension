/// <summary>
/// Custom API page exposing the current user's BC User ID.
/// Enables Thyme to identify the logged-in user and match them to a Resource.
///
/// Endpoint: /api/knowall/thyme/v1.0/companies({companyId})/currentUser
/// </summary>
page 50106 "Thyme Current User API"
{
    APIGroup = 'thyme';
    APIPublisher = 'knowall';
    APIVersion = 'v1.0';
    EntityName = 'currentUser';
    EntitySetName = 'currentUser';
    PageType = API;
    SourceTable = User;
    SourceTableView = sorting("User Security ID");
    DelayedInsert = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    ODataKeyFields = "User Security ID";
    Extensible = false;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(userSecurityId; Rec."User Security ID")
                {
                    Caption = 'User Security ID';
                    Editable = false;
                }
                field(userName; Rec."User Name")
                {
                    Caption = 'User Name';
                    Editable = false;
                }
                field(fullName; Rec."Full Name")
                {
                    Caption = 'Full Name';
                    Editable = false;
                }
                field(state; Rec.State)
                {
                    Caption = 'State';
                    Editable = false;
                }
                field(expiryDate; Rec."Expiry Date")
                {
                    Caption = 'Expiry Date';
                    Editable = false;
                }
                field(authenticationEmail; Rec."Authentication Email")
                {
                    Caption = 'Authentication Email';
                    Editable = false;
                }
                field(contactEmail; Rec."Contact Email")
                {
                    Caption = 'Contact Email';
                    Editable = false;
                }
                field(licenseType; Rec."License Type")
                {
                    Caption = 'License Type';
                    Editable = false;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.SetRange("User Security ID", UserSecurityId());
    end;
}
