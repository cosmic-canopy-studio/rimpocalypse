extends Control

@export var player_inventory: Inventory
@export var player: Pawn
@export var grid_cursor:GridCursor

@onready var crafting_spot: InventoryItem = player.inventory_database.get_item(4)

func _on_close_button_pressed():
	visible = false


func _on_button_pressed():
	print("clicked!")
	if player_inventory.contains(crafting_spot):
		print("placing crafting spot!")
		visible=false
		grid_cursor.handle_construction_placement(crafting_spot)
	#if there's a crafting spot in the inventory:
		# hide the menu
		# display the ghost for constructing the item
