extends CanvasLayer

signal done

@onready var continue_button: Button = $Score/Continue
@onready var button: Button = $Score/Button
@onready var button_2: Button = $Score/Button2
@onready var button_3: Button = $Score/Button3
var buttonlist: Array[Button] = []

func _ready() -> void:
	buttonlist = [button, button_2, button_3]

func display() -> void:
	
	visible = true
	
func _on_continue_pressed() -> void:
	visible = false
	emit_signal("done")
