

function adjustThrottleKerbin {
    if ship:availableThrust > 0 {
        return min(1, 1.5 * currentGravity() * (ship:mass / ship:availableThrust)).
    }
    return 0.
}

function currentGravity {
    return (constant:G * body:mass)/((ship:altitude + ship:body:radius)^2).
}

function checkStage {
    parameter stageThrust.
	if stageThrust - ship:maxthrust > 10 {
		return true.
	}
    return false.
}

function telemetry {
    parameter accel.
	print "Status: " + ship:status + "      " at (25,2).
	print "Stage  : " + stage:number + " " at (1,4).
	print "Throttle: " + round(accel,2) + "      " at (1,5).
	print "Connection to KSC: " at (25,1).
	if homeconnection:isconnected {
        print "YES" at (44,1).
	}
	else {
		print "NO " at (44,1).
	}
}