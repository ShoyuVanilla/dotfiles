$PSReadLineOptions = @{
    EditMode = "Vi"
    ViModeIndicator = "Cursor"
    BellStyle = "None"
    PredictionSource = "HistoryAndPlugin"
    PredictionViewStyle = "ListView"
}
Set-PSReadLineOption @PSReadLineOptions

# TODO: https://github.com/PowerShell/CompletionPredictor#use-the-predictor

# Shows navigable menu of all options when hitting Tab
Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete

# Autocompletion for arrow keys
Set-PSReadlineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadlineKeyHandler -Key DownArrow -Function HistorySearchForward

# Aliases
Set-Alias -Name df -Value duf

Set-Alias -Name ls -Value eza
function Fll {eza -l --group-directories-first --sort=ext}
Set-Alias -Name ll -Value Fll
function Fld {eza -lD}
Set-Alias -Name ld -Value Fld # List Directories
function Flf {eza -lf --sort=ext}
Set-Alias -Name lf -Value Flf # List Files
function Fla {eza -al --group-directories-first --sort=ext}
Set-Alias -Name la -Value Fla # List All
function Flt {eza -al --sort=modified}
Set-Alias -Name lt -Value Flt # List by Time

function Stop-Process() {
    $targetPid = (procs --color always |
        fzf -m --ansi --header="$(Get-Date)" --header-lines=2 |
        ForEach-Object { $_.Split(' ')[1] })

    if ($null -ne $targetPid) {
        Stop-Process -Force -Id $targetPid
    }
}
Set-Alias -Name pskill -Value Stop-Process

function Export-Scoop() {
    $scoopfilePath = Join-Path `
        -Path (Split-Path -Parent (Get-Item -Path $PSCommandPath | Select-Object -ExpandProperty Target)) `
        -ChildPath scoopfile.json
    scoop export |
        jq 'walk(if type=="object" then to_entries | sort_by(.key) | from_entries else . end)' > `
        $scoopfilePath
}

# FNM - Fast Node Managr
fnm env --use-on-cd | Out-String | Invoke-Expression

# zoxide for jumping directories
Invoke-Expression (& { (zoxide init powershell | Out-String) })

# starship shell prompt
Invoke-Expression (&starship init powershell)
