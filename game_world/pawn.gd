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
@export var animation_player: AnimationPlayer
@export var animated_sprite: AnimatedSprite2D

var speed = 100
var activity: Node2D
var current_action_sound_delay := 0
var current_direction = Vector2.DOWN

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


func _on_moving_state_physics_processing(_delta):
	if navigation_agent.is_navigation_finished():
		if not navigation_agent.is_target_reachable():
			# TODO: Calculate distance, only send error if distance is
			# greater than one cell
			state_chart.send_event("target_unreachable")
			print("Target unreachable!")
			return

	var direction = to_local(navigation_agent.get_next_path_position()).normalized()
	var cardinal_direction = _get_cardinal_direction(direction)
	if current_direction != cardinal_direction:
		current_direction = cardinal_direction
		_play_directional_animation("walk")

	velocity = speed * direction
	move_and_slide()


func _play_action_animation():
	if activity is WorkObject:
		animation_player.play("chop")
	elif activity is Constructable:
		animation_player.play("hammer")
	elif activity is DroppedItem2D:
		# TODO: Troubleshoot pickup not playing correctly
		animation_player.play("pickup")


func _play_directional_animation(animation: String):
	var direction = _vec2_dir_to_string(current_direction)
	animated_sprite.play(animation + "_" + direction)


func _vec2_dir_to_string(vec2: Vector2) -> String:
	if vec2 == Vector2.UP:
		return "up"
	if vec2 == Vector2.LEFT:
		return "left"
	if vec2 == Vector2.RIGHT:
		return "right"
	# Default to Vector2.DOWN
	return "down"


func _get_cardinal_direction(direction: Vector2):
	var cardinal_directions = [
		Vector2.UP,
		Vector2.DOWN,
		Vector2.LEFT,
		Vector2.RIGHT,
	]
	var nearest_distance = 2
	var nearest_direction: Vector2
	for dir in cardinal_directions:
		var distance = direction.distance_to(dir)
		if direction.distance_to(dir) < nearest_distance:
			nearest_distance = distance
			nearest_direction = dir

	return nearest_direction


func _reset_animations():
	animation_player.play("RESET")
	_play_directional_animation("idle")


func _on_acting_state_processing(delta):
	var effort_multiplier = 1

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
		inventory_handler.pick_to_inventory(activity)
		inventory_changed.emit()
		activity = null
		state_chart.send_event("activity_completed")
	else:
		printerr("Unrecognized activity!")
		state_chart.send_event("activity_invalid")


func _on_crafted(_recipe_index):
	_on_activity_completed()


func _on_item_eaten(item):
	for need in needs:
		if need.need.name == "hunger":
			var fulfillment = item.properties.get("fulfillment")
			need.increase(fulfillment)
			break


func _on_moving_state_entered():
	_play_directional_animation("walk")
	animation_player.play("walk")


func _on_idle_state_entered():
	_play_directional_animation("idle")
	animation_player.play("idle")


func _on_acting_state_entered():
	_play_directional_animation("action")
	_play_action_animation()


func _on_state_exited():
	animation_player.play("pickup")
	_reset_animations()
