# GRRAgentDeployer

Invoke-GRRAgentDeployer.ps1 is PowerShell script to deploy Google Rapid Response (GRR) agents in a Windows environment. The goal of this project is to quickly deploy GRR agents across your network prior to or during an Incident Response. 

# Getting Started

Open a Powershell Session (best to use an Administrative session)  
Set-ExecutionPolicy -ExecutionPolicy Unrestricted  
##If you plan to deploy to just a single target  
.\Invoke-GRRAgentDeployer.ps1 -target 192.168.131.101  
OR  
##If you plan to deploy your GRR Agents to multiple targets 
.\Invoke-GRRAgentDeployer.ps1  

# Example

PS C:\Users\user.b.subject\Desktop> .\Invoke-GRRAgentDeployer.ps1 -target 192.168.131.101  
Execution Policy has been set to Bypass.  
Trusted Hosts values are set.  

Setting up Credentials to use on the remote host(s)...  

Enter the domain short name  
TEST2  

Enter the username to connect to the remote system(s)  
ghost.admin 

Please enter the password to connect to the remote system(s): ****************  

Do you want to identify a list of targets: yes or no?  
no  

Enter the full path to your GRR Executable:  
C:\Users\user.b.subject\Desktop\grr.exe  
The local path has been set to C:\Users\user.b.subject\Desktop\grr.exe  

Enter the full path on the remote host wher you want to deploy the executable:  
c:\windows\system32\grr.exe  
The remote path has been set to c:\windows\system32\grr.exe  

Handles  NPM(K)    PM(K)      WS(K)     CPU(s)     Id  SI ProcessName                    PSComputerName  
-------  ------    -----      -----     ------     --  -- -----------                    --------------
     37       2      284        680       0.02   4872   0 grr                            192.168.131.101  
     
GRR agent deployed for host 192.168.131.101  

