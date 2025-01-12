extends Node2D
class_name Machine

var labelstr: String
var ops: Array[Operator] = []
var axis: Axis
var dir: Placer.Direction
var func_up: bool
var upgraded: bool = false
var cost: int = 0

const self_scene = preload("res://src/machines/machine.tscn")

@onready var background: TextureRect = $Background
@onready var label: Label = $Background/Label
@onready var hole: TextureRect = $HoleParent/Hole
@onready var hole_parent: Node2D = $HoleParent
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

signal animation_finished
signal set_counter

static func construct(id: int, dir: Placer.Direction) -> Machine:
	var obj = self_scene.instantiate()
	obj.dir = dir
	
	match(id):
		0:
			obj.labelstr = "+2"
			obj.ops.push_back(Operator.new("a + 2",
				func(a): 
				return a + 2
				))
			obj.axis = Axis.Line
			obj.func_up = false
			obj.cost = 2
		1:
			obj.labelstr = "x2"
			obj.ops.push_back(Operator.new("a x 2",
				func(a): 
				return a * 2
				))
			obj.axis = Axis.Right
			obj.func_up = false
			obj.cost = 4
		2:
			obj.labelstr = "0->32"
			obj.ops.push_back(Operator.new(
			"a == 0 ? 32 : a",
			func(a): 
				if a == 0:
					return 32
				else:
					return a
				))
			obj.axis = Axis.Left
			obj.func_up = false
			obj.cost = 2
		3:
			obj.labelstr = "λ + 2"
			obj.ops.push_back(Operator.new(
			"λ + 2",
			func(a): 
				return a + 2
			))
			obj.axis = Axis.Left
			obj.func_up = true
			obj.cost = 5
		4:
			obj.labelstr = "λ x 2"
			obj.ops.push_back(Operator.new(
			"λ x 2",
			func(a): 
				return a * 2
			))
			obj.axis = Axis.Left
			obj.func_up = true
			obj.cost = 7
		5:
			obj.labelstr = "-1 (+$)"
			obj.ops.push_back(Operator.new(
			"a - 1 (+ 1 coin)",
			func(a): 
				return a - 1
				InventorySingleton.coins += 1
			))
			obj.axis = Axis.Line
			obj.func_up = false
			obj.cost = 5
		6:
			obj.labelstr = "λ x -4"
			obj.ops.push_back(Operator.new(
			"λ x -4",
			func(a): 
				return a * -4
			))
			obj.axis = Axis.Line
			obj.func_up = true
			obj.cost = 4
		7:
			obj.labelstr = "a x #"
			obj.ops.push_back(Operator.new(
			"x * #unused_machines",
			func(a): 
				return a * InventorySingleton.machines.size()
			))
			obj.axis = Axis.Line
			obj.func_up = false
			obj.cost = 4
		8:
			obj.labelstr = "λ * $"
			obj.ops.push_back(Operator.new(
			"λ * #coins",
			func(a): 
				return a * InventorySingleton.coins
			))
			obj.axis = Axis.Line
			obj.func_up = true
			obj.cost = 7
		9:
			obj.labelstr = "repeat"
			obj.ops.push_back(Operator.new(
			"repeat previous",
			func(a): 
				return "repeat"
			))
			obj.axis = Axis.Line
			obj.func_up = true
			obj.cost = 9
		_:
			printerr("Ne?", id)
	
	return obj

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_tooltip()
	
	match (axis):
		Axis.Left:
			hole.rotation = deg_to_rad(-90)
		Axis.Right:
			hole.rotation = deg_to_rad(90)
	
	label.text = labelstr
	
	if func_up:
		background.texture = preload("res://assets/machines/lambdal.png")

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

func execute_operations(a: int) -> int:
	for i in range(ops.size()):
		var op = ops[i]
		var next = op.op.call(a)
		
		var repeat_index = i
		while (next is String and next == "repeat"):
			next = ops[repeat_index-1].op.call(a)
			repeat_index -= 1
		a = next
		bounce()
		emit_signal("set_counter",a)
		audio_stream_player.play()
		await(animation_finished)
	return a

func upgrade(machine_to_upgrade: Machine):
	machine_to_upgrade.ops.append_array(ops)
	machine_to_upgrade.upgraded = true
	update_tooltip()
	
func update_tooltip():
	background.tooltip_text = tooltip_gen()

func tooltip_gen():
	var res = "Operations:\n"
	
	for o in ops:
		res += "- "
		res += o.desc + "\n"
	
	res = res.left(res.length() - 1)
	return res

static func rng_tier1() -> Machine:
	return Machine.construct(randi() % 4, Placer.Direction.Up)
	

func bounce():
	animation_player.play("wobble_bounce")
	await(animation_player.animation_finished)
	emit_signal("animation_finished")

enum Axis {
	Line,
	Left,
	Right
}
