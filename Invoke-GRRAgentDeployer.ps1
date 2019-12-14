Function Invoke-DeployGRRAgent 
{
    [CmdletBinding()]
    Param(
    [alias("a")]
    [String]$Agent,
    [alias("u")]
    [String]$username,
    [alias("p")]
    [SecureString]$password
    )
    
    Enable-PSRemoting -SkipNetworkProfileCheck -Force

    if((Get-ExecutionPolicy) -ne 'Unrestricted') 
    { 
        Set-ExecutionPolicy -ExecutionPolicy Bypass -Force
    }
    #Set the TrustedHosts Value
    if((Get-Item -Path WSMan:\localhost\Client\TrustedHosts).Value -ne $subnet) 
    { 
        Set-Item WSMan:\localhost\Client\TrustedHosts -Value * -Force 
    }

     #Add a variable for credentials
     $UserPassSecure = ConvertTo-SecureString $password -AsPlainText -Force
     $UserCredentials = New-Object -TypeName System.Management.Automation.PSCredential $UserName,$UserPassSecure
 
 
     Write-Host "Enter location of your GRR Executable: " -ForegroundColor Yellow
     LocalPath = Read-Host  
     Write-Host "The local path has been set to $LocalPath" -ForegroundColor Cyan
     Write-Host "Enter the location on the remote host wher you want to deploy the executable: " -ForegroundColor Yellow
     RemotePath = Read-Host 
     Write-Host "The remote path has been set to $RemotePath" -ForegroundColor Cyan
 
     Copy-Item -Path "C:\Users\DCI Student\Downloads\GRR_3.2.0.1_amd64.exe" "C:\Tools\dbg_GRR_3.2.0.1_amd64.exe"
 
     $Session1 = New-PSSession -ComputerName 172.16.12.5 -Credential Administrator
 
     Copy-Item -ToSession $Session1 -Path c:\Tools\dbg_GRR_3.2.0.1_amd64.exe -Destination c:\Tools\dbg_GRR_3.2.0.1_amd64.exe
 
     Invoke-Command -ComputerName $Target -Credential $UserCredentials -ScriptBlock {
         Start-Process $RemotePath\$Agent -NoNewWindow -PassThru 
         Get-Process -Name GRR*
     }
}



   