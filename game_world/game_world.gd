extends Node2D

@export var highlight: PackedScene
@export var player: CharacterBody2D
@export var inventory_database: InventoryDatabase

@onready var wood: InventoryItem = inventory_database.get_item(0)
@onready var stone: InventoryItem = inventory_database.get_item(1)
@onready var inventory: Inventory = player.inventory_handler.inventory


func _ready():
	player.inventory_handler.add_to_inventory(inventory, wood, 10)

	var work_objects = get_tree().get_nodes_in_group("work_objects")  
	for work_object in work_objects:  
		work_object.connect("produced", _on_produced)
		work_object.connect("blocked", _on_blocked)
		work_object.connect("object_input_event", _on_object_input_event)
	
	var dropped_items = get_tree().get_nodes_in_group("dropped_items")  
	for dropped_item in dropped_items:  
		dropped_item.connect("pick_up_dropped_item", _on_pick_up_dropped_item)


func handle_input(event, object: Node2D):
	if event is InputEventMouseButton and event.is_pressed():
		object.find_child("Sprite2D").add_child(highlight.instantiate())		
		if object == player:
			player.find_child("Sprite2D").add_child(highlight.instantiate())
			player.selected = not player.selected
			return
			
		if player.selected:
			player.find_child("NavigationAgent2D").target_position = object.position
			player.set_activity(object)


func _on_pawn_input_event(_viewport, event, _shape_idx):
	handle_input(event, $Pawn)


func _on_pick_up_dropped_item(event: InputEvent, dropped_item: DroppedItem2D):
	handle_input(event, dropped_item)


func _on_crafting_spot_input_event(_viewport, event, _shape_idx):
	handle_input(event, $CraftingSpot)


func _on_wood_input_event(_viewport, event, _shape_idx):
	handle_input(event, $Items/Wood)


func _on_produced(type_produced, amount_produced = 1):
	print("Produced: ", amount_produced, " ", type_produced)
	if type_produced == "wood":
		player.inventory_handler.add_to_inventory(inventory, wood, amount_produced)
	PlayerResources.resources[type_produced] += amount_produced


func _on_crafting_spot_produced(type):
	print("Item produced: ", type)
	PlayerResources.bed += 1


func _on_blocked(_reason: String):
	$Pawn/AnimationPlayer.stop()
	$Pawn/AnimationPlayer.play("blocked")


func _on_object_input_event(event: InputEvent, object: WorkObject):
	handle_input(event, object)


func _on_gui_crafting_spot_completed():
	$CraftingSpot.visible = true


func _on_craft_station_constructable_input_event(event, constructable):
	handle_input(event, constructable)
