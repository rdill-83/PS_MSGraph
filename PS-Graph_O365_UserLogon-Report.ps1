# PS-Graph_O365_UserLogonReport

# List Office 365 Logins via MS Graph

# Connect to Microsoft Graph:
Connect-MGGraph -Environment USGov -Scopes "AuditLog.Read.All","User.Read.All" 
 
# Set the Graph Profile:
Select-MgProfile beta
 
# Define Properties to Retrieve:
$Properties = @(
    'Id','DisplayName','Mail','UserPrincipalName','AccountEnabled', 'SignInActivity'   
)
 
# Get All users along with the properties:
$AllUsers = Get-MgUser -All -Property $Properties 
 
$SigninLogs = @()
ForEach ($User in $AllUsers)
{
    $SigninLogs += [PSCustomObject][ordered]@{
            LoginName       = $User.UserPrincipalName
            Email           = $User.Mail
            DisplayName     = $User.DisplayName
            AccountEnabled  = $User.AccountEnabled
            LastSignIn      = $User.SignInActivity.LastSignInDateTime
    }
}
 
$SigninLogs
 
# Export Data to CSV:
$SigninLogs | Export-Csv -Path "C:\Temp\SigninLogs.csv" -NoTypeInformation

# Orign / Source: https://www.sharepointdiary.com/2022/04/office-365-find-last-login-date-using-powershell.html
