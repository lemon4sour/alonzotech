extends CanvasLayer

signal button_press

func _on_item_pressed() -> void:
	emit_signal("button_press")
