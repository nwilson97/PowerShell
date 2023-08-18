# Set light theme
Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize -Name 'AppsUseLightTheme' -Type DWord -Value 1
Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize -Name 'SystemUsesLightTheme' -Type DWord -Value 1
Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize -Name 'ColorPrevalence' -Type DWord -Value 1

<# Get coordinates
Add-Type -AssemblyName System.Device #Required to access System.Device.Location namespace
$GeoWatcher = New-Object System.Device.Location.GeoCoordinateWatcher #Create the required object
$GeoWatcher.Start() #Begin resolving current locaton

while (($GeoWatcher.Status -ne 'Ready') -and ($GeoWatcher.Permission -ne 'Denied')) {
    Start-Sleep -Milliseconds 100 #Wait for discovery.
}  

if ($GeoWatcher.Permission -eq 'Denied'){
    Write-Error 'Access Denied for Location Information'
} else {
    $lat = $GeoWatcher.Position.Location.Latitude
    $lng = $GeoWatcher.Position.Location.Longitude
}#>
$location = (Invoke-RestMethod "http://ip-api.com/json/")
$lat = $location.lat
$lng = $location.lon
$tz = $location.timezone

# Get sunset
$today = (Invoke-RestMethod "https://api.sunrisesunset.io/json?lat=$lat&lng=$lng&date=today&timezone=$tz").results
$sunset  = $today.Sunset | Get-Date

# Update task
$time = New-ScheduledTaskTrigger -At $sunset -Daily
Set-ScheduledTask -TaskPath '\My Tasks\' -TaskName 'Set dark theme' -Trigger $time
