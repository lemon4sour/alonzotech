extends HBoxContainer

@onready var item: Button = $"../../../Item"

func _ready() -> void:
	clear_buttons()
	
	var i = 0
	for machine in InventorySingleton.machines:
		var button : Button = item.duplicate()
		button.visible = true
		add_child(button)
		button.pressed.connect(_on_button_pressed.bind(i))
		i += 1
		
func clear_buttons() -> void:
	for child in get_children():
		remove_child(child)
		child.queue_free()
		
	
func _on_button_pressed(index: int) -> void:
	emit_signal("machine_selected", 1)
