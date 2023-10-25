extends Button

func _process(delta):
	if PlayerResources.wood < 100 or $"../../../CraftingSpot".visible:
		self.disabled = true
	else: self.disabled = false
