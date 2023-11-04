extends Node

@export var game_world: Node2D
@export var gui: Control

func _ready():
	game_world.visible = true
	gui.visible = true
