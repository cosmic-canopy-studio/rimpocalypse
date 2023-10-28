extends CharacterBody2D

@export var selected: bool
@export var activity: Area2D

var speed = 150

@onready var navigation_agent = $NavigationAgent2D

func _process(_delta):
	$Panel.visible = selected


func _physics_process(delta):
	if navigation_agent.is_navigation_finished():
		return
	
	var direction = to_local(navigation_agent.get_next_path_position()).normalized()
	velocity = speed * direction
	move_and_slide()


func _on_work_interval_timeout():
	if activity and navigation_agent.is_navigation_finished():
		activity.produce()
