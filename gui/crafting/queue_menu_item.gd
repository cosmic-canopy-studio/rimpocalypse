class_name QueueMenuItem
extends PanelContainer

signal item_selected(selected_recipe: QueueMenuItem)

@export var recipe_name: Label
@export var icon: TextureRect
@export var effort_amount: Label
@export var button: Button
@export var progress_bar: ProgressBar

var _craft_station: CraftStation
var _recipe: Recipe

@onready var green_highlight: StyleBoxFlat = load("res://assets/styles/green_outline.tres")
@onready var blank_highlight: StyleBoxEmpty = load("res://assets/styles/empty_style.tres")


func set_recipe(craft_station: CraftStation, recipe: Recipe):
	self._recipe = recipe
	self._craft_station = craft_station
	icon.texture = recipe.product.item.icon
	recipe_name.text = str(recipe.product.item.name).capitalize()
	effort_amount.text = str(recipe.time_to_craft)
	progress_bar.max_value = recipe.time_to_craft


func _on_button_pressed():
	item_selected.emit(self)


func update_progress(amount):
	progress_bar.value = progress_bar.max_value - amount
