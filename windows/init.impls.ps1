$ErrorActionPreference = "Stop"

function Check-Command($cmdname)
{
    return [bool](Get-Command -Name $cmdname -ErrorAction SilentlyContinue)
}

# Symlink PowerShell Profile
New-Item -ItemType Directory -Force -Path (Split-Path $PROFILE)
New-Item -ItemType SymbolicLink -Path $PROFILE -Target (Join-Path -Path $PSScriptRoot -ChildPath Microsoft.PowerShell_profile.ps1)

# Install Scoop
if (-not(Check-Command -cmdname 'scoop'))
{
    Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
    irm get.scoop.sh | iex
}

# Install Rust
if (-not(Check-Command -cmdname 'rustup'))
{
    $WebClient = New-Object System.Net.WebClient
    $Url = 'https://win.rustup.rs/x86_64'
    $InstallFile = Join-Path -Path $PSScriptRoot -ChildPath rustup-init.exe
    $WebClient.DownloadFile($Url, $InstallFile)
    & $InstallFile
    Remove-Item -Path $InstallFile
}

Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scpoe CurrentUser
