# Powershell script to pull the VM files from GitHub into the current folder.
# Either invoke with a VMversion parameter specifying the version you want to download, 
# or use FetchVM.cmd, which will query git to determine the correct version.

param 
(
    [string]$tagVersion
)

# Override Powershell's default use of TLS1.0 for web requests; this is insecure and no longer works with GitHub
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

if(-not($tagVersion)) { Throw “tagVersion required (hint: Use/see fetchvm.cmd)” }

Try 
{
	$scriptDir = Split-Path $script:MyInvocation.MyCommand.Path;
	$parts = $tagVersion -split '\.'
	$VMversion = $parts[0] + '.' + $parts[1]
	Write-Host "Fetching DolphinVM.zip" $VMversion
	$source = "https://github.com/dolphinsmalltalk/Dolphin/releases/download/$VMversion/DolphinVM.zip";
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