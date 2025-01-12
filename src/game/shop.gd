extends CanvasLayer

signal done
@onready var canvas_layer: CanvasLayer = $"../CanvasLayer"

@onready var continue_button: Button = $Score/Continue
@onready var button: Button = $Score/Button
@onready var button_2: Button = $Score/Button2
@onready var button_3: Button = $Score/Button3
var buttonlist: Array[Button] = []

func _ready() -> void:
	buttonlist = [button, button_2, button_3]

func display() -> void:
	for button: Button in buttonlist:
		var machine = Machine.construct(randi() % 10, Placer.Direction.Up)
		button.text = machine.labelstr
		button.pressed.connect(on_buy.bind(machine, button))
		button.tooltip_text = machine.tooltip_gen()
		
		if machine.func_up:
			button.modulate = Color.WEB_PURPLE
		else:
			button.modulate = Color.WHITE
		
		button.disabled = false
		
	visible = true
	
func on_buy(machine: Machine, button: Button) -> void:
	button.disabled = true
	InventorySingleton.coins -= machine.cost
	canvas_layer.set_coins(InventorySingleton.coins)
	InventorySingleton.machines.push_front(machine)
	canvas_layer.update_buttons()
	
func _on_continue_pressed() -> void:
	visible = false
	emit_signal("done")
