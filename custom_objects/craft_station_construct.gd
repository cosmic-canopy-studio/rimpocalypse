extends Constructable
class_name CraftStationContructable

signal crafting_menu_requested(craft_station: CraftStation, inventory: Inventory)

@export var craft_station: CraftStation
@export var station_type: CraftStationType
@export var current_craft_icon: Sprite2D

var opened: bool = false
var actively_crafting: bool = true


func _ready():
	super()
	craft_station.type = station_type
	current_craft_icon.visible = false


func _process(_delta):
	if craft_station.is_crafting():
		progress_bar.value = progress_bar.max_value - craft_station.craftings[0].time


func do_work(effort = 1, inventory: Inventory = null):
	if not constructed:
		super(effort)
		return
	
	if opened:
		return
	
	if craft_station.is_crafting():
		craft_station.can_processing_craftings = true
		return

	if inventory:
		emit_signal("crafting_menu_requested", craft_station, inventory)
		craft_station.can_processing_craftings = true		
		opened = true
	else:
		printerr("No inventory provided for crafting!")


func stop_crafting():
	opened = false
	craft_station.can_processing_craftings = false


func get_current_recipe() -> Recipe:
	var current_crafting = craft_station.craftings[0]
	var current_recipe = craft_station.database.recipes[current_crafting.recipe_index]
	return current_recipe


func _on_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.is_pressed():
		opened = false
	super(_viewport, event, _shape_idx)


func _on_craft_station_on_crafted(_recipe_index):
	progress_bar.visible = false
	current_craft_icon.visible = false
	_signal_activity_completed()


func _on_craft_station_crafting_added(_crafting_index):
	var current_recipe = get_current_recipe()
	progress_bar.max_value = current_recipe.time_to_craft
	progress_bar.visible = true
	current_craft_icon.texture = current_recipe.product.item.icon
	current_craft_icon.visible = true
