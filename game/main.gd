class_name Main
extends Node2D

signal player_created(player)

var player_grid_pos := Vector2i.ZERO

const PLAYER_DEF: EntityDefinition = preload("res://entities/actors/entity_def_player.tres")

@onready var player: Entity
@onready var action_handler: ActionHandler = $ActionHandler
@onready var map: Map = $Map
@onready var camera_2d: Camera2D = $Camera2D

func _ready() -> void:
	player = Entity.new(null, Vector2i.ZERO, PLAYER_DEF)
	player_created.emit(player)
	camera_2d.reparent(player)
	map.generate_map(player)
	map.update_fov(player.grid_position)
	MessageLog.send_message.bind(
		"Time to find some fish!", GameColors.WELCOME_TEXT
	).call_deferred()

func _physics_process(_delta: float) -> void:
	var action: Action = action_handler.get_action(player)
	if action:
		var prev_player_pos: Vector2i = player.grid_position
		action.perform_action()
		handle_enemy_turns()
		map.update_fov(player.grid_position)
		
func get_map_data() -> MapData:
	return map.map_data

func handle_enemy_turns() -> void:
	for entity in get_map_data().get_actors():
		if entity.is_alive() and entity != player:
			entity.ai_component.perform_behaviour()
