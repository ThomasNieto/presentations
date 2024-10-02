@{
    RootModule = 'AnyPackage.Zip.psm1'
    ModuleVersion = '0.1.0'
    CompatiblePSEditions = @('Desktop', 'Core')
    GUID = 'eec9235b-69ab-4c9e-9ef9-4b70eb25fd8f'
    Author = 'Thomas Nieto'
    Copyright = '(c) 2024 Thomas Nieto. All rights reserved.'
    Description = 'ZIP provider for AnyPackage.'
    PowerShellVersion = '5.1'
    RequiredModules = @(
        @{ ModuleName = 'AnyPackage'; ModuleVersion = '0.7.0' }
    )
    FunctionsToExport = @()
    CmdletsToExport = @()
    AliasesToExport = @()
    PrivateData = @{
        AnyPackage = @{
            Providers = 'ZIP'
        }
        PSData = @{
            Tags = @('AnyPackage', 'Provider', 'ZIP', 'Windows', 'Linux', 'MacOS')
            LicenseUri = 'https://github.com/anypackage/zip/blob/main/LICENSE'
            ProjectUri = 'https://github.com/anypackage/zip'
        }
    }
    HelpInfoURI = 'https://go.anypackage.dev/help'
}
