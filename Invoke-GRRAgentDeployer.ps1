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
}



   