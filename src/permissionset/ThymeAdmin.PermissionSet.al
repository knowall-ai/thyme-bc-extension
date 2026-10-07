/// <summary>
/// For Thyme administrators: everything in THYME USER, plus changing the company-wide
/// Thyme settings (the default billable target) through the thymeSetup API or the
/// Thyme Setup page. Per-person billable targets are Resource fields, so editing them
/// needs modify permission on Resource from the standard D365 permission sets.
/// </summary>
permissionset 50102 "THYME ADMIN"
{
    Assignable = true;
    Caption = 'Thyme Admin';
    IncludedPermissionSets = "THYME USER";

    Permissions =
        tabledata "Thyme Setup" = RIM,
        page "Thyme Setup" = X;
}
