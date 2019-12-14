﻿Function Invoke-DeployGRRAgent 
{
    [CmdletBinding()]
    Param(
    [String]$target,
    [alias("a")]
    [Parameter(Mandatory=$true)]
    [String]$agent,
    [Parameter(Mandatory=$true)]
    [alias("u")]
    [String]$username,
    [Parameter(Mandatory=$true)]
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
    
    Write-Host "Do you want to identify a list of targets"
    if ($target -eq 'null') {
        #Load your hosts in a host file. Will update this in the future to be more dynamic.
        Write-Host "Enter the path to a list of hosts." -ForegroundColor Yellow
        Read-Host = $RemoteHosts
    }

    #Provide the full path the GRR executable.
    Write-Host "Enter the full path to your GRR Executable: " -ForegroundColor Yellow
    LocalPath = Read-Host  
    Write-Host "The local path has been set to $LocalPath" -ForegroundColor Cyan
     
    #Provide the location of where to set the GRR agent on the remote hosts
    Write-Host "Enter the full path on the remote host wher you want to deploy the executable: " -ForegroundColor Yellow
    RemotePath = Read-Host 
    Write-Host "The remote path has been set to $RemotePath" -ForegroundColor Cyan

    if ($target -eq 'null') {
        $Session1 = New-PSSession -ComputerName $target -Credential Administrator
    
        #Use the Copy-Item function to move the executable across the established session
        Copy-Item -ToSession $Session1 -Path $LocalPath -Destination $RemotePath
        #Kill the remote session
        Remove-PSSession -Session $Session1
        #Create a new connection, start the GRR agent, verify it, disconnect and kills session automatically.
        Invoke-Command -ComputerName $target -Credential $UserCredentials -ScriptBlock {
            Start-Process $RemotePath -NoNewWindow -PassThru 
            Get-Process -Name GRR*
        }
    }

    foreach ($h in $RemoteHosts) {
        #Establish a session to the remost host to move the executable to the remote system.
        $Session1 = New-PSSession -ComputerName $h -Credential Administrator
        
        #Use the Copy-Item function to move the executable across the established session
        Copy-Item -ToSession $Session1 -Path $LocalPath -Destination $RemotePath
        #Kill the session
        Remove-PSSession -Session $Session1
        #Create a new connection, start the GRR agent, verify it, disconnect and kills session automatically.
        Invoke-Command -ComputerName $h -Credential $UserCredentials -ScriptBlock {
            Start-Process $RemotePath -NoNewWindow -PassThru 
            Get-Process -Name GRR*
        }
    }
}

 

   