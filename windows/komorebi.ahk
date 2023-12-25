#Requires AutoHotkey v2.0

Persistent

PrefixHook := InputHook("B", "{;}")
PrefixHook.OnKeyDown := PrefixKeyDown
PrefixHook.OnEnd := PrefixKeyOnEnd
PrefixHook.KeyOpt("{All}", "S") 

PrefixGui := Gui()
PrefixGui.Opt("+AlwaysOnTop -Caption +Disabled +Owner")
PrefixGui.Add("Text",, "Please enter your name:")

PrefixKeyDown(ih, vk, sc)
{
}

PrefixKeyOnEnd(ih)
{
    PrefixGui.Hide()
}

^b::
{
    PrefixHook.Start()
    PrefixGui.Show()
}
