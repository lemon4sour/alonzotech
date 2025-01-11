extends Node

var machines: Array[Machine]
var startable: bool = true
var revertable: bool = false

func reset():
	machines.clear()
	for i in 100:
		machines.push_back(Machine.rng_tier1())
	
	startable = true
	revertable = false
