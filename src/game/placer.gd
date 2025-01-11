extends Node2D

class_name Placer

@export var tile_id: int = 8
@export var active: bool = true

var MachineQueue : Array[Machine] = []

enum Direction {
	Up,
	Down,
	Left,
	Right
}

var initial: Vector2i = Vector2i(0, 0)
var place_index: Vector2i = Vector2i(32, 0)
var direction: Direction = Direction.Right

func _ready() -> void:
	InventorySingleton.reset()

var xy := 0.0
func _physics_process(delta: float) -> void:
	xy += delta
	if xy > 2.0:
		xy = 0.0
		_on_canvas_layer_button_press(randi() % 5)

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

func _on_canvas_layer_button_press(index: int) -> void:
	var machinescene = InventorySingleton.machines.pop_front()
	machinescene.dir = direction
	add_child(machinescene)
	machinescene.position = place_index
	
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
