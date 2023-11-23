extends NavigationRegion2D

@export var tile_map: TileMap

var new_navigation_polygon: NavigationPolygon = get_navigation_polygon()


func _ready():
	#update()

	visible = true


func update():
	parse_2d_collisionshapes($"..")

	new_navigation_polygon = get_navigation_polygon()

	new_navigation_polygon.make_polygons_from_outlines()
	set_navigation_polygon(new_navigation_polygon)

	$Polygon2D.polygons = new_navigation_polygon.polygons

	print($Polygon2D.polygons.size(), ", ", new_navigation_polygon.polygons.size())


func parse_2d_collisionshapes(root_node: Node2D):
	for node in root_node.get_children():
		if not node is Node2D:
			continue

		if node.get_child_count() > 0:
			parse_2d_collisionshapes(node)

		if node is CollisionPolygon2D:
			var collisionpolygon_transform: Transform2D = node.get_global_transform()
			var collisionpolygon: PackedVector2Array = node.polygon

			var new_collision_outline: PackedVector2Array = (
				collisionpolygon_transform * collisionpolygon
			)

			new_navigation_polygon.add_outline(new_collision_outline)


func tile_update(tilemap, id):
	var polygon = new_navigation_polygon.get_navigation_polygon()
	var used_tiles = tilemap.get_used_cells_by_id(id)
	#for tile in used_tiles:
	#var tile_polygon =
