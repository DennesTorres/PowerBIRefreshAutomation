<#
.SYNOPSIS 
    Indexes tables in a database if they have a high fragmentation

.DESCRIPTION
    This runbook indexes all of the tables in a given database if the fragmentation is
    above a certain percentage. 
    It highlights how to break up calls into smaller chunks, 
    in this case each table in a database, and use checkpoints. 
    This allows the runbook job to resume for the next chunk of work even if the 
    fairshare feature of Azure Automation puts the job back into the queue every 30 minutes

.PARAMETER PowerBIEndpoint
    Power BI XMLA endpoint address

.PARAMETER ServicePrincipal
    Service principal to connect to the XMLA endpoint in the format Appid@TenantId
    
.PARAMETER ServicePrincipalSecret
    Secret value created for the service principal

.PARAMETER Query
    XMLA statement to be executed, either in XML or JSON.

.NOTES
    AUTHOR: Dennes Torres
    LASTEDIT: March 20, 2022
#>
    param(
        [parameter(Mandatory=$True)]
        [string] $PowerBIEndpoint,
    
        [parameter(Mandatory=$True)]
        [string] $ServicePrincipal,
    
        [parameter(Mandatory=$True)]
        [string] $ServicePrincipalSecret,            

        [parameter(Mandatory=$False)]
        [string] $Query
                  
    )

$assemblyPath = "C:\Modules\User\Microsoft.AnalysisServices.AdomdClient\Microsoft.AnalysisServices.AdomdClient.dll"
try {Add-Type -Path $assemblyPath}
catch  { $_.Exception.LoaderExceptions }

$Connection = New-Object Microsoft.AnalysisServices.AdomdClient.AdomdConnection
$Connection.ConnectionString = "Datasource="+ $PowerBIEndpoint +";User ID="+ $ServicePrincipal +";Password="+ $ServicePrincipalSecret  

        $Command = $Connection.CreateCommand();
        $Command.CommandTimeout = 20000;
        $Command.CommandType = [System.Data.CommandType]::Text;
        $Command.CommandText = $Query;


$Connection.Open()

$Command.ExecuteNonQuery()

$Connection.Close()
$Connection.Dispose()