// helper functions to import ks scripts

// basic import scripts by type and name
function import {
    parameter type.
    parameter name.
    if homeConnection:isconnected {
        if exists("0:/" + type + "/" + name + ".ks") {
            copyPath("0:/" + type + "/" + name + ".ks", "1:/" + type + "/" + name + ".ks").
            print "Importing " + type + " " + name + "...".
            return true.
        }
        else {
            print "0:/" + type + "/" + name + ".ks doesn't exist!".
            return false.
        }
    }
    else {
        print "We have no connection to home!".
        return false.
    }
}

// imports library scripts
function lib {
    parameter name.
    if import("library", name) {
        runOncePath("1:/library/" + name + ".ks").
        return true.
    }
    else {
        return false.
    }
}

// import maneuvers
function maneuvers {
    parameter name.
    if import("maneuvers", name) {
        runOncePath("1:/maneuvers/" + name + ".ks").
        return true.
    }
    else {
        return false.
    }
}

// imports missions
function missions {
    if homeConnection:isconnected {
        if exists("0:/missions/" + ship:Name + "/mission.ks") {
            copyPath("0:/missions/" + ship:name + "/mission.ks", "1:/").
            print "Importing mission file for " + ship:name.
            return true.
        }
        else {
            print "Mission file for " + ship:name + " do not exist!".
            return false.
        }
    }
    else {
        print "We have no connection to home!".
        return false.
    }
}