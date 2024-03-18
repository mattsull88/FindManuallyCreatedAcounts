function Send-ManualUserAlert {
    param (
        [array] $Account

    )

    #Set up email details
    $smtpServer = "****"

    $emailFrom = "****"
    $priority = "Normal"

    $EmailimgBanner = "$PSScriptRoot\Emailbanner.jpg"
    $Emailimgsign = "$PSScriptRoot\Emailsign.jpg"
    
    $Byte    = [system.io.file]::ReadAllBytes("$Emailimgbanner")
    $Base64  = [System.Convert]::ToBase64String($Byte)
    $ContentBanner = '{0}{1}{2}' -f '<img src="data:image/png;base64,',$Base64,'">'

    $Byte    = [system.io.file]::ReadAllBytes("$Emailimgsign")
    $Base64  = [System.Convert]::ToBase64String($Byte)
    $ContentSign = '{0}{1}{2}' -f '<img src="data:image/png;base64,',$Base64,'">'

    #Sets up head css for the email
    $body = @"
<style>
TD{width:600px;border: 0px solid #ffffff00; padding: 0px; }
</style>
<table align="center">
 <tr><td>$ContentBanner
</td></tr>

<html>
<table align="center" border="0" cellpadding="0">
	<tbody>
		<tr>
			<td style="width:597px"><font color='414042'>Dear $($Account.AccountName), $($Account.CreatorName)</font><br/>
		<br />
		<font color='0a7cb9'>Warning: Your account $($Account.Account) has been created without evidence of approval. This account will be disabled in 7 days.</b></font></b>
			<br />


		<br />
			<font color='414042'>After the account is disabled, any function or access entitlement linked to this account will cease.</font><br />
			<br />
			<font color='0a7cb9'>What you need to do:</font>
            <br />
            <font color='414042'>You need to provide evidence of an ICT Service Desk ticket with manager approval. The ticket number (e.g. REQ0123456) must be inserted into the Description field of the account in the Active Directory.</font><br />
			<br />

           <tr>
			<td style="width:597px"><font color='414042'>
			For account creator - $($Account.CreatorName): 


			<ol> 
			<li value="1"><font color='414042'>If you have the evidence, please provide the ticket number to the Service Desk team member who created the account, and ask for it to be inserted into the description field of the account in the Active Directory. You can find his/her email address in the recipient field of this email. </strong></font>$ContentSC
            </li></ol>

            <ol>     
            <li value="2"><font color='414042'>If you do not have the evidence, follow the steps below to raise an ICT Service Desk ticket:</em></b></font>
            </li></ol>

			<ol>
        	<li value="3"><font color='414042'>Log onto ICT Service Desk portal and raise a 'Service Desk' request.</font>
            </li></ol>

            <ol>
            <li value="4"><font color='414042'> Select 'Something else' and then 'Request something else' in the two drop down boxes.</em></b></font>
            </li></ol>

            <ol>
            <li value="5"><font color='414042'>In the 'Request Description' field, paste in the following sentence: 
            As per DCS CISO IAM team's request, I would like to provide evidence of manager approval for the account "$($Account.Account)". Please insert this ticket number (i.e. the REQ#) into the description field of this account in Active Directory. 
             </li></ol>

            <ol>
            <li value="6"><font color='414042'>Submit the ticket and promptly follow-up with your manager for approval.
            </li></ol>

            <ol>
            <li value="7"><font color='414042'> Contact the Service Desk team member for fulfilment. You can find the email address of the person who created this account in the recipient field of this email.  
            </li></ol>

			</td>
		</tr>
		<tr>
			<td style="width:597px"><font color='414042'>
			For account creator - $($Account.AccountName): 
            <ol>
            <li value="1"><font color='414042'> You must have received an ICT Service Desk ticket for the creation of this manual account.   
            </li></ol>
            <ol>
            <li value="2"><font color='414042'> If the ticket contains evidence of manager approval, please enter the ticket REQ# into the description field of this account in the Active Directory. 
            </li></ol>
            <ol>
            <li value="3"><font color='414042'> If the ticket does not contain evidence of manager approval, request the account user to submit a new ICT Service Desk ticket. Refer to the above section for details. 
            </li></ol>
            <ol>
            <li value="4"><font color='414042'> Once the ticket is approved by the account user's manager, fulfil the ticket by inserting the REQ# into the description field of the account in the Active Directory, as evidence of manager approval.  
            </li></ol>
            <ol>
            <li value="5"><font color='414042'> Advise the account user upon completion. 
            </li></ol>
            
            <br />
            <br>
			<font color='414042'>Note: CISO IAM team admin will monitor the account in the due date. If the REQ# is not found, or the ticket does not contain evidence of manager approval, the account will be disabled.  
            <br />
            <br>
            <br />
		</tr>
<br> 
$ContentSign
</table>
</body>
</html>
"@

    #Imports the data to create the HTML report as well as a csv containing the data
    $subject = "Action Required: Your Account will be disabled in 7 days "

    #Sends the email
    try{
    Send-MailMessage -To $($Account.CreatorEmail) -CC "****"-Subject $subject -Body ($body | Out-String) -BodyAsHtml -SmtpServer $smtpServer -From $emailFrom -Priority $priority

    }
    catch{
    }
    try{
    Send-MailMessage -To $($Account.AccountEmail) -CC "****"-Subject $subject -Body ($body | Out-String) -BodyAsHtml -SmtpServer $smtpServer -From $emailFrom -Priority $priority

    }
    catch{
    }
    <#
.Description
Sends a basic email report with the count of the objects in the Data parameter and a list. Exports the list to .csv and adds as an attachment.
#>    
}

Select-AzSubscription -Subscription ****
$workspace = Get-AzOperationalInsightsWorkspace -ResourceGroupName "****" -Name "****"
$query = 'SecurityEvent
| where TimeGenerated >= startofday(ago(7d))
| where EventID == 4720
| where AccountType == "User"
| where Computer has "**domain**" or Computer has "**domain**" or Computer has "**domain**"
| where SubjectAccount !has "**AutomationAccountName**" and SubjectAccount !has "**AutomationAccountName**" and SubjectAccount !has "**AutomationAccountName**"'
$return = Invoke-AzOperationalInsightsQuery -Workspace $workspace -Query $query
$Accounts = @()
foreach($line in $return.Results){
    if ($line.SubjectDomainName -eq "**Domain**"){
        $CreatorDomain = "**Domain**"
    }
    if ($line.SubjectDomainName -eq "**Domain**"){
        $CreatorDomain = "**Domain**"
    }
    if ($line.SubjectDomainName -eq "**Domain**"){
        $CreatorDomain = "**Domain**"
    }
    if ($line.TargetDomainName -eq "**Domain**"){
        $AccountDomain = "**Domain**"
    }
    if ($line.TargetDomainName -eq "**Domain**"){
        $AccountDomain = "**Domain**"
    }
    if ($line.TargetDomainName -eq "**Domain**"){
        $AccountDomain = "**Domain**"
    }
    $custom = [PSCustomObject]@{
        CreatorDomain = $CreatorDomain
        Creator = $line.SubjectUserName
        AccountDomain = $AccountDomain
        Account = $line.TargetUserName
        CreatedTime = $line.TimeGenerated
        Found = get-date -format "yyyy/MM/dd"
        AccountEmail = $line.UserPrincipalName
    }
    $Accounts += $custom

}

$AdAccounts= @()
foreach($Account in $Accounts){
    try {
        $user = Get-ADUser -Server $Account.AccountDomain -Identity $Account.Account -Properties Description,DisplayName,Mail,Notes
        $creator = Get-ADUser -Server $Account.CreatorDomain -Identity $Account.Creator -Properties DisplayName,Mail

        if($user.Description -notlike "*REQ*" -and $user.Description -notlike "*INC*" -and $user.Notes -notlike "*REQ*" -and $user.Notes -notlike "*INC*"){


        $customUser = [PSCustomObject]@{
            Creator = $Account.Creator
            CreatorName = $creator.DisplayName
            CreatorEmail = $creator.Mail
            AccountDomain = $Account.AccountDomain
            Account = $Account.Account
            AccountName = $user.DisplayName
            Description = $user.Description
            Notes = $user.Notes
            CreatedTime = $Account.CreatedTime
            Found = get-date -format "yyyy/MM/dd"
            AccountEmail = $user.Mail
            }
        $AdAccounts += $customUser
        }
        
    }
    catch {

    }

}  

Foreach($account in $AdAccounts){
    Send-ManualUserAlert -Account $account
}
