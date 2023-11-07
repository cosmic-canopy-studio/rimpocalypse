extends Control

@export var player_inventory: Inventory
@export var player: Pawn
@export var grid_cursor:GridCursor
@export var furniture_category: ItemCategory
@export var build_menu_item: PackedScene

var current_items: Array[InventoryItem]

@onready var crafting_spot: InventoryItem = player.inventory_database.get_item(4)

func update():
	current_items = []
	for child in $MarginContainer/VBoxContainer.get_children():
		child.queue_free()
		
	for slot in player_inventory.get_slots_with_an_item_of_category(furniture_category):
		if not current_items.has(slot.item):
			current_items.append(slot.item)
	
	for item in current_items:
		var menu_item = build_menu_item.instantiate()
		menu_item.current_item = item
		menu_item.build_menu_item_selected.connect(_on_build_menu_item_selected)
		$MarginContainer/VBoxContainer.add_child(menu_item)


func _on_close_button_pressed():
	visible = false


func _on_build_menu_item_selected(selected_menu_item: BuildMenuItem):
	var item := selected_menu_item.current_item
	if player_inventory.contains(item):
		visible=false
		grid_cursor.handle_construction_placement(item)


func _on_timer_timeout():
	if not visible:
		return
	
	var slots = player_inventory.get_slots_with_an_item_of_category(furniture_category)
	
	if slots.size() != current_items.size():
		update()
		return
	for slot in slots:
		if not current_items.has(slot.item):
			update()
			return
