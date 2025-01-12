extends CanvasLayer
@onready var h_box_container: HBoxContainer = $Inventory/Scroll/HBoxContainer
@onready var runbutton: Button = $Run/Button
@onready var revertbutton: Button = $Revert/Button
@onready var item: EventButton = $Item

@onready var slot_1: Button = $Deploy/Slot1
@onready var slot_3: Button = $Deploy/Slot3
@onready var slot_2: Button = $Deploy/Slot2

@export var input_enabled: bool = true

@onready var moves: Label = $Score/Moves
@onready var gained: Label = $Score/Gained
@onready var score: Label = $Score/Score
@onready var objective: Label = $Score/Objective

@onready var coins: Label = $Stats/Panel/Coins
@onready var level: Label = $Stats/Panel2/Level

var score_value : float = 0

var slotlist : Array[Button] = []

signal machine_selected
signal revert
signal run
signal send_machine
signal remove_machine
signal insert_finished

func _ready() -> void:
	slotlist = [slot_1, slot_2, slot_3]

func update_buttons():
	h_box_container.clear_buttons()
	h_box_container.list_buttons()
	runbutton.disabled = !InventorySingleton.startable
	revertbutton.disabled = !InventorySingleton.revertable
	
func update_list(current_round, machine_buffer: Array[Machine]):
	var i = 0
	for machine in machine_buffer:
		slotlist[i].text = machine.labelstr
		slotlist[i].pressed.connect(on_click.bind(i))
		i += 1
	
	for size in range(machine_buffer.size(), 3):
		slotlist[size].text = str(current_round[size])
		
func on_click(index: int) -> void:
	if (not input_enabled):
		return
	emit_signal("remove_machine",index)
		
func clear_list() -> void:
	for button : Button in slotlist:
		if button.pressed.is_connected(on_click):
			button.pressed.disconnect(on_click)
		

func on_machine_selected(index: int) -> void:
	if (not input_enabled):
		return
	emit_signal("machine_selected",index)
	
func on_send_machine(index: int) -> void:
	if (not input_enabled):
		return
	emit_signal("send_machine", index)

func _on_revert_pressed() -> void:
	if (not input_enabled):
		return
	emit_signal("revert")
	
func _on_run_pressed() -> void:
	if (not input_enabled):
		return
	emit_signal("run")
	
func clear_slot(index: int):
	var button : Button = slotlist[index]
	if (button.pressed.is_connected(on_click)):
		button.pressed.disconnect(on_click)
	button.text = ""
	
func set_moves(count: int):
	moves.text = str(count)
	
func reset_counter():
	gained.text = ""
	
func set_counter(number: int):
	gained.text = "+%s" % str(number)
	
func set_score(number: float):
	reset_counter()
	score_value = number
	score.text = str(number)
	
func score_insert(number: float):
	if number == 0.0:
		await get_tree().create_timer(.1).timeout
		emit_signal("insert_finished")
		return
	var step_size: int = number / 50
	if step_size < 1:
		step_size = 1
	for i in range(number,0,-step_size):
		set_counter(i)
		score_value += 1
		score.text = str(score_value)
		await get_tree().create_timer(.01).timeout
	emit_signal("insert_finished")
		
	
func set_objective(number: float):
	objective.text = "Earn up to %s points to win" % str(number)
	
func set_level(number: int):
	level.text = "Level: %s" % str(number)
	
func set_coins(number: int):
	coins.text = str(number)
