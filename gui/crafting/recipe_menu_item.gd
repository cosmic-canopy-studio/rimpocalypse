class_name RecipeMenuItem
extends PanelContainer

signal recipe_selected(selected_recipe: RecipeMenuItem)

@export var ingredient_list_item: PackedScene
@export var recipe_name: Label
@export var icon: TextureRect
@export var effort_amount: Label
@export var ingredients_container: BoxContainer
@export var tools_container: BoxContainer
@export var button: Button

var _craft_station: CraftStation
var _ingredients: Array[IngredientListItem]
var _recipe: Recipe
var _recipe_index: int
var _tools: Array[Sprite2D]

@onready var green_highlight: StyleBoxFlat = load("res://assets/styles/green_outline.tres")
@onready var blank_highlight: StyleBoxEmpty = load("res://assets/styles/empty_style.tres")


func set_recipe(craft_station: CraftStation, recipe: Recipe, recipe_index: int):
	self._recipe = recipe
	self._craft_station = craft_station
	self._recipe_index = recipe_index
	icon.texture = recipe.product.item.icon
	recipe_name.text = str(recipe.product.item.name).capitalize()
	effort_amount.text = str(recipe.time_to_craft)
	_clear_ingredients()
	for ingredient in recipe.ingredients:
		var ingredient_obj: IngredientListItem = ingredient_list_item.instantiate()
		ingredients_container.add_child(ingredient_obj)
		ingredient_obj.setup(ingredient)
		_ingredients.append(ingredient_obj)
	_clear_tools()
	for tool in recipe.tools_required:
		var tool_obj = Sprite2D.new()
		tool_obj.texture = tool.item.icon
		if not craft_station.input_inventory.contains(tool.item):
			tool_obj.self_modulate = Color(1, 1, 1, 0.5)
		tools_container.add_child(tool_obj)
		_tools.append(tool_obj)
	_check_if_has_ingredients()


func _clear_ingredients():
	for ingredient_ui in _ingredients:
		ingredient_ui.queue_free()
		_ingredients.clear()


func _clear_tools():
	for toolobj in _tools:
		toolobj.queue_free()
		_tools.clear()


func _check_if_has_ingredients():
	var recipe = _craft_station.database.recipes[_recipe_index]
	button.disabled = not _craft_station.can_craft(recipe)
	if button.disabled:
		button.set_mouse_filter(Control.MOUSE_FILTER_IGNORE)
	else:
		button.set_mouse_filter(Control.MOUSE_FILTER_STOP)


func sync():
	_check_if_has_ingredients()


func execute():
	_craft_station.craft(_recipe_index)


func _on_button_pressed():
	emit_signal("recipe_selected", self)
