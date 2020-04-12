$SteamDir = (get-itemproperty HKCU:/Software/Valve/Steam).SteamPath
$KSPDir = $SteamDir + "/steamapps/common/Kerbal Space Program"
$KSPScriptDir = $KSPDir + "/Ships/Script"
Copy-Item -Recurse -Force scripts/* $KSPScriptDir
