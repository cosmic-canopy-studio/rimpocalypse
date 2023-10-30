extends Node

@export var starting_wood: int
@export var starting_stone: int

func _ready():
	PlayerResources.resources.wood = starting_wood
	PlayerResources.resources.stone = starting_stone

