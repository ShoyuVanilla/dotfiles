$ErrorActionPreference = "Stop"

# Symlink PowerShell Profile
New-Item -ItemType Directory -Force -Path (Split-Path $PROFILE)
New-Item `
    -ItemType SymbolicLink `
    -Path $PROFILE `
    -Target (Join-Path -Path $PSScriptRoot -ChildPath Microsoft.PowerShell_profile.ps1) `
    -Force

# Symlink Helix Settings
New-Item `
    -ItemType SymbolicLink `
    -Path (Join-Path -Path $HOME -ChildPath 'scoop\persist\helix\config.toml') `
    -Target (Join-Path -Path (Get-Item -Path $PSScriptRoot).Parent -ChildPath 'helix\config.toml') `
    -Force
New-Item `
    -ItemType SymbolicLink `
    -Path (Join-Path -Path $HOME -ChildPath 'scoop\persist\helix\languages.toml') `
    -Target (Join-Path -Path (Get-Item -Path $PSScriptRoot).Parent -ChildPath 'helix\languages.toml') `
    -Force

# Symlink Wezterm Settings
New-Item `
    -ItemType SymbolicLink `
    -Path (Join-Path -Path $HOME -ChildPath '.wezterm.lua') `
    -Target (Join-Path -Path $PSScriptRoot -ChildPath 'wezterm.lua') `
    -Force
