@icon("res://addons/inventory-system/icons/dropped_item_2d.svg")
extends Node2D
class_name DroppedItem2D

signal pick_up_dropped_item(event: InputEvent, dropped_item: DroppedItem2D)
@export var item: InventoryItem
@export var is_pickable := true


func _on_area_2d_input_event(_viewport, event, _shape_idx):
	emit_signal("pick_up_dropped_item", event, self)
