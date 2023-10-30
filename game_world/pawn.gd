extends CharacterBody2D
class_name Pawn

@export var selected: bool
@export var activity: Node2D


var speed = 150

@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
@onready var crafting_table: CraftStation = $Crafter/CraftStation

func _process(_delta):
	$Panel.visible = selected


func _physics_process(_delta):
	if navigation_agent.is_navigation_finished():
		return
	
	var direction = to_local(navigation_agent.get_next_path_position()).normalized()
	velocity = speed * direction
	move_and_slide()


func _on_work_interval_timeout():
	if activity and navigation_agent.is_navigation_finished():
		if activity is WorkObject:
			activity.produce()
		elif activity is DroppedItem2D:
			PlayerResources.resources[activity.item.name] += 10
			activity.queue_free()
			activity = null
		else:
			printerr("Unrecognized activity!")
	
	if not activity:
		$AnimationPlayer.stop()
		$AnimationPlayer.play("idle")

