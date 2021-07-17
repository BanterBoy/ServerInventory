# [ArgumentCompleter( {
#     $baseOU = (Get-ADDomain).DistinguishedName
#     $OUs = Get-ADOrganizationalUnit -Filter * -SearchScope SubTree -SearchBase $baseOU | Sort-Object -Property DistinguishedName
#     $OUs | Where-Object { ( $_.DistinguishedName -Like $SelectOU ) -and ( $_.DistinguishedName -Like '*users*' ) } | Select-Object -Property DistinguishedName
# } ) ]


# $searchTerm = Read-Host -Prompt "Enter searchTerm String"
# $baseOU = (Get-ADDomain).DistinguishedName
# $OUs = Get-ADOrganizationalUnit -Filter * -SearchScope SubTree -SearchBase $baseOU | Sort-Object -Property DistinguishedName
# $UserOU = $OUs | Where-Object { ( $_.DistinguishedName -Like "*$searchTerm*" ) -and ( $_.DistinguishedName -Like '*users*' ) } | Select-Object -Property DistinguishedName
# $UserOU.DistinguishedName
