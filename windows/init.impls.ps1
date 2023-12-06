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
if (-not(Check-Command -cmdname 'rustc'))
{
    winget install Microsoft.VisualStudio.2022.Community --silent --override "--wait --quiet --add ProductLang En-us --add Microsoft.VisualStudio.Workload.NativeDesktop --includeRecommended"
    winget install Rustlang.Rustup
}

Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scpoe CurrentUser
