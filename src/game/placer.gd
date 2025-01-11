extends Node2D

@onready var Border: Control = %Border
@onready var tilemap: TileMapLayer = $"../TileMapLayer"
@export var tile_id: int = 8
@export var active: bool = true

var initial: Vector2i = Vector2i(0, 0)

func place():
	var mouse_pos = get_global_mouse_position()
	var local_pos = tilemap.to_local(mouse_pos)
	var tile_pos = tilemap.local_to_map(local_pos)
	print(tile_pos)

func _input(event):
	if not active:
		return
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		place()

func _on_canvas_layer_button_press() -> void:
	tilemap.set_cell(initial,8,Vector2i(0,0),8)
	initial.x += 1
