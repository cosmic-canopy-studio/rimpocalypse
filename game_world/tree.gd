extends Area2D

signal produced(type)

var type = "wood"
var work_to_produce = 5
@onready var work_progress = $Sprite2D/ProgressBar

func _ready():
	work_progress.max_value = work_to_produce


func _process(_delta):
	if work_progress.value == 0:
		work_progress.visible = false
	else:
		work_progress.visible = true


func produce(effort = 1):
	work_progress.value += effort
	if work_progress.value >= work_progress.max_value:
		work_progress.value = 0
		emit_signal("produced", type)
