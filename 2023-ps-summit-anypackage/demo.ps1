$ProgressPreference = 'SilentlyContinue'

# AnyPackage is a PackageManagement (OneGet) replacement
# Manage packages from various package managers

# Package commands
Get-Command -Noun Package -Module AnyPackage

# Source commands
Get-Command -Noun PackageSource -Module AnyPackage

# Find package providers
Find-PSResource -Tag AnyPackage -ErrorAction SilentlyContinue | Where-Object Tags -Contains Provider

# Install package provider
Install-PSResource AnyPackage.Scoop

# List available providers
Get-PackageProvider -ListAvailable

# Import package provider
Import-Module AnyPackage.PowerShellGet

# Import all available package providers
Get-PackageProvider -ListAvailable | Select-Object -ExpandProperty Module | Import-Module

# Get imported package providers
Get-PackageProvider

# Remove package provider
Remove-Module AnyPackage.Chocolatey -ErrorAction SilentlyContinue
Get-PackageProvider

# Get packages
$packages = Get-Package
$packages

# Version property is sortable
$packages | Sort-Object Version

# Version property supports multiple version schemes
$packages | Select-Object -ExpandProperty Version | Group-Object Scheme

# Count Name                      Group
# ----- ----                      -----
#    66 AlphaNumeric              {20221229.172126.d813aa6, 1.0.9_1, 4882-g6e0a6b7e5, 4882-g6e0a6b7e5…}
#    12 Integer                   {9477386, 20130305, 112, 20230214…}
#   224 MultiPartNumeric          {22.01, 19.00, 0.9.1.326, 1.89…}
#     7 MultiPartNumericSuffix    {1.4g, 0.2.4a4, 3.02a09, 3.1.2b…}
#   922 SemanticVersion           {2.15.0, 1.0.0, 3.7.0, 0.6.0…}

# Version parameter
Find-Package PSReadLine -Version *
Find-Package PSReadLine -Version 2.0
Find-Package PSReadLine -Version '[1.0,2.0)'
Find-Package PSReadLine -Version '(,2.0)'
Find-Package PSReadLine -Version '[1.0,)'

# Find and Get return all packages with that version range while
# Install, Update, Save use the latest version

# Find package by Path and Uri
Find-Package -Path c:\test\*
Find-Package -LiteralPath C:\test\windows10.0-kb4570334-x64_ba511aeaff89c0d9ed999541909dd50758280132.msu

# Install/Update/Uninstall package
Install-Package snmp -Version 1.0 -PassThru
Update-Package snmp -PassThru
Get-Package snmp
Uninstall-Package snmp -PassThru

# Install using specified provider
Install-Package 7zip -Provider Scoop -PassThru
Install-Package Mozilla.Firefox -Provider WinGet -PassThru
Install-Package python -Provider Chocolatey -PassThru

# Save package
Save-Package snmp -Path $env:TEMP -PassThru

# Provider dynamic parameters
Find-Package -
Find-Package -Provider PowerShellGet -





# DSC Package Present
$params = @{
    Name       = 'Package'
    ModuleName = 'AnyPackageDsc'
    Method     = 'Set'
    Property   = @{
        Name     = 'snmp'
        Provider = 'AnyPackage.PowerShellGet\PowerShellGet'
        Version  = '*'
        Ensure   = 'Present'
    }
}

Invoke-DscResource @params

# DSC Package Get
$params.Method = 'Get'
Invoke-DscResource @params

# DSC Package Absent
$params.Method = 'Set'
$params.Property.Ensure = 'Absent'
Invoke-DscResource @params

# DSC Source
$params = @{
    Name       = 'Source'
    ModuleName = 'AnyPackageDsc'
    Method     = 'Set'
    Property   = @{
        Name     = 'Test'
        Provider = 'AnyPackage.PowerShellGet\PowerShellGet'
        Location = 'file:///C:/Test'
        Ensure   = 'Present'
    }
}

Invoke-DscResource @params

# DSC Source Get
$params.Method = 'Get'
Invoke-DscResource @params

# DSC Source Absent
$params.Method = 'Set'
$params.Property.Ensure = 'Absent'
Invoke-DscResource @params
