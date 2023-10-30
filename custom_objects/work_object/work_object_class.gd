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

@onready var sprite = $Sprite2D
@onready var work_progress = $Sprite2D/ProgressBar
@onready var object_name = self.name

func _ready():
	self.connect("input_event", _on_input_event)
	
	if effort_to_construct > 0:
		constructed = false
		work_progress.max_value = effort_to_construct
		sprite.material = load("res://custom_objects/work_object/constructing.material")
	else:
		work_progress.max_value = effort_to_produce
	


func _process(_delta):
	if work_progress.value == 0:
		work_progress.visible = false
	else:
		work_progress.visible = true


func produce(effort = 1):
	work_progress.value += effort
	if work_progress.value >= work_progress.max_value:
		work_progress.value = 0
		if not constructed:
			constructed = true
			work_progress.max_value = effort_to_produce
			$Sprite2D.material = null
			print(object_name," construction complete")
		else:
			emit_signal("produced", output_type)


func is_constructed() -> bool:
	return constructed


func _on_input_event(_viewport, event, _shape_idx):
	emit_signal("object_input_event", event, self)
