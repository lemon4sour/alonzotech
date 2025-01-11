extends CanvasLayer
@onready var h_box_container: HBoxContainer = $Inventory/Scroll/HBoxContainer
@onready var runbutton: Button = $Run/Button
@onready var revertbutton: Button = $Revert/Button
signal machine_selected
signal revert
signal run


func update_buttons():
	h_box_container.clear_buttons()
	h_box_container.list_buttons()
	runbutton.disabled = !InventorySingleton.startable
	revertbutton.disabled = !InventorySingleton.revertable

func on_machine_selected(index: int) -> void:
	emit_signal("machine_selected",index)


func _on_revert_pressed() -> void:
	emit_signal("revert")
	
func _on_run_pressed() -> void:
	emit_signal("run")
