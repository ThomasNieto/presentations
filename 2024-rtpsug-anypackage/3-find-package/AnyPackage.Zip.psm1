using module AnyPackage
using namespace AnyPackage.Provider
using namespace System.IO
using namespace System.IO.Compression

[PackageProvider('ZIP', FileExtensions = '.zip', PackageByName = $false)]
class ZipProvider : PackageProvider, IFindPackage {
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
