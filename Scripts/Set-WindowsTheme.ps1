<# Set light theme
Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize -Name 'AppsUseLightTheme' -Type DWord -Value 1
Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize -Name 'SystemUsesLightTheme' -Type DWord -Value 1
#Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize -Name 'ColorPrevalence' -Type DWord -Value 1
#>

<# Set dark theme
Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize -Name 'AppsUseLightTheme' -Type DWord -Value 0
Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize -Name 'SystemUsesLightTheme' -Type DWord -Value 0
Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize -Name 'ColorPrevalence' -Type DWord -Value 1
#>


#<# Get location
$location = (Invoke-RestMethod "http://ip-api.com/json/")
$lat = $location.lat
$lng = $location.lon
$tz = $location.timezone
#>

#<# Get sunset today
$today = (Invoke-RestMethod -Method Get -Uri "https://api.sunrisesunset.io/json?lat=$lat&lng=$lng&date=today&timezone=$tz").results
$sunset  = $today.Sunset | Get-Date
#>

#<# Get sunrise tomorrow
$tomorrow = (Invoke-RestMethod -Method Get -Uri "https://api.sunrisesunset.io/json?lat=$lat&lng=$lng&date=today&timezone=$tz").results
$sunrise = $tomorrow.sunrise | Get-Date
#>

$light = 'Set light theme'
$dark = 'Set dark theme'

function Update-Task {
    param (
        $Theme=($light,$dark),
        $Time=($sunrise,$sunset)
    )
    $trigger = New-ScheduledTaskTrigger -At $Time -Daily
    Set-ScheduledTask -TaskPath '\My Tasks\' -TaskName $Theme -Trigger $trigger
}
#<# Update task
#>

Update-Task -Theme $dark -Time $sunset