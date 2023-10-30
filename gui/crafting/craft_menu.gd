extends Control
class_name CraftMenu

@export var recipe_scene: PackedScene
@export var recipe_slots: Container
@export var craft_button: Button

var _recipe_scene_nodes: Array[RecipeMenuItem]
var _selected_recipe: RecipeMenuItem

@onready var green_outline: StyleBoxFlat = load("res://gui/crafting/green_outline.tres")
@onready var empty_outline: StyleBoxEmpty = load("res://gui/crafting/empty_style.tres")


func initialize(craft_station: CraftStation):
	_clear()
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
	visible = true


func close():
	visible = false


func toggle(pawn: Pawn):
	if visible:
		close()
	else:
		open(pawn.crafting_table)


func _clear():
	for recipe_scene_node in _recipe_scene_nodes:
		recipe_scene_node.queue_free()
	_recipe_scene_nodes.clear()
	custom_minimum_size.x = 0


func _update_signals():
	var craft_recipes = get_tree().get_nodes_in_group("craft_recipes")  
	for craft_recipe in craft_recipes:
		if not craft_recipe.is_connected("recipe_selected", _on_recipe_selected):
			craft_recipe.connect("recipe_selected", _on_recipe_selected)


func _on_recipe_selected(selected_recipe: RecipeMenuItem):
	if craft_button.disabled:
		craft_button.disabled = false
	
	if _selected_recipe:
		_selected_recipe.button.add_theme_stylebox_override("normal", empty_outline)
		_selected_recipe.button.add_theme_stylebox_override("focus", empty_outline)
	
	_selected_recipe = selected_recipe
	_selected_recipe.button.add_theme_stylebox_override("normal", green_outline)
	_selected_recipe.button.add_theme_stylebox_override("focus", green_outline)


func _disconnect_signals():
	var connections = self.get_incoming_connections();
	print (connections)
	for connection in connections:
		if connection.callable == _on_recipe_selected:
			print("disconnecting")
			self.disconnect(str(connection.signal), connection.callable)


func _on_craft_button_pressed():
	pass # Replace with function body.
