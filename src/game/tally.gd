extends Node2D

var result: int = 0
var round: int = 0
var currentround = round_nums[round - 1]
var machinebuffer: Array[Machine] = []

var moves: int = 5

var sell_machine: Node2D

@onready var canvas_layer: CanvasLayer = $"../CanvasLayer"
@onready var placer: Placer = $"../Placer"
@onready var run_audio: AudioStreamPlayer = $RunAudio

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
	moves -= 1
	canvas_layer.set_moves(moves)
	
	InventorySingleton.startable = false
	InventorySingleton.revertable = false
	canvas_layer.update_buttons()
	
	var slot_index = 0;
	
	sell_machine = preload("res://src/machines/sell_machine.tscn").instantiate()
	run_audio.play()
	add_child(sell_machine)
	sell_machine.position = placer.place_index
	await run_audio.finished
	
	var machines = placer.MachineQueue
	
	for machine : Machine in machinebuffer:
		canvas_layer.clear_slot(slot_index)
		slot_index += 1
		
		for m: Machine in machines:
			m.bounce()
			await(m.animation_finished)
			if (m.func_up):
				m.upgrade(machine)
		InventorySingleton.machines.push_front(machine)
		
		sell_machine.bounce()
		await(sell_machine.animation_finished)
		canvas_layer.update_buttons()
			
	var total = 0
	for i in range(machinebuffer.size(),3):
		canvas_layer.reset_counter()
		canvas_layer.clear_slot(slot_index)
		slot_index += 1
		
		total = currentround[i]
		for m: Machine in machines:
			if m.func_up:
				continue
			
			m.set_counter.connect(on_counter_update)
			total = await m.execute_operations(total)
			m.set_counter.disconnect(on_counter_update)
			
			
		
		
		sell_machine.bounce()
		await(sell_machine.animation_finished)
		
		await get_tree().create_timer(1).timeout
		
		canvas_layer.score_insert(total)
		result += total
		await(canvas_layer.insert_finished)
		canvas_layer.set_score(result)
		print("x")
		await get_tree().create_timer(.5).timeout
	
	if result >= round_goals[round - 1]:
		InventorySingleton.coins += 2
		InventorySingleton.coins += moves
		canvas_layer.set_coins(InventorySingleton.coins)
		placer.win()
	else:
		if moves <= 0:
			round = 0
			placer.lose()
		else:
			placer.reset()
			canvas_layer.input_enabled = true
		
	remove_child(sell_machine)
	sell_machine.queue_free()
	machinebuffer = []
	canvas_layer.update_list(currentround,machinebuffer)
	
func next_level():
	round += 1
	result = 0
	moves = 5
	currentround = round_nums[round - 1]
	canvas_layer.set_moves(moves)
	canvas_layer.update_buttons()
	canvas_layer.set_score(result)
	canvas_layer.set_level(round)
	canvas_layer.set_objective(round_goals[round - 1])
	canvas_layer.update_list(currentround,machinebuffer)

func on_counter_update(value: float):
	canvas_layer.set_counter(value)

const round_nums = [
[1, 1, 1],
[1, 1, 1],
[1, 1, 1],
[2, 2, 2],
[2, 2, 2],
[2, 2, 2],
[3, 3, 3],
[3, 3, 3]
]

const round_goals = [
	100,
	200,
	400,
	600,
	1000,
	1500,
	2500,
	5000
]
