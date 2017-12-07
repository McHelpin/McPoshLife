Function Enable-UserAccount {
 [CmdletBinding()]
Param( [Parameter(Mandatory = $true,HelpMessage = "Enter 'First Last'")]$UserName,
       [Parameter(Mandatory = $true,HelpMessage = 'Enter OU')]$OU,
       [Parameter(Mandatory = $false,HelpMessage = 'Enter server name')]$Server = 'DC01.posh.net'
)
    Set-ADObject -Identity:"CN=$UserName,OU=$OU,DC=posh,DC=net" -Replace:@{"userAccountControl"="512"} -Server:$Server
}
