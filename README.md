# Powershell
Powershell stuff

Setup powershell  path for any scripts or modules to be used. this should be done in each version of powershell being used. 5.1 and 7.x

Add a server share to the enviroment path for scripts:

$Env:Path += ";\\Server-Fileshare\Departments\IT\Powershell\;"



Add a server share to your module path:

$Env:PSModulePath += ";\\Server-Fileshare\Departments\IT\Powershell\Modules\;"



paths can be overwritten. use with caution:

$Env:PSModulePath = "C:\Users\mmorin_admin\Documents\WindowsPowerShell\Modules;C:\Program Files\WindowsPowerShell\Modules;C:\WINDOWS\system32\WindowsPowerShell\v1.0\Modules;c:\Users\mmorin_admin\.vscode\extensions\ms-vscode.powershell-2020.6.0\modules;\\NC-Fileshare\Departments\IT\Powershell\Modules\"



these path changes wont persist with each powershell session. path changes can be set in powershell startup profile: $profile.AllUsersAllHosts

'$env:Psmodulepath += ";\\Servershare\Departments\IT\Powershell\Modules\"' | Out-File -FilePath $PROFILE.AllUsersAllHosts -Append
