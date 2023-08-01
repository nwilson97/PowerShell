Add-Type -Path 'C:\Program Files\PackageManagement\NuGet\Packages\MailKit.4.1.0\lib\netstandard2.1\MailKit.dll'
Add-Type -Path 'C:\Program Files\PackageManagement\NuGet\Packages\MimeKit.4.1.0\lib\netstandard2.1\MimeKit.dll'

$vaultpassword = (Import-CliXml ~/vaultpassword.xml).Password
Unlock-SecretStore -Password $vaultpassword
[pscredential]$credential = Get-Secret -Name Email -Vault LocalVault
$myEmail = $credential.UserName

$SMTP     = New-Object MailKit.Net.Smtp.SmtpClient
$Message  = New-Object MimeKit.MimeMessage
$TextPart = [MimeKit.TextPart]::new("plain")
$TextPart.Text = "Email using MailKit and secured password."
$Message.From.Add($myEmail)
$Message.To.Add($myEmail)
$Message.Subject = 'MailKit message'
$Message.Body    = $TextPart
$SMTP.Connect('smtp.gmail.com', 587, $False)
$SMTP.Authenticate($credential)
$SMTP.Send($Message)
$SMTP.Disconnect($true)
$SMTP.Dispose()
