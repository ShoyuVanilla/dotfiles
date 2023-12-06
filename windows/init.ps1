# winget install -e --id Microsoft.PowerShell --source winget
# Set-ExecutionPolicy -ExecutionPolicy Unrestricted

New-Item -ItemType Directory -Force -Path (Split-Path $PROFILE)
New-Item -ItemType SymbolicLink -Path $PROFILE -Target (Join-Path -Path $PSScriptRoot -ChildPath Microsoft.PowerShell_profile.ps1)
