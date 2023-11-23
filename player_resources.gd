extends Node

var inventory_database := preload("res://data/inventory_database.tres")

var items = inventory_database.items

var resources: Dictionary


func _ready():
	initialize_resources()


func initialize_resources():
	resources.clear()
	for item in items:
		print("adding ", item.name)
		if item != null:
			resources[item.name] = 0
