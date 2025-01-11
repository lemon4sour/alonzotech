extends Node2D

var result: int = 0
var round: int = 1
var currentround = round_nums[round - 1]

@onready var placer: Placer = $"../Placer"

func on_machine_insert(machine: Machine):
	pass
	
func on_machine_extract(machine: Machine):
	pass

func on_start_selected():
	result = 0
	
	var machines = placer.MachineQueue
	var total = 0
	for start_number in currentround:
		total = start_number
		for m: Machine in machines:
			total = m.execute(total)
		result += total
	
	print(result)

const round_nums = [[
	1, 1, 1
],
[
	2, 2, 2
],
[
	3, 3, 3
]]

const round_goals = [
	15,
	30,
	45
]
