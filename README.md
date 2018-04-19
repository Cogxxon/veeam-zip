
# VEEAM-ZIP
### Build Environment
* Veeam 9.5 Free Sp2
* Powershell 5.1.15063.0

### 1. Contents
 - README.MD
 - Send-Psmail.ps1 - *Wrapper for **System.Net.Mail.MailMessage***
 - veeam-zip.ps1 - *Main Script file, handles the job submission to Veeam Server*
 - veeam-zipClearnup.ps1 - *Clean up **.vbk** files older then the specified retention period*
 - veeam-zipReporter.ps1 - *Email Reporter of kept **.vbk** files with within the retention Period*
### 2. Script File Usage
> veeam-zip.ps1
> ```powershell
> veeam-zip -vza_backup:$true -retention 7
> --or--
> veeam-zip -vza_backup -retention 7
> ```
**Switches** 
 - vza_backup: Type=bool
 - Retention: type

| First Header  | Second Header |
| ------------- | ------------- |
| Content Cell  | Content Cell  |
| Content Cell  | Content Cell  |

### 3. Permissions
### 4. How to use
```powershell
```

