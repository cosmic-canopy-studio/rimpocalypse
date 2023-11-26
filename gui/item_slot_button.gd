class_name ItemSlotButton
extends Button

signal button_primary_selected(slot: ItemSlotButton)
signal button_secondary_selected(slot: ItemSlotButton)

@export var slot: Slot

var inventory_slot_index: int


func _ready():
	toggle_mode = true

	if slot:
		text = str(slot.amount)
		icon = slot.item.icon


func _gui_input(event):
	if event is InputEventMouseButton:
		if Input.is_action_pressed("primary_select"):
			button_primary_selected.emit(self)
		if Input.is_action_pressed("secondary_select"):
			button_secondary_selected.emit(self)
