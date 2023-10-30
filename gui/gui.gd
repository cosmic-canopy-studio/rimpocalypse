extends Control

signal crafting_spot_completed

@export var player: Pawn
@export var craft_menu: CraftMenu

func _ready():
	craft_menu.initialize(player.crafting_table)


func _on_build_button_pressed():
	$BuildMenu.visible = true


func _on_back_button_pressed():
	$BuildMenu.visible = false


func _on_crafting_spot_button_pressed():
	if PlayerResources.resources.wood >= 100:
		print("100 wood deducted.")
		PlayerResources.resources.wood -= 100
		emit_signal("crafting_spot_completed")
		print("Crafting Spot created.")
	else:
		print("Not enough wood, 100 wood required.")


func _on_craft_button_pressed():
	craft_menu.toggle(player)
