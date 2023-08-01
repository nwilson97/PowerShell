function New-MailMessage {
    [CmdletBinding()]
    param (
        # Body
        [Parameter(Mandatory)]
        [string]
        $Body,

        # Subject
        [Parameter()]
        [string]
        $Subject = 'New message',

        # Recipient
        [Parameter()]
        [mailaddress]
        $Recipient = 'nicholaswilson97@gmail.com',

        # From
        [Parameter()]
        [string]
        $From = 'nicholaswilson97@gmail.com'
    )

    # Retrieve credentials
    $vaultpassword = (Import-CliXml ~/vaultpassword.xml).Password
    Unlock-SecretStore -Password $vaultpassword
    [pscredential]$credential = Get-Secret -Name Email -Vault LocalVault
    #$userName = $credentialObject.$userName
    #$password = $credential.Password

    # Set SMTP server
    $PSEmailServer = 'smtp.gmail.com'

    $Params = @{
        #Attachments = ''
        Body       = $Body
        From       = $From
        #SmtpServer = 'smtp.gmail.com'
        Subject    = $Subject
        To         = $Recipient
        Credential = $credential
        UseSsl     = $True
        Port       = 587
    }
    
    try {
        Send-MailMessage @Params -ErrorAction Stop -WarningAction SilentlyContinue
    }
    catch {
        Write-Error $PSItem.Exception.Message
    }
    
    #Requires -Modules Microsoft.PowerShell.SecretManagement, Microsoft.PowerShell.SecretStore
    <#
    .SYNOPSIS
    A basic script to send email
    .DESCRIPTION
    This script is mean to take output from another script and send it via email
    #>
}
