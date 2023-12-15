$ErrorActionPreference = "Stop"

$ImplPath = Join-Path -Path $PSScriptRoot -ChildPath init.impls.ps1

if ( (winget list) -match 'Microsoft\.PowerShell.+ winget$' ) {
    Write-Host 'Powershell is installed'
    &$ImplPath
}
else {
    Invoke-WebRequest -Uri https://aka.ms/getwinget -OutFile winget.msixbundle
    Add-AppxPackage winget.msixbundle
    Remove-Item -Path winget.msixbundle
    Write-Host 'Installing Powershell'
    winget --version
    winget search Microsoft.PowerShell
    winget install --id Microsoft.PowerShell --source winget

    $env:Path=(
        [System.Environment]::GetEnvironmentVariable("Path", "Machine"),
        [System.Environment]::GetEnvironmentVariable("Path", "User")
    ) -match '.' -join ';'

    Write-Host 'Installed Powershell'

    pwsh $ImplPath
}
