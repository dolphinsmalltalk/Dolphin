
# Powershell script to pull the VM files from GitHub into the current folder.
# Edit the following to match the version of the VM that is compatible with this image

param 
(
    [string]$VMversion="v7.0.49"
)

Try 
{
	$scriptDir = Split-Path $script:MyInvocation.MyCommand.Path;
	Write-Host "Fetching DolphinVM.zip" $VMversion
	$source = "https://github.com/dolphinsmalltalk/DolphinVM/releases/download/$VMversion/DolphinVM.zip";
	$zipFile = $scriptDir+"\DolphinVM.zip";
	Invoke-WebRequest $source -OutFile $zipFile;
}
Catch
{
	Write-Host "Unable to fetch DolphinVM.zip" $VMversion;
	Break;
}

$shell = new-object -com shell.application;
$zip = $shell.NameSpace($zipFile);
foreach($item in $zip.items())
{
	Write-Host "..unpack" $item.Name
	$shell.Namespace($scriptDir).copyhere($item, 0x14);
}
Write-Host "Removing Zip"
Remove-Item $zipFile
Write-Host "Done fetching DolphinVM.zip" $VMversion