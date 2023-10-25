extends Node

func _on_pawn_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.is_pressed():
		$Pawn.selected = not $Pawn.selected
		print("Pawn selection state: ", $Pawn.selected)


func _on_tree_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.is_pressed():
		$Tree.selected = not $Tree.selected
		print("Tree selection state: ", $Tree.selected)
		if $Pawn.selected:
			print("Assigning Pawn to work at Tree")
			$Pawn.position.x = $Tree.position.x - 50
			$Pawn.position.y = $Tree.position.y + 20
			$Pawn.selected = false
			$Pawn.activity = $Tree


func _on_crafting_spot_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.is_pressed():
		$CraftingSpot.selected = not $CraftingSpot.selected
		print("Tree selection state: ", $CraftingSpot.selected)
		if $Pawn.selected:
			print("Assigning Pawn to work at Crafting Spot")
			$Pawn.position.x = $CraftingSpot.position.x - 50
			$Pawn.position.y = $CraftingSpot.position.y + 20
			$Pawn.selected = false
			$Pawn.activity = $CraftingSpot


func _on_tree_produced(type):
	print("Resource produced: ", type)
	PlayerResources.wood += 10


func _on_crafting_spot_produced(type):
	if PlayerResources.wood >= 100:
		print("Item produced: ", type)
		PlayerResources.bed += 1
		PlayerResources.wood -= 100
	else:
		print("Not enough wood, 100 wood required.")


func _on_build_button_pressed():
	$BuildMenu.visible = true


func _on_back_button_pressed():
	$BuildMenu.visible = false


func _on_crafting_spot_button_pressed():
	if PlayerResources.wood >= 100:
		print("100 wood deducted.")
		PlayerResources.wood -= 100
		$CraftingSpot.visible = true
		print("Crafting Spot created.")
	else:
		print("Not enough wood, 100 wood required.")



