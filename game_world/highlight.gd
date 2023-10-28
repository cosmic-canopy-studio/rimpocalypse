extends Panel


func _ready():
	self.size.x = get_parent().size.x + 4
	self.size.y = get_parent().size.y + 4
	self.global_position.x = get_parent().position.x
	self.global_position.y = get_parent().position.y
	self.visible = true
	print(self.size)
	print(self.position)
	
