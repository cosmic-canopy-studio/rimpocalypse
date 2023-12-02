class_name SimpleNeed
extends Resource

@export var name: String
@export var max_fulfillment: float = 100
@export var current_fulfillment: float = 100
@export var decay_rate: float = 1
@export var fulfilled_percent: float = 0.8
@export var deficient_percent: float = 0.2
