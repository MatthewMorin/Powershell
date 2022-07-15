$online = Test-NetConnection -ComputerName "NC-WXD-Ship01"

if($online.PingSucceeded -eq $true)
{
    write-output "nice!"
}