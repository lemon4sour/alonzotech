extends CanvasLayer
@onready var h_box_container: HBoxContainer = $Inventory/Scroll/HBoxContainer
@onready var button: Button = $Run/Button
signal machine_selected

func update_buttons():
	h_box_container.clear_buttons()
	h_box_container.list_buttons()

func on_machine_selected(index: int) -> void:
	emit_signal("machine_selected",index)

func _process(delta: float) -> void:
	button.disabled = !InventorySingleton.startable
