using module AnyPackage
using namespace AnyPackage.Provider

[PackageProvider('ZIP', FileExtensions = '.zip', PackageByName = $false)]
class ZipProvider : PackageProvider {
    
}

[guid] $id = 'f502ce32-5147-4e46-a774-d2dbd6acad67'
[PackageProviderManager]::RegisterProvider($id, [ZipProvider], $MyInvocation.MyCommand.ScriptBlock.Module)

$MyInvocation.MyCommand.ScriptBlock.Module.OnRemove = {
    [PackageProviderManager]::UnregisterProvider($id)
}
