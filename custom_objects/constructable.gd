@icon("res://custom_objects/constructable.svg")
class_name Constructable
extends Area2D

signal constructable_input_event(event: InputEvent, constructable: Constructable)
signal activity_completed

@export var constructed: bool = false
@export var effort_to_construct: int = 10
@export var red_fill: StyleBoxFlat
@export var yellow_fill: StyleBoxFlat

var current_item: InventoryItem

@onready var sprite = $Sprite2D
@onready var progress_bar = $Sprite2D/ProgressBar


func _ready():
	self.connect("input_event", _on_input_event)
	effort_to_construct = current_item.properties.get("labor_cost")
	progress_bar.max_value = effort_to_construct
	progress_bar.visible = false
	sprite.texture = current_item.icon
	if not constructed:
		sprite.self_modulate = Color(1, 1, 1, 0.5)


func do_work(effort: float):
	if constructed:
		return
	progress_bar.visible = true
	# TODO: Rework color to work with multipliier & delta
	if effort > 1:
		progress_bar.add_theme_stylebox_override("fill", yellow_fill)
	else:
		progress_bar.add_theme_stylebox_override("fill", red_fill)
	progress_bar.value += effort
	if progress_bar.value >= progress_bar.max_value:
		progress_bar.value = 0
		progress_bar.visible = false

		if not constructed:
			constructed = true
			sprite.self_modulate = Color(1, 1, 1, 1)
			progress_bar.add_theme_stylebox_override("fill", red_fill)


func _signal_activity_completed():
	emit_signal("activity_completed")


func _on_input_event(_viewport, event, _shape_idx):
	emit_signal("constructable_input_event", event, self)
