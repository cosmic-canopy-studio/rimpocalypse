extends HBoxContainer

@export var resource_name: String
@export var resource_icon: Texture2D


func _ready():
	$TextureRect.texture = resource_icon
