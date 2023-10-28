extends Node2D

var highlight = load("res://highlight.tscn")


func _on_pawn_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.is_pressed():
		$Pawn/Sprite2D.add_child(highlight.instantiate())
		$Pawn.selected = not $Pawn.selected
		print("Pawn selection state: ", $Pawn.selected)


func _on_tree_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.is_pressed():
		$Tree/Sprite2D.add_child(highlight.instantiate())
		if $Pawn.selected:
			print("Assigning Pawn to work at Tree")
			$Pawn/NavigationAgent2D.target_position = $Tree.position
			$Pawn.selected = false
			$Pawn.activity = $Tree


func _on_crafting_spot_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.is_pressed():
		$CraftingSpot/Sprite2D.add_child(highlight.instantiate())
		if $Pawn.selected:
			print("Assigning Pawn to work at Crafting Spot")
			$Pawn/NavigationAgent2D.target_position = $CraftingSpot.position
			$Pawn.selected = false
			$Pawn.activity = $CraftingSpot


func _on_tree_produced(type):
	print("Resource produced: ", type)
	PlayerResources.wood += 10


func _on_crafting_spot_produced(type):
	print("Item produced: ", type)
	PlayerResources.bed += 1


func _on_gui_crafting_spot_completed():
	$CraftingSpot.visible = true


func _on_crafting_spot_blocked():
	print("Playing blocked animation")
	$Pawn/Blocked/AnimationPlayer.stop()
	$Pawn/Blocked/AnimationPlayer.play("blocked")
