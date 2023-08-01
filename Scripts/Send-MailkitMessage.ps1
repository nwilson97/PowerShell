Function Send-MailkitMessage {
  [CmdletBinding(
    SupportsShouldProcess = $true,
    ConfirmImpact = "Low"
  )] # Terminate CmdletBinding

  Param(
    [Parameter( Position = 0, Mandatory = $True )][String]$To,
    [Parameter( Position = 1, Mandatory = $True )][String]$Subject,
    [Parameter( Position = 2, Mandatory = $True )][String]$Body,
    [Parameter( Position = 3 )][Alias("ComputerName")][String]$SmtpServer = $PSEmailServer,
    [Parameter( Mandatory = $True )][String]$From,
    [String]$CC,
    [String]$BCC,
    [Switch]$BodyAsHtml,
    $Credential,
    [Int32]$Port = 25
  )

  Process {
    $SMTP = New-Object MailKit.Net.Smtp.SmtpClient
    $Message = New-Object MimeKit.MimeMessage

    If ($BodyAsHtml) {
      $TextPart = [MimeKit.TextPart]::new("html")
    }
    Else {
      $TextPart = [MimeKit.TextPart]::new("plain")
    }
    
    $TextPart.Text = $Body

    $Message.From.Add($From)
    $Message.To.Add($To)
    
    If ($CC) {
      $Message.CC.Add($CC)
    }
    
    If ($BCC) {
      $Message.BCC.Add($BCC)
    }

    $Message.Subject = $Subject
    $Message.Body = $TextPart

    $SMTP.Connect($SmtpServer, $Port, $False)

    If ($Credential) {
      $SMTP.Authenticate($Credential.UserName, $Credential.GetNetworkCredential().Password)
    }

    If ($PSCmdlet.ShouldProcess('Send the mail message via MailKit.')) {
      $SMTP.Send($Message)
    }

    $SMTP.Disconnect($true)
    $SMTP.Dispose()
  }
}
