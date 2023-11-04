extends Node2D
class_name GridCursor

signal grid_clicked(grid_position: Vector2, map_position: Vector2, grid_center: Vector2)
signal item_placed(item: InventoryItem, grid_position: Vector2, map_position: Vector2, grid_center: Vector2)

@export var cursor_color := Color.WHITE
@export var grid_cursor: StyleBoxFlat

var game_grid := Grid.new()
var grid_coords: Vector2
var placing_item := false
var item_being_placed: InventoryItem


func _unhandled_input(event):
	if event is InputEventMouseButton and event.is_pressed():
		var local_coords = get_local_mouse_position()
		var grid_position = game_grid.calculate_grid_coordinates(local_coords)
		var center_position = game_grid.calculate_map_position(grid_position)
		
		if not placing_item:
			$AnimationPlayer.play("on_click")
			emit_signal("grid_clicked", grid_position, local_coords, center_position)
			
		else: 
			print("crafting spot placed!")
			emit_signal("item_placed", item_being_placed, grid_position, local_coords, center_position)
			placing_item = false
			item_being_placed = null
			$Panel.add_theme_stylebox_override("panel",grid_cursor)
			$Panel.size = Vector2(16,16)


func _process(_delta):
	var mouse_position = get_local_mouse_position()
	$Panel.position = game_grid.round_to_top_left_position(mouse_position)


func handle_construction_placement(item: InventoryItem):
	placing_item = true
	item_being_placed = item
	var object_cursor = StyleBoxTexture.new()
	object_cursor.texture = item.icon
	$Panel.add_theme_stylebox_override("panel", object_cursor)
	$Panel.size = item.icon.get_size()
	$Panel.modulate=Color(1,1,1,0.5)
