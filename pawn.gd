extends Area2D

@export var selected: bool
@export var activity: Area2D


func _process(_delta):
	$Panel.visible = selected


func _on_work_interval_timeout():
	if activity:
		activity.produce()
