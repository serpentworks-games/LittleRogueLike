class_name DungeonGenerator
extends Node

@export_category("Map Dimensions")
@export var map_width: int = 80
@export var map_height: int = 45

@export_category("Room RNG")
@export var max_rooms: int = 30
@export var min_room_size: int = 6
@export var max_room_size: int = 10

@export_category("Monster RNG")
@export var max_monsters_per_room = 2

var _rng := RandomNumberGenerator.new()

const ENTITY_TYPES = {
	"dog" = preload("res://entities/actors/entity_def_dog.tres"),
	"human" = preload("res://entities/actors/entity_def_human.tres")
}

func _ready() -> void:
	_rng.randomize()
	
func generate_dungeon(player: Entity) -> MapData:
	var dungeon := MapData.new(map_width, map_height)
	dungeon.entities.append(player)
	
	var rooms: Array[Rect2i] = []
	
	for _try_room in max_rooms:
		var room_width: int = _rng.randi_range(min_room_size, max_room_size)
		var room_height: int = _rng.randi_range(min_room_size, max_room_size)
		
		var x: int = _rng.randi_range(0, dungeon.width - room_width - 1)
		var y: int = _rng.randi_range(0, dungeon.height - room_height - 1)
		
		var new_room := Rect2i(x, y, room_width, room_height)
		
		var has_intersections = false
		for room in rooms:
			if room.intersects(new_room.grow(-1)):
				has_intersections = true
				break
		if has_intersections:
			continue
		
		carve_room(dungeon, new_room)
		
		if rooms.is_empty():
			player.grid_position = new_room.get_center()
		else:
			tunnel_between(dungeon, rooms.back().get_center(), new_room.get_center())
		
		place_entities(dungeon, new_room)
		
		rooms.append(new_room)
	
	return dungeon
	
func carve_tile(map_data: MapData, x: int, y: int) -> void:
	var tile_pos = Vector2i(x,y)
	var tile: Tile = map_data.get_tile(tile_pos)
	
	if not tile: 
		return

	tile.set_tile_type(map_data.TILE_TYPES.floor)

func carve_room(map_data: MapData, room: Rect2i) -> void:
	var inner: Rect2i = room.grow(-1)
	for y in range(inner.position.y, inner.end.y + 1):
		for x in range(inner.position.x, inner.end.x + 1):
			carve_tile(map_data, x, y)

func tunnel_horizontal(map_data: MapData, y: int, x_start: int, x_end: int) -> void:
	var x_min: int = mini(x_start, x_end)
	var x_max: int = maxi(x_start, x_end)
	for x in range(x_min, x_max + 1):
		carve_tile(map_data, x, y)
		
func tunnel_vertical(map_data: MapData, x: int, y_start: int, y_end: int) -> void:
	var y_min: int = mini(y_start, y_end)
	var y_max: int = maxi(y_start, y_end)
	for y in range(y_min, y_max + 1):
		carve_tile(map_data, x, y)
		
func tunnel_between(map_data: MapData, start: Vector2i, end: Vector2i) -> void:
	if _rng.randf() < 0.5:
		tunnel_horizontal(map_data, start.y, start.x, end.x)
		tunnel_vertical(map_data, start.x, start.y, end.y)
	else:
		tunnel_horizontal(map_data, start.x, start.y, end.y)
		tunnel_vertical(map_data, start.y, start.x, end.x)

func place_entities(map_data: MapData, room: Rect2i) -> void:
	var num_of_monsters: int = _rng.randi_range(0, max_monsters_per_room)
	
	for _i in num_of_monsters:
		var x: int = _rng.randi_range(room.position.x + 1, room.end.x - 1)
		var y: int = _rng.randi_range(room.position.y + 1, room.end.y - 1)
		var new_entity_pos := Vector2i(x,y)
		
		var can_place = true
		for entity in map_data.entities:
			if entity.grid_position == new_entity_pos:
				can_place = false
				break
		
		if can_place:
			var new_entity: Entity
			if _rng.randf() < 0.8:
				new_entity = Entity.new(new_entity_pos, ENTITY_TYPES.dog)
			else:
				new_entity = Entity.new(new_entity_pos, ENTITY_TYPES.human)
			map_data.entities.append(new_entity)
