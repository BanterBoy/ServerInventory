Get-ChildItem .\*.ps1 | ForEach-Object { . $_ }


$serversOuPath = Get-OUDistinguishedName -SearchTerm Server
$servers = Get-ADComputer -SearchBase $serversOuPath -Filter *  | Select-Object -ExpandProperty Name


foreach ($server in $servers) {
    Write-Output $server
}
