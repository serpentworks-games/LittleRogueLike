class_name MapData
extends RefCounted

const TILE_TYPES = {
	"floor" = preload("res://assets/tile_definitions/tile_def_floor.tres"),
	"wall" = preload("res://assets/tile_definitions/tile_def_wall.tres")
}

var width: int
var height: int
var tiles: Array[Tile]
var entities: Array[Entity]
var player: Entity
var pathfinder: AStarGrid2D

const ENTITY_PATHFINDING_WEIGHT = 10.0

func _init(map_width: int, map_height: int, player: Entity) -> void:
	width = map_width
	height = map_height
	self.player = player
	entities = []
	setup_tiles()

func setup_tiles() -> void:
	tiles = []
	for y in height:
		for x in width:
			var tile_pos := Vector2i(x,y)
			var tile := Tile.new(tile_pos, TILE_TYPES.wall)
			tiles.append(tile)

func get_tile(grid_pos: Vector2i) -> Tile:
	var tile_index: int = grid_to_index(grid_pos)
	if tile_index == -1:
		return null
	return tiles[tile_index]
	
func get_tile_xy(x: int, y: int) -> Tile:
	var grid_pos := Vector2i(x,y)
	return get_tile(grid_pos)
	
func grid_to_index(grid_pos: Vector2i) -> int:
	if not is_in_bounds(grid_pos):
		return -1
	return grid_pos.y * width + grid_pos.x
	
func is_in_bounds(coordinate: Vector2i) -> bool:
	return (
		0 <= coordinate.x
		and coordinate.x < width
		and 0 <= coordinate.y
		and coordinate.y < height
	)
	
func get_actors() -> Array[Entity]:
	var actors: Array[Entity] = []
	for entity in entities:
		if entity.is_alive():
			actors.append(entity)
	return actors

func get_actor_at_location(grid_pos: Vector2i) -> Entity:
	for actor in get_actors():
		if actor.grid_position == grid_pos:
			return actor
	return null

func get_blocking_entity_at_location(grid_pos: Vector2i) -> Entity:
	for entity in entities:
		if entity.can_block_movement() and entity.grid_position == grid_pos:
			return entity
	return null

func register_blocking_entity(entity: Entity) -> void:
	pathfinder.set_point_weight_scale(entity.grid_position, ENTITY_PATHFINDING_WEIGHT)
	
func unregister_blocking_entity(entity: Entity) -> void:
	pathfinder.set_point_weight_scale(entity.grid_position, 0)
	
func setup_pathfinding() -> void:
	pathfinder = AStarGrid2D.new()
	pathfinder.region = Rect2i(0,0,width, height)
	pathfinder.update()
	for y in height:
		for x in width:
			var grid_pos := Vector2i(x,y)
			var tile: Tile = get_tile(grid_pos)
			pathfinder.set_point_solid(grid_pos, not tile.is_walkable())
	for entity in entities:
		if entity.can_block_movement():
			register_blocking_entity(entity)
