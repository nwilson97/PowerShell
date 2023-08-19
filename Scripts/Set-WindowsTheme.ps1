# Registry path
$regPath = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize'

# Registry properties
$apps = 'AppsUseLightTheme'
#$system = 'SystemUsesLightTheme'
#$color = 'ColorPrevalence'
#$transparency = 'EnableTransparency'

# API URIs
$locationUri = 'http://ip-api.com/json'
$solarUri = 'https://api.sunrisesunset.io/json'

# Current location
$location = Invoke-RestMethod -Method Get -Uri $locationUri
$lat = $location.lat
$lon = $location.lon
$tz = $location.timezone

# Current time
$now = Get-Date

# Solar times today
$today = (Invoke-RestMethod -Method Get -Uri "${solarUri}?lat=$lat&lng=$lon&date=today&timezone=$tz").results
$sunriseToday = $today.sunrise | Get-Date
$sunsetToday = $today.Sunset | Get-Date

# Solar times tomorrow
$tomorrow = (Invoke-RestMethod -Method Get -Uri "${solarUri}?lat=$lat&lng=$lon&date=tomorrow&timezone=$tz").results
$sunriseTomorrow = $tomorrow.sunrise | Get-Date
$sunriseTomorrow = $sunriseTomorrow.AddDays(1)
#$sunsetTomorrow = $tomorrow.sunset | Get-Date

# Tasks
$taskName = 'Set theme'
#$tasks = Get-ScheduledTask -Taskpath '\My Tasks\' -TaskName 'Set * theme' | Get-ScheduledTaskInfo
#$previousTask = $tasks | Sort-Object -Property LastRunTime | Select-Object -Last 1
#$nextTask = $tasks | Sort-Object -Property NextRunTime | Select-Object -First 1

# Set next solar time and theme
if ($now -lt $sunriseToday) {
    $nextTime = $sunriseToday
    $setTheme = 'dark'
}
elseif ($now -gt $sunriseToday -and $now -lt $sunsetToday) {
    $nextTime = $sunsetToday
    $setTheme = 'light'
}
elseif ($now -gt $sunsetToday) {
    $nextTime = $sunriseTomorrow
    $setTheme = 'dark'
}

# Set registry property value based on upcoming theme
if ($setTheme -eq 'light') {
    $value = 1
}
elseif ($setTheme -eq 'dark') {
    $value = 0
}

# Functions
function Set-Theme {
    Set-ItemProperty -Path $regPath -Name $apps -Value $value
}

function Update-Task {
    $trigger = @(
        $(New-ScheduledTaskTrigger -AtLogOn -User 'nicho'),
        $(New-ScheduledTaskTrigger -At $nextTime -Once)
    )
    Set-ScheduledTask -TaskPath '\My Tasks\' -TaskName $taskName -Trigger $trigger 
}


Set-Theme
Update-Task