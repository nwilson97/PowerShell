function New-Hostname {
    <#
    .SYNOPSIS
        Hostname generator
    .DESCRIPTION
        Run this script with the applicable prefix to generate a hostname 
    #>

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

    Write-Output "Hostname: $hostname"

    New-MailMessage -Subject 'New hostname request' -Body "The hostname you requested is $hostname"
}

function New-MailMessage {
    <#
    .SYNOPSIS
        A basic script to send email
    .DESCRIPTION
        This script is mean to take output from another script and send it via email
    #>

    [CmdletBinding()]
    param (
        # Email body
        [Parameter(Mandatory)]
        [string]$Body,

        # Email subject
        [Parameter()]
        [string]$Subject = 'New message'
    )

    # Define Credentials
    [string]$userName = 'nicholaswilson97@gmail.com'
    [string]$userPassword = 'gfzhakxetwkyrqdr'

    # Crete credential Object
    [SecureString]$secureString = $userPassword | ConvertTo-SecureString -AsPlainText -Force 
    [PSCredential]$credentialObejct = New-Object System.Management.Automation.PSCredential -ArgumentList $userName, $secureString

    $Params = @{
    #   Attachments = ''
        Body        = $Body
        From        = $userName
        SmtpServer  = 'smtp.gmail.com'
        Subject     = $Subject
        To          = $userName
        Credential  = $credentialObejct
        UseSsl      = $True
        Port        = 587
    }
    
    Send-MailMessage @Params -WarningAction SilentlyContinue  
}
