// initial boot up 
wait until ship:unpacked.
clearscreen.
CORE:PART:GETMODULE("kOSProcessor"):DOEVENT("Open Terminal").
set Terminal:CHARHEIGHT to 18.
switch to 1.

if exists("0:/library/import.ks") {
    copyPath("0:/library/import.ks", "1:/library/import.ks").
    runOncePath("1:/library/import.ks").
}
else {
    shutdown.
}

// load initial configuration
lib("gui").

//load telemetry
lib("telemetry").

//load science
lib("science").

// load mission scripts
if missions() {
    message("Missions loaded...").
    runpath("mission.ks").
}
else {
    message("Failed to load mission scripts!", red).
}
