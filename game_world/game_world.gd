extends Node2D

@export var highlight: PackedScene


func _ready():
	var work_objects = get_tree().get_nodes_in_group("work_objects")  
	for work_object in work_objects:  
		work_object.connect("produced", _on_produced)
		work_object.connect("blocked", _on_blocked)
		work_object.connect("object_input_event", _on_object_input_event)


func handle_input(event, object: Node2D):
	if event is InputEventMouseButton and event.is_pressed():
		object.find_child("Sprite2D").add_child(highlight.instantiate())		
		if object == $Pawn:
			$Pawn/Sprite2D.add_child(highlight.instantiate())
			$Pawn.selected = not $Pawn.selected
			print("Pawn selection state: ", $Pawn.selected)
			return
			
		if $Pawn.selected:
			print("Assigning Pawn to work at ", object.name)
			$Pawn/NavigationAgent2D.target_position = object.position
			$Pawn.selected = false
			$Pawn.activity = object

func _on_pawn_input_event(_viewport, event, _shape_idx):
	handle_input(event, $Pawn)
	


func _on_tree_input_event(_viewport, event, _shape_idx):
	handle_input(event, $Tree)


func _on_crafting_spot_input_event(_viewport, event, _shape_idx):
	handle_input(event, $CraftingSpot)


func _on_wood_input_event(_viewport, event, _shape_idx):
	handle_input(event, $Items/Wood)


func _on_stone_input_event(_viewport, event, _shape_idx):
		handle_input(event, $Items/Stone) 


func _on_produced(type_produced, amount_produced = 1):
	print("Produced: ", amount_produced, " ", type_produced)
	PlayerResources.resources[type_produced] += amount_produced


func _on_crafting_spot_produced(type):
	print("Item produced: ", type)
	PlayerResources.bed += 1


func _on_blocked(_reason: String):
	$Pawn/AnimationPlayer.stop()
	$Pawn/AnimationPlayer.play("blocked")


func _on_object_input_event(event: InputEvent, object: WorkObject):
	handle_input(event, object)


func _on_gui_crafting_spot_completed():
	$CraftingSpot.visible = true

