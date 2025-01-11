extends Node

var machines: Array[Machine]

func reset():
	machines.clear()
	for i in 50:
		machines.push_back(Machine.rng_tier1())
