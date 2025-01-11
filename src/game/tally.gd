extends Node2D

var result: int = 0
var round: int = 1
var currentround = round_nums[round - 1]
var machinebuffer: Array[Machine] = []

var sell_machine: Node2D

@onready var canvas_layer: CanvasLayer = $"../CanvasLayer"
@onready var placer: Placer = $"../Placer"

func _ready() -> void:
	await(canvas_layer.ready)
	canvas_layer.update_list(currentround,machinebuffer)

func on_machine_insert(index: int):
	var machine = InventorySingleton.machines[index]
	if machinebuffer.size() < 3:
		machinebuffer.push_front(machine)
		InventorySingleton.machines.remove_at(index)
		canvas_layer.update_list(currentround,machinebuffer)
		canvas_layer.update_buttons()
	
func on_machine_extract(index: int):
	var machine = machinebuffer.pop_at(index)
	InventorySingleton.machines.push_back(machine)
	canvas_layer.clear_list()
	canvas_layer.update_list(currentround,machinebuffer)
	canvas_layer.update_buttons()

func on_start_selected():
	canvas_layer.input_enabled = false
	result = 0
	
	var slot_index = 0;
	
	sell_machine = preload("res://src/machines/sell_machine.tscn").instantiate()
	add_child(sell_machine)
	sell_machine.position = placer.place_index
	
	var machines = placer.MachineQueue
	
	for machine : Machine in machinebuffer:
		canvas_layer.clear_slot(slot_index)
		slot_index += 1
		
		for m: Machine in machines:
			m.bounce()
			await(m.animation_finished)
			if (m.func_up):
				m.upgrade(machine)
		InventorySingleton.machines.push_back(machine)
		
		sell_machine.bounce()
		await(sell_machine.animation_finished)
		canvas_layer.update_buttons()
			
	var total = 0
	for i in range(machinebuffer.size(),3):
		canvas_layer.clear_slot(slot_index)
		slot_index += 1
		
		total = currentround[i]
		for m: Machine in machines:
			m.bounce()
			await(m.animation_finished)
			total = m.execute(total)
		result += total
		
		sell_machine.bounce()
		await(sell_machine.animation_finished)
		
	canvas_layer.input_enabled = true

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
