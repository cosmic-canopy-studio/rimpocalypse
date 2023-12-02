class_name NeedHandler
extends Node

signal need_fulfilled(need: SimpleNeed)
signal need_unfulfilled(need: SimpleNeed)
signal need_deficient(need: SimpleNeed)
signal need_changed(need: SimpleNeed)

@export var need: SimpleNeed

@onready var state_chart: StateChart = %NeedsStateChart


func _ready():
	state_chart.set_expression_property("current_fulfillment", need.current_fulfillment)
	state_chart.set_expression_property("max_fulfillment", need.max_fulfillment)
	var fulfilled_level = need.max_fulfillment * need.fulfilled_percent
	state_chart.set_expression_property("fulfilled_level", fulfilled_level)
	var deficient_level = need.max_fulfillment * need.deficient_percent
	state_chart.set_expression_property("deficient_level", deficient_level)


func disable():
	state_chart.send_event("disable_need")


func enable():
	state_chart.send_event("enable_need")


func increase(amount):
	need.current_fulfillment += amount
	if need.current_fulfillment > need.max_fulfillment:
		need.current_fulfillment = need.max_fulfillment
	_need_updated()


func decrease(amount):
	need.current_fulfillment -= amount
	if need.current_fulfillment < 0:
		need.current_fulfillment = 0
	_need_updated()


func is_fulfilled() -> bool:
	if need.current_fulfillment >= need.max_fulfillment * need.fulfilled_percent:
		return true
	return false


func is_deficient() -> bool:
	if need.current_fulfillment < need.max_fulfillment * need.deficient_percent:
		return true
	return false


func _need_updated():
	state_chart.set_expression_property("current_fulfillment", need.current_fulfillment)
	state_chart.send_event("fulfillment_updated")
	need_changed.emit(need)


func _on_fulfilled_state_entered():
	need_fulfilled.emit(need)


func _on_unfulfilled_state_entered():
	need_unfulfilled.emit(need)


func _on_deficient_state_entered():
	need_deficient.emit(need)


func _on_enabled_state_processing(delta):
	var decay_amount = delta * need.decay_rate
	decrease(decay_amount)
