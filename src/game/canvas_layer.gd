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


var slotlist : Array[Button] = []

signal machine_selected
signal revert
signal run
signal send_machine
signal remove_machine

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
	#make animation here later
	
func set_moves(count: int):
	moves.text = str(count)
	
func reset_counter():
	gained.text = ""
	
func set_counter(number: int):
	gained.text = "+%s" % str(number)
	
func set_score(number: float):
	score.text = str(number)
	reset_counter()
	
func set_objective(number: float):
	objective.text = "Earn up to %s points to win" % str(number)
	
