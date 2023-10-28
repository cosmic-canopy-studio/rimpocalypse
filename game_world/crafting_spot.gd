extends Area2D

signal produced(type)
signal blocked

var type = "bed"
var work_to_build = 10
var construction_complete = false
var work_to_produce = 5
var current_craft = {
	name = "bed",
	wood_cost = 100
}

@onready var work_progress = $Sprite2D/ProgressBar
@onready var object_name = self.name

func _ready():
	work_progress.max_value = work_to_build


func _process(_delta):
	if work_progress.value == 0:
		work_progress.visible = false
	else:
		work_progress.visible = true


func produce(effort = 1):
	if work_progress.value == 0 and construction_complete:
		if not begin_craft():
				print("Could not begin crafting ", current_craft.name)
				return
	work_progress.value += effort
	if work_progress.value >= work_progress.max_value:
		work_progress.value = 0
		if not construction_complete:
			construction_complete = true
			work_progress.max_value = work_to_produce
			$Sprite2D.material = null
			print(object_name," construction complete")
		else:
			emit_signal("produced", type)


func begin_craft() -> bool:
	if PlayerResources.wood >= current_craft.wood_cost:
		print("Beginning craft at ", object_name, " producing ", current_craft.name)
		PlayerResources.wood -= current_craft.wood_cost
		return true
	else:
		print("Not enough wood, ", current_craft.wood_cost, " wood required.")
		emit_signal("blocked")
		return false
