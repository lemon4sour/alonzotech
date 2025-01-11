extends Node2D

@export var tile_id: int = 8
@export var active: bool = true

enum Direction {
	Up,
	Down,
	Left,
	Right
}

var initial: Vector2i = Vector2i(0, 0)
var place_index: Vector2i = Vector2i(0,0)
var direction: Direction = Direction.Right

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
			print("huh?")

func _on_canvas_layer_button_press() -> void:
	var machinescene = preload("res://src/machines/machine.tscn").instantiate()
	add_child(machinescene)
	machinescene.position = place_index
	var new_machine : Machine = Machine.new(0)
	move()
