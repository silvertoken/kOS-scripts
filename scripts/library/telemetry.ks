// functions to log telemetry data
local startTime is TIME:SECONDS.
local loggers is lexicon().

function logTelem {
    local logFile is "0:/telem/telem.csv".
    //init the loggers
    if loggers:length = 0 {
        initLoggers().
    }

    // update the log data
    local data is list().
    for key in loggers:KEYS {
        data:ADD(loggers[key]:CALL()).
    }

    log data:JOIN(",") to logFile.

}

function initLoggers {
    local logFile is "0:/telem/telem.csv".
    message("Initializing telemetry loggers...").
    if exists(logFile) {
        deletePath(logFile).
    }
    loggers:ADD("MET", { return ROUND(TIME:SECONDS - starttime, 5). }).
    loggers:ADD("THRUST", { return SHIP:AVAILABLETHRUST. }).
    loggers:ADD("MAXTHRUST", { return SHIP:MAXTHRUST. }).
    loggers:ADD("THROTTLE_TWR", { if ship:availableThrust > 0 { 
            return min(1, (1.5 * (ship:body:mu / ship:body:position:mag ^ 2) * ship:mass) / ship:availableThrust). 
        } 
            return 0.
    }).
    loggers:ADD("ALTITUDE", { return ALTITUDE. }).
    loggers:ADD("SPEED", { return SHIP:VELOCITY:SURFACE:MAG. }).
    loggers:ADD("GRAVITY", {return ship:body:mu / ship:body:position:mag ^ 2.}).
    loggers:ADD("CENTRIPETAL", { return ship:mass * ship:velocity:orbit:mag^2 / (altitude + orbit:body:radius).}).
    loggers:ADD("GROUNDSPEED", { return GROUNDSPEED. }).
    loggers:ADD("ACCELERATION", { return SHIP:AVAILABLETHRUST / SHIP:MASS. }).
    loggers:ADD("PITCH", { return 90 - VANG(SHIP:UP:VECTOR, SHIP:FACING:FOREVECTOR). }).
    loggers:ADD("AoA", { return VANG(SHIP:FACING:FOREVECTOR, SHIP:VELOCITY:SURFACE). }).
    loggers:ADD("Q", { return SHIP:Q. }).
    loggers:ADD("ETA_APOAPSIS", { return ETA:APOAPSIS. }).
    loggers:ADD("APOAPSIS", { return APOAPSIS. }).
    loggers:ADD("_PERIAPSIS", { return PERIAPSIS. }).
    loggers:ADD("ECCENTRICITY", { return orbit:eccentricity.}).
    log loggers:KEYS:JOIN(",") to logFile.
   
}

on floor(time:seconds * 20) {
    if homeConnection:isconnected {
        logTelem().
    }
    return true.
}