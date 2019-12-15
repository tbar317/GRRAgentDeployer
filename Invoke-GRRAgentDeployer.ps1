Function Invoke-DeployGRRAgent 
{
    [CmdletBinding()]
    Param(
    [String]$target
    )
    
    Enable-PSRemoting -SkipNetworkProfileCheck -Force
    #Set the Execution Policy if needed
    if((Get-ExecutionPolicy) -ne 'Unrestricted') 
    { 
        Set-ExecutionPolicy -ExecutionPolicy Bypass -Force
    }

    Write-Host "Execution Policy has been set to Bypass." -ForegroundColor Cyan
    
    #Set the TrustedHosts Value
    if((Get-Item -Path WSMan:\localhost\Client\TrustedHosts).Value -ne $subnet) 
    { 
        Set-Item WSMan:\localhost\Client\TrustedHosts -Value * -Force 
    }
    
    Write-Host "Trusted Hosts values are set." -ForegroundColor Cyan
    
    Write-Host ""

    Write-Host "Setting up Credentials to use on the remote host(s)..." -ForegroundColor Cyan

    Write-Host ""

    Write-Host "Enter the domain short name " -ForegroundColor Yellow

    $Domain = Read-Host

    Write-Host ""

    Write-Host "Enter the username to connect to the remote system(s)" -ForegroundColor Yellow

    $UserName = Read-Host 

    $domainCreds = "$Domain\$Username"

    Write-Host ""

    $password = Read-Host "Please enter the password to connect to the remote system(s)" -AsSecureString

    Write-Host ""

    #Add a variable for credentials

    $UserCredentials = New-Object -TypeName System.Management.Automation.PSCredential $domainCreds,$password

    
    Write-Host "Do you want to identify a list of targets: yes or no?" -ForegroundColor Yellow
    $answer = Read-Host

    if ($answer -eq 'yes') {
        #Load your hosts in a host file. Will update this in the future to be more dynamic.
        Write-Host "Enter the path to a list of hosts." -ForegroundColor Yellow
        Read-Host = $FilePath
        $RemoteHosts = Get-Content @($FilePath)
    } 
    else {
        #Get the Users temp directory and create a random file in it
        $tempdir = [System.IO.path]::GetTempPath()
        $fakename = [System.IO.path]::GetRandomFileName()
        #Write the target IP address into the random file and then read the contents of the file into variable $h      
        $tempplace = New-Item -ItemType File -Path (Join-Path $tempdir $fakename)
        Write-Output -InputObject $target > $tempplace
        #IP address of the target gets assigned to $h for use below
        $h = Get-Content @($tempplace)
    }

    #Provide the full path the GRR executable.
    Write-Host "Enter the full path to your GRR Executable: " -ForegroundColor Yellow
    $lpath = Read-Host  
    Write-Host "The local path has been set to $LocalPath" -ForegroundColor Cyan
     
    #Provide the location of where to set the GRR agent on the remote hosts
    Write-Host "Enter the full path on the remote host wher you want to deploy the executable: " -ForegroundColor Yellow
    $rpath = Read-Host 
    Write-Host "The remote path has been set to $RemotePath" -ForegroundColor Cyan

    foreach ($h in $RemoteHosts) {
        #Establish a session to the remost host to move the executable to the remote system.
        $Session1 = New-PSSession -ComputerName $h -Credential $UserCredentials
        
        #Use the Copy-Item function to move the executable across the established session
        Copy-Item -ToSession $Session1 -Path $lpath -Destination $rpath
        #Kill the session
        Remove-PSSession -Session $Session1
        #Create a new connection, start the GRR agent, verify it, disconnect and kills session automatically.
        Invoke-Command -ComputerName $h -Credential $UserCredentials -ScriptBlock {
            Start-Process $using:rpath -NoNewWindow -PassThru 
            #Get-Process -Name GRR*
            Get-Process -Name PStest.exe
        }

        Write-Host "GRR agent deployed for host $h" -ForegroundColor Cyan
    }
}

Invoke-DeployGRRAgent -target 192.168.131.101

   