
$installDir = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent

if (!$env:HOME) { $env:HOME = "$env:HOMEDRIVE$env:HOMEPATH" }
if (!$env:HOME) { $env:HOME = "$env:USERPROFILE" }
set HOME $env:HOME -Force
(Get-PSProvider 'FileSystem').Home = $env:HOME

. $installDir\shared.ps1

. $installDir\7zip\load.ps1
. $installDir\git\load.ps1
. $installDir\git-extras-windows\load.ps1
. $installDir\git-tfs\load.ps1
. $installDir\posh-git\load.ps1

if (GitIsInstalled -and PoshGitIsInstalled)
{
    Start-SshAgent -Quiet
}

cd $env:HOME