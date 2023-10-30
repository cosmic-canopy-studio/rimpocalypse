extends WorkObject


var current_craft = {
	name = "bed",
	wood_cost = 100
}


func produce(effort = 1):
	if progress_bar .value == 0 and super.is_constructed():
		if not begin_craft():
			return
	super(effort)


func begin_craft() -> bool:
	if PlayerResources.resources.wood >= current_craft.wood_cost:
		print("Beginning craft at ", object_name, " producing ", current_craft.name)
		PlayerResources.resources.wood -= current_craft.wood_cost
		return true
	else:
		var reason = str("Could not begin crafting ", current_craft.name, "\n")
		reason += str("Not enough wood, ", current_craft.wood_cost, " wood required.")
		emit_signal("blocked", reason)
		return false
