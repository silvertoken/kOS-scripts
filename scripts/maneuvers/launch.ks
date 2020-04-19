lib("control").
lib("systems").

function launch {
    parameter staging is 1.
    parameter targetAltitude is 80000.
    
	sas off.
    local booster is 0.
    local dthrot is 1.
    lock throttle to dthrot.
    lock steering to heading(90, 90 - 90 * (apoapsis / targetAltitude)).
    message("Initiate Launch Procedure...").
    
    if stage:solidfuel > 0 {
        set booster to 1.
    }

    wait 3.
    message("Ignition...").
    stage.
    wait 1.

    //we don't have boosters
    if booster = 0 {
        lock throttle to adjustThrottleTWR().
    }

    until altitude > 40000  or checkFlameout() {
        if booster = 1 {
            if stage:number > 0 {
                if stage:solidfuel = 0  and stage:ready {
                    set dthrot to 0.
                    stage.
                    set booster to 0.
                    lock throttle to adjustThrottleTWR().
                    message("Staging boosters...").
                }
            }
        }
        else {
            if checkStage() {
                stage.
                message("Staging...").
            }
        }
    }

    if checkFlameout() {
        message("Out of fuel.  Aborting ascent...").
        return false.
    }

    message("Leaving thick atmosphere...").
    // set throttle back to 1
    set dthrot to 1.
    lock throttle to dthrot.

    until apoapsis > 70000 or checkFlameout() {
        // handle initial solid boosters?
        if booster = 1 {
           if stage:number > 0 {
                if stage:solidfuel = 0 {
                    set dthrot to 0.
                    stage.
                    set booster to 0.
                    set dthrot to 1.
                    message("Staging boosters...").
                }
            } 
        }
        else {
            if checkStage() {
                set dthrot to 0.
                stage.
                set dthrot to 1.
                message("Staging...").
            }
        }
    }

    if checkFlameout() {
        message("Out of fuel.  Aborting ascent...").
        return false.
    }

    message("Reached apoapsis target of 70000...").

    lock steering to heading(90 + orbit:inclination, 90 - 90 * (apoapsis / targetAltitude)).

    until round(apoapsis,2) >= targetAltitude  or checkFlameout() {
         if checkStage() {
            set dthrot to 0.
		    stage.
		    set dthrot to 1.
            message("Staging...").
        }
    }
    if checkFlameout() {
        message("Out of fuel.  Aborting ascent...").
        return false.
    }

    message("Apoapsis reached target altitude").

    return true.
}

