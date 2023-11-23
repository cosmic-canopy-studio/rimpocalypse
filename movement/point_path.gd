extends Node2D

@export var player: Node2D


func _process(_delta):
	queue_redraw()


func _draw():
	if player.current_point_path.is_empty():
		return

	draw_polyline(player.current_point_path, Color.RED)
