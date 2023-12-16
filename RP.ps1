$AppList =@(
"Clipchamp.Clipchamp"
"Microsoft.549981C3F5F10"
"Microsoft.BingNews"
"Microsoft.BingWeather"
"Microsoft.GamingApp"
"Microsoft.GetHelp"
"Microsoft.Getstarted"
"Microsoft.MicrosoftOfficeHub"
"Microsoft.MicrosoftSolitaireCollection"
"Microsoft.MicrosoftStickyNotes"
"Microsoft.Paint"
"Microsoft.People"
"Microsoft.PowerAutomateDesktop"
"Microsoft.ScreenSketch"
"Microsoft.Todos"
"Microsoft.Windows.Photos"
"microsoft.windowscommunicationsapps"
"Microsoft.WindowsFeedbackHub"
"Microsoft.WindowsMaps"
"Microsoft.XboxSpeechToTextOverlay"
#"Microsoft.Microsoft.XboxGameOverlay"
"Microsoft.Xbox.TCUI"
"Microsoft.YourPhone"
"Microsoft.ZuneMusic"
"Microsoft.ZuneVideo"
"MicrosoftCorporationII.QuickAssist"
"MicrosoftWindows.Client.WebExperience"
#"Microsoft.WindowsNotepad"
#"Microsoft.WindowsSoundRecorder"
"MicrosoftTeams"
#"Microsoft.WindowsCamera"
#"Microsoft.WindowsAlarms"
)
ForEach ($App in $AppList) {
	$PackageFullName = (Get-AppxPackage $App).PackageFullName
	$ProPackageFullName = (Get-AppxProvisionedPackage -path "WimMounted" | where {$_.Displayname -like $App}).PackageName
	if ($PackageFullName){
		Write-Host "Rimozione: $App"
		remove-AppxPackage -package $PackageFullName -AllUsers | Out-Null
	} 
	if ($ProPackageFullName) {
		Write-Host "Rimozione: $App"
		Remove-AppxProvisionedPackage -path "WimMounted" -packagename $ProPackageFullName | Out-Null
	}
	else {
		Write-Host "Impossibile trovare: $App"
	}
} 

