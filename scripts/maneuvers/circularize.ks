lib("control").

function circularize {
    parameter targetAltitude is 80000.
    set targetVel to getOrbitalVel(targetAltitude).
    set burnTime to getBurnTime(targetVel).
    set timeToBurn to getTimeToBurn(burnTime).
    lock steering to heading(90,0).
    lock throttle to 0.

    message("Waiting " + round(timeToBurn) + " seconds for orbital burn of " + round(burnTime) + " seconds...").
    wait timeToBurn - 1.

    message("Orbital burn...").
    
    lock throttle to 1.
    
    until ship:velocity:orbit:mag >= targetVel or checkFlameout() {
        if checkStage() {
            lock throttle to 0.
		    stage.
            message("Staging...").
		    lock throttle to 1.
        }

    }

     if checkFlameout() {
        message("Out of fuel.  Aborting circularization...").
        return false.
    }

    lock throttle to 0.
    message("Orbit reached...").
    return true.
}