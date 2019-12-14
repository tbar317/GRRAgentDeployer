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

        }
}



   