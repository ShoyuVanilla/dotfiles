$ErrorActionPreference = "Stop"

$ImplPath = Join-Path -Path $PSScriptRoot -ChildPath init.impls.ps1

if ((winget list) -match 'Microsoft\.PowerShell.+ winget$')
{
    winget install -e --id Microsoft.PowerShell --source winget
    $env:Path=(
        [System.Environment]::GetEnvironmentVariable("Path", "Machine"),
        [System.Environment]::GetEnvironmentVariable("Path", "User")
    ) -match '.' -join ';'
    pwsh $ImplPath
}
else
{
    &$ImplPath
}
