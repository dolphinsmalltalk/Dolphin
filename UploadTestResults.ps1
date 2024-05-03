# Powershell script to upload the regression tests results to AppVeyor

if ([System.IO.File]::Exists(".\RegressionTests.xml")) {
	$wc = New-Object 'System.Net.WebClient'
	$wc.UploadFile("https://ci.appveyor.com/api/testresults/junit/$($env:APPVEYOR_JOB_ID)", (Resolve-Path .\RegressionTests.xml))
}

