extends HBoxContainer

@onready var item: Button = $"../../../Item"
signal machine_selected
signal send_machine

func update_buttons() -> void:
	clear_buttons()
	list_buttons()
	
		
func list_buttons() -> void:
	var i = 0
	for machine in InventorySingleton.machines:
		var button : Button = item.duplicate()
		button.visible = true
		add_child(button)
		button.text = machine.labelstr
		button.left_click.connect(_on_button_pressed.bind(i))
		button.right_click.connect(_on_stash.bind(i))
		button.tooltip_text = machine.tooltip_gen()
		
		if machine.func_up:
			button.modulate = Color.WEB_PURPLE
		
		if machine.upgraded:
			button.modulate = Color.CRIMSON
		
		i += 1
		
func clear_buttons() -> void:
	for child in get_children():
		remove_child(child)
		child.queue_free()
		
func _on_stash(index: int) -> void:
	emit_signal("send_machine", index)
	
func _on_button_pressed(index: int) -> void:
	emit_signal("machine_selected", index)
