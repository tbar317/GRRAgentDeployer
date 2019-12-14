﻿Function Invoke-DeployGRRAgent 
{
    [CmdletBinding()]
    Param(
    [String]$target,
    [alias("a")]
    [String]$agent,
    [alias("u")]
    [String]$username,
    [alias("p")]
    [SecureString]$password
    )
    
    Enable-PSRemoting -SkipNetworkProfileCheck -Force
    #Set the Execution Policy if needed
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
 
    #Provide the full path the GRR executable.
    Write-Host "Enter location of your GRR Executable: " -ForegroundColor Yellow
    LocalPath = Read-Host  
    Write-Host "The local path has been set to $LocalPath" -ForegroundColor Cyan
     
    #Provide the location of where to set the GRR agent on the remote hosts
    Write-Host "Enter the location on the remote host wher you want to deploy the executable: " -ForegroundColor Yellow
    RemotePath = Read-Host 
    Write-Host "The remote path has been set to $RemotePath" -ForegroundColor Cyan

    #Establish a session to the remost host to move the executable to the remote system.
    $Session1 = New-PSSession -ComputerName $target -Credential Administrator
    
    #Use the Copy-Item function to move the executable across the established session
    Copy-Item -ToSession $Session1 -Path c:\Tools\dbg_GRR_3.2.0.1_amd64.exe -Destination c:\Tools\dbg_GRR_3.2.0.1_amd64.exe
 
    Invoke-Command -ComputerName $target -Credential $UserCredentials -ScriptBlock {
        Start-Process $RemotePath\$agent -NoNewWindow -PassThru 
        Get-Process -Name GRR*
    }
}



   