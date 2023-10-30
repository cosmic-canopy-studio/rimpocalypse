extends CharacterBody2D
class_name Pawn

@export var selected: bool
@export var activity: Node2D
@export var inventory_database: InventoryDatabase
@export var inventory_handler: InventoryHandler
@export var inventory: Inventory
@export var crafter: Crafter
@export var craft_station: CraftStation
@export var progress_bar: ProgressBar

var speed = 150

@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
@onready var crafting_table: CraftStation = $Crafter/CraftStation
@onready var axe: InventoryItem = inventory_database.get_item(5)


func _process(_delta):
	$Panel.visible = selected
	if craft_station.is_crafting():
		activity = null
		progress_bar.visible = true
		var current_crafting = craft_station.craftings[0]
		progress_bar.max_value = craft_station.database.recipes[current_crafting.recipe_index].time_to_craft
		progress_bar.value = progress_bar.max_value - current_crafting.time
	else:
		progress_bar.visible = false

func _physics_process(_delta):
	if navigation_agent.is_navigation_finished():
		return
	
	var direction = to_local(navigation_agent.get_next_path_position()).normalized()
	velocity = speed * direction
	move_and_slide()


func _on_work_interval_timeout():
	if activity and navigation_agent.is_navigation_finished():
		if activity is WorkObject:
			var effort = 1
			var have_axe = inventory.contains(axe)
			if activity is TreeWorkObject and have_axe:
				effort = 3
			activity.produce(effort)
		elif activity is DroppedItem2D:
			inventory_handler.pick_to_inventory(activity)
			activity = null
		else:
			printerr("Unrecognized activity!")
	
	if not activity:
		$AnimationPlayer.stop()
		$AnimationPlayer.play("idle")

