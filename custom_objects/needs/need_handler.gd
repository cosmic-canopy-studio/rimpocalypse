class_name NeedHandler
extends Node2D

signal need_fulfilled(need: SimpleNeed)
signal need_unfulfilled(need: SimpleNeed)
signal need_deficient(need: SimpleNeed)
signal need_changed(need: SimpleNeed)

@export var need: SimpleNeed

@onready var state_chart: StateChart = %NeedsStateChart


func _ready():
	state_chart.set_expression_property("current", need.current)
	state_chart.set_expression_property("max", need.max)
	var fulfilled_level = need.max * need.fulfilled_percent
	state_chart.set_expression_property("fulfilled_level", fulfilled_level)
	var deficient_level = need.max * need.deficient_percent
	state_chart.set_expression_property("deficient_level", deficient_level)


func disable():
	state_chart.send_event("disable_need")


func enable():
	state_chart.send_event("enable_need")


func increase(amount):
	need.current += amount
	if need.current > need.max:
		need.current = need.max
	_need_updated()


func decrease(amount):
	need.current -= amount
	if need.current < 0:
		need.current = 0
	_need_updated()


func is_fulfilled() -> bool:
	if need.current >= need.max * need.fulfilled_percent:
		return true
	return false


func is_deficient() -> bool:
	if need.current < need.max * need.deficient_percent:
		return true
	return false


func _need_updated():
	state_chart.set_expression_property("current", need.current)
	need_changed.emit(self)


func _on_fulfilled_state_entered():
	need_fulfilled.emit(self)


func _on_unfulfilled_state_entered():
	need_unfulfilled.emit(self)


func _on_deficient_state_entered():
	need_deficient.emit(self)


func _on_enabled_state_processing(delta):
	var decay_amount = delta * need.decay_rate
	need.deplete_need(decay_amount)
