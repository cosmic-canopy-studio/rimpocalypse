extends PanelContainer

signal item_dropped(item: InventoryItem, quantity: int)

@export var item_slot_button: PackedScene

var inventory_handler: InventoryHandler
var inventory: Inventory
var _currently_selected_slot: ItemSlotButton
var _current_slots: Array[ItemSlotButton] = []

@onready var item_slot_grid = %ItemSlotGrid
@onready var item_details = %ItemDetails


func _ready():
	item_details.visible = false


func set_inventory_handler(new_handler: InventoryHandler):
	inventory_handler = new_handler
	_initialize_inventory()


func toggle_visibility():
	if not visible:
		_open()
	else:
		_close()


func _open():
	_refresh_slots()
	visible = true


func _close():
	visible = false
	_unset_currently_selected_slot()
	_clear_slots()


func _initialize_inventory():
	inventory = inventory_handler.inventory
	_refresh_slots()


func _refresh_slots():
	_clear_slots()
	var i = 0
	while i < inventory.slots.size():
		var slot_button = item_slot_button.instantiate()
		slot_button.slot = inventory.slots[i]
		slot_button.inventory_slot_index = i
		_current_slots.append(slot_button)
		item_slot_grid.add_child(slot_button)
		slot_button.button_primary_selected.connect(_on_slot_primary_selected)
		slot_button.button_secondary_selected.connect(_on_slot_secondary_selected)
		i += 1


func _clear_slots():
	for slot in _current_slots:
		slot.button_primary_selected.disconnect(_on_slot_primary_selected)
		slot.button_secondary_selected.disconnect(_on_slot_secondary_selected)
		slot.queue_free()

	_current_slots.clear()


func _set_currently_selected_slot(new_slot: ItemSlotButton):
	if _currently_selected_slot:
		_unset_currently_selected_slot()
	_currently_selected_slot = new_slot
	_currently_selected_slot.button_pressed = true
	var description = new_slot.slot.item.properties.get("description")
	if description:
		item_details.text = description
		item_details.visible = true


func _unset_currently_selected_slot():
	if _currently_selected_slot:
		_currently_selected_slot.button_pressed = false
		_currently_selected_slot = null
	item_details.visible = false
	item_details.text = ""


func _on_close_button_pressed():
	toggle_visibility()


func _on_slot_primary_selected(slot: ItemSlotButton):
	if _currently_selected_slot:
		var selected_index = _currently_selected_slot.inventory_slot_index
		var clicked_index = slot.inventory_slot_index
		if selected_index == clicked_index:
			_unset_currently_selected_slot()
			return
		inventory.slots[selected_index] = inventory.slots[clicked_index]
		inventory.slots[clicked_index] = _currently_selected_slot.slot
		_refresh_slots()
		_unset_currently_selected_slot()
		return
	_set_currently_selected_slot(slot)


func _on_slot_secondary_selected(slot: ItemSlotButton):
	if slot.slot == null:
		return
	var item = slot.slot.item
	var amount = slot.slot.amount
	inventory.get_id_from_item(item)
	inventory_handler.drop_from_inventory(slot.inventory_slot_index, amount)
	_unset_currently_selected_slot()
	item_dropped.emit(item, amount)
	_refresh_slots()


func _on_pawn_inventory_changed():
	_refresh_slots()
