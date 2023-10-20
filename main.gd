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
