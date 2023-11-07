extends HBoxContainer

@export var resource_name: String
@export var resource_icon: Texture2D


func _ready():
	$TextureRect.texture = resource_icon


func _process(_delta):
	$Label.text = str(PlayerResources.resources[resource_name])
	if $Label.text == "0":
		self.visible = false
	else:
		self.visible = true
