extends Area2D

@export var selected: bool
@export var activity: Area2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Panel.visible = selected


func _on_work_interval_timeout():
	if activity:
		activity.produce()
