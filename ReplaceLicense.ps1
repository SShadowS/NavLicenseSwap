#Settings
$serverins = "DynamicsNAV70"
$user = "FTPUsername"
$url = "ftp.there.com/directory/Fin.flf"
$serviceName = "Microsoft Dynamics NAV Server [DynamicsNAV70]"
$navModule = "E:\Program Files\Microsoft Dynamics NAV\70\Service\NavAdminTool.ps1"

#Imports
Import-Module $navModule

#Functions
function display-licens{

$message = Export-NAVServerLicenseInformation -ServerInstance $serverins

$title = "Current license"
$message = "Choose license to import?"

$developer = New-Object System.Management.Automation.Host.ChoiceDescription "&Developer license", `
       "Imports developer license by FTP."
$client = New-Object System.Management.Automation.Host.ChoiceDescription "&Client license", `
       "Imports client license from local dir."
$no = New-Object System.Management.Automation.Host.ChoiceDescription "&Stop", `
       "Stops script, no license changes."

$options = [System.Management.Automation.Host.ChoiceDescription[]]($developer, $client,$no)

$resultLicense = $host.ui.PromptForChoice($title, $message, $options, 0) 
}

Function Show-Sessions{
Write-Host -ForegroundColor Red "Open sessions:"
Write-Host -ForegroundColor Red "-----------------------------------------------"
$output
Write-Host -ForegroundColor Red "-----------------------------------------------"
}

Function Confirm-Ignore-Sessions{
$title = "Open sessions"
$message = "Sessions open on server, sure you want to continue?"
    
$yes = New-Object System.Management.Automation.Host.ChoiceDescription "&Yes", `
       "Stops all sessions and replaces licens."
    
$no = New-Object System.Management.Automation.Host.ChoiceDescription "&No", `
      "Stops script, no licens changes."

$options = [System.Management.Automation.Host.ChoiceDescription[]]($yes, $no)

$result = $host.ui.PromptForChoice($title, $message, $options, 0) 
}

Function Download-License ($password){
$ftp = "ftp://" + $user +":" + $password + "@" +$url
$webclient = New-Object System.Net.WebClient
$uri = New-Object System.Uri($ftp)
"Downloading license..."
$license = $webclient.DownloadString($uri)
"Download done."
}

Function Replace-LicenseLocal {
"Importing client license"
#Import-NAVServerLicense DynamicsNAV70 -LicenseData ([Byte[]]$(Get-Content -Path "fin.flf" -Encoding Byte))
}

Function Replace-LicenseFTP {
"Importing developer license"
#Import-NAVServerLicense DynamicsNAV70 -LicenseData ([Byte[]]$(Get-Content -Path "fin.flf" -Encoding Byte))
}


#Script body
display-licens

$list = Get-NAVServerSession $serverins
$output = Format-List -InputObject $list -Property "User ID", "Client Type", "Client Computer Name"
if ($output -ne "" ){
    Show-Sessions
    Confirm-Ignore-Sessions
    if ($result -eq 0){
        switch ($resultLicense){
                0 {
                    $pwd_secure_string = read-host "Enter FTP Password" -assecurestring
                    Download-License $pwd_secure_string
                    Replace-LicenseFTP
                    "Restarting service"
                    #Restart-Service -DisplayName $serviceName
                    "All done."
                }
                1 {
                    Replace-LicenseLocal
                    "Restarting service"
                    #Restart-Service -DisplayName $serviceName
                    "All done."
                }
                2 {
                    "Nothing done!"
                }

        }
    }
}