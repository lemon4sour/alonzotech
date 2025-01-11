extends Node2D
class_name Machine

var sprite: Sprite2D
var ops: Array[Operator] = []
var axis: Axis
var dir: Placer.Direction
var func_up: bool
var upgraded: bool = false

const self_scene = preload("res://src/machines/machine.tscn")

@onready var background: Sprite2D = $Background
@onready var label: Sprite2D = $Background/Label
@onready var hole: Sprite2D = $HoleParent/Hole
@onready var hole_parent: Node2D = $HoleParent


static func construct(id: int, dir: Placer.Direction) -> Machine:
	var obj = self_scene.instantiate()
	obj.dir = dir
	
	match(id):
		0:
			obj.ops.push_back(Operator.new("a + 2",
				func(a): 
				return a + 2
				))
			obj.axis = Axis.Line
			obj.func_up = false
		1:
			obj.ops.push_back(Operator.new("a x 2",
				func(a): 
				return a * 2
				))
			obj.axis = Axis.Right
			obj.func_up = false
		2:
			obj.ops.push_back(Operator.new(
			"if (a == 0) {100} else {a}",
			func(a): 
				if a == 0:
					return 100
				else:
					return a
				))
			obj.axis = Axis.Left
			obj.func_up = false
		_:
			printerr("Ne?", id)
	
	return obj

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	match (axis):
		Axis.Left:
			hole.rotation = deg_to_rad(-90)
		Axis.Right:
			hole.rotation = deg_to_rad(90)
	
	match(dir):
		Placer.Direction.Up:
			hole_parent.rotation = deg_to_rad(0)
		Placer.Direction.Down:
			hole_parent.rotation = deg_to_rad(180)
		Placer.Direction.Left:
			hole_parent.rotation = deg_to_rad(-90)
		Placer.Direction.Right:
			hole_parent.rotation = deg_to_rad(90)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	match(dir):
		Placer.Direction.Up:
			hole_parent.rotation = deg_to_rad(0)
		Placer.Direction.Down:
			hole_parent.rotation = deg_to_rad(180)
		Placer.Direction.Left:
			hole_parent.rotation = deg_to_rad(-90)
		Placer.Direction.Right:
			hole_parent.rotation = deg_to_rad(90)

func execute(a: int) -> int:
	for op in ops:
		a = op.op.call(a)
	
	return a

func upgrade(m: Machine):
	m.ops.append_array(ops)
	m.upgraded = true
	

static func rng_tier1() -> Machine:
	return Machine.construct(randi() % 3, Placer.Direction.Up)
	


enum Axis {
	Line,
	Left,
	Right
}
