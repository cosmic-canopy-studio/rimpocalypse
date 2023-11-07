class_name IngredientListItem
extends Control

@export var icon: TextureRect
@export var amount: Label


func setup(slot: Slot):
	self.icon.texture = slot.item.icon
	self.amount.text = "X " + str(slot.amount)
