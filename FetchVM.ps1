# Powershell script to pull the VM files from GitHub into the current folder.
# Edit the following to match the version of the VM that is compatible with this image

param 
(
    [string]$VMversion="7.0.54.1"
)

# Override Powershell's default use of TLS1.0 for web requests; this is insecure and no longer works with GitHub
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12


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