extends Node2D

var result: int = 0
var round: int = 1

@onready var placer: Placer = $"../Placer"

func on_start_selected():
	result = 0
	
	var machines = placer.MachineQueue
	var tmp = 1
	
	for i in round_nums[round - 1]:
		for m: Machine in machines:
			tmp = m.execute(tmp)
	
	result += tmp

const round_nums = [[
	1, 1, 1
],
[
	3, 5, 7
],
[
	1, 33, 7
]]

const round_goals = [
	10,
	25,
	150
]
