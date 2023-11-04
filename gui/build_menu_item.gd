extends Control
class_name BuildMenuItem

signal build_menu_item_selected(build_menu_item: BuildMenuItem)

@export var item_icon: TextureRect
@export var item_name: Label
@export var labor_cost: Label

var current_item: InventoryItem

func _ready():
	initialize(current_item)


func initialize(item: InventoryItem):
	current_item = item
	item_icon.texture = item.icon
	item_name.text = item.name
	if item.properties.has("labor_cost"):
		labor_cost.text = str(item.properties.get("labor_cost"))
	else:
		printerr("Furniture item is missing labor cost!")


func _on_button_pressed():
	build_menu_item_selected.emit(self)
