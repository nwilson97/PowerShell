function New-Hostname {
    [CmdletBinding()]
    param (
        # Hostname prefix to identify computer type
        [Parameter(Mandatory=$true)]
        [ValidateSet('Desktop', 'Laptop', 'VM', 'WIN')]
        [String]$Prefix
    )

    $type = $Prefix.ToUpper() + '-'
    $measure = $type | Measure-Object -Character
    $count = 15 - $measure.Characters
    $string = -join ( (48..57) + (65..90) | Get-Random -Count $count | ForEach-Object { [char]$_ } )
    $hostname = $type + $string

    Write-Output "Hostname is: $hostname"

    New-MailMessage -Subject 'New Hostname' -Body "This is the new hostname you requested: $hostname"

    <#
    .SYNOPSIS
        Hostname generator
    .DESCRIPTION
        Run this script with the applicable prefix to generate a hostname 
    #>
}