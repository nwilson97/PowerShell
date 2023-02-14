function New-MailMessage {
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
    <#
    .SYNOPSIS
        A basic script to send email
    .DESCRIPTION
        This script is mean to take output from another script and send it via email
    #>
}
