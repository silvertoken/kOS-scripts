
function runScience {
	parameter data is true.
	parameter sample is false.
	if data {
		getData().
	}

	if sample {
		getSamples().   
	}
}

function getData {
	message("Getting Science Data...").
	set xmit to false.
	set scienceModules to getScienceModules().
	
    for theModule in scienceModules {
		if theModule:rerunnable {
			if not theModule:hasdata {
				runExperiment(theModule).
			}
		}
	}
    // this check is dangerous and can lead to stacked triggers
    set tDelay to time:seconds + 5.
	when tDelay < time:seconds then {
        message("Checking Science Data...").
        for theModule in scienceModules {
            checkData(theModule).
        }
    }
}

function getSamples {
	message("Getting Science Sample...").
	local scienceModules is getScienceModules().
	for theModule in scienceModules {
		if not theModule:rerunnable and
		   not theModule:inoperable and
			 not theModule:hasdata {
				runExperiment(theModule).
				//break.?
		}
	}
}
function runExperiment{
	parameter theModule.
	if not theModule:inoperable {
		theModule:deploy().
	}
}

function checkData {
	parameter theModule.
	if theModule:rerunnable and not theModule:inoperable and theModule:hasdata {
		local dataT is theModule:data[0]:transmitvalue.
		if dataT = 0 {
			message("Dumping redundant data...").
			theModule:dump().
			if not theModule:inoperable {
				theModule:reset().
			}
			return.
		}

		if checkTransmit(theModule:data[0]) {
			message("Transmitting module data...").
			theModule:transmit().
		}
	}
}

function getResource {
	parameter searchTerm.
	local allResources to ship:resources.
	local theResult to "".
	for theResource in allResources {
		if theResource:name = searchTerm {
			set theResult to theResource.
			break.
		}
	}
	return theResult.
}

function checkTransmit {
	parameter scienceData.
	local electricalPerData to 6.
	local electricalResource to getResource("ElectricCharge").
	local chargeMargin to 1.05. // Want to have not just enough,but a 5% margin
	local canTransmit to true.
	local neededCharge to scienceData:dataamount * electricalPerData * chargeMargin.
	if (electricalResource:capacity < neededCharge) or (electricalResource:amount < neededCharge) {
		message("Insufficient electrical capacity to attempt transmission").
		set canTransmit to false.
	}

	if not homeconnection:isconnected {
		set canTransmit to false.
	}
	return canTransmit.
}

function getScienceModules {
	local scienceModules to list().
	local partList to ship:parts.
	
    for thePart in partList {
		local moduleList to thePart:modules.
		from {
            local i is 0.
        } 
        until i = moduleList:length step {
            set i to i+1.
        } do {
			local theModule is moduleList[i].
			if (theModule = "ModuleScienceExperiment") or (theModule = "DMModuleScienceAnimate") {
				scienceModules:add(thePart:getModuleByIndex(i)).
			}                      
		}
	}

	return scienceModules.
}

//run once every 20
when mod(floor(time:seconds), 20) = 0 then {
    if altitude > 100 {
        runScience().
    }
    return true.
}
