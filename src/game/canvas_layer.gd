extends CanvasLayer

signal button_press

for machine in singleton:
	clone button
	parent under inventory
	listen to button
	emit singal with machine id

func _on_item_pressed() -> void:
	emit_signal("button_press")
