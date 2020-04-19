maneuvers("launch").
maneuvers("circularize").
if launch() {
    if circularize() {
        
    }
}

when ship:status = "LANDED" or ship:status = "SPLASHED" then {
	runScience().
}

//This sets the user's throttle setting to zero to prevent the throttle
//from returning to the position it was at before the script was run.
SET SHIP:CONTROL:PILOTMAINTHROTTLE TO 0.