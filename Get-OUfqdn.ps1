function Get-OUfqdn {
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
        $Department
    )

    $baseOU = (Get-ADDomain).DistinguishedName
    $OUs = Get-ADOrganizationalUnit -Filter * -SearchScope SubTree -SearchBase $baseOU | Sort-Object -Property DistinguishedName
    $UserOU = $OUs | Where-Object { ( $_.DistinguishedName -Like "*$Department*" ) -and ( $_.DistinguishedName -Like '*users*' ) } | Select-Object -Property DistinguishedName
    $UserOU.DistinguishedName

}


# [ArgumentCompleter( {
#     $baseOU = (Get-ADDomain).DistinguishedName
#     $OUs = Get-ADOrganizationalUnit -Filter * -SearchScope SubTree -SearchBase $baseOU | Sort-Object -Property DistinguishedName
#     $OUs | Where-Object { ( $_.DistinguishedName -Like $SelectOU ) -and ( $_.DistinguishedName -Like '*users*' ) } | Select-Object -Property DistinguishedName
# } ) ]


# $Department = Read-Host -Prompt "Enter Department String"
# $baseOU = (Get-ADDomain).DistinguishedName
# $OUs = Get-ADOrganizationalUnit -Filter * -SearchScope SubTree -SearchBase $baseOU | Sort-Object -Property DistinguishedName
# $UserOU = $OUs | Where-Object { ( $_.DistinguishedName -Like "*$Department*" ) -and ( $_.DistinguishedName -Like '*users*' ) } | Select-Object -Property DistinguishedName
# $UserOU.DistinguishedName
