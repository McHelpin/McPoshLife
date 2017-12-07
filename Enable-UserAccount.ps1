Function Enable-UserAccount {
 [CmdletBinding()]
Param( [Parameter(Mandatory = $true,HelpMessage = "Enter 'First Last'")]$UserName 
)
    Set-ADObject -Identity:"CN=$UserName,OU=Edina,OU=Accounts,DC=tcbmn,DC=net" -Replace:@{"userAccountControl"="512"} -Server:"EDDC01.tcbmn.net"
}
