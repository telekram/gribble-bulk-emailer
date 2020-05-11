# Gribble Bulk Emailer
### Gribble is a quick and dirty PowerShell emailer 
Reads email addresses from a CSV file called **email_addresses.csv** using the 
column header *EmailAddress*. You can easily inject data from other columns into the
body of you email.  
    
Gribble will output to **log.csv** for success and failures.

#### Configuration
Gribble needs a JSON file containing the following keys:  
* server
* port
* username
* password
  
example server could be **smtp.gmail.com** with port **587** username **noreply@yourdomain.com**
