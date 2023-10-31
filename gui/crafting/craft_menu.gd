extends Control
class_name CraftMenu

@export var menu_title: Label
@export var recipe_scene: PackedScene
@export var recipe_slots: Container
@export var craft_button: Button
@export var close_button: Button

var _current_station: CraftStation
var _recipe_scene_nodes: Array[RecipeMenuItem]
var _selected_recipe: RecipeMenuItem

@onready var green_outline: StyleBoxFlat = load("res://gui/crafting/green_outline.tres")
@onready var empty_outline: StyleBoxEmpty = load("res://gui/crafting/empty_style.tres")


func initialize(craft_station: CraftStation):
	if craft_station.type != null:
		menu_title.text = "Crafts: " + craft_station.type.name.capitalize()
	else:
		menu_title.text = "Crafts: Personal"
	var recipes = craft_station.database.recipes
	for i in craft_station.valid_recipes.size():
		var recipe_index = craft_station.valid_recipes[i]
		var recipe = craft_station.database.recipes[recipe_index]
		var recipe_scene_instance: RecipeMenuItem = recipe_scene.instantiate()
		_recipe_scene_nodes.append(recipe_scene_instance)
		recipe_scene_instance.set_recipe(craft_station, recipe, recipe_index)		
		recipe_slots.add_child(recipe_scene_instance)
	_update_signals()

func open(craft_station: CraftStation):
	initialize(craft_station)
	_current_station = craft_station
	visible = true


func close():
	_clear_recipes()
	_current_station = null
	visible = false


func toggle_player_crafting(pawn: Pawn):
	if visible:
		if _current_station != pawn.crafting_table:
			close()
			open(pawn.crafting_table)
		else:
			close()
	else:
		open(pawn.crafting_table)

func open_craft_menu(craft_station: CraftStation, inventory: Inventory):
	craft_station.input_inventory = inventory
	craft_station.output_inventory = inventory
	open(craft_station)
	

func _clear_recipes():
	_selected_recipe = null
	_clear_signals()
	for recipe_scene_node in _recipe_scene_nodes:
		recipe_scene_node.queue_free()
	_recipe_scene_nodes.clear()


func _update_signals():
	var craft_recipes = get_tree().get_nodes_in_group("craft_recipes")  
	for craft_recipe in craft_recipes:
		if not craft_recipe.is_connected("recipe_selected", _on_recipe_selected):
			craft_recipe.connect("recipe_selected", _on_recipe_selected)

func _clear_signals():
	var craft_recipes = get_tree().get_nodes_in_group("craft_recipes")  
	for craft_recipe in craft_recipes:
		craft_recipe.disconnect("recipe_selected", _on_recipe_selected)


func _on_recipe_selected(selected_recipe: RecipeMenuItem):
	if craft_button.disabled:
		craft_button.disabled = false
	
	if _selected_recipe:
		_selected_recipe.button.add_theme_stylebox_override("normal", empty_outline)
		_selected_recipe.button.add_theme_stylebox_override("focus", empty_outline)
	
	_selected_recipe = selected_recipe
	_selected_recipe.button.add_theme_stylebox_override("normal", green_outline)
	_selected_recipe.button.add_theme_stylebox_override("focus", green_outline)


func _on_craft_button_pressed():
	_selected_recipe.execute()
	close()


func _on_close_button_pressed():
	close()


func _on_crafting_menu_requested(craft_station, inventory):
	open_craft_menu(craft_station, inventory)
