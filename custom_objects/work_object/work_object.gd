@icon("res://custom_objects/work_object/work_object.svg")
extends Area2D
class_name WorkObject


signal produced(output_type: String)
signal blocked(reason: String)
signal object_input_event(event: InputEvent, object: WorkObject)

@export var constructed := true
@export var effort_to_construct := 0
@export var effort_to_produce := 5
@export var output_type := "wood"
@export var red_fill: StyleBoxFlat
@export var yellow_fill: StyleBoxFlat

@onready var sprite = $Sprite2D
@onready var progress_bar = $Sprite2D/ProgressBar
@onready var object_name = self.name

func _ready():
	self.connect("input_event", _on_input_event)
	
	if effort_to_construct > 0:
		constructed = false
		progress_bar.max_value = effort_to_construct
		sprite.material = load("res://custom_objects/work_object/constructing.material")
	else:
		progress_bar.max_value = effort_to_produce



func _process(_delta):
	if progress_bar.value == 0:
		progress_bar.visible = false
	else:
		progress_bar.visible = true


func produce(effort = 1):
	
	if effort > 1:
		progress_bar.add_theme_stylebox_override("fill", yellow_fill)
	else:
		progress_bar.add_theme_stylebox_override("fill", red_fill)
	progress_bar.value += effort
	
	if progress_bar.value >= progress_bar.max_value:
		progress_bar.value = 0
		
		if not constructed:
			constructed = true
			progress_bar.max_value = effort_to_produce
			$Sprite2D.material = null
			print(object_name," construction complete")
		else:
			emit_signal("produced", output_type)


func is_constructed() -> bool:
	return constructed


func _on_input_event(_viewport, event, _shape_idx):
	emit_signal("object_input_event", event, self)
