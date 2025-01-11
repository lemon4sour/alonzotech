extends Node

var machines: Array[Machine]
var startable: bool = true
var revertable: bool = false

func reset():
	machines.clear()
	machines.push_back(Machine.construct(0, Placer.Direction.Left))
	for i in 3:
		machines.push_back(Machine.rng_tier1())
	
	
	startable = true
	revertable = false
