extends Control

signal crafting_spot_completed

@export var player: Pawn
@export var craft_menu: CraftMenu
@export var build_menu: Control
@export var hud: BoxContainer
@export var hud_item_scene: PackedScene

func _ready():
	build_menu.player_inventory = player.inventory


func _process(_delta):
	_update_hud()


func _update_hud():
	_clear_hud()
	for slot in player.inventory_handler.inventory.slots:
		if slot.item == null:
			continue
		var hud_item = hud_item_scene.instantiate()
		hud_item.update_info_with_slot(slot)
		hud.add_child(hud_item)


func _clear_hud():
	var children = hud.get_children()
	for child in children:
		child.queue_free()

func _on_build_button_pressed():
	build_menu.visible = true


func _on_back_button_pressed():
	build_menu.visible = false


func _on_crafting_spot_button_pressed():
	if PlayerResources.resources.wood >= 100:
		print("100 wood deducted.")
		PlayerResources.resources.wood -= 100
		emit_signal("crafting_spot_completed")
		print("Crafting Spot created.")
	else:
		print("Not enough wood, 100 wood required.")


func _on_craft_button_pressed():
	craft_menu.toggle_player_crafting(player)

func _on_crafting_menu_requested(craft_station, inventory):
	craft_menu.open_craft_menu(craft_station, inventory)
