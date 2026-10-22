/// <summary>
/// Custom API page exposing Projects (Jobs) with additional fields
/// not available in the standard BC API v2.0.
///
/// sellToCustomerNo / sellToCustomerName are the customer the project's work is for, and
/// billToCustomerNo / billToCustomerName the customer who pays for it. They differ when the work is
/// sold through a partner: Sell-to is the end client and Bill-to the partner. These are Business
/// Central's own Project fields and follow its rules: changing sellToCustomerNo also sets the Bill-to
/// customer (to the new customer's Bill-to Customer, or the customer itself), and either is refused
/// once the project has invoiced (Sale) ledger entries or sales lines. To change the Sell-to customer
/// and keep the Bill-to customer, send both in one PATCH: sellToCustomerNo comes first on this page,
/// so it is applied before billToCustomerNo.
///
/// canEditSourceLinks is true when the caller may add, change and remove the project's linked
/// sources (see the projectSourceLinks endpoint): a Thyme administrator or the project's manager.
///
/// canEditPlan is true when the caller may change the plan (the project's resource planning lines
/// and what goes with them): a user with permission to write Job Planning Lines. Per caller, the
/// same on every row.
///
/// Endpoint: /api/knowall/thyme/v1.0/companies({companyId})/projects
/// </summary>
page 50100 "Thyme Projects API"
{
    APIGroup = 'thyme';
    APIPublisher = 'knowall';
    APIVersion = 'v1.0';
    EntityName = 'project';
    EntitySetName = 'projects';
    PageType = API;
    SourceTable = Job;
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
                field(number; Rec."No.")
                {
                    Caption = 'Number';
                }
                field(displayName; Rec.Description)
                {
                    Caption = 'Display Name';
                }
                // Before the Bill-to fields: on a PATCH with both, BC applies Sell-to first (which
                // also sets Bill-to), then the Bill-to that was sent.
                field(sellToCustomerNo; Rec."Sell-to Customer No.")
                {
                    Caption = 'Sell-to Customer No.';
                }
                // Read-only: set sellToCustomerNo, and BC fills in the name from the customer.
                field(sellToCustomerName; Rec."Sell-to Customer Name")
                {
                    Caption = 'Sell-to Customer Name';
                    Editable = false;
                }
                field(billToCustomerNo; Rec."Bill-to Customer No.")
                {
                    Caption = 'Bill-to Customer No.';
                }
                field(billToCustomerName; Rec."Bill-to Name")
                {
                    Caption = 'Bill-to Customer Name';
                }
                field(personResponsible; Rec."Person Responsible")
                {
                    Caption = 'Person Responsible';
                }
                field(status; Rec.Status)
                {
                    Caption = 'Status';
                }
                field(blocked; Rec.Blocked)
                {
                    Caption = 'Blocked';
                }
                field(startingDate; Rec."Starting Date")
                {
                    Caption = 'Starting Date';
                }
                field(endingDate; Rec."Ending Date")
                {
                    Caption = 'Ending Date';
                }
                // Currency of the project's prices (Job Planning Lines and Job Ledger Entries).
                // Blank means the company's local currency (LCY). Read-only: changing it in BC
                // re-prices the planning lines, so it isn't something to PATCH through the API.
                field(currencyCode; Rec."Currency Code")
                {
                    Caption = 'Currency Code';
                    Editable = false;
                }
                field(canEditSourceLinks; CanEditSourceLinks)
                {
                    Caption = 'Can Edit Source Links';
                    Editable = false;
                }
                // Whether the caller may change the plan. Per caller; read-only.
                field(canEditPlan; CanEditPlan)
                {
                    Caption = 'Can Edit Plan';
                    Editable = false;
                }
                field(lastModifiedDateTime; Rec.SystemModifiedAt)
                {
                    Caption = 'Last Modified DateTime';
                    Editable = false;
                }
            }
        }
    }

    var
        CallerIsThymeAdmin: Boolean;
        CanEditSourceLinks: Boolean;
        CanEditPlan: Boolean;

    trigger OnOpenPage()
    var
        RecordSecurity: Codeunit "Thyme Record Security";
    begin
        CallerIsThymeAdmin := RecordSecurity.IsThymeAdmin();
        CanEditPlan := RecordSecurity.CanEditPlan();
    end;

    trigger OnAfterGetRecord()
    var
        RecordSecurity: Codeunit "Thyme Record Security";
    begin
        CanEditSourceLinks := RecordSecurity.CanEditProjectSourceLinks(Rec, CallerIsThymeAdmin);
    end;
}
