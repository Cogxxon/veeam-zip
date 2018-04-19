
# VEEAM-ZIP
### Build Environment
* Veeam 9.5 Free SP1
* Powershell 5.1.15063.0

### 1. Contents
 - README.MD
 - Send-Psmail.ps1 - *Wrapper for **System.Net.Mail.MailMessage***
 - veeam-zip.ps1 - *Main Script file, handles the job submission to Veeam Server*
 - veeam-zipClearnup.ps1 - *Clean up **.vbk** files older then the specified retention period*
 - veeam-zipReporter.ps1 - *Email Reporter of kept **.vbk** files with within the retention Period*
### 2. Script File Usage's
> veeam-zip.ps1
> ```powershell
> veeam-zip -vza_backup:$true -retention 7
> --or--
> veeam-zip -vza_backup -retention 7
> ```
> #### 2.1 **Switches** 
> | Switches      | Type                                    |
> | ------------- | --------------------------------------- |
> | vza_backup    | **[Bool]**, *$true* or *$false*         | 
> | Retention     | **[int32]**                             |

> veeam-zipCleanup.ps1
> ```powershell
> veeam-zipCleanup
> ```
### 3. Permissions
### 4. How to use
```powershell
```
