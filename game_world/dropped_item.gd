extends DroppedItem2D

var quantity := 1

@onready var sprite = $Sprite2D
@onready var collision_shape = %CollisionShape2D


func _ready():
	sprite.texture = item.icon
	collision_shape.shape.size = sprite.texture.get_size()
