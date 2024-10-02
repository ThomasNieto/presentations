function New-PackageInfo {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Name,

        [Parameter(ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Version,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]
        $Description,

        [Parameter(ValueFromPipelineByPropertyName)]
        [PackageSourceInfo]
        $Source,

        [Parameter(ValueFromPipelineByPropertyName)]
        [hashtable]
        $Metadata = @{ },

        [Parameter(ValueFromPipelineByPropertyName)]
        [PackageDependency[]]
        $Dependencies,

        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [PackageProviderInfo]
        $ProviderInfo
    )

    if ($PSBoundParameters['Version']) {
        $packageVersion = $Version
    } else {
        $packageVersion = $null
    }

    [PackageInfo]::new($Name, $packageVersion, $Source, $Description, $Dependencies, $Metadata, $ProviderInfo)
}

function New-SourceInfo {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Name,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]
        $Location,

        [Parameter(ValueFromPipelineByPropertyName)]
        [switch]
        $Trusted,

        [Parameter(ValueFromPipelineByPropertyName)]
        [hashtable]
        $Metadata = @{ },

        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [PackageProviderInfo]
        $ProviderInfo
    )

    [PackageSourceInfo]::new($Name, $Location, $Trusted, $Metadata, $ProviderInfo)
}

function New-PackageDependency {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Name,

        [Parameter(ValueFromPipelineByPropertyName)]
        [PackageVersionRange]
        $VersionRange,

        [Parameter(ValueFromPipelineByPropertyName)]
        [PackageProviderInfo]
        $ProviderInfo
    )

    if ($PSBoundParameters['ProviderInfo']) {
        [PackageDependency]::new($Name, $VersionRange, $ProviderInfo)
    }
    else {
        [PackageDependency]::new($Name, $VersionRange)
    }
}

function New-VersionRange {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ValueFromPipelineByPropertyName, ParameterSetName = 'Range')]
        [ValidateNotNullOrEmpty()]
        [string]
        $Range,

        [Parameter(ParameterSetName = 'PackageVersion')]
        [PackageVersion]
        $MinVersion,

        [Parameter(ParameterSetName = 'PackageVersion')]
        [PackageVersion]
        $MaxVersion,

        [Parameter()]
        [switch]
        $MinInclusive,

        [Parameter()]
        [switch]
        $MaxInclusive
    )

    if ($PSCmdlet.ParameterSetName -eq 'Range') {
        [PackageVersionRange]::new($Range)
    }
    else {
        [PackageVersionRange]::new($MinVersion, $MaxVersion, $IsMinInclusive, $IsMaxInclusive)
    }
}

function New-Feedback {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]
        $PackageName,

        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [PackageProviderInfo]
        $ProviderInfo
    )

    process {
        [CommandNotFoundFeedback]::new($PackageName, $ProviderInfo)
    }
}
