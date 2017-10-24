<#
.SYNOPSIS
    Short description
.DESCRIPTION
    Long description
.EXAMPLE
    Example of how to use this cmdlet
.EXAMPLE
    Another example of how to use this cmdlet
#>

[CmdletBinding()]
    param(
    # vCenter name, if not default server used
    [Parameter(Mandatory=$false)]
        [string]$vCenter,

    [Parameter(Mandatory = $true)]
        [string]$vCCluster,

    [Parameter(Mandatory=$True)]
        [int]$vlanID
    )
    
# Connect to vCenter if specified, otherwise use default server
if($vCenter) {
    Connect-VIServer $vCenter # -credentials (Get-Credential)
}

$hostsToCheck = Get-VMHost -Location $vCCluster

foreach ($host in $hostsToCheck) {
    $vSwitchesOnHost = get-virtualswitch -host $host
    foreach ($vSwitch in $vSwitchesOnHost) {
        
    }
    
}
