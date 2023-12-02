extends Control

@export var player: Pawn
@export var craft_menu: CraftMenu
@export var build_menu: Control
@export var inventory_menu: Control
@export var hud: BoxContainer
@export var hud_item_scene: PackedScene

@onready var hunger_bar = %HungerBar


func _ready():
	build_menu.player_inventory = player.inventory
	inventory_menu.set_inventory_handler(player.inventory_handler)
	for need in player.needs:
		need.need_changed.connect(_on_need_changed)
		need.need_deficient.connect(_on_need_deficient)
		need.need_fulfilled.connect(_on_need_fulfilled)
		need.need_unfulfilled.connect(_on_need_unfulfilled)


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
	build_menu.visible = not build_menu.visible


func _on_back_button_pressed():
	build_menu.toggle()


func _on_craft_button_pressed():
	craft_menu.toggle_player_crafting(player)


func _on_crafting_menu_requested(craft_station, inventory):
	craft_menu.open_craft_menu(craft_station, inventory)


func _on_inventory_button_pressed():
	inventory_menu.toggle_visibility()


func _on_need_changed(need: SimpleNeed):
	if need.name == "hunger":
		hunger_bar.max_value = need.max_fulfillment
		hunger_bar.value = need.current_fulfillment


func _on_need_deficient(need: SimpleNeed):
	if need.name == "hunger":
		hunger_bar.theme_type_variation = "RedProgressBar"


func _on_need_fulfilled(need: SimpleNeed):
	if need.name == "hunger":
		hunger_bar.theme_type_variation = "GreenProgressBar"


func _on_need_unfulfilled(need: SimpleNeed):
	if need.name == "hunger":
		hunger_bar.theme_type_variation = ""
