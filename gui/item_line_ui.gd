extends Control
class_name ItemLineUI

@export var item_icon: TextureRect
@export var name_label: Label
@export var separator: Separator
@export var amount_label: Label
@export var focus_panel: Panel
@export var show_name: bool

## Color when mouse enter
@export var highlight_color = Color.WHITE

func _ready():
	name_label.visible = show_name
	separator.visible = show_name
		

func update_info_with_slot(slot : Slot):
	if slot != null and slot.item != null:
		# TODO Slow call, use cache from node inv base
		if slot.item != null:
			update_info_with_item(slot.item, slot.amount)
			return
	item_icon.texture = null
	amount_label.visible = false


func update_info_with_item_instance(item_instance: ItemInstance):
	if item_instance != null and item_instance.item != null:
		if item_instance.item != null:
			update_info_with_item(item_instance.item, item_instance.amount)
			return
	item_icon.texture = null
	amount_label.visible = false



func update_info_with_item(item : InventoryItem, amount := 1):
	if item != null:
		item_icon.texture = item.icon
		name_label.text = item.name
		tooltip_text = item.name
	else:
		tooltip_text = ""
	amount_label.text = str(amount)


func clear_info():
	amount_label.visible = false


func _on_mouse_entered():
	grab_focus()


func _on_mouse_exited():
	release_focus()


func _on_hidden():
	release_focus()


func _on_focus_entered() -> void:
	focus_panel.self_modulate = highlight_color


func _on_focus_exited() -> void:
	focus_panel.self_modulate = Color.TRANSPARENT
