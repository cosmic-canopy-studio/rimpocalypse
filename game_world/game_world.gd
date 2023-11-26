extends Node2D

@export var highlight: PackedScene
@export var player: CharacterBody2D
@export var inventory_database: InventoryDatabase
@export var constructable_scene: PackedScene
@export var craft_station_scene: PackedScene
@export var dropped_item_scene: PackedScene
@export var tile_map: TileMap
@export var gui: Control

var game_grid := Grid.new()
var grid_coords: Vector2

@onready var dropped_item_node := %DroppedItems
@onready var wood: InventoryItem = inventory_database.get_item(0)
@onready var stone: InventoryItem = inventory_database.get_item(1)
@onready var crafting_spot: InventoryItem = inventory_database.get_item(4)
@onready var inventory: Inventory = player.inventory_handler.inventory


func _ready():
	player.inventory_handler.add_to_inventory(inventory, wood, 10)
	player.inventory_handler.add_to_inventory(inventory, crafting_spot, 1)

	var work_objects = get_tree().get_nodes_in_group("work_objects")
	for work_object in work_objects:
		work_object.produced.connect(_on_produced)
		work_object.blocked.connect(_on_blocked)
		work_object.object_input_event.connect(_on_object_input_event)

	var dropped_items = get_tree().get_nodes_in_group("dropped_items")
	for dropped_item in dropped_items:
		dropped_item.pick_up_dropped_item.connect(_on_pick_up_dropped_item)


func handle_input(event, object: Node2D):
	if event is InputEventMouseButton and event.is_pressed():
		object.find_child("Sprite2D").add_child(highlight.instantiate())
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
	if type_produced == "wood":
		player.inventory_handler.add_to_inventory(inventory, wood, amount_produced)
		player.inventory_changed.emit()


func _on_blocked(_reason: String):
	$Pawn/AnimationPlayer.stop()
	$Pawn/AnimationPlayer.play("blocked")


func _on_object_input_event(event: InputEvent, object: WorkObject):
	handle_input(event, object)


func _on_constructable_input_event(event, constructable):
	handle_input(event, constructable)


func _on_grid_cursor_grid_clicked(_grid_position, map_position, _grid_center):
	player.set_activity(null)
	player.set_destination(map_position)


func _on_grid_cursor_item_placed(
	item: InventoryItem, grid_position: Vector2, _map_position: Vector2, grid_center: Vector2
):
	var constructable_instance
	if item == crafting_spot:
		constructable_instance = craft_station_scene.instantiate()
		constructable_instance.crafting_menu_requested.connect(gui._on_crafting_menu_requested)
	else:
		constructable_instance = constructable_scene.instantiate()
	constructable_instance.current_item = item
	constructable_instance.activity_completed.connect(player._on_activity_completed)
	constructable_instance.constructable_input_event.connect(_on_constructable_input_event)
	constructable_instance.position = grid_center
	$Construtions.add_child(constructable_instance)

	if item.properties.get("impassable") == true:
		tile_map.set_cell(0, grid_position, 0, Vector2(6, 0), 0)
	player.inventory.remove(item)


func _on_inventory_menu_item_dropped(item: InventoryItem, quantity: int):
	var i = 0
	while i < quantity:
		_spawn_dropped_item_near_player(item)
		i += 1
	print("Player dropped ", quantity, " ", item.name)


func _spawn_dropped_item_near_player(item: InventoryItem):
	var new_drop = dropped_item_scene.instantiate() as DroppedItem2D
	new_drop.item = item
	randomize()
	var spread = 16
	var location_x = player.position.x + randi_range(-spread, spread)
	var location_y = player.position.y + randi_range(-spread, spread)
	new_drop.position = Vector2(location_x, location_y)
	new_drop.pick_up_dropped_item.connect(_on_pick_up_dropped_item)
	dropped_item_node.add_child(new_drop)
