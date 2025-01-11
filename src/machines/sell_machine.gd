extends Node2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
signal animation_finished

func bounce():
	animation_player.play("wobble_bounce")
	await(animation_player.animation_finished)
	emit_signal("animation_finished")
