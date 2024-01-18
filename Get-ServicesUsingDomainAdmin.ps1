break

# One liner format 
Get-ADComputer -Filter * | # Query Active Directory for all computers
ForEach-Object {Get-wmiobject -ComputerName $_.Name Win32_Service} | # Query all services on domain computers
Where-Object {$_.StartName -eq “mchelpin\administrator”} | # Return only services who’s “Log On As” property is set to domain\administrator
Select-Object SystemName,Name,StartMode,State | # Format the output to include onle SystemName, Service name, Log On As, and Service State
Export-CSV AdministratorServices.csv -NoTypeInformation # Export output to CS


break

# Lets break it up a bit
$ComputerList = Get-ADComputer -Filter 'Name -NotLike "WFH*" -and Name -NotLike "KM*" -and Name -notlike "V*" ' #use filters to exclude ind or groups of computers if needed
$i = 0
$Count = $ComputerList.Count
ForEach($Computer in $ComputerList)
{
    if(Test-Connection -Count 1 -ComputerName $Computer.Name -Quiet)
    {
        Write-Progress -Activity "Checking for services using domain admin"  -Status "Querying $($Computer.Name)" -PercentComplete $(($i++)/$Count * 100)
        if(Get-wmiobject -ComputerName $Computer.Name Win32_Service | Where-Object {$_.StartName -eq “mchelpin\administrator”} -ErrorAction SilentlyContinue -OutVariable obj )
        {
            #$obj = Get-wmiobject -ComputerName $Computer.Name Win32_Service | Where-Object {$_.StartName -eq “mchelpin\administrator”} -ErrorAction SilentlyContinue |select Name,StartMode,State
           foreach($o in $obj)
           {
                [pscustomobject]@{'Computer'=$Computer.Name;'Service'=$o.Name;}
            }
        }
    }
}
