

function getOrbitalVel {
	parameter targetAlt.
	return sqrt(constant:G * orbit:body:mass / (targetAlt + orbit:body:radius)).
}

function getMaxAccel {
	return SHIP:AVAILABLETHRUST / SHIP:MASS.
}

function getBurnTime {
	parameter targetVel.
	return (targetVel - ship:velocity:orbit:mag) / getMaxAccel().
}

function getTimeToBurn {
	parameter burnTime.
	return eta:apoapsis - (burnTime / 2).
}

function adjustThrottleTWR {
    if ship:availableThrust > 0 {
        return min(1, (1.5 * currentG() * ship:mass) / ship:availableThrust).
    }
    return 0.25.
}

function currentG {
	return ship:body:mu / ship:body:position:mag ^ 2.
}

function currentC {
	return ship:mass * ship:velocity:orbit:mag^2 / currentR().
}

function currentR {
	return altitude + orbit:body:radius.
}

function checkFlameout {
	if stage:number = 0 {
		list engines in elist.
		for e in elist {
			if e:flameout {
				return true.
			}
		}
		return false.
	}
	return false.
}

function checkStage {
	if stage:liquidfuel = 0 and stage:number > 0 and stage:ready {
		return true.
	}
	return false.
}

function setAlarm {
	parameter aTime.
	if not addons:kac:available{
		return.
	}
	if aTime < time:seconds{
		return.
	}
	local na is addAlarm("Raw",aTime,"Auto from kOS","Auto").
}

