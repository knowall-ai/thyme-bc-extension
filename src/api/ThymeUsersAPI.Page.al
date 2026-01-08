/// <summary>
/// Custom API page exposing BC Users with current user identification.
/// Enables Thyme to list users and identify the authenticated user.
///
/// Endpoint: /api/knowall/thyme/v1.0/companies({companyId})/users
/// </summary>
page 50106 "Thyme Users API"
{
    APIGroup = 'thyme';
    APIPublisher = 'knowall';
    APIVersion = 'v1.0';
    EntityName = 'user';
    EntitySetName = 'users';
    PageType = API;
    SourceTable = User;
    SourceTableView = sorting("User Name");
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
                field(isCurrentUser; IsCurrentUser)
                {
                    Caption = 'Is Current User';
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

    trigger OnAfterGetRecord()
    begin
        IsCurrentUser := Rec."User Security ID" = UserSecurityId();
    end;

    var
        IsCurrentUser: Boolean;
}
