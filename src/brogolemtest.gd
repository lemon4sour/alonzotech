extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var m = Machine.new(0)
	assert(m.execute(0) == 2)
	assert(m.execute(1) == 3)
	assert(m.execute(27) == 29)
	m = Machine.new(1)
	assert(m.execute(0) == 0)
	assert(m.execute(1) == 2)
	assert(m.execute(27) == 54)
	m = Machine.new(2)
	assert(m.execute(0) == 100)
	assert(m.execute(1) == 1)
	assert(m.execute(27) == 27)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
