function Get-ObservedIPRange {
    
    # Credit: http://poshcode.org/
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $True, HelpMessage = ”Physical NIC from Get-VMHostNetworkAdapter”)]
        [Object[]]$Nics
    
    )
    
    process {
    
        forEach ($Nic in $Nics) {
    
            if ($Nic -notlike “vmk*”) {
                [VMware.VimAutomation.Client20.Host.NIC.PhysicalNicImpl]$NicImpl = $Nic
                $hostView = Get-VMHost -Id $NicImpl.VMHostId | Get-View -Property ConfigManager
                $ns = Get-View $hostView.ConfigManager.NetworkSystem
                $hints = $ns.QueryNetworkHint($NicImpl.Name)
    
                foreach ($hint in $hints) {
                    if ( ($hint.ConnectedSwitchPort) ) {
                        foreach ($subnet in $hint.subnet) {
                            $observed = New-Object -TypeName PSObject
                            $observed | Add-Member -MemberType NoteProperty -Name Device -Value $NicImpl.Name
                            $observed | Add-Member -MemberType NoteProperty -Name VMHostId -Value $NicImpl.VMHostId
                            $observed | Add-Member -MemberType NoteProperty -Name IPSubnet -Value $subnet.IPSubnet
                            $observed | Add-Member -MemberType NoteProperty -Name VlanId -Value $subnet.VlanId
                            Write-Output $observed
                        }
                    }
                }
    
            }
    
        }
    }
    
    # Example use:
    
    # Get-VMHost esx01a.vmworld.com | Get-VMHostNetworkAdapter | | Get-ObservedIPRange
}