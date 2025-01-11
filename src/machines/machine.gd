extends Node2D
class_name Machine

var sprite: Sprite2D
var ops: Array = []
var axis: Axis
var func_up: bool
var upgraded: bool = false
var rotat: float = 0

@onready var background: Sprite2D = $Background
@onready var label: Sprite2D = $Background/Label
@onready var hole: Sprite2D = $Node2D/Hole
@onready var hole_parent: Node2D = $HoleParent


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	axis = Axis.Line
	match (axis):
		Axis.Left:
			hole.rotation = deg_to_rad(-90)
		Axis.Right:
			hole.rotation = deg_to_rad(90)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	hole_parent.rotation = deg_to_rad(rotat)

func execute(a: int) -> int:
	for op in ops:
		a = op.op.call(a)
	
	return a

static func rng_tier1() -> Machine:
	return Machine.new(randi() % 3)
	

func _init(id: int):
	match(id):
		0:
			ops.push_back(Operator.new("a + 2",
				func(a): 
				return a + 2
				))
			axis = Axis.Line
			func_up = false
		1:
			ops.push_back(Operator.new("a x 2",
				func(a): 
				return a * 2
				))
			axis = Axis.Right
			func_up = false
		2:
			ops.push_back(Operator.new(
			"if (a == 0) {100} else {a}",
			func(a): 
				if a == 0:
					100
				else:
					a
				))
			axis = Axis.Left
			func_up = false
		_:
			printerr("Ne?", id)


enum Axis {
	Line,
	Left,
	Right
}
