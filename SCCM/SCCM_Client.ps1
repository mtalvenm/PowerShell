# queries client for current Site Code
function getSCCMSite() {
    $sccm = New-Object -ComObject "Microsoft.SMS.Client"
    $sccm.getSiteAssignment()
}

# set new Site Code for client
function setSCCMSite([String] $siteCode) {
    $sccm = New-Object -ComObject "Microsoft.SMS.Client"
    $sccm.setSiteAssignment($siteCode)
}
