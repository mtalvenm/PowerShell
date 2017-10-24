[CmdletBinding()]
    Param
    (
        # Param1 help description
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        $SubDir
    )

$OutScript = "install-($SubDir)GPOs.ps1"
foreach($dir in (Get-ChildItem -Directory $SubDir)) {
    $strGuid = (($dir.Name) -replace("[{}]",""))
    [xml]$GPReport = Get-Content -Path $SubDir\$dir\gpreport.xml
    $GPOName = $GPReport.GPO.Name
    "Import-GPO -BackupID $strGUID -TargetName ""$GPOName"" -Path ""`$PSScriptRoot\$SubDir\"" -CreateIfNeeded" | Out-File -Append "install-${SubDir}GPOs.ps1"
}
