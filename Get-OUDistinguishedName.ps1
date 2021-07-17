function Get-OUDistinguishedName {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            ParameterSetName = 'ParameterSet1')]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [OutputType([string])]
        [string]
        $SearchTerm,

        [Parameter(Mandatory = $false,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            ParameterSetName = 'ParameterSet1')]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [OutputType([string])]
        [string]
        $Refine = "*"

    )

    $baseOU = (Get-ADDomain).DistinguishedName
    $OUs = Get-ADOrganizationalUnit -Filter * -SearchScope SubTree -SearchBase $baseOU | Sort-Object -Property DistinguishedName
    $UserOU = $OUs | Where-Object { ( $_.DistinguishedName -Like "*$SearchTerm*" ) -and ( $_.DistinguishedName -Like "*$Refine*" ) } | Select-Object -Property DistinguishedName
    $UserOU.DistinguishedName

}
