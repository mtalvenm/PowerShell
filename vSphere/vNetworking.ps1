<#
.SYNOPSIS
    Adding portgroups on single esx host or all hosts in cluster.
.DESCRIPTION
    Create virtual portgroups (with specified name and vlan id) on host standard switch or multiple hosts on cluster
.NOTES
    File Name      : addPortGroups.ps1
    Author         : Mikko Talvenmaa / Digia (mikko.talvenmaa@digia.com)
    Date           : 23.8.2017
.EXAMPLE
    Add-Portgroup -vmHost esxi-xx -vSWName vSW01 -vPGName netServers -vlanID 5
.EXAMPLE
    Add-Portgroup -vCCluster cluster-xx -vSWName vSW02 -vPGName netBackup -vlanID 52
#>
function Add-PortGroup {
[CmdletBinding(
            DefaultParameterSetName='cluster'
)]
Param(
   # vCenter name, if not default server used
   [Parameter(Mandatory=$false)]
   [string]$vCenter,

   [Parameter(ParameterSetName="cluster",
            Mandatory = $true)]
   [string]$vCCluster,

   [Parameter(ParameterSetName="host")]
   [string]$vmHost,

   [Parameter(Mandatory=$True)]
   [string]$vSWName,
	
   [Parameter(Mandatory=$True)]
   [string]$vPGName,

   [Parameter(Mandatory=$True)]
   [int]$vlanID

)

begin {
    $vCenterConnected = $false
    # Connect to vCenter if specified, otherwise use default server
    if($vCenter) {
        Connect-VIServer $vCenter # -credentials (Get-Credential)
        $vCenterConnected = $true
    }
}

process {
    # Depending on commandline parameters, choosing and selecting either host or enumerating hosts of cluster 
    switch($PsCmdlet.ParameterSetName) {
        "host" { 
            # Get only specified host
            Write-Debug "Single host selected"
            $modifiedHosts = Get-VMHost -Name $vmHost
        }
        "cluster" { 
            # Get hosts on specified cluster
            Write-Debug "Cluster of hosts selected"
            $modifiedHosts = Get-VMHost -Location $vCCluster
        }
    }

    # Cycle through all host in collection (one host or hosts of cluster)
    foreach ($host in $modifiedHosts) {

            # Get vSwitch by name
            $vSW = get-virtualswitch -host $host -name $vSWName

            # Check if port group already exists
            # TOIMIIKO TUO IF!
            if(Get-virtualportgroup -VirtualSwitch $vSW -Name $vPGName) {
                Write-Warning "$vPGName portgroup on switch $vSWName in host $host already configured!"
                continue
            }

            # Add new portgroup to vSwitch
            $vPG = new-virtualportgroup -VirtualSwitch $vSW -Name $vPGName -VLanID $vlanID
            Write-Verbose $vPG
    }
}

end {
    if($vCenterConnected == $true) {
        Disconnect-VIServer $vCenter
    }
}
}

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
function Check-VLANId {
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

begin {
    $vCenterConnected = $false
    # Connect to vCenter if specified, otherwise use default server
    if($vCenter) {
        Connect-VIServer $vCenter # -credentials (Get-Credential)
        $vCenterConnected = $true
    }
}

process {
    $hostsToCheck = Get-VMHost -Location $vCCluster
    
    foreach ($host in $hostsToCheck) {
        $vSwitchesOnHost = get-virtualswitch -host $host
        foreach ($vSwitch in $vSwitchesOnHost) {
            
        }
    }
}

end {
    if($vCenterConnected == $true) {
        Disconnect-VIServer $vCenter
    }
}
}
