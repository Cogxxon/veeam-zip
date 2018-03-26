function veeam-zipCleanup()
{
    param(
            [int32]$retention
         )
    ##///////////////////////////////////
    ##//( BACKUP LOCATION)///////////////
    ##///////////////////////////////////
    $location = '\\dr-nas01\DR_VNA_Backups'
    ##///////////////////////////////////
    ##//( DATE BUILDER )/////////////////
    ##///////////////////////////////////    
    $current_date = get-date
    $date1 = get-date
    $days_prier_to_current = $date1.AddDays(-$retention)

    foreach ($vbk in (Get-ChildItem -Path $location))
    {
        if($vbk.LastWriteTime -le $days_prier_to_current)
        {
            $vbk_name = $vbk.Name
            Write-Host -ForegroundColor yellow "vbk < $vbk_name > will be deleted  - " -NoNewline;write-host -ForegroundColor Magenta $vbk.LastWriteTime
            Remove-Item -Path $vbk.FullName -Force:$true -Confirm:$false -Verbose
        }
    }
}

veeam-zipCleanup -retention 7 #days