$ErrorActionPreference = "Stop"

function Check-Command($cmdname)
{
    return [bool](Get-Command -Name $cmdname -ErrorAction SilentlyContinue)
}

# Install Scoop
if (-not(Check-Command -cmdname 'scoop'))
{
    Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
    irm get.scoop.sh | iex
    $env:Path=(
        [System.Environment]::GetEnvironmentVariable("Path", "Machine"),
        [System.Environment]::GetEnvironmentVariable("Path", "User")
    ) -match '.' -join ';'
    Start-Process pwsh -Verb RunAs -ArgumentList "Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope CurrentUser"
    scoop install git
}

# Install Rust
if (-not(Check-Command -cmdname 'rustup'))
{
    winget install Microsoft.VisualStudio.2022.Community --silent --override "--wait --quiet --add ProductLang En-us --add Microsoft.VisualStudio.Workload.NativeDesktop --includeRecommended"
    winget install Rustlang.Rustup
}

scoop import $(Join-Path -Path $PSScriptRoot -ChildPath scoopfile.json)

# Symlink PowerShell Profile
New-Item -ItemType Directory -Force -Path (Split-Path $PROFILE)
sudo New-Item -ItemType SymbolicLink -Path `$PROFILE -Target $(Join-Path -Path $PSScriptRoot -ChildPath Microsoft.PowerShell_profile.ps1)
