<#
    .SYNOPSIS
        Short description
    .DESCRIPTION
        Long description
    .EXAMPLE
        Example of how to use this cmdlet
    .EXAMPLE
        Another example of how to use this cmdlet
    .INPUTS
        Inputs to this cmdlet (if any)
    .OUTPUTS
        Output from this cmdlet (if any)
    .NOTES
        General notes
    .COMPONENT
        The component this cmdlet belongs to
    .ROLE
        The role this cmdlet belongs to
    .FUNCTIONALITY
        The functionality that best describes this cmdlet
#>

[CmdletBinding(DefaultParameterSetName = 'Default',
    SupportsShouldProcess = $true,
    PositionalBinding = $false,
    HelpUri = 'https://github.com/BanterBoy/ServerInventory',
    ConfirmImpact = 'Medium')]
[Alias()]
[OutputType([String])]
Param (
    # You can enter a single ComputerName or pipe a string of ComputerNames into this field.
    [Parameter(Mandatory = $true,
        ValueFromPipeline = $true,
        ValueFromPipelineByPropertyName = $true,
        ParameterSetName = 'Default')]
    [ValidateNotNull()]
    [ValidateNotNullOrEmpty()]
    [Alias("cn")] 
    [string[]]
    $ComputerName,

    # The Credential field is required to authenticate against the machine that you are reporting on.
    [Parameter(Mandatory = $true,
        ValueFromPipeline = $true,
        ValueFromPipelineByPropertyName = $true,
        ParameterSetName = 'Default')]
    [ValidateNotNull()]
    [ValidateNotNullOrEmpty()]
    [System.Management.Automation.PSCredential]
    [System.Management.Automation.Credential()]
    [Alias("cred")]
    $Credential
)

$Header = @"
<style>
    table {
        font-family: "Trebuchet MS", Arial, Helvetica, sans-serif;
        border-collapse: collapse;
        width: 100%;
    }
    th {
        padding-top: 12px;
        padding-bottom: 12px;
        text-align: left;
        background-color: #4CAF50;
        color: white;
    }
    </style>
"@

$scriptBlock = {
    $output = @{
        'ServerName'               = (hostname)
        'IPAddress'                = $null
        'OperatingSystem'          = $null
        'AvailableDriveSpace (GB)' = $null
        'Memory (GB)'              = $null
        'UserProfilesSize (MB)'    = $null
        'StoppedServices'          = $null
    }

    $output.ServerName = $server

    $userProfileSize = (Get-ChildItem -Path 'C:\Users' -File -Recurse | Measure-Object -Property Length -Sum).Sum
    $output.'UserProfilesSize (GB)' = [math]::Round($userProfileSize / 1GB, 1)
    
    $output.'AvailableDriveSpace (GB)' = Get-CimInstance -ClassName Win32_LogicalDisk | Select-Object -Property DeviceID, @{Name = 'FreeSpace'; Expression = { [Math]::Round(($_.Freespace / 1GB), 1) } }
    
    $output.'OperatingSystem' = (Get-CimInstance -ClassName Win32_OperatingSystem).Caption
    
    $output.'Memory (GB)' = (Get-CimInstance -ClassName Win32_PhysicalMemory | Measure-Object -Property Capacity -Sum).Sum / 1GB
    
    $output.'IPAddress' = (Get-CimInstance -ClassName Win32_NetworkAdapterConfiguration -Filter "IPEnabled = 'True'").IPAddress[0]
    
    $output.StoppedServices = (Get-Service | Where-Object { $_.Status -eq 'Stopped' } | Measure-Object).Count
    
    [pscustomobject]$output

}

$icmParams = @{
    ComputerName = $ComputerName
    ScriptBlock = $scriptBlock
    Credential = $Credential
}


$report = Invoke-Command @icmParams | Select-Object -Property * -ExcludeProperty 'RunspaceId', 'PSComputerName', 'PSShowComputerName' | ConvertTo-Html -Fragment
ConvertTo-HTML -PreContent "<h1>Server Information Report</h1>" -PostContent $report -Head $Header | Out-File D:\ServerInventory\ServerReport.html
Invoke-Item D:\ServerInventory\ServerReport.html

