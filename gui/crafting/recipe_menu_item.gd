extends Control
class_name RecipeMenuItem

signal recipe_selected(selected_recipe: RecipeMenuItem)

@export var ingredient_list_item: PackedScene

@export var recipe_name: Label

@export var icon: TextureRect
@export var effort_amount: Label
@export var ingredients_container: BoxContainer
@export var tools_container: BoxContainer
@export var button: Button

@onready var green_highlight: StyleBoxFlat = load("res://gui/crafting/green_outline.tres")
@onready var blank_highlight: StyleBoxEmpty = load("res://gui/crafting/empty_style.tres")

var _recipe_index: int
var _craft_station: CraftStation
var _ingredients: Array[IngredientListItem]

func set_recipe(craft_station: CraftStation, recipe: Recipe, recipe_index: int):
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
	_check_if_has_ingredients()


func _clear_ingredients():
	for ingredient_ui in _ingredients:
		ingredient_ui.queue_free()
		_ingredients.clear()	


func _check_if_has_ingredients():
	var recipe = _craft_station.database.recipes[_recipe_index]
	button.disabled = not _craft_station.can_craft(recipe)
	if button.disabled:
		button.set_mouse_filter(Control.MOUSE_FILTER_IGNORE)
	else:
		button.set_mouse_filter(Control.MOUSE_FILTER_STOP)


func sync():
	_check_if_has_ingredients()


func _on_button_pressed():
	emit_signal("recipe_selected", self)
