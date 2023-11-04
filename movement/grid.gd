## Represents a grid with its size, the size of each cell in pixels, and some helper functions to
## calculate and convert coordinates.
## It's meant to be shared between game objects that need access to those values.
class_name Grid
extends Resource

## The grid's rows and columns.
@export var size := Vector2(20, 20)
## The size of a cell in pixels.
@export var cell_size := Vector2(16, 16)

## Half of ``cell_size``
var _half_cell_size = cell_size / 2


## Returns the position of a cell's center in pixels.
func calculate_map_position(grid_position: Vector2) -> Vector2:
	return grid_position * cell_size + _half_cell_size


## Returns the position of a cell's center in pixels.
func calculate_top_left_position(grid_position: Vector2) -> Vector2:
	return grid_position * cell_size


## Returns the map position of the top left corner of the nearest grid
func round_to_top_left_position(map_position:Vector2) -> Vector2:
	var grid_coords = calculate_grid_coordinates(map_position)
	return calculate_top_left_position(grid_coords)


## Returns the position of a grid's center in pixels.
func calculate_grid_center(map_position: Vector2) -> Vector2:
	var grid_position = calculate_grid_coordinates(map_position)
	return grid_position * cell_size + _half_cell_size



## Returns the coordinates of the cell on the grid given a position on the map.
func calculate_grid_coordinates(map_position: Vector2) -> Vector2:
	return (map_position / cell_size).floor()


## Returns true if the `cell_coordinates` are within the grid.
func is_within_bounds(cell_coordinates: Vector2) -> bool:
	var out := cell_coordinates.x >= 0 and cell_coordinates.x < size.x
	return out and cell_coordinates.y >= 0 and cell_coordinates.y < size.y


## Makes the `grid_position` fit within the grid's bounds.
func grid_clamp(grid_position: Vector2) -> Vector2:
	var out := grid_position
	out.x = clamp(out.x, 0, size.x - 1.0)
	out.y = clamp(out.y, 0, size.y - 1.0)
	return out

