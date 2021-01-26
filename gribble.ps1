# Gribble: Quick and Dirty Powershell Bulk emailer

$csvFile = Import-Csv ".\email_addresses.csv"
$settings = Get-Content -Raw -Path .\settings.json | ConvertFrom-Json

$SMTPServer = $settings.server
$SMTPPort = $settings.port


$username = $settings.username
$password = ConvertTo-SecureString $settings.password -AsPlainText -Force

$progressCounter = 0
$totalCount = $csvFile.Count

$csvFile | ForEach-Object{
   
  $From = $username
  $To = $_.emailaddress

  $Subject = "Gribble Lives"
  $Body = "<h3>Email Body</h3>"
  $Body += "<p>Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do...</p>"

  try {

    Send-MailMessage -From $From -to $To -Subject $Subject -Body $Body -BodyAsHtml -SmtpServer $SMTPServer -Port $SMTPPort -UseSsl -Credential (New-Object System.Management.Automation.PSCredential ($username, $password))
    
    $log = [PSCustomObject]@{
      Status = 'Success'
      Recipient = $To
    }
    
    Write-Progress -Activity $To -Status "Success:" -PercentComplete ($progressCounter / $totalCount * 100)

    Export-Csv -Path './log.csv' -InputObject $log -Append -NoTypeInformation

  } catch {

    $log = [PSCustomObject]@{
      Status = 'Failure'
      Recipient = $To
    }

    Write-Progress -Activity $To -Status "Failure:" -PercentComplete ($progressCounter / $totalCount * 100)

    Export-Csv -Path './log.csv' -InputObject $log -Append -NoTypeInformation
  }

  $progressCounter = $progressCounter + 1
}
