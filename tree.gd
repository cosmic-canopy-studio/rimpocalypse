extends Area2D

signal produced(type)

@export var selected: bool
var type = "wood"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Panel.visible = selected
	if $Panel.visible == true and $HighlightTimeout.is_stopped():
		$HighlightTimeout.start()


func _on_highlight_timeout_timeout():
	selected = false

func produce():
	emit_signal("produced", type)
