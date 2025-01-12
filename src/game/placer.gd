extends Node2D

class_name Placer
@onready var canvas_layer: CanvasLayer = $"../CanvasLayer"

@export var tile_id: int = 8
@export var active: bool = true

var MachineQueue : Array[Machine] = []
var map: Dictionary = {}
var startable: bool = true

@export var input_machine: Node2D

enum Direction {
	Up,
	Down,
	Left,
	Right
}

var initial: Vector2i = Vector2i(0, 0)
@export var place_index: Vector2i = Vector2i(32, 0)
var direction: Direction = Direction.Right

func reset() -> void:
	map = {}
	InventorySingleton.startable = true
	while MachineQueue.size() > 0:
		var machine = MachineQueue.pop_back()
		InventorySingleton.machines.push_back(machine)
		remove_child(machine)
		move_back()
		map.erase(place_index)
	canvas_layer.update_buttons()
	
	place_index = Vector2i(32, 0)
	initial = Vector2i(0, 0)
	direction = Direction.Right
	map.get_or_add(place_index)
	move()
	

func _ready() -> void:
	InventorySingleton.reset()
	
	input_machine = preload("res://src/machines/input_machine.tscn").instantiate()
	add_child(input_machine)
	input_machine.position = place_index
	map.get_or_add(place_index)
	move()

func move():
	match (direction):
		Direction.Up:
			place_index.y -= 32
		Direction.Down:
			place_index.y += 32
		Direction.Left:
			place_index.x -= 32
		Direction.Right:
			place_index.x += 32
		_:
			printerr("huh?")

func move_back():
	match (direction):
		Direction.Up:
			place_index.y += 32
		Direction.Down:
			place_index.y -= 32
		Direction.Left:
			place_index.x += 32
		Direction.Right:
			place_index.x -= 32
		_:
			printerr("huh?")

func on_machine_selected(index: int) -> void:
	if !InventorySingleton.startable:
		return
	
	var machinescene = InventorySingleton.machines.pop_at(index)
	machinescene.dir = direction
	add_child(machinescene)
	machinescene.position = place_index
	map.get_or_add(place_index)
	
	match (machinescene.axis):
		Machine.Axis.Left:
			match (direction):
				Direction.Up:
					direction = Direction.Left
				Direction.Left:
					direction = Direction.Down
				Direction.Down:
					direction = Direction.Right
				Direction.Right:
					direction = Direction.Up
		Machine.Axis.Right:
			match (direction):
				Direction.Up:
					direction = Direction.Right
				Direction.Left:
					direction = Direction.Up
				Direction.Down:
					direction = Direction.Left
				Direction.Right:
					direction = Direction.Down
	
	MachineQueue.push_back(machinescene)
	move()
	InventorySingleton.startable = !map.has(place_index)
	InventorySingleton.revertable = true
	canvas_layer.update_buttons()
	

func on_revert_selected() -> void:
	var machine = MachineQueue.pop_back()
	InventorySingleton.machines.push_back(machine)
	remove_child(machine)
	move_back()
	map.erase(place_index)
	
	match (machine.axis):
		Machine.Axis.Left:
			match (direction):
				Direction.Up:
					direction = Direction.Right
				Direction.Left:
					direction = Direction.Up
				Direction.Down:
					direction = Direction.Left
				Direction.Right:
					direction = Direction.Down
		Machine.Axis.Right:
			match (direction):
				Direction.Up:
					direction = Direction.Left
				Direction.Left:
					direction = Direction.Down
				Direction.Down:
					direction = Direction.Right
				Direction.Right:
					direction = Direction.Up
	
	InventorySingleton.startable = true
	InventorySingleton.revertable = !MachineQueue.is_empty()
	canvas_layer.update_buttons()
