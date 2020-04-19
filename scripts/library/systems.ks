function deployAntenna{
	for theModule in ship:modulesnamed("ModuleRTAntenna"){
		if theModule:hasfield("omni range") and theModule:hasevent("Activate"){
			theModule:doevent("Activate").
			message("Deploying Antenna...").
		}
	}
}
function retractAntenna{
	for theModule in ship:modulesnamed("ModuleRTAntenna"){
		if theModule:hasfield("omni range") and theModule:hasevent("Deactivate"){
			theModule:doevent("Deactivate").
			message("Retracting Antenna...").
		}
	}
}

function deployPanels{
	panels on.
	message("Deploying Solar Panels...").
}
function retractPanels{
	panels off.
	message("Retracting Solar Panels...").
}