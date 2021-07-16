Get-ChildItem .\*.ps1 | ForEach-Object {. $_ }

$Accounts = Get-OUfqdn -Department accounts
$servers = Get-ADComputer -SearchBase $serversOuPath -Filter *