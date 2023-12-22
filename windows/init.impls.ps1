$ErrorActionPreference = "Stop"

function Search-Command($cmdname) {
    return [bool](Get-Command -Name $cmdname -ErrorAction SilentlyContinue)
}

# Install Scoop
if ( -not(Search-Command -cmdname 'scoop') ) {
    Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
    Invoke-RestMethod get.scoop.sh | Invoke-Expression
    $env:Path=(
        [System.Environment]::GetEnvironmentVariable("Path", "Machine"),
        [System.Environment]::GetEnvironmentVariable("Path", "User")
    ) -match '.' -join ';'
    Start-Process pwsh -Verb RunAs -ArgumentList "Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope CurrentUser"
    scoop install git
}

# Install Rust
if ( -not(Search-Command -cmdname 'rustup') ) {
    winget install Microsoft.VisualStudio.2022.Community --silent --override "--wait --quiet --add ProductLang En-us --add Microsoft.VisualStudio.Workload.NativeDesktop --includeRecommended"
    winget install Rustlang.Rustup
}
rustup component add rust-analyzer

# Install vs-code
if ( -not(Search-Command -cmdname 'code') ) {
    winget install Microsoft.VisualStudioCode
}

scoop import $(Join-Path -Path $PSScriptRoot -ChildPath scoopfile.json)

# Install pyenv
Invoke-WebRequest -UseBasicParsing -Uri "https://raw.githubusercontent.com/pyenv-win/pyenv-win/master/pyenv-win/install-pyenv-win.ps1" -OutFile "./install-pyenv-win.ps1"; &"./install-pyenv-win.ps1"

# Symlink PowerShell Profile
New-Item -ItemType Directory -Force -Path (Split-Path $PROFILE)
sudo New-Item -ItemType SymbolicLink -Path `$PROFILE -Target $(Join-Path -Path $PSScriptRoot -ChildPath Microsoft.PowerShell_profile.ps1) -Force

#Symlink Helix Settings
sudo New-Item -ItemType SymbolicLink -Path $(Join-Path -Path $HOME -ChildPath 'scoop\persist\helix\config.toml') -Target $(Join-Path -Path (Get-Item -Path $PSScriptRoot).Parent -ChildPath 'helix\config.toml') -Force
sudo New-Item -ItemType SymbolicLink -Path $(Join-Path -Path $HOME -ChildPath 'scoop\persist\helix\languages.toml') -Target $(Join-Path -Path (Get-Item -Path $PSScriptRoot).Parent -ChildPath 'helix\languages.toml') -Force
