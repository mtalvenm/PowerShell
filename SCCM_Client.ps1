function getSCCMSite() {
    $sccm = New-Object -ComObject "Microsoft.SMS.Client"
    $sccm.getSiteAssignment()
}

function setSCCMSite([String] $siteCode) {
    $sccm = New-Object -ComObject "Microsoft.SMS.Client"
    $sccm.setSiteAssignment($siteCode)
}
