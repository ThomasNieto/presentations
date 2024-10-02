using module AnyPackage
using namespace AnyPackage.Provider
using namespace System.IO
using namespace System.IO.Compression

[PackageProvider('ZIP', FileExtensions = '.zip', PackageByName = $false)]
class ZipProvider : PackageProvider, IFindPackage, IGetPackage, IInstallPackage, IUninstallPackage, IUpdatePackage {
    [object] GetDynamicParameters([string] $commandName) {
        return $(switch ($commandName) {
                'Get-Package' { return [GetPackageDynamicParameters]::new() }
                default { return $null }
            })
    }

    [PackageProviderInfo] Initialize([PackageProviderInfo] $providerInfo) {
        return [ZipProviderInfo]::new($providerInfo)
    }
    
    [void] FindPackage([PackageRequest] $request) {
        $info = Get-PackageInfo -Path $request.Path
        
        $sourceParams = @{
            Name     = $request.Path
            Location = $request.Path
            Provider = $request.ProviderInfo
        }

        $source = New-SourceInfo @sourceParams

        $packageParams = @{
            Name        = $info.Name
            Version     = $info.Version
            Source      = $source
            Description = $info.Description
            Metadata    = ($info.Metadata | ConvertTo-Hashtable)
            Provider    = $request.ProviderInfo
        }

        $package = New-PackageInfo @packageParams
        $request.WritePackage($package)
    }

    [void] GetPackage([PackageRequest] $request) {
        $installPath = if ($request.DynamicParameters.Path) {
            $request.DynamicParameters.Path
        } else {
            $request.ProviderInfo.InstallPath
        }

        if (-not (Test-Path $installPath)) {
            return
        }

        $getChildItemParams = @{
            Path = (Join-Path $installPath '*/*/.package.json')
        }

        $files = Get-ChildItem @getChildItemParams

        foreach ($file in $files) {
            $info = $file | Get-Content | ConvertFrom-Json

            $sourceParams = @{
                Name     = $file.Directory
                Location = $file.Directory
                Provider = $request.ProviderInfo
            }
    
            $source = New-SourceInfo @sourceParams
    
            $packageParams = @{
                Name        = $info.Name
                Version     = $info.Version
                Source      = $source
                Description = $info.Description
                Metadata    = ($info.Metadata | ConvertTo-Hashtable)
                Provider    = $request.ProviderInfo
            }

            $package = New-PackageInfo @packageParams

            if ($request.IsMatch($package.Name, $package.Version)) { 
                $request.WritePackage($package)
            }
        }
    }

    [void] InstallPackage([PackageRequest] $request) {
        if ($request.ParameterSetName -eq 'InputObject') {
            $path = $request.Source
            $package = $request.Package
        } else {
            $path = $request.Path
            $info = Get-PackageInfo -Path $path
            
            $sourceParams = @{
                Name     = $request.Path
                Location = $request.Path
                Provider = $request.ProviderInfo
            }
    
            $source = New-SourceInfo @sourceParams

            $packageParams = @{
                Name        = $info.Name
                Version     = $info.Version
                Source      = $source
                Description = $info.Description
                Metadata    = ($info.Metadata | ConvertTo-Hashtable)
                Provider    = $request.ProviderInfo
            }
    
            $package = New-PackageInfo @packageParams
        }

        $installPath = Join-Path -Path $request.ProviderInfo.InstallPath -ChildPath "$($package.Name)/$($package.Version)"
        $request.WriteVerbose("Install path: $installPath")

        Expand-Archive -Path $path -DestinationPath $installPath -ErrorAction Stop
        $request.WritePackage($package)
    }

    [void] UninstallPackage([PackageRequest] $request) {
        if ($request.ParameterSetName -eq 'Name') {
            $getPackageParams = @{
                Name     = $request.Name
                Provider = $request.ProviderInfo.FullName
            }

            if ($request.Version) {
                $getPackageParams['Version'] = $request.Version
            }

            $packages = Get-Package @getPackageParams
        } else {
            $packages = $request.Package
        }

        foreach ($package in $packages) {
            if (Test-Path -Path $package.Source.Location) {
                Remove-Item -Path $package.Source.Location -Recurse -ErrorAction Stop
                $request.WritePackage($package)
            }
        }
    }

    [void] UpdatePackage([PackageRequest] $request) {
        if ($request.ParameterSetName -eq 'Path') {
            $findPackageParams = @{
                Path     = $request.Path
                Provider = $request.ProviderInfo.FullName
            }
            
            $findPackage = Find-Package @findPackageParams
        } else {
            $findPackage = $request.Package
        }
        
        if ($null -eq $findPackage) {
            return
        }

        $getPackageParams = @{
            Name     = $findPackage.Name
            Provider = $request.ProviderInfo.FullName
        }

        $latest = Get-Package @getPackageParams |
            Sort-Object Version -Descending |
            Select-Object -First 1

        if ($null -eq $latest) {
            return
        }

        if ($findPackage.Version -lt $latest.Version) {
            throw "Package '$($findPackage.Name)' version '$($findPackage.Version)' is less than installed version '$($latest.Version)'."
        }

        $package = $findPackage | Install-Package -PassThru -ErrorAction Stop
        $request.WritePackage($package)
    }
}

class GetPackageDynamicParameters {
    [Parameter()]
    [string]
    $Path
}

class ZipProviderInfo : PackageProviderInfo {
    [string] $InstallPath
    
    ZipProviderInfo([PackageProviderInfo] $providerInfo) : base($providerInfo) {
        if ($global:IsLinux -or $global:IsMacOS) {
            $this.InstallPath = Join-Path -Path $global:Home -ChildPath '.local/share/anypackage/zip'
        } else {
            $this.InstallPath = Join-Path -Path $env:LOCALAPPDATA -ChildPath 'anypackage/zip'
        }
    }
}

function Get-PackageInfo {
    param(
        [string]
        $Path
    )

    try {
        $fs = [FileStream]::new($Path, [FileMode]::Open)
        $zip = [ZipArchive]::new($fs)
        $file = $zip.Entries | Where-Object Name -EQ '.package.json'
        if (-not $file) { throw '.package.json not found in zip file.' }
        $sr = [StreamReader]::new($file.Open())
        $sr.ReadToEnd() | ConvertFrom-Json
    } finally {
        if ($fs) { $fs.Dispose() }
        if ($zip) { $zip.Dispose() }
        if ($sr) { $sr.Dispose() }
    }
}

function ConvertTo-Hashtable {
    param (
        [Parameter(ValueFromPipeline)]
        [PSObject]
        $InputObject
    )
    
    process {
        $props = $InputObject | Get-Member -MemberType Properties | Select-Object -ExpandProperty Name
        $ht = @{ }

        foreach ($prop in $props) {
            $ht[$prop] = $InputObject.$prop
        }

        $ht
    }
}

[guid] $id = 'f502ce32-5147-4e46-a774-d2dbd6acad67'
[PackageProviderManager]::RegisterProvider($id, [ZipProvider], $MyInvocation.MyCommand.ScriptBlock.Module)

$MyInvocation.MyCommand.ScriptBlock.Module.OnRemove = {
    [PackageProviderManager]::UnregisterProvider($id)
}
