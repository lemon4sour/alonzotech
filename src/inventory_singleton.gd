extends Node

var machines: Array[Machine]
var coins: int = 5
var startable: bool = true
var revertable: bool = false

func reset():
	machines.clear()
	for i in range(4):
		machines.push_back(Machine.construct(0, Placer.Direction.Left))
	for i in range(4):
		machines.push_back(Machine.construct(1, Placer.Direction.Left))
	machines.push_back(Machine.construct(3, Placer.Direction.Left))
	machines.push_back(Machine.construct(7, Placer.Direction.Left))
	machines.push_back(Machine.construct(9, Placer.Direction.Left))
	
	startable = true
	revertable = false
