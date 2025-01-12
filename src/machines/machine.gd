extends Node2D
class_name Machine

var labelstr: String
var ops: Array[Operator] = []
var axis: Axis
var dir: Placer.Direction
var func_up: bool
var upgraded: bool = false

const self_scene = preload("res://src/machines/machine.tscn")

@onready var background: Sprite2D = $Background
@onready var label: Label = $Background/Label
@onready var hole: Sprite2D = $HoleParent/Hole
@onready var hole_parent: Node2D = $HoleParent
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var tooltip_panel: Panel = $TooltipPanel
@onready var tally: Node2D = $Tally

signal animation_finished


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
		1:
			obj.labelstr = "x2"
			obj.ops.push_back(Operator.new("a x 2",
				func(a): 
				return a * 2
				))
			obj.axis = Axis.Right
			obj.func_up = false
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
		3:
			obj.labelstr = "λ+2"
			obj.ops.push_back(Operator.new(
			"f(x) + 2",
			func(a): 
				return a + 2
			))
			obj.axis = Axis.Left
			obj.func_up = true
		4:
			obj.labelstr = "λ*2"
			obj.ops.push_back(Operator.new(
			"f(x) * 2",
			func(a): 
				return a * 2
			))
			obj.axis = Axis.Left
			obj.func_up = true
		5:
			obj.labelstr = "-1"
			obj.ops.push_back(Operator.new(
			"x - 1",
			func(a): 
				return a - 1
			))
			obj.axis = Axis.Line
			obj.func_up = false
		6:
			obj.labelstr = "λ*-4"
			obj.ops.push_back(Operator.new(
			"f(x) * -4",
			func(a): 
				return a * -4
			))
			obj.axis = Axis.Line
			obj.func_up = false
		7:
			obj.labelstr = "a * #"
			obj.ops.push_back(Operator.new(
			"a * #unused_machines",
			func(a): 
				return a * InventorySingleton.machines.size()
			))
			obj.axis = Axis.Line
			obj.func_up = false
		8:
			obj.labelstr = "f(x) * $"
			obj.ops.push_back(Operator.new(
			"f(x) * #coins",
			func(a): 
				return a * InventorySingleton.coins
			))
			obj.axis = Axis.Line
			obj.func_up = true
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

func execute(a: int) -> int:
	for op in ops:
		a = op.op.call(a)
	
	return a

func upgrade(m: Machine):
	m.ops.append_array(ops)
	m.upgraded = true
	update_tooltip()
	
func update_tooltip():
	tooltip_panel.tooltip_text = tooltip_gen()

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
