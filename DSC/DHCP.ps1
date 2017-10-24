Configuration DHCPServer {
    Import-DscResource -Module 'xDhcpServer'

    Node $AllNodes.NodeName {
        WindowsFeature DHCP {
            Ensure = 'Present'
            Name = 'DHCP'
        }

#        xDhcpServerScope ToimistoVerkko {
#            Ensure = 'Present'
#            Name = 'HVK Fabianinkatu LAN scope'
#            IPStartRange = '10.100.100.100'
#            IPEndRange = '10.100.100.199'
#            SubnetMask = '255.255.255.0'
#            LeaseDuration = '00:08:00'
#            State = 'Active'
#            AddressFamily = 'IPv4'
#            DependsOn =@('[WindowsFeature]DHCP')
#        }

        xDhcpServerAuthorization LocalServerActivation {
            Ensure = 'Present'
        }

    }
}

@{
    AllNodes = @(
        @{
            NodeName = "*"
            BackupPath = "polku" # ei käytössä 
        },

        @{
            NodeName = "HVK-Titan"

        }
    )
}