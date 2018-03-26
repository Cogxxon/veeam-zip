function veeam-zipReporter()
{

    #//////////////////////////#
    #///(General Settings/)////#
    #//////////////////////////# 
    $backupName                 = "DR VNA Backup to DR-NAS"
    $backupLocation             = '\\dr-nas01\DR_VNA_Backups'
    $Site                       = "John James"
    $compression_rate           = "x5"
    $email_to                   = 'NDCSupport <ndcsupport@calvarycare.org.au>';
    $email_from                 = 'no-reply-veeam@calvarycare.org.au';
    $email_subject              = 'Veeam Backup Report - VNA DR John James';
    $email_smtp                 = '10.0.0.77';
    $backup_destination_size_GB = '2048'
    $backup_path_size_GB = 2048
    $retention = '7 Days'
    $backupTotalSize = (Get-ChildItem $backupLocation | Measure-Object -Property Length -Sum).Sum /1GB
    $_csv = Import-Csv -Path $PSScriptRoot"\VNA_backup_pool.csv"
    #//////////////////////////# 

    write-host -ForegroundColor Green 'Importing module: send-psmail'
    import-module -name $PSScriptRoot"\send-psmail.ps1"
    
    ##////////////////////////////////////
    ##//( BACKUP LOCATION )///////////////
    ##///////////////////////////////////
    $location = '\\dr-nas01\DR_VNA_Backups'
    ##///////////////////////////////////
   
    $html = "<head>"
        $html += '<style>'
        $html += "

                    .title{
                      padding: 20px !important;
                      font-size: 20px;
                      color: #fff
                      font: normal Arial, Helvetica, sans-serif;
                    }
                    .datagrid table {
                        border-collapse: collapse;
                        border: 1px solid #f4f4f4;
                        text-align: left;
                        width: 100%;
                        padding 5px;
                    }
                    .datagrid table tr {
                        border-bottom:1px solid #f4f4f4;
                    }
                    .datagrid {
                        font: normal 12px/150% Arial, Helvetica, sans-serif;
                        background: #fff;
                        overflow: hidden;
                        -webkit-border-radius: 3px;
                        -moz-border-radius: 3px;
                        border-radius: 3px;
                    }

                    .datagrid table td,
                    .datagrid table th {
                        padding: 9px 30px;
                    }

                    .datagrid table thead th {
                        background: -webkit-gradient( linear, left top, left bottom, color-stop(0.05, #00b336), color-stop(1, #00b336));
                        background: -moz-linear-gradient( center top, #8C8C8C 5%, #7D7D7D 100%);
                        filter: progid: DXImageTransform.Microsoft.gradient(startColorstr='#00b336', endColorstr='#00b336');
                        background-color:#00b336;
                        color: #FFFFFF;
                        font-size: 15px;
                        font-weight: bold;
                        border-left: 1px solid #A3A3A3;
                    }

                    .datagrid table thead th:first-child {
                        border: none;
                    }

                    .datagrid table tbody td {
                        color: #7D7D7D;
                        border-left: 1px solid #DBDBDB;
                        border-bottom: 1px solid #DBDBDB;
                        font-size: 12px;
                        font-weight: normal;
                    }

                    .datagrid table tbody .alt td {
                        background: #EBEBEB;
                        color: #7D7D7D;
                    }

                    .datagrid table tbody td:first-child {
                        border-left: none;
                    }

                    .datagrid table tbody tr:last-child td {
                        border-bottom: none;
                    }

                    .datagrid table tfoot td div {
                        border-top: 1px solid #8C8C8C;
                        background: #EBEBEB;
                    }

                    .datagrid table tfoot td {
                        padding: 0;
                        font-size: 12px
                    }

                    .datagrid table tfoot td div {
                        padding: 2px;
                    }

                    .datagrid table tfoot td ul {
                        margin: 0;
                        padding: 0;
                        list-style: none;
                        text-align: right;
                    }

                    .datagrid table tfoot li {
                        display: inline;
                    }

                    .datagrid table tfoot li a {
                        text-decoration: none;
                        display: inline-block;
                        padding: 2px 8px;
                        margin: 1px;
                        color: #F5F5F5;
                        border: 1px solid #8C8C8C;
                        -webkit-border-radius: 3px;
                        -moz-border-radius: 3px;
                        border-radius: 3px;
                        background: -webkit-gradient( linear, left top, left bottom, color-stop(0.05, #8C8C8C), color-stop(1, #7D7D7D));
                        background: -moz-linear-gradient( center top, #8C8C8C 5%, #7D7D7D 100%);
                        filter: progid: DXImageTransform.Microsoft.gradient(startColorstr='#8C8C8C', endColorstr='#7D7D7D');
                        background-color: #8C8C8C;
                    }

                    .datagrid table tfoot ul.active,
                    .datagrid table tfoot ul a:hover {
                        text-decoration: none;
                        border-color: #7D7D7D;
                        color: #F5F5F5;
                        background: none;
                        background-color: #8C8C8C;
                    }

                    div.dhtmlx_window_active,
                    div.dhx_modal_cover_dv {
                        position: fixed !important;
                    }
                    .percent{
                        font-weight: bold;
                        color: #383838;
                    }
                    "
        $html += '</style>'
    $html += "</head>"
    
    $html += "<table style='width:100%;border:1px solid #D3D3D3;'>"
        $html += "<tr>"

            $html += "<td>"
                $html += "<div style='padding:5px;' class='title'><b style='color:green;'>Backup Job-:</b> $backupName </div>"
                $html += "<div style='padding:5px;' class='title'><b style='color:green;'>Backup Location-:</b> $location </div>"
                $html += "<div style='padding:5px;' class='title'><b style='color:green;'>Backup Site-:</b> $Site </div>"
                $html += "<div style='padding:5px;' class='title'><b style='color:green;'>Retention-:</b> $retention </div>"

            $html += "</td>"

            $html += "<td>"
                $html += "<tr style='border:1px solid #D3D3D3;'>"

                    $html += "<td>"
                        $html += "<div  class='percent'>" + [math]::round(($backupTotalSize / $backup_path_size_GB * 100),2) +"% Used</div>"
                        $html += "<div  class='percent'>" + [math]::round(($backupTotalSize ),0) + " GiB / $backup_path_size_GB GiB</div>"
                        $html += "<div  class='percent'>" +$_csv.count + " VMs</div>"
                    $html += "</td>"

                $html += "</tr>"   
            $html += "</td>"

        $html += "</tr>"
    $html += "</table>"

    $html +='<div class="datagrid">'
    $html +='<table>'
        $html +='<thead> <tr> <th>Veeam Backup</th> <th>Restore Points</th> <th>Backup Sets</th> <th>Compression Ratio</th> <th>Total backupSize</th></tr> </thead>'
            $html +='<tbody>'


    $grouped_backups = Get-ChildItem -Path $location | Group-Object { $_.name.ToString().Split('-')[0] }
    

    foreach($gbu in $grouped_backups)
    {
        $gbu_name = $gbu.name
        $gbu_rp = $gbu.group.count
        $backup_sets = $gbu | select -ExpandProperty Group

        $html +='<tr>'
            $html +="<td> $gbu_name</td>"
            $html +="<td> $gbu_rp </td>"   
            $html +="<td>" 
                        $totalbackupbtyes = 0 
                        foreach($gbu_indiv in $gbu.Group)
                        {
                             $backupSet_name = $gbu_indiv.Name
                             $totalbackupbtyes += $gbu_indiv.length
                             $backupSet_date = $gbu_indiv.lastWriteTime
                             $backupSet_Size = [math]::round(($gbu_indiv.length / 1GB),2)
                             $totalbackupsize = [math]::round(($totalbackupbtyes / 1GB),2)
                             $html += "<li> $backupSet_name </br> &nbsp;&nbsp;&nbsp; <b style='font-weight:normal;color:#00b336;'>$backupSet_date </b> <b style='font-weight:normal;color:brown;'> $backupSet_Size GB </b></li>"
                        }
            $html += "</td>"
            $html +="<td> $compression_rate </td>"
            $html +="<td> $totalbackupsize GiB</td>"  

        $html +='</tr>'

    }
            $html +='</tbody>'
        $html +='</table>'
    $html +='</div>'

    $GLOBAL:BKSIZE = $globalbackupSize
    send-psmail -smtp $email_smtp -from $email_from -to $email_to -subject $email_subject -htmlBody:$true -body $html 
}

veeam-zipReporter


