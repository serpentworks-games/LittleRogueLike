class_name Main
extends Node2D

var player_grid_pos := Vector2i.ZERO

const PLAYER_DEF: EntityDefinition = preload("res://entities/actors/entity_def_player.tres")

@onready var player: Entity
@onready var action_handler: ActionHandler = $ActionHandler
@onready var map: Map = $Map
@onready var camera_2d: Camera2D = $Camera2D

func _ready() -> void:
	player = Entity.new(Vector2i.ZERO, PLAYER_DEF)
	camera_2d.reparent(player)
	map.generate_map(player)
	map.update_fov(player.grid_position)

func _physics_process(_delta: float) -> void:
	var action: Action = action_handler.get_action()
	if action:
		var prev_player_pos: Vector2i = player.grid_position
		action.perform_action(self, player)
		if player.grid_position != prev_player_pos:
			map.update_fov(player.grid_position)
		
func get_map_data() -> MapData:
	return map.map_data

func handle_enemy_turns() -> void:
	for entity in get_map_data().entities:
		if entity == player: continue
		print("%s would like a turn please!" % entity.get_entity_name())
