extends Button

var crafting_spot_completed = false

func _process(delta):
	if PlayerResources.wood < 100 or crafting_spot_completed:
		self.disabled = true
	else: self.disabled = false
