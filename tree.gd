extends Area2D

signal produced(type)

@export var selected: bool
var type = "wood"


func _process(_delta):
	$Panel.visible = selected
	if $Panel.visible == true and $HighlightTimeout.is_stopped():
		$HighlightTimeout.start()


func _on_highlight_timeout_timeout():
	selected = false


func produce():
	emit_signal("produced", type)
