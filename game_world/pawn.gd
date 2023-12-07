class_name Pawn
extends CharacterBody2D

signal clicked(node: Node2D)
signal inventory_changed

@export var inventory_database: InventoryDatabase
@export var inventory_handler: InventoryHandler
@export var inventory: Inventory
@export var crafter: Crafter
@export var craft_station: CraftStation
@export var progress_bar: ProgressBar
@export var needs: Array[NeedHandler]
@export var action_sound: AudioStreamPlayer2D
@export var action_sound_delay := 1
@export var walk_sound: AudioStreamPlayer2D

var speed = 100
var activity: Node2D
var current_action_sound_delay := 0

@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
@onready var state_chart: StateChart = $StateChart
@onready var crafting_table: CraftStation = $Crafter/CraftStation
@onready var axe: InventoryItem = inventory_database.get_item(5)
@onready var hammer: InventoryItem = inventory_database.get_item(2)


func set_activity(object: Node2D):
	craft_station.cancel_craft(0)

	# Stop crafting at table if currently doing so
	if activity is CraftStationContructable:
		activity.stop_crafting()
	# Set new activity
	activity = object
	state_chart.set_expression_property("current_activity", object)

	if not object:
		state_chart.send_event("activity_cleared")
		return

	state_chart.send_event("activity_set")
	set_destination(object.position)


func set_destination(map_coords: Vector2):
	navigation_agent.set_target_position(map_coords)
	state_chart.set_expression_property("target_position", map_coords)
	state_chart.send_event("destination_set")


func _on_input_event(_viewport, event, _shape_idx):
	if (
		event is InputEventMouseButton
		and event.button_index == MOUSE_BUTTON_LEFT
		and event.is_pressed() == false
	):
		clicked.emit(self)


func _on_activity_completed():
	activity = null
	state_chart.send_event("activity_completed")


func _on_idle_state_entered():
	print("idle state entered")


func _on_moving_state_physics_processing(_delta):
	if not walk_sound.playing:
		walk_sound.play()
	if navigation_agent.is_navigation_finished():
		if not navigation_agent.is_target_reachable():
			# TODO: Calculate distance, only send error if distance is
			# greater than one cell
			state_chart.send_event("target_unreachable")
			print("Target unreachable!")
			return

	var direction = to_local(navigation_agent.get_next_path_position()).normalized()
	velocity = speed * direction
	move_and_slide()


func _on_acting_state_processing(delta):
	var effort_multiplier = 1
	if not action_sound.playing:
		if current_action_sound_delay > 0:
			current_action_sound_delay -= delta
		else:
			action_sound.play()
			current_action_sound_delay = action_sound_delay

	## TODO: Make crafting station assignment assignable as activity
	if craft_station.is_crafting():
		activity = null
		progress_bar.visible = true
		var current_crafting = craft_station.craftings[0]
		progress_bar.max_value = (
			craft_station.database.recipes[current_crafting.recipe_index].time_to_craft
		)
		progress_bar.value = progress_bar.max_value - current_crafting.time
	else:
		progress_bar.visible = false

	if activity is WorkObject:
		var have_axe = inventory.contains(axe)
		if activity is TreeWorkObject and have_axe:
			effort_multiplier = 3
		activity.produce(delta * effort_multiplier)
	elif activity is Constructable:
		if inventory.contains(hammer):
			effort_multiplier = 2
		if activity is CraftStationContructable:
			activity.do_work(delta * effort_multiplier, inventory)
		else:
			activity.do_work(delta * effort_multiplier)
	elif activity is DroppedItem2D:
		(
			inventory_handler
			. pick_to_inventory(
				activity,
			)
		)
		inventory_changed.emit()
		activity = null
		state_chart.send_event("activity_completed")
	else:
		printerr("Unrecognized activity!")
		state_chart.send_event("activity_invalid")


func _on_idle_state_processing(_delta):
	$AnimationPlayer.stop()
	$AnimationPlayer.play("idle")


func _on_crafted(_recipe_index):
	_on_activity_completed()


func _on_item_eaten(item):
	for need in needs:
		if need.need.name == "hunger":
			var fulfillment = item.properties.get("fulfillment")
			need.increase(fulfillment)
			break
