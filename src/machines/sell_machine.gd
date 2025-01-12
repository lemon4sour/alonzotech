extends Node2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

signal animation_finished

func bounce():
	animation_player.play("wobble_bounce")
	audio_stream_player.play()
	await(animation_player.animation_finished)
	emit_signal("animation_finished")
