extends Node2D

@onready var Border: Control = %Border
@onready var tilemap: TileMapLayer = $"../TileMapLayer"
@export var tile_id: int = 8
@export var active: bool = true

func place():
	var mouse_pos = get_global_mouse_position()
	var local_pos = tilemap.to_local(mouse_pos)
	var tile_pos = tilemap.local_to_map(local_pos)
	tilemap.set_cell(tile_pos,tile_id,Vector2i(0,0),tile_id)

func _input(event):
	if not active:
		return
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		place()
