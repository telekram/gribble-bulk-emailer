# Quick and Dirty Powershell Bulk emailer
$csvFile = Import-Csv ".\email_addresses.csv"
$settings = Get-Content -Raw -Path .\settings.json | ConvertFrom-Json

$SMTPServer = $settings."server"
$SMTPPort = $settings."port"

$username = $settings."username"
$password = ConvertTo-SecureString $settings."password" -AsPlainText -Force

$logObj = New-Object -TypeName pscustomobject

$csvFile | ForEach-Object{
   
  $From = $username
  $To = $_.emailaddress

  $Subject = "Gribble Lives"
  $Body = "<h3>Email Body</h3>"
  $Body += "<p>Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do...</p>"

  try {
    Send-MailMessage -From $From -to $To -Subject $Subject -Body $Body -BodyAsHtml -SmtpServer $SMTPServer -Port $SMTPPort -UseSsl -Credential (New-Object System.Management.Automation.PSCredential ($username, $password))
    Write-Host "Sent message to: $To"
    $logObj | Add-Member -MemberType NoteProperty -Name Email -Value $To
    Write-Host "Email sent to: $_.emailaddress"  
    $logObj | Add-Member -MemberType NoteProperty -Name Status -Value 'Email sent SUCCESSFULLY'
  
  } catch {
    $logObj | Add-Member -MemberType NoteProperty -Name Email -Value $To
    $logObj | Add-Member -MemberType NoteProperty -Name Status -Value 'Email sending FAILED'
    Write-Host "FAILED: $_.emailaddress"
  }
}
  Export-Csv -Path './log.csv' -InputObject $logObj -Append -NoTypeInformation