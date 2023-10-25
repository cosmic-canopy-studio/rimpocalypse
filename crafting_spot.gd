extends Area2D

signal produced(type)

@export var selected: bool
var type = "bed"
var work = 10
@onready var work_progress = $Sprite2D/ProgressBar

func _ready():
	work_progress.max_value = work


func _process(_delta):
	$Panel.visible = selected
	if $Panel.visible == true and $HighlightTimeout.is_stopped():
		$HighlightTimeout.start()


func _on_highlight_timeout_timeout():
	selected = false


func produce():
	if work > 0:
		work -= 1
		work_progress.value = work_progress.max_value - work
		print("Work remaining: ", work)
	else:
		work_progress.visible = false
		emit_signal("produced", type)
