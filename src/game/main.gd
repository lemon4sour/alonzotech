extends CanvasLayer

@onready var placer: Placer = $"../Placer"

func _on_play_pressed() -> void:
	placer.start()
	visible = false
