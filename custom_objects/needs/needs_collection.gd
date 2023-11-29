class_name NeedsCollection
extends Resource

@export var needs: Array[SimpleNeed]:
	set(new_needs):
		needs = new_needs
		update_needs_cache()
	get:
		return needs

var needs_cache: Dictionary


func update_needs_cache():
	needs_cache.clear()
	for need in needs:
		if need != null:
			needs_cache[need.name] = need


func add_need(need: SimpleNeed):
	needs.append(need)
	update_needs_cache()


func remove_need(need: SimpleNeed):
	var index = needs.find(need)
	if index > -1:
		needs.remove_at(index)
		update_needs_cache()


func has_need(need_name: String) -> bool:
	if needs_cache[need_name]:
		return true
	return false


func get_need(need_name: String) -> SimpleNeed:
	if has_need(need_name):
		return needs_cache[need_name]
	return null
