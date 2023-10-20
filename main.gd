extends Node



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_pawn_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.is_pressed():
		$Pawn.selected = not $Pawn.selected
		print("Pawn selection state: ", $Pawn.selected)


func _on_tree_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.is_pressed():
		$Tree.selected = not $Tree.selected
		print("Tree selection state: ", $Tree.selected)
		if $Pawn.selected:
			print("Assigning Pawn to work at Tree")
			$Pawn.position.x = $Tree.position.x - 50
			$Pawn.position.y = $Tree.position.y + 20
			$Pawn.selected = false
			$Pawn.activity = $Tree
			
			
			
