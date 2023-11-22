class_name CraftMenu
extends Control

@export var menu_title: Label
@export var recipe_scene: PackedScene
@export var recipe_slots: Container
@export var cancel_button: Button
@export var close_button: Button
@export var craft_button: Button

var _current_station: CraftStation
var _recipe_scene_nodes: Array[RecipeMenuItem]
var _selected_recipe: RecipeMenuItem

@onready var state_chart: StateChart = $StateChart
@onready var green_outline: StyleBoxFlat = load("res://assets/styles/green_outline.tres")
@onready var empty_outline: StyleBoxEmpty = load("res://assets/styles/empty_style.tres")


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
		recipe_scene_instance.recipe_selected.connect(_on_recipe_selected)


func open(craft_station: CraftStation):
	_current_station = craft_station
	state_chart.send_event("show_window")


func close():
	state_chart.send_event("hide_window")


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
	for recipe_scene_node in _recipe_scene_nodes:
		recipe_scene_node.recipe_selected.disconnect(_on_recipe_selected)
		recipe_scene_node.queue_free()
	_recipe_scene_nodes.clear()


func _on_recipe_selected(selected_recipe: RecipeMenuItem):
	if craft_button.disabled:
		craft_button.disabled = false

	if _selected_recipe:
		_selected_recipe.button.add_theme_stylebox_override("normal", empty_outline)
		_selected_recipe.button.add_theme_stylebox_override("focus", empty_outline)

	_selected_recipe = selected_recipe
	_selected_recipe.button.add_theme_stylebox_override("normal", green_outline)
	_selected_recipe.button.add_theme_stylebox_override("focus", green_outline)


func _on_queue_item_selected(selected_recipe: RecipeMenuItem):
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


func _on_cancel_button_pressed():
	# TODO: Cancel item in queue
	pass  # Replace with function body.


func _on_hidden_state_entered():
	_clear_recipes()
	_current_station = null
	visible = false


func _on_visible_state_entered():
	initialize(_current_station)
	visible = true


func _on_visible_state_processing(_delta):
	# TODO: Handle window updates
	pass  # Replace with function body.
