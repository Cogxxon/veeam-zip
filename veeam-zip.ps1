<#///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    AUTHER------: Garvey Snow
    VERSION-----: 1.2
    DESCRIPTION-: Function wrapper for veeam 9.5 - Free addtional will work with full version
    DEPENDANCIES: VEEAM PS-Snap-in's
	BUILD ENV   : Powershell Version 5.0.10586.117
    LICENCE-----: GNU GENERAL PUBLIC LICENSE
    KB: o-» https://helpcenter.veeam.com/docs/backup/powershell/start-vbrzip.html?ver=95
      : o-> https://helpcenter.veeam.com/docs/backup/free/veeamzip_options.html
      : o-» https://forums.veeam.com/veeam-backup-replication-f2/backing-up-multiple-vm-s-at-the-same-time-t3736.html
      : o-» https://stackoverflow.com/questions/21640598/powershell-parameter-list-of-values
             
	UPDATE: 25/11/2017 @ 16:11
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////#>

function veeam-zip()
{
    
    param(
            [switch]
            [parameter(Mandatory=$false,ValueFromPipeline=$true)]
            $vza_backup,

            [string[]]
            [ValidateSet('Never','Tonight','TomorrowNight','In3days','In1Week','In2Weeks','In1Month','In3Months','In6Months','In1Year')]
            $retention,

            [string[]]
            $report
    )

    #//////////////////////////#
    #///(Importing Modules)////#
    #//////////////////////////#    
    write-host -ForegroundColor Green 'Importing module: Write-Segline'
    import-module -name $PSScriptRoot"\Write-Segline.ps1"
    #//////////////////////////# 

    #/////////////////////////#
    #///(VEEAM PS CMDLETS)////#
    #/////////////////////////#
    write-host -ForegroundColor Green 'Importing PSSnapin: VeeamPSSnapin'
    Add-PSSnapin VeeamPSSnapin

    #////////////////////////////////#
    #///(Un-attended Credentials)////#
    #////////////////////////////////#

    $VBR_CREDS = Get-VBRCredentials -Name "calvarycare\adm_gsnow"

    #//////////////////////////////////////////# ACTIONS
    #//( IMPORT CSV - LIST OF VMS TO BACKUP )//#  -skip = skip backup 
    #//////////////////////////////////////////#  -backup = backup vm
    $vm_backup_list = Import-Csv -Path 'C:\scripts\VNA_VEEAM-ZIP\VNA_backup_pool.csv'



    #/////////////////////////
    #///(MAIN LOOP)///////////
    #/////////////////////////
    foreach($vm in $vm_backup_list)
    {
       
       if($vm.action -eq "backup" -and $vza_backup -eq $true )
       {
           #/////////////////////////////////////#
           #/ Populate VM object through veeam ///#
           $vm_name = $vm.vmname
           write-host -f yellow "FINDING VM ENTITY: $vm_name" 
  
                #//////////////////////////////////////////////
                #/// Only start Job que if VBR que is empty ///
                #//////////////////////////////////////////////
                WRITE-SEGLINE -numlines 2 -firstline 'Adding backup (Active Full)' -secondline $vm.vmname
                Start-VBRZip -Entity (Find-VBRViEntity -Name $vm.vmname) -Folder $vm.bk_location -Compression 5 -AutoDelete $Retention -RunAsync -DisableQuiesce -NetworkCredentials $VBR_CREDS 
   
       }
    }
}

#INIT
veeam-zip -vza_backup -retention In1Week