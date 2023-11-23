class_name CraftMenu
extends Control

@export var menu_title: Label
@export var recipe_scene: PackedScene
@export var queue_scene: PackedScene
@export var recipe_slots: Container
@export var queue_slots: Container
@export var cancel_button: Button
@export var close_button: Button
@export var craft_button: Button

var _current_station: CraftStation
var _recipe_scene_nodes: Array[RecipeMenuItem]
var _queue_scene_nodes: Array[QueueMenuItem]
var _selected_recipe: RecipeMenuItem
var _selected_queue_item: QueueMenuItem

@onready var state_chart: StateChart = $StateChart
@onready var green_outline: StyleBoxFlat = load("res://assets/styles/green_outline.tres")
@onready var empty_outline: StyleBoxEmpty = load("res://assets/styles/empty_style.tres")


func initialize(craft_station: CraftStation):
	if craft_station.type != null:
		menu_title.text = "Crafts: " + craft_station.type.name.capitalize()
	else:
		menu_title.text = "Crafts: Personal"
	_add_recipes(craft_station)


func _add_recipes(craft_station: CraftStation):
	for i in craft_station.valid_recipes.size():
		var recipe_index = craft_station.valid_recipes[i]
		var recipe = craft_station.database.recipes[recipe_index]
		var recipe_scene_instance: RecipeMenuItem = recipe_scene.instantiate()
		_recipe_scene_nodes.append(recipe_scene_instance)
		recipe_scene_instance.set_recipe(craft_station, recipe, recipe_index)
		recipe_slots.add_child(recipe_scene_instance)
		recipe_scene_instance.recipe_selected.connect(_on_recipe_selected)


func _open(craft_station: CraftStation):
	_current_station = craft_station
	_current_station.crafting_added.connect(_on_crafting_changed)
	_current_station.crafting_removed.connect(_on_crafting_changed)

	state_chart.send_event("show_window")


func _close():
	_current_station.crafting_added.disconnect(_on_crafting_changed)
	_current_station.crafting_removed.disconnect(_on_crafting_changed)

	state_chart.send_event("hide_window")


func toggle_player_crafting(pawn: Pawn):
	if visible:
		if _current_station != pawn.crafting_table:
			_close()
			_open(pawn.crafting_table)
		else:
			_close()
	else:
		_open(pawn.crafting_table)


func open_craft_menu(craft_station: CraftStation, inventory: Inventory):
	craft_station.input_inventory = inventory
	craft_station.output_inventory = inventory
	_open(craft_station)


func _clear_recipes():
	_selected_recipe = null
	for recipe_scene_node in _recipe_scene_nodes:
		recipe_scene_node.recipe_selected.disconnect(_on_recipe_selected)
		recipe_scene_node.queue_free()
	_recipe_scene_nodes.clear()


func _clear_queue():
	_selected_queue_item = null
	for queue_scene_node in _queue_scene_nodes:
		queue_scene_node.item_selected.disconnect(_on_queue_item_selected)
		queue_scene_node.queue_free()
	_queue_scene_nodes.clear()


func _on_recipe_selected(selected_recipe: RecipeMenuItem):
	if craft_button.disabled:
		craft_button.disabled = false

	if _selected_recipe:
		_selected_recipe.button.add_theme_stylebox_override("normal", empty_outline)
		_selected_recipe.button.add_theme_stylebox_override("focus", empty_outline)

	_selected_recipe = selected_recipe
	_selected_recipe.button.add_theme_stylebox_override("normal", green_outline)
	_selected_recipe.button.add_theme_stylebox_override("focus", green_outline)


func _on_queue_item_selected(queue_item: QueueMenuItem):
	if cancel_button.disabled:
		cancel_button.disabled = false

	if _selected_queue_item:
		_selected_queue_item.button.add_theme_stylebox_override("normal", empty_outline)
		_selected_recipe.button.add_theme_stylebox_override("focus", empty_outline)

	_selected_queue_item = queue_item
	_selected_queue_item.button.add_theme_stylebox_override("normal", green_outline)
	_selected_queue_item.button.add_theme_stylebox_override("focus", green_outline)


func _on_craft_button_pressed():
	_selected_recipe.execute()


func _on_close_button_pressed():
	_close()


func _on_cancel_button_pressed():
	var i = 0
	while i < _queue_scene_nodes.size():
		if _queue_scene_nodes[i] == _selected_queue_item:
			_current_station.cancel_craft(i)
			break
		i += 1


func _on_hidden_state_entered():
	_clear_recipes()
	_clear_queue()
	_current_station = null
	visible = false


func _on_visible_state_entered():
	initialize(_current_station)
	visible = true


func _on_visible_state_processing(_delta):
	if _current_station.is_crafting():
		_update_queue_pane()
	_sync_craftable_recipes()


func _sync_craftable_recipes():
	for recipe in _recipe_scene_nodes:
		recipe.sync()


func _on_crafting_changed(_position):
	_refresh_queue_pane()
	_sync_craftable_recipes()


func _update_queue_pane():
	if _queue_scene_nodes.size() == 0:
		printerr("Queue is empty!")
		return
	var current_item = _current_station.craftings[0]
	_queue_scene_nodes[0].update_progress(current_item.time)


func _refresh_queue_pane():
	_clear_queue()
	var queue = _current_station.craftings
	for queue_item in queue:
		var recipe_index = queue_item.recipe_index
		var recipe = _current_station.database.recipes[recipe_index]
		var queue_scene_instance: QueueMenuItem = queue_scene.instantiate()
		_queue_scene_nodes.append(queue_scene_instance)
		queue_scene_instance.set_recipe(_current_station, recipe)
		queue_scene_instance.update_progress(queue_item.time)
		queue_slots.add_child(queue_scene_instance)
		queue_scene_instance.item_selected.connect(_on_queue_item_selected)
