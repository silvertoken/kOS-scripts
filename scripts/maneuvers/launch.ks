lib("control").

function launch {
    parameter targetAltitude is 80000.
	sas off.
    local accel is 1.
    local stageThrust is ship:maxthrust.
    lock throttle to accel.
    lock steering to heading(90, 90 - 90 * (apoapsis / targetAltitude)).
    message("Initiate Launch Procedure...").
    wait 3.

    local lEng is list().
    list engines in lEng.
    for eng in lEng {
        if eng:stage = (stage:number - 1) and eng:allowshutdown {
            eng:activate().
            set accel to 1.
            message("IGNITION").
        }
    }

    wait 1.
    stage.
    wait 1.

    until apoapsis > 70000 {
        if checkStage(stageThrust) {
            lock throttle to 0.
		    stage.
		    wait 1.
		    lock throttle to accel.
		    set stageThrust to ship:maxthrust.
        }
        set accel to adjustThrottleKerbin().

    }

    message("Reached apoapsis target of 70000...").

    lock steering to heading(90 + orbit:inclination, 90 - 90 * (apoapsis / targetAltitude)).
    until apoapsis >= targetAltitude - 500 {
        if checkStage(stageThrust) {
            lock throttle to 0.
		    stage.
		    wait 1.
		    lock throttle to accel.
		    set stageThrust to ship:maxthrust.
        }
        set accel to adjustThrottleKerbin().
    }

    lock throttle to 0.
    lock steering to prograde.
    wait until altitude > 70001.

    lock throttle to accel.
    until round(apoapsis,2) >= targetAltitude + 0.3 {
         if checkStage(stageThrust) {
            lock throttle to 0.
		    stage.
		    wait 1.
		    lock throttle to accel.
		    set stageThrust to ship:maxthrust.
        }
        set accel to adjustThrottleKerbin().
        telemetry(accel).
    }

    lock throttle to 0.

    message("Apoapsis reached target altitude").
}
