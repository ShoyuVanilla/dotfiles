# Vi mode
Set-PSReadLineOption -EditMode Vi

# Shows navigable menu of all options when hitting Tab
Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete

# Autocompletion for arrow keys
Set-PSReadlineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadlineKeyHandler -Key DownArrow -Function HistorySearchForward

# FNM - Fast Node Managr
fnm env --use-on-cd | Out-String | Invoke-Expression

Invoke-Expression (& { (zoxide init powershell | Out-String) })

Invoke-Expression (&starship init powershell)
