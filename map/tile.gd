class_name Tile
extends Sprite2D

var _definition: TileDefinition

var is_explored: bool = false:
	set(value):
		is_explored = value
		if is_explored and not visible:
			visible = true
			
var is_in_view: bool = false:
	set(value):
		is_in_view = value
		modulate = _definition.color_lit if is_in_view else _definition.color_unlit
		if is_in_view and not is_explored:
			is_explored = true

func _init(grid_pos: Vector2i, tile_def: TileDefinition) -> void:
	visible = false
	centered = false
	position = Grid.grid_to_world(grid_pos)
	set_tile_type(tile_def)
	
func set_tile_type(tile_def: TileDefinition) -> void:
	_definition = tile_def
	texture = _definition.texture
	modulate = _definition.color_unlit
	
func is_walkable() -> bool:
	return _definition.is_walkable

func is_transparent() -> bool:
	return _definition.is_transparent
