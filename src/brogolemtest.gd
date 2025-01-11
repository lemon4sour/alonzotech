extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var m1 = Machine.construct(0)
	var m2 = Machine.construct(1)
	m2.upgrade(m1)
	assert(m1.execute(0) == 4)
	print(m1.execute(1))



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
